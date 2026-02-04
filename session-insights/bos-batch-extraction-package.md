# BOS Batch Job Extraction - Experiment Package

**Purpose:** Materials for testing AI-assisted BOS context extraction from batch job documentation.

**Status:** v1 — Hypothesis for experimentation.

---

## Cover Message (Draft)

> **Subject:** BOS Extraction Experiment - Need Your Help
>
> Team,
>
> We have 2 batch job examples with documentation to test this approach.
>
> We're testing an AI-assisted approach to extract BOS (Business Observability System) context from batch job documentation. The prompt below guides an LLM to pull out stakeholders, expectations, impacts, and signals from JIL files and wiki pages.
>
> **THE ASK:**
> 1. Try the prompt with the batch job materials (JIL + Confluence)
> 2. See what extracts cleanly vs. what's missing
> 3. Share the output + your observations (see feedback template below)
>
> This is experiment #1 — we expect to iterate based on what you learn.
>
> The prompt and instructions are below.

---

## How to Use the Prompt

1. **Start a new LLM session** (Claude, ChatGPT, or other)

2. **Copy the entire prompt** (from `PROMPT START` to `PROMPT END` below)

3. **Paste your first batch of materials** — JIL file, Confluence page, whatever you have

4. **Review the extraction** — The LLM will produce a complete structured document showing what it found and what's still missing

5. **Add more context as needed** — Paste additional pages, runbooks, etc. Each time, you'll get an updated complete extraction

6. **Stop when satisfied** — The last output is your extraction. No special command needed.

### Example Session Flow

```
You: [paste prompt]
You: Here's the JIL file for the batch job: [paste JIL]

LLM: [produces complete extraction — some fields filled, many marked "NOT FOUND"]

You: Here's the Confluence page for this job: [paste Confluence content]

LLM: [produces updated extraction — business context now filled, fewer gaps]

You: I also found this runbook: [paste runbook]

LLM: [produces updated extraction — operational metadata now filled]

(Done — the last output is your extraction)
```

---

## PROMPT START

You are helping extract Business Observability System (BOS) context from batch job documentation.

### How This Works

1. The user will provide batch job materials (JIL files, Confluence pages, runbooks, etc.) — possibly across multiple messages
2. After **every** input, produce the **complete** BOS extraction document (all 10 sections)
3. Flag gaps explicitly — "NOT FOUND" is valuable information
4. When user provides more materials, update the extraction and show the complete document again

### Output Format

Produce a markdown document with this structure:

```
# BOS Extraction: [Job Name]

**Materials Processed:** [list what you've seen so far]
**Gaps Remaining:** [count of NOT FOUND items]

## 1. Job Identification
[table]

## 2. Business Context
[table]

## 3. Stakeholders
[table]

## 4. Expectations
[table]

## 5. Impacts
[table]

## 6. Dependencies & Data Lineage
[table]

## 7. Operational Metadata
[table]

## 8. Error Signatures
[table]

## 9. Proposed Signals
[table]

## 10. Gaps & SME Questions
[table]
```

### Key Rules

- **Source references required** — Every extracted value must show where it came from: `[Source: JIL field]` or `[Source: Confluence > Section Name]`
- **Flag gaps, don't invent** — If information isn't in the materials, write "NOT FOUND — needs SME input"
- **Accumulate across inputs** — When user provides additional materials, UPDATE the extraction (don't start over)
- **Track what you've processed** — List materials in the header so user knows what's included

### BOS Concepts (for your extraction)

**Core Pattern (Semantic Flow):**
```
[Stakeholder] → expects → [Outcome] → if broken → [Impact] → detected by → [Signal]
```

**Four Impact Categories** — Try to identify all four:
- Customer (external user experience)
- Financial (revenue, cost, penalties)
- Legal/Risk (compliance, regulatory)
- Operational (internal efficiency, manual workarounds)

**Three Signal Types:**
- Business Health — Is the business goal achieved?
- Process — Is the workflow completing?
- System — Is the infrastructure working?

### Section Details

**1. Job Identification**

| Field | Value | Source |
|-------|-------|--------|
| Job Name/Code | | |
| Job Stream/Group | | |
| Schedule | | |
| CMDB Application ID | | |

**2. Business Context**

| Field | Value | Source |
|-------|-------|--------|
| Business Purpose | [Why does this job exist?] | |
| Business Function | [e.g., Regulatory Reporting] | |
| Criticality | [T1/T2/T3 if stated] | |

**3. Stakeholders**

| Stakeholder | Why They Care | Source |
|-------------|---------------|--------|
| | | |

**4. Expectations**

| Stakeholder | Expectation | Source |
|-------------|-------------|--------|
| [Who] | "[Who] expects [specific measurable outcome]" | |

Transform technical specs into business language:
- JIL `max_run_time: 60` → "Job completes within 60 minutes"
- JIL `alarm_if_fail: 1` → "Job succeeds without errors"

**5. Impacts**

| Category | Consequence if Failed | Source |
|----------|----------------------|--------|
| Customer | | |
| Financial | | |
| Legal/Risk | | |
| Operational | | |

**6. Dependencies & Data Lineage**

| Direction | Dependency | Type | Source |
|-----------|------------|------|--------|
| Upstream | [must complete first] | job/file/table | |
| Downstream | [consumes this output] | job/file/system | |

JIL hints: `condition:` = upstream, file paths = inputs/outputs

**7. Operational Metadata**

| Field | Value | Source |
|-------|-------|--------|
| Runbook URL | | |
| Support Team | | |
| PagerDuty Service | | |
| Safe to Restart? | | |
| Idempotent? | | |

**8. Error Signatures**

| Error Pattern | Root Cause | Resolution | Source |
|---------------|------------|------------|--------|
| | | | |

Often undocumented — flag as gap if not found.

**9. Proposed Signals**

| Signal Type | Signal Name | What It Measures | Derived From |
|-------------|-------------|------------------|--------------|
| Business Health | | | [Expectation #X] |
| Process | | | [Dependency #Y] |
| System | | | [Standard pattern] |

**10. Gaps & SME Questions**

| Gap Area | What's Missing | Why It Matters |
|----------|----------------|----------------|
| | | |

### On Each User Input

1. Parse the new material
2. Merge with any previous extraction
3. Produce the **complete** extraction document (all 10 sections)
4. At the top, briefly note what was added: "Updated with: [source name]"
5. Gaps remain visible in Section 10

Every output is a complete, usable extraction. The user stops when satisfied.

---

Ready. Paste your batch job materials (JIL file, Confluence page, or any documentation you have).

## PROMPT END

---

## Feedback Template

After running the experiment, please capture:

### What Worked
- Which sections extracted cleanly?
- What was the LLM good at finding?

### What Was Confusing
- Any instructions that were unclear?
- Did the LLM misunderstand anything?

### What Was Missing
- Information you expected to extract but the prompt didn't ask for?
- BOS concepts that should be captured but aren't in the template?

### Gaps That Surfaced
- What required SME follow-up?
- What's genuinely undocumented vs. just not in these materials?

### Sample Output
- Please share the final extraction document (or a representative excerpt)
- This helps us see what the LLM actually produced

---

## Version

| Version | Date | Notes |
|---------|------|-------|
| v1 | 2026-02-04 | Initial hypothesis for batch job extraction |
