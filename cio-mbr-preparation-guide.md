# MBR Update Quality Reference — CIO Monthly Business Review

Quality reference for preparing updates presented at the CIO's monthly business review. Structure follows FM 6-0 Status Brief doctrine with Minto Pyramid (BLUF) and CIA analytic standards (So What). Quality standards derived from observed evaluation patterns across multiple review cycles.

---

## Update Structure

Each MBR update should follow this skeleton. Adapted from FM 6-0 Staff Status Brief for CIO-level monthly review cadence.

| Section | Purpose | Content |
|---------|---------|---------|
| **BLUF** | Bottom line up front (Minto Pyramid) | One sentence: on track, behind, or needs a decision. The answer before the analysis. |
| **Done** | Accomplishments since last review (FM 6-0) | What was completed, with quantities. Note what changed from prior period. |
| **So What** | Why it matters to this consumer (CIA Kent School) | Financial or capacity return: hours saved, risk reduced, coverage expanded, spend avoided. |
| **Next** | Forward-looking plan (FM 6-0) | What's planned for next period, with targets and dates. |
| **Blocked** | Constraints with path to resolution (FM 6-0) | What's slowing progress + a recommendation for how to resolve it. Not options — a recommendation. |
| **Ask** | What's needed from leadership | Specific request, if any. Decisions, approvals, organizational support. |

Not every section applies to every update. A topic with no blockers skips Blocked. A topic needing no decision skips Ask. But the order holds — BLUF is always first, and any section present follows this sequence.

---

## Quality Standards

Applied to the content within the structure above. These are evaluation criteria, not additional sections. Derived from observed leadership evaluation patterns across multiple review cycles.

### 1. Dimensional Specificity

Every claim includes quantities, timelines, and scope boundaries.

Before presenting, check:
- **How many?** Applications, services, use cases, accounts — whatever the unit of work is.
- **By when?** Quarter, month, specific date — even if it's an estimate.
- **For whom?** Which domains, which L3s, which teams are covered — not just "platform-wide."

Test: if someone could reasonably ask "but how much of that?" after hearing the update — the dimension is missing.

### 2. Financial or Capacity Return

Technical improvements must be translated into what the work gives back — capacity freed up, risk reduced, toil hours avoided, coverage expanded.

Even early-stage work should have a hypothesis: *"This reduces BCP preparation effort by X hours per event"* or *"This covers N critical applications that currently have no automated rotation."*

If there's no expected return yet, state that directly — that's better than being asked and not having an answer.

### 3. Progress Beyond the Concept

If leadership has already agreed a concept is important, don't re-justify it. Show what's changed since the last review.

Test: has the CIO already agreed this is important? If yes, the update is about operationalization progress — not the framework or the rationale. The concept is sold. Show new work.

### 4. Orient, Then Go to Substance

Two failure modes — and they look like opposites:

1. **Starting with meta-commentary** about what you're going to cover ("So this was an open item from last month, and we have an update...") before getting to the actual content. If there is a summary slide and a detail slide — go straight to the detail.

2. **Jumping into detail without orienting** on what topic is being discussed. If someone has to say "wait, what are we talking about?" — the setup was skipped.

The sweet spot: one sentence that frames the topic, then straight to substance. *"Service account rotation — here's where we are"* and then the detail. No preamble, but no confusion either.

### 5. Uncertainty Expression

When numbers represent estimates or depend on external factors, flag the confidence level. "38 apps covered" is fact. "Targeting full coverage Q2" is an estimate contingent on a vendor delivery in April. Distinguish what you know from what you're projecting.

Leadership asks about this distinction even when the presenter doesn't surface it — *"is this an extra five hours, or is this an extra 100 hours?"*

### 6. Push Information Proactively

If leadership has to ask for the timeline, the dependency, or the constraint — the update was incomplete.

Predictable questions for most platform updates:
- What's the timeline?
- What are the dependencies?
- How much effort is this?
- What do you need from me?

If the question is predictable, the answer should already be in the update.

### 7. Name the Constraint — and Come with a Path Forward

Identify what's blocking faster progress. Surface it with a recommendation — not just the problem, and not options for leadership to choose between. Don't make them solve the prioritization problem.

Framing matters — especially when the constraint involves other teams:

- *"We can't control whether product teams engage"* — dead end. No lever for leadership to pull.
- *"Product team engagement is the constraint — here's what we're doing to drive it, and here's where organizational support would accelerate it"* — gives leadership something to act on.

When you depend on teams you don't directly control, show what you've done to drive engagement, where you've gotten traction, and what would help move it faster. Leadership solves organizational blockers when they're surfaced clearly — but only if you give them something to act on.

### 8. Team and Coordination Visibility

Name who you're partnering with. Say "we" not "I." Reference the teams, the coordination, the people involved.

Updates that show cross-functional engagement land better than solo narratives — and they're more accurate to how platform work actually happens. At CIO level, the implicit question is whether this scales beyond one person.

### 9. Progress Reframing

Sometimes the real work is navigating complexity — getting alignment, clearing blockers, changing the approach based on what was learned. That's forward momentum, even if the output count hasn't changed.

When the visible progress doesn't match the actual effort, reframe what was navigated: *"We spent Q1 solving the adoption constraint — here's what we learned and how it changes the path forward"* is stronger than explaining why pace was slow. Show that the problems being worked on now are better problems than the ones you started with.

---

## Worked Example

Synthetic example applying structure and quality standards to a platform automation initiative.

```
TOPIC: Automated Configuration Drift Detection

BLUF:
On track — 38 of 64 critical apps covered, targeting full
coverage Q2 pending vendor Oracle support in April.

DONE:
- Moved from POC (5 apps) to 38 apps with automated drift
  checks running in production-path environments
- Partnered with the servicing platform team to pilot across
  their top-10 critical apps
- 3 drift issues caught in February that would have surfaced
  during the BCP event weekend

SO WHAT:
- Estimated 120 person-hours saved per BCP preparation
  cycle vs. manual checklist process
- Reduces all-hands BCP weekend staffing requirement
- February catches avoided potential event-day firefighting

NEXT:
- Run automated checks in production environment at next
  BCP cycle (targeting April)
- Onboard remaining 26 apps as Oracle config support
  becomes available (vendor confirmed April delivery)
- Expand to Originations domain apps in Q2

BLOCKED:
- 26 remaining apps require Oracle configuration support
  the tool doesn't cover yet. Vendor confirmed April.
- Recommendation: proceed with the 38 now. Phase Oracle
  apps in Q2. Don't hold the majority for the minority.

ASK:
- Approval to run automated checks in production starting
  next BCP cycle
```

---

## Pre-Submission Checklist

### Structure
- [ ] Does the update lead with a BLUF? (one sentence: on track / behind / needs decision)
- [ ] Is there a Done section with accomplishments since last review?
- [ ] Is there a So What translating progress into business value?
- [ ] Is there a Next section with forward-looking targets and dates?
- [ ] If something is blocked, is there a recommendation for resolution?
- [ ] If something is needed from leadership, is the ask specific?

### Quality
- [ ] Do all claims include quantities, timelines, and scope? (how many, by when, for whom — by domain/L3, not just "platform-wide")
- [ ] Is there a financial or capacity dimension? (hours saved, effort avoided, risk reduced — hypothesis acceptable for early-stage work)
- [ ] Am I showing new progress, or revisiting established ground? (has the CIO already agreed this is important? If yes, skip justification.)
- [ ] Does the slide orient the audience in one sentence, then go to substance? (no preamble, but no unframed detail either)
- [ ] Are estimates distinguished from facts? (confidence level flagged for projections and vendor dependencies)
- [ ] Am I pushing information proactively? (timeline, dependencies, effort, what I need — pre-answered)
- [ ] Am I coming with a recommendation, not presenting options for leadership to solve?
- [ ] When the constraint involves other teams, am I showing what I've done to drive engagement and where traction exists?
- [ ] Does the update show partnerships and team coordination? ("we" not "I")
- [ ] If progress looks slow, am I showing what we navigated and why the path is better?
- [ ] If I have five things to cover, do I know which two matter most if time runs short?

---

## AI Assistant Instructions

If you are an AI assistant helping prepare or evaluate an MBR update using this reference, follow these instructions.

### Writing Style

MBR updates are brief, spoken-pace content for a CIO audience. Write accordingly:

- **Plain language.** No jargon, no acronyms without context, no technical terms the audience doesn't use daily. "We automated the pre-event configuration checks" not "We implemented drift detection tooling leveraging automated config diffing."
- **Concise.** Each section should be 2-4 bullet points. An entire update fits in 3-5 minutes of speaking time. If a section runs longer than 4 bullets, it needs editing, not more content.
- **Direct.** State facts and positions. "38 of 64 apps covered" not "We have been making significant progress toward expanding coverage across our application portfolio."
- **Specific over general.** Numbers, dates, names, domains. Never "several applications" or "key stakeholders" or "various teams."

### When Evaluating a Draft

- Score each quality criterion pass or fail with specific evidence from the draft. Do not soften the evaluation.
- If a criterion fails, state what is missing and what the draft needs. Do not say "consider adding" — say "this is missing."
- Do not give performative approval. "Great start!" followed by substantive failures is misleading. Lead with what fails.
- If the draft contains filler language that sounds like content but carries no information ("We continue to drive alignment on key initiatives"), flag it explicitly and replace it with what should be there — or flag the gap.

### When Helping Generate an Update

- When the user has not provided a specific number, date, or name, insert a gap marker: `[INSERT: number of apps covered]` or `[INSERT: target date]`. Never invent plausible specifics.
- Do not conflate what exists today with what is planned. Use present tense for facts, future tense for plans. Flag the distinction if the user's input blurs it.
- Do not hedge claims with unnecessary qualifiers. "38 apps covered" not "approximately 38 apps have been covered to date." If confidence is uncertain, use the Uncertainty Expression standard — state the fact and flag the dependency separately.
- Do not generate corporate filler. Every sentence must carry information that would be missing if the sentence were removed. If removing a sentence changes nothing, delete it.
- Do not add sections or content the user didn't provide input for. A shorter update with real content is better than a longer update with invented content.
