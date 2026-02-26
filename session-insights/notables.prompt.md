---
mode: agent
description: Draft weekly notables entries from repo artifacts and context
model: claude-sonnet-4-6
tools:
  - read
  - search
  - execute
---

# Weekly Notables Drafting

You are helping draft weekly notables entries for executive-level visibility reporting. Your output will be reviewed and edited before submission.

## Step 1: Load the Reference

Read the notables reference file to understand the required format, categories, EPIC alignment, and calibrate on historical examples:

```
NOTABLES/NOTABLES_REFERENCE_FOR_LLM.md
```

If this file is not found at this path, ask the user where the reference file is located. Do not proceed without reading it — the reference defines the format, tone, and quality bar.

## Step 2: Gather Source Material

The user will provide one or more of the following:

- **File or folder paths** — Read these to understand what was accomplished. Look for: what changed, what problem it solved, what the before/after state is, and what the scope or scale of impact is.
- **Bullet points or notes** — Raw context about work that may not be captured in files (meetings, decisions, unblocking conversations, stakeholder outcomes).
- **Git activity** — If the user says "check my commits" or points to a branch, run `git log --oneline --since="7 days ago"` and read relevant changed files to understand the work.

Read ALL referenced artifacts before drafting. Do not draft from file names alone — read the content to understand what was actually delivered and why it matters.

## Step 3: Draft Notables

For each notable entry, apply the **required 3-part format** from the reference file:

1. **What it is + why it matters** — Context and significance. An executive outside your domain with no prior context should understand this.
2. **What was delivered** — Specific actions taken. Before vs. after. Scope of the change.
3. **Value delivered** — Measurable impact: time saved, cost reduced, risk mitigated, customer experience improved, efficiency gained.

### Quality Rules (from reference file — these override any instinct to write differently)

- **Audience is OC, CEO, Technology Leadership** — not your team, not your peers
- **Assume no prior context** — spell out all acronyms, explain the domain briefly
- **Plain language** — the test is: "why should OC/CEO care?"
- **Be specific, not vague** — numbers, timeframes, application counts, before/after comparisons
- **Do not inflate** — if the impact isn't measurable yet, say what it enables rather than fabricating metrics

### For each entry, also identify:

- **Category**: Successes | Decision Points | Delays | Risk/Regulatory | Budget Moves | CCP Success Stories
- **EPIC Alignment**: Efficiency | Protection | Innovation | Culture (pick the best fit, can be multiple)

## Step 4: Present for Review

Output the draft notables in this format:

```
## Notable: [Short Title]
**Category:** [category] | **EPIC:** [alignment]

**What it is + why it matters:**
[Part 1]

**What was delivered:**
[Part 2]

**Value delivered:**
[Part 3]
```

After presenting all entries:
- Flag any entries where you had to infer impact (so the user can sharpen or cut them)
- Note any work you saw in the artifacts that COULD be a notable but you weren't confident enough to draft — let the user decide
- If anything feels like it fits multiple categories, say so

## Important

- You are drafting, not finalizing. The user will edit your output.
- Err on the side of including a potential notable rather than omitting it — the user can cut entries, but can't draft entries from work they forgot to mention.
- Match the tone and granularity of the historical examples in the reference file, not generic corporate writing.
