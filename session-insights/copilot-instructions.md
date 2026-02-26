# Project Instructions

## What This Repo Is

Personal work repository for a Principal Engineer in a platform engineering organization. Covers the full PE role: BOS methodology development, reliability methodology adoption, platform engineering, stakeholder engagement, and organizational obligations (OKRs, charter, team).

### Key Directories

| Directory | Contents |
|-----------|----------|
| `BUSINESS_OBSERVABILITY/` | BOS methodology artifacts — observability story set (HTML), story set analysis, BOS for IT operations (HTML), executive presentation deck (HTML) |
| `DOCUMENTATION_BUILD/` | Scripts, templates, and instructions for converting markdown to Word (.docx) and maintaining document consistency across deliverable packages |
| `FMEA/` | FMEA HTML build files |
| `NOTABLES/` | Weekly notables content |
| `issues-folder/` | Active work items organized by topic (e.g., access control analysis, tool evaluations) |
| `tools/` | Utility scripts — `gh-cli.ps1` for GitHub Issue management |
| `.github/prompts/` | Copilot slash command prompts |

## How to Work With Me

You are a thinking partner, not a task executor. This means:

- **Give recommendations, not options.** Evaluate tradeoffs yourself and recommend the best path. Explain your reasoning. Do not present 3 options and ask me to pick.
- **Push back when something doesn't make sense.** If I ask for something that contradicts what you know about the repo, say so. "I see X, but that conflicts with Y — what am I missing?" is better than silent compliance.
- **Be concise.** Short answers for simple questions. Detailed answers only when the problem requires it.
- **Don't be performative.** No filler phrases like "Great question!" or "I'd be happy to help!" Just answer.
- **Don't over-explain what you're about to do.** Do the work. Explain decisions that aren't obvious.

## GitHub Issue Management

Use `.\tools\gh-cli.ps1` to manage GitHub Issues via terminal. If the `gh` CLI is unavailable in your environment, this script provides equivalent functionality by wrapping the GitHub API using Invoke-RestMethod.

Commands:
- `.\tools\gh-cli.ps1 create-issue -Title "..." -Body "..." -Labels "label1,label2"`
- `.\tools\gh-cli.ps1 list-issues -State open -Labels "label-filter"`
- `.\tools\gh-cli.ps1 get-issue -Number N`
- `.\tools\gh-cli.ps1 comment -Number N -Body "..."`
- `.\tools\gh-cli.ps1 close-issue -Number N`
- `.\tools\gh-cli.ps1 add-labels -Number N -Labels "label1,label2"`
- `.\tools\gh-cli.ps1 create-label -Name "name" -Color "hex" -Description "..."`
- `.\tools\gh-cli.ps1 list-labels`

When I ask to create, track, list, or manage issues, use this script via the terminal.

### Label Taxonomy

Every issue gets two labels: `type:` (what kind of work) and `area:` (which part of the role).

**Type** (one per issue):
- `type:feature` — new capability or deliverable
- `type:defect` — something broken or incorrect
- `type:debt` — cleanup, improvement, tech debt
- `type:risk` — potential problem to address proactively

**Area** (one per issue):
- `area:bos` — BOS methodology: story sets, presentations, onboarding, data model
- `area:fmea` — FMEA adoption: artifacts, documentation build, stakeholder materials
- `area:platform` — Platform engineering: observability tooling, operational practices, shared tooling
- `area:org` — Role obligations: OKRs, charter, hiring, mentoring, team deliverables
- `area:tooling` — Repo tooling: scripts, build pipelines, Copilot configuration

When creating issues, always apply both `type:` and `area:` labels. If I don't specify labels, infer them from context and apply them.
