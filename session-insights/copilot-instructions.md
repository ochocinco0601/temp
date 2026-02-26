# Project Instructions

## GitHub Issue Management

Use `.\tools\gh-cli.ps1` to manage GitHub Issues via terminal. The `gh` CLI is not installed — this script wraps the GitHub Enterprise API using Invoke-RestMethod.

Commands:
- `.\tools\gh-cli.ps1 create-issue -Title "..." -Body "..." -Labels "label1,label2"`
- `.\tools\gh-cli.ps1 list-issues -State open -Labels "label-filter"`
- `.\tools\gh-cli.ps1 get-issue -Number N`
- `.\tools\gh-cli.ps1 comment -Number N -Body "..."`
- `.\tools\gh-cli.ps1 close-issue -Number N`
- `.\tools\gh-cli.ps1 add-labels -Number N -Labels "label1,label2"`

When I ask to create, track, list, or manage issues, use this script via the terminal.
