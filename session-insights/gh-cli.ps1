<#
.SYNOPSIS
    GitHub Enterprise API wrapper for managed environments without gh CLI.
    Issue management via Invoke-RestMethod + Personal Access Token.

.DESCRIPTION
    Replaces the gh CLI for GitHub Enterprise when it can't be installed on
    corporate-managed machines. Authenticates with $env:GH_TOKEN (set in
    PowerShell profile) and auto-detects repo owner/name from git remote.

    Mutations from Copilot are attributed so you can distinguish AI-created
    content from manual entries.

.PARAMETER Command
    Operation to perform. See examples below.

.EXAMPLE
    .\tools\gh-cli.ps1 create-issue -Title "Signal cascade bug" -Body "Details..." -Labels "type:defect,area:methodology"
    .\tools\gh-cli.ps1 list-issues -State open -Labels "type:defect"
    .\tools\gh-cli.ps1 get-issue -Number 3
    .\tools\gh-cli.ps1 comment -Number 3 -Body "Fixed in commit abc123"
    .\tools\gh-cli.ps1 close-issue -Number 3
    .\tools\gh-cli.ps1 add-labels -Number 3 -Labels "priority:high"
    .\tools\gh-cli.ps1 create-label -Name "type:defect" -Color "d73a4a" -Description "Something isn't working"
    .\tools\gh-cli.ps1 list-labels
#>

param(
    [Parameter(Mandatory, Position = 0)]
    [ValidateSet(
        'create-issue', 'list-issues', 'get-issue',
        'comment', 'close-issue', 'reopen-issue',
        'add-labels', 'create-label', 'list-labels'
    )]
    [string]$Command,

    # Issue creation / commenting
    [string]$Title,
    [string]$Body,
    [string]$Labels,        # Comma-separated: "type:defect,area:eng"

    # Issue reference
    [int]$Number,

    # Label creation
    [string]$Name,
    [string]$Color = "ededed",
    [string]$Description,

    # List filtering
    [ValidateSet('open', 'closed', 'all')]
    [string]$State = 'open',

    [int]$Limit = 30
)

# --- Assembly dependency for URL encoding ---
Add-Type -AssemblyName System.Web

# --- Preflight: token check ---
if (-not $env:GH_TOKEN) {
    Write-Error "GH_TOKEN environment variable not set. Add `$env:GH_TOKEN = 'your-token' to your PowerShell profile (`$PROFILE)."
    exit 1
}

# --- Repo detection from git remote ---
function Get-RepoInfo {
    $remote = (git remote get-url origin 2>$null).Trim()
    if (-not $remote) {
        Write-Error "Not in a git repository or no 'origin' remote configured."
        exit 1
    }

    # HTTPS: https://github.enterprise.com/owner/repo.git
    if ($remote -match 'https?://([^/]+)/([^/]+)/([^/]+?)(?:\.git)?$') {
        return @{
            Host    = $Matches[1]
            Owner   = $Matches[2]
            Repo    = $Matches[3]
            ApiBase = "https://$($Matches[1])/api/v3"
        }
    }
    # SSH: git@github.enterprise.com:owner/repo.git
    elseif ($remote -match '@([^:]+):([^/]+)/([^/]+?)(?:\.git)?$') {
        return @{
            Host    = $Matches[1]
            Owner   = $Matches[2]
            Repo    = $Matches[3]
            ApiBase = "https://$($Matches[1])/api/v3"
        }
    }
    else {
        Write-Error "Cannot parse git remote URL: $remote"
        exit 1
    }
}

# --- Authenticated API call ---
function Invoke-GitHubApi {
    param(
        [string]$Path,
        [string]$Method = 'Get',
        [object]$RequestBody,
        [hashtable]$QueryParams
    )

    $repo = Get-RepoInfo
    $uri = "$($repo.ApiBase)/repos/$($repo.Owner)/$($repo.Repo)$Path"

    if ($QueryParams) {
        $builder = [System.UriBuilder]$uri
        $qs = [System.Web.HttpUtility]::ParseQueryString($builder.Query)
        foreach ($kv in $QueryParams.GetEnumerator()) {
            $qs[$kv.Key] = "$($kv.Value)"
        }
        $builder.Query = $qs.ToString()
        $uri = $builder.Uri.AbsoluteUri
    }

    $headers = @{
        Authorization = "token $env:GH_TOKEN"
        Accept        = "application/vnd.github.v3+json"
    }

    $params = @{
        Uri         = $uri
        Method      = $Method
        Headers     = $headers
        ContentType = "application/json"
    }

    if ($RequestBody) {
        $params.Body = ($RequestBody | ConvertTo-Json -Depth 10)
    }

    try {
        Invoke-RestMethod @params
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($err.message) {
            Write-Error "GitHub API error: $($err.message)"
            if ($err.errors) {
                foreach ($e in $err.errors) {
                    Write-Error "  - $($e.resource).$($e.field): $($e.code) $($e.message)"
                }
            }
        }
        else {
            Write-Error "API call failed: $_"
        }
        exit 1
    }
}

# --- Command routing ---
switch ($Command) {

    'create-issue' {
        if (-not $Title) { Write-Error "-Title is required"; exit 1 }
        if (-not $Body)  { Write-Error "-Body is required"; exit 1 }

        $attributedBody = "*Created via Copilot*`n`n$Body"
        $issueData = @{ title = $Title; body = $attributedBody }

        if ($Labels) {
            $issueData.labels = @($Labels -split ',\s*')
        }

        $result = Invoke-GitHubApi -Path "/issues" -Method Post -RequestBody $issueData
        Write-Output "Created issue #$($result.number): $($result.title)"
        Write-Output "URL: $($result.html_url)"
    }

    'list-issues' {
        $query = @{ state = $State; per_page = $Limit }
        if ($Labels) { $query.labels = $Labels }

        $issues = @(Invoke-GitHubApi -Path "/issues" -QueryParams $query)

        if ($issues.Count -eq 0) {
            Write-Output "No issues found (state=$State)."
        }
        else {
            foreach ($issue in $issues) {
                $labelStr = ($issue.labels | ForEach-Object { $_.name }) -join ', '
                $pad = if ($issue.number -lt 10) { " " } else { "" }
                Write-Output "$pad#$($issue.number)  $($issue.state.PadRight(6))  $($issue.title)  [$labelStr]"
            }
        }
    }

    'get-issue' {
        if (-not $Number) { Write-Error "-Number is required"; exit 1 }

        $issue = Invoke-GitHubApi -Path "/issues/$Number"
        Write-Output "Issue #$($issue.number): $($issue.title)"
        Write-Output "State:   $($issue.state)"
        Write-Output "Labels:  $(($issue.labels | ForEach-Object { $_.name }) -join ', ')"
        Write-Output "Created: $($issue.created_at)"
        Write-Output "Updated: $($issue.updated_at)"
        Write-Output ""
        Write-Output $issue.body
    }

    'comment' {
        if (-not $Number) { Write-Error "-Number is required"; exit 1 }
        if (-not $Body)   { Write-Error "-Body is required"; exit 1 }

        $attributedBody = "*From Copilot*`n`n$Body"
        $result = Invoke-GitHubApi -Path "/issues/$Number/comments" -Method Post -RequestBody @{ body = $attributedBody }
        Write-Output "Comment added to issue #${Number}"
        Write-Output "URL: $($result.html_url)"
    }

    'close-issue' {
        if (-not $Number) { Write-Error "-Number is required"; exit 1 }

        $result = Invoke-GitHubApi -Path "/issues/$Number" -Method Patch -RequestBody @{ state = "closed" }
        Write-Output "Closed issue #$($result.number): $($result.title)"
    }

    'reopen-issue' {
        if (-not $Number) { Write-Error "-Number is required"; exit 1 }

        $result = Invoke-GitHubApi -Path "/issues/$Number" -Method Patch -RequestBody @{ state = "open" }
        Write-Output "Reopened issue #$($result.number): $($result.title)"
    }

    'add-labels' {
        if (-not $Number) { Write-Error "-Number is required"; exit 1 }
        if (-not $Labels) { Write-Error "-Labels is required"; exit 1 }

        $labelArray = @($Labels -split ',\s*')
        Invoke-GitHubApi -Path "/issues/$Number/labels" -Method Post -RequestBody @{ labels = $labelArray } | Out-Null
        Write-Output "Labels added to issue #${Number}: $($labelArray -join ', ')"
    }

    'create-label' {
        if (-not $Name) { Write-Error "-Name is required"; exit 1 }

        $labelData = @{ name = $Name; color = $Color }
        if ($Description) { $labelData.description = $Description }

        $result = Invoke-GitHubApi -Path "/labels" -Method Post -RequestBody $labelData
        Write-Output "Created label: $($result.name) (#$($result.color))"
    }

    'list-labels' {
        $labels = @(Invoke-GitHubApi -Path "/labels" -QueryParams @{ per_page = 100 })

        if ($labels.Count -eq 0) {
            Write-Output "No labels found."
        }
        else {
            foreach ($label in $labels | Sort-Object name) {
                $desc = if ($label.description) { " - $($label.description)" } else { "" }
                Write-Output "$($label.name)$desc"
            }
        }
    }
}
