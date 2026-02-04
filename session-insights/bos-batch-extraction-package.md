# BOS Batch Job Extraction - Experiment Package

## Cover Message (Draft)

> **Subject:** BOS Extraction Experiment - Need Your Help
>
> Team,
>
> We have 2 batch job examples with documentation to test this approach.
>
> We're testing an AI-assisted approach to extract BOS (Business Observability System) context from batch job documentation. The prompt guides an LLM to pull out stakeholders, expectations, impacts, and signals from JIL files and wiki pages.
>
> **THE ASK:**
> 1. Try the prompt with the batch job materials (JIL + wiki pages)
> 2. See what extracts cleanly vs. what's missing
> 3. Share the output + your observations (see feedback template below)
>
> This is experiment #1 — we expect to iterate based on what you learn.

---

## How to Use

1. **Start a new LLM session** (Claude, ChatGPT, or other)

2. **Copy the entire prompt** from `bos-batch-extraction-prompt.md`

3. **Paste your batch job materials** — JIL file, wiki page, whatever you have

4. **Review the extraction** — You'll get a complete structured document showing what was found and what's missing

5. **Add more context as needed** — Paste additional pages, runbooks, etc. Each time, you'll get an updated extraction

6. **Stop when satisfied** — The last output is your extraction

---

## Feedback Template

After running the experiment, please capture:

**What Worked**
- Which sections extracted cleanly?
- What was the LLM good at finding?

**What Was Confusing**
- Any instructions that were unclear?
- Did the LLM misunderstand anything?

**What Was Missing**
- Information you expected to extract but the prompt didn't ask for?
- BOS concepts that should be captured but aren't in the template?

**Gaps That Surfaced**
- What required SME follow-up?
- What's genuinely undocumented vs. just not in these materials?

**Sample Output**
- Please share the final extraction document (or a representative excerpt)

---

## Files

| File | Purpose |
|------|---------|
| `bos-batch-extraction-prompt.md` | The prompt — copy and paste into LLM |
| `bos-batch-extraction-package.md` | This file — instructions and feedback template |

---

## Version

v1 — 2026-02-04 — Initial hypothesis for batch job extraction
