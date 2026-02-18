# Prompt for Copilot Chat (Agent Mode, Sonnet 4.5)

Paste the following into Copilot Chat:

---

Read the file `observability-story-set-public.html` in this workspace. Analyze the entire file — HTML structure, CSS, JavaScript, Alpine.js data model, and all interactive behavior.

Create a new file called `observability-story-set-analysis.md` that documents your understanding of this application. Structure it as:

1. **Purpose** — What is this application for? What problem does it solve? Who would use it?
2. **Architecture** — What frameworks/libraries are used? How is state managed? What is the data model?
3. **Feature Inventory** — Every distinct feature you can identify (tabs, forms, import/export, etc.), with a one-sentence description of each
4. **Data Flow** — How does data enter the system, where is it stored, how does it persist, how is it exported?
5. **Signal Model** — What is a "signal" in this application? What are the signal layers and types? How do signals relate to the other concepts?
6. **Interaction Design** — How does the multi-tab structure work? What are the editing patterns? What happens on save/load/export?
7. **Gaps or Ambiguities** — Anything you found unclear, potentially incomplete, or that you'd want to ask the author about

Be specific. Reference actual function names, Alpine.js x-data properties, and DOM structure. This is a technical analysis, not a summary.
