| **Field**                   | **Value**                                                                                                                                                                       |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Flow`                      | Credit Check (Loan Origination)                                                                                                                                                 |
| `Audience`                  | PO (Ankur), Platform SRE on-call, AppDev lead, SoD reviewer                                                                                                                     |
| `Purpose`                   | Know quickly if applicants can complete Credit Check so the loan can progress.                                                                                                  |
| `Current Health`            | Derived from thresholds — On track / Degraded / Failing                                                                                                                         |
| `Success Definition`        | A credit decision is returned fast enough to avoid abandonment, with minimal failures.                                                                                          |
| `Targets & Tolerances`      | **Latency (P90):** Target ≤ 3s; **Warn > 5s; Fail > 10s**. **Error rate (5-min):** Target ≤ 0.3%; **Warn > 0.7%; Fail > 1.5%**. **Timeouts/min:** **Warn ≥ 20**; **Fail ≥ 50**. |
| `Error Rate Scope`          | **Excludes business-rule denials**; counts only technical/system-caused failures (e.g., timeouts, transport, dependency/system faults).                                         |
| `Recent Volume`             | Typical \~9,000/day; peaks 09:30–12:00 CT and 18:00–20:30 CT; weekend \~65%.                                                                                                    |
| `Current Impact (template)` | “Applicants cannot advance past Credit Check; \~`<N>` affected (\~`<P>%`) since `<window>`. Loan officer assist rate rising; abandonment risk elevated.”                        |
| `Scope (Now)`               | Auto-computed counts/% over last 30 min and last 5 min guardrail window.                                                                                                        |
| `Likely Driver`             | Pattern examples: primary bureau response latency >2× baseline; retries causing queueing.                                                                                       |
| `Action Now`                | **Manual**: PO-approved failover to Alternate Bureau when thresholds are breached; reduce retry concurrency by \~30%; communicate impact; monitor queue drain.                  |
| `Decisions Needed`          | Confirm LOS-only incident definition; finalize failover criteria wording; document owners/dates.                                                                                |
| `Next Checkpoint`           | 2025-09-23 10:00 CT (BCV review); 2025-09-24 SoD readiness gate.                                                                                                                |


---

Understood—no extra populated email/Confluence docs.

Here’s a tight kit you can run with as-is.

## 30-minute run sheet (PO-only)

* **0–3 min** `Frame`: “We’re defining the Business Context View—plain language; no tooling.”
* **3–8 min** `Flow` / `Audience` / `Purpose` (capture in PO words).
* **8–15 min** `Success Definition` → confirm `Targets & Tolerances` (you propose; PO approves).
* **15–22 min** `Impact statement (template)`—pressure-test clarity (“What would you want read to stakeholders?”).
* **22–27 min** `Decisions Needed` (owner + date) including “manual failover requires business approval.”
* **27–30 min** `Next Checkpoint` and confirm you’ll compute health/volume/scope offline.

## Health rules (final for sim)

```
if P90_latency > 10s or error_rate_5m > 1.5% or timeouts_per_min >= 50: Failing
elif P90_latency > 5s or error_rate_5m > 0.7% or timeouts_per_min >= 20: Degraded
else: On track
```

* P90 target ≤ 3s.
* Error rate excludes business-rule denials.

## Post-meeting quick checklist

* Fill: `Current Health`, `Recent Volume`, `Scope (Now)`, `Likely Driver`, `Action Now` (note: **manual failover requires business approval**).
* Drop numbers into the BCV slide and capture sheet.
* Send recap (below) with 1–3 decisions + dates.

## Recap email template (send same day)

Subject: **Credit Check — Business Context View outcomes (PO 1:1)**

Body:

```
Ankur,

Thanks for defining the Credit Check Business Context View today. 
Highlights:
• Success: decision returned fast enough to avoid abandonment; failures rare.
• Targets/Tolerances: P90 ≤ 3s; Warn > 5s; Fail > 10s. Error (5-min) ≤ 0.3%; Warn > 0.7%; Fail > 1.5%. Timeouts Warn ≥ 20/min; Fail ≥ 50/min. 
• Impact sentence: “Applicants cannot advance past Credit Check; ~<N> affected (~<P>%) since <window>. Loan officer assist rate rising; abandonment risk elevated.”
• Constraint: Manual failover to Alternate Bureau requires business approval.

Decisions needed:
1) LOS-only incident definition — Owner: Ankur — Due: <date>
2) Final wording for failover criteria — Owner: Ankur — Due: <date>

Next checkpoint: <date/time> — review the populated BCV.
I’ll compute health/volume/scope and send the draft slide before the checkpoint.
– <Your Name>
```

## Files you already have

* PO Capture Sheet (DOCX): [download](sandbox:/mnt/data/BCV_Credit_Check_PO_Capture_Sheet.docx)
* BCV Slide (Proposed, ready to populate): [download](sandbox:/mnt/data/BCV_Credit_Check_vProposed.pptx)

Anything else you want tightened (e.g., alternate error thresholds, different impact sentence variants, or adding a “customer cohorts” row) before you meet Ankur?


---

Great prompt. Below is a tight, end-to-end map that shows how each **PO-captured field** drives telemetry, rules, dashboards, and behavior. Think of it as: **PO intent → measurable logic → computed status → Business Context View → playbook & comms**.

# 1) Field → Lineage → Result (13 fields)

| **Field (captured in 1:1)**            | **Purpose (why it exists)**                                          | **Translation to telemetry/logic**                                                                                                                                  | **Dashboard placement (what the user sees)**                          | **Operational use (what changes)**                                                 |
| -------------------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `Flow`                                 | Anchor to a business capability; the unit of value we’re protecting. | Map to `service_id`, `business_flow`, `stage`, `step` in your registry/CMDB; tag all queries with these keys.                                                       | Panel title and tags (e.g., “Credit Check — Loan Origination”).       | Routing and ownership; lets you slice incidents, SLOs, reports by flow.            |
| `Audience`                             | Clarify who reads/acts; prevents orphaned views.                     | Bind viewers/notification lists to roles (PO, on-call SRE, AppDev).                                                                                                 | “For:” meta-line on the panel; optional viewer filters.               | Decides who gets paged/notified and who approves actions.                          |
| `Purpose`                              | Keep it business-first; frames success in the business’ words.       | Stored verbatim; no computation.                                                                                                                                    | Short subtitle that explains *why this panel exists.*                 | Improves incident comms and exec scan; keeps UX language aligned.                  |
| `Current Health`                       | One status to compress many signals for exec scan.                   | Rule engine evaluates thresholds from `Targets & Tolerances` (worst dimension wins).                                                                                | Big status chip: `On track / Degraded / Failing`.                     | Drives page banners, SoD gates, and escalation policies.                           |
| `Success Definition`                   | Canonical statement of “what good looks like.”                       | Translate nouns → signals; verbs → computations; time/quality → thresholds. Example: *“decision returned quickly; failures rare”* → `latency_p90`, `error_rate_5m`. | Appears in a collapsible “Definition” card; links to signal formulas. | Serves as acceptance criteria for dashboards/alerts; audit trail for changes.      |
| `Targets & Tolerances`                 | Business-approved guardrails that make status computable.            | Thresholds wired into queries/alert rules (e.g., P90 ≤ 3s; Warn > 5s; Fail > 10s).                                                                                  | Rendered as a small table next to the status.                         | Alerting, SoD gates, and burn-rate checks pull from here (single source of truth). |
| `Error Rate Scope`                     | Prevents conflating policy denials with technical failure.           | Query filters exclude business-rule denials; include only system-caused errors (timeouts, dependency faults).                                                       | Footnote on the error stat: “Excludes policy denials.”                | Cuts false positives; aligns ops language with product language.                   |
| `Recent Volume`                        | Denominator/context; prevents false alarms at low load.              | Rolling windows (`5m/30m/24h`) for `req_count`; store peaks by hour/day.                                                                                            | Secondary stat (“9,000/day; peak 09:30–12:00 CT”).                    | Calibrates impact; informs rate-based alert thresholds and SoD readiness.          |
| `Current Impact (template)`            | Narrative the PO wants read aloud during incidents.                  | Template with live inserts: `<N>` from counts, `<P>%` from ratios, `<window>` from time bounds.                                                                     | A text panel updated live (numbers injected).                         | Standardizes comms; copy-paste ready for exec updates.                             |
| `Scope (Now)`                          | Quantifies how much is affected right now.                           | Computed counts/percent over a timebox (e.g., 30 min and 5 min guardrail).                                                                                          | “Scope: 380 affected (22%) since 09:40 CT.”                           | Decides severity/priority; feeds incident forms and SoD pass/fail.                 |
| `Likely Driver`                        | Give a defensible first hypothesis to shorten triage.                | Top contributors: e.g., `bureau_latency_p90 > 2x baseline`, retry queue depth spikes, dependency error class.                                                       | Short “Why” line with a link to drill-down.                           | Directs the first playbook step; improves minutes-to-clarity.                      |
| `Action Now`                           | Converts status into behavior (no stall).                            | Playbook entries tied to state; for Credit Check: **manual** failover requires business approval; reduce retry concurrency.                                         | Buttons/links: “Open playbook,” “Request business approval.”          | Ensures safe, repeatable mitigation; records approvals.                            |
| `Decisions Needed` & `Next Checkpoint` | Close gaps; create cadence and accountability.                       | Checklist with owners/dates; writes back to Confluence/Jira.                                                                                                        | Small table on the panel; “Next checkpoint: \<date/time>.”            | Keeps the system moving; creates a governance loop for unfinished definitions.     |

---

# 2) Translation examples (Credit Check)

**From PO input → signals:**

* `Success Definition` (PO): *“decision fast enough; failures rare”*
  → Signals:

  * `credit_check.decision.latency_ms` (end-to-end)
  * `credit_check.error.rate_5m` (excluding policy denials)
  * `credit_check.timeout.count_per_min`

**Thresholds (from `Targets & Tolerances`):**

* Latency `P90`: Target ≤ `3s`; `Warn > 5s`; `Fail > 10s`
* Error rate (5-min): Target ≤ `0.3%`; `Warn > 0.7%`; `Fail > 1.5%`
* Timeouts/min: `Warn ≥ 20`; `Fail ≥ 50`

**Health rule** (worst dimension wins):

```
if P90_latency > 10s or error_rate_5m > 1.5% or timeouts_per_min >= 50: "Failing"
elif P90_latency > 5s or error_rate_5m > 0.7% or timeouts_per_min >= 20: "Degraded"
else: "On track"
```

**Error scope logic** (`Error Rate Scope`):

* Include: timeouts, transport errors, dependency/system failures
* Exclude: valid *policy denials* (business rules)

**Impact template (with live numbers injected):**

* “Applicants cannot advance past Credit Check; \~`<N>` affected (\~`<P>%`) since `<window>`. Loan officer assist rate rising; abandonment risk elevated.”

---

# 3) Lineage diagram (intent → data → view → action)

```
[PO Inputs]
  Flow, Purpose, Success Definition,
  Targets & Tolerances, Error Rate Scope,
  Impact Template, Decisions/Checkpoint
        │
        ▼
[Translation Layer]
  • Map to service/flow IDs (CMDB/registry)
  • Define signals (latency_p90, error_rate_5m, timeouts/min)
  • Implement filters (exclude policy denials)
  • Encode thresholds (warn/fail)
        │
        ▼
[Telemetry + Computation]
  • Queries over logs/APM/metrics
  • Rolling windows (5m/30m/24h)
  • Health evaluation (worst dimension)
  • Scope counts & % (time-bounded)
        │
        ▼
[Business Context View]
  • Status chip: On track/Degraded/Failing
  • Volume, Scope, Why (Likely Driver)
  • Impact narrative (numbers injected)
  • Threshold table + Definition card
  • Decisions/Checkpoint table
        │
        ▼
[Operational Outcomes]
  • Incident comms (paste-ready sentence)
  • Playbook actions (manual failover needs business approval)
  • SoD readiness gates and weekly reviews
  • Jira/Confluence updates for open decisions
```

---

# 4) Final result in dashboards (what “good” looks like)

**Executive scan row (Credit Check):**

* **Status chip:** `On track / Degraded / Failing` (computed)
* **Key stats:** `P90 latency`, `5m error rate`, `timeouts/min`, `requests (30m/24h)`
* **Impact panel:** the PO’s sentence with live numbers
* **Why:** one-liner (“Primary bureau latency > 2× baseline; retry queue elevated”), link to drill-down
* **Threshold table:** shows the PO-approved tolerances
* **Operating cards:** “Open playbook,” “Request business approval” (for manual failover)
* **Governance:** decisions list and next checkpoint

**Drill-downs (for SRE/AppDev):**

* Latency percentile chart with baseline bands
* Error breakdown by class (policy denials excluded)
* Dependency latency/timeout charts
* Retry/concurrency charts

---

# 5) Concrete mapping snippets (so it’s computable)

**Signal formulas (illustrative):**

```
latency_p90_5m = P90(latency_ms over last 5 minutes WHERE flow='credit_check' AND is_policy_denial=false)
error_rate_5m  = SUM(error_events WHERE system_failure=true) / SUM(valid_requests) over last 5 minutes
timeouts_per_min = COUNT(timeouts WHERE http_status=504 OR app_timeout=true) per minute
```

**Impact injection (pseudo):**

```
N = COUNT(failed_or_slow_requests over last 30 minutes)
P = ROUND(100 * N / COUNT(all_requests over last 30 minutes), 1)
window = "09:40–10:10 CT"
impact_sentence = f"Applicants cannot advance past Credit Check; ~{N} affected (~{P}%) since {window}. Loan officer assist rate rising; abandonment risk elevated."
```

**Playbook guard (manual failover requires business approval):**

```
IF health in {"Degraded" (≥10m), "Failing"}:
    Prompt = "Request business approval for Alternate Bureau failover"
    Block automatic switch; log decision owner + timestamp
```

---

## Why this structure works

* **PO defines meaning;** the system computes status.
* **Single source of truth** for thresholds prevents drift between dashboards and alerts.
* **Narrative with numbers** answers executives in one glance—then provides drill-downs for engineers.
* **Governance loop** (Decisions/Checkpoint) ensures unfinished definitions don’t stall adoption.

If you want, I can turn this into a Confluence “Lineage” section you can paste under the Credit Check BCV, or generate example queries for your specific tooling (Splunk, Grafana, or Splunk Observability).
---

I understand. Here’s an information architecture you can roll out in Confluence to make Business Observability a repeatable, company-wide SOP. It’s opinionated, minimal, and scales.

# Design goals

* **Repeatable:** same flow and artifacts for every service/flow.
* **Discoverable:** executives find “the view” fast; engineers find specs/drill-downs.
* **Governed:** clear ownership, review dates, and status.
* **Composable:** reuse snippets (definitions, logic, queries) across pages.

# Spaces & ownership

* **BOS — Standards & Templates** *(central space; read-wide, write-limited)*
  Holds SOPs, templates, canonical definitions, label taxonomy, governance.
* **BOS — <Line of Business> Implementations** *(one per LOB, e.g., “BOS — Home Lending”)*
  Holds actual Business Context Views (BCVs), signal specs, playbooks, decision logs.
* Optional: **Team subspaces** if you need autonomy (e.g., “BOS — Capital Markets”).

# Page tree (central Standards space)

1. **Start Here**

   * *What is Business Observability?*
   * *Core Principles* (your Philosophy → Reasoning → Implementation)
2. **Standard Operating Procedures**

   * SOP: *Create & Publish a Business Context View (BCV)*
   * SOP: *Signal Specification & Validation*
   * SOP: *Playbook Authoring*
   * SOP: *SoD Readiness & Review Cadence*
3. **Templates**

   * **Template — BCV Capture (PO 1:1)**
   * **Template — BCV (Published View)**
   * **Template — Signal Spec**
   * **Template — Playbook**
   * **Template — Decision Log**
4. **Registries**

   * **Flow Registry** (index of all flows with owners/status/review date)
   * **Signal Registry** (canonical signal names/definitions)
   * **Playbook Index** (by flow and severity)
5. **Governance**

   * Publishing workflow & RACI
   * Review calendar & SLAs
   * Change log (versioning policy)
6. **Tooling Guides**

   * Splunk/Grafana query patterns
   * Error scope rules (e.g., exclude policy denials)
   * Data quality checks
7. **Examples (Exemplars)**

   * “What good looks like” BCVs (approved)
   * Before/After examples

# Page tree (LOB Implementation space — example)

* **Home Lending — Overview**

  * Readiness dashboard (Page Properties Report aggregating all BCVs)
* **Flows/**

  * **Credit Check/**

    * **BCV — Credit Check (Published)**
    * **BCV Capture — Credit Check (PO 1:1)**
    * **Signal Spec — Credit Check**
    * **Playbook — Credit Check**
    * **Decision Log — Credit Check**
    * **Dashboard Links & Drill-downs** (Grafana/Splunk)
  * *Document Upload/* (same structure)
  * *Treasury Wires/* (same structure)

# Templates (how each page is structured)

## A) BCV Capture (PO 1:1) — Template

Use this to capture `PO-owned` fields only; everything computable is filled later.

```
# Business Context View — <Flow> (PO Capture)

`PO:` <name>   `Facilitator:` <name>   `Date:` <YYYY-MM-DD>   `Version:` v0.1

## PO Inputs (captured live)
- `Flow:` …
- `Audience:` …
- `Purpose:` …
- `Success Definition:` …
- `Targets & Tolerances:` …
- `Error Rate Scope:` …
- `Impact statement (template):` …
- `Decisions Needed:` …
- `Next Checkpoint:` …

## Computed/Operational (filled post-session)
- `Current Health:` Auto-computed
- `Recent Volume:` Auto-computed
- `Scope (Now):` Auto-computed
- `Likely Driver:` Post-session hypothesis
- `Action Now:` Playbook draft (note any constraints: e.g., manual failover requires business approval)
```

## B) BCV (Published View) — Template

Make this the single “system of record” page for the service’s business health.

**Top section — Page Properties table (for rollups):**

| Field              | Value                                        |
| ------------------ | -------------------------------------------- |
| `Flow`             | <Flow name>                                  |
| `Owner (PO)`       | <Name>                                       |
| `Status`           | Draft \| In Review \| Approved \| Deprecated |
| `Review_Date`      | <YYYY-MM-DD>                                 |
| `P90_Target`       | 3s                                           |
| `Error_Rate_Scope` | Excludes business-rule denials               |
| `LOB`              | Home Lending                                 |

**Middle — The View (what execs see):**

* **Status chip:** On track / Degraded / Failing (computed)
* **Key stats:** P90 latency, 5-min error rate, timeouts/min, requests (30m/24h)
* **Impact (live sentence):** template with injected numbers
* **Why (Likely Driver):** short hypothesis + link to drill-down
* **Thresholds table:** business-approved tolerances
* **Actions:** link to Playbook; “Request business approval” (for manual failover)

**Bottom — References:**

* Link to *BCV Capture*, *Signal Spec*, *Playbook*, *Decision Log*, *Dashboard links*

> Use Confluence *Page Properties* macro for the top table and *Page Properties Report* on rollup pages.

## C) Signal Spec — Template

Defines the computable logic that turns PO intent into numbers.

```
# Signal Spec — <Flow>

## Scope
`FlowID:` <id>   `Stage:` <stage>   `Step:` <step>   `ServiceNow:` <service>

## Definitions
- `latency_p90_5m:` P90 of end-to-end decision latency over 5 min
- `error_rate_5m:` errors / valid_requests over 5 min
  - Include: timeouts, transport, dependency/system faults
  - Exclude: policy denials
- `timeouts_per_min:` count of HTTP 504 + app timeouts per minute

## Thresholds (source of truth)
- P90: Target ≤ 3s; Warn > 5s; Fail > 10s
- Error rate: Target ≤ 0.3%; Warn > 0.7%; Fail > 1.5%
- Timeouts/min: Warn ≥ 20; Fail ≥ 50

## Queries / Panels
- Splunk/Grafana queries (links or code blocks)
- Data quality checks
```

## D) Playbook — Template

```
# Playbook — <Flow>

## Triggers
- Health = Degraded for ≥10 min OR any Failing condition

## Actions (v0.1)
- Escalate for business approval of manual failover (record approver + timestamp)
- Reduce retry concurrency by ~30%; cap in-flight requests to baseline P95
- Communicate impact using BCV sentence; update every 15 min
- Verify recovery (P90 ≤ 3.5s within 20 min); revert routing after 30 min under Warn

## Safety Constraints
- Manual failover requires business approval

## Links
- BCV (Published), Signal Spec, Dashboards, Incident runbook
```

## E) Decision Log — Template

Simple table; one row per decision.

| Date       | Decision                     | Owner | Due/Review | Status | Notes |
| ---------- | ---------------------------- | ----- | ---------- | ------ | ----- |
| 2025-09-23 | LOS-only incident definition | Ankur | 2025-09-24 | Open   | —     |

# Rollups & navigation (how people find things)

* **LOB Overview page** uses *Page Properties Report* to list all **BCVs** with columns: `Flow`, `Owner`, `Status`, `Review_Date`, `P90_Target`.
* **Signal Registry** uses the same pattern to aggregate *Signal Spec* pages.
* **Playbook Index** aggregates all playbooks by flow/severity.

# Labels (taxonomy for search & reports)

Apply consistently:

* Content type: `bos-bcv`, `bos-bcv-capture`, `bos-signal`, `bos-playbook`, `bos-decisions`
* Domain: `lob-home-lending`, `flow-credit-check`, `stage-loan-origination`
* Lifecycle: `status-draft`, `status-approved`, `status-deprecated`

# Naming conventions

* **BCV — <Flow>** (Published)
* **BCV Capture — <Flow>**
* **Signal Spec — <Flow>**
* **Playbook — <Flow>**
* **Decision Log — <Flow>**

# Workflow & governance

* **States:** Draft → In Review → Approved → Live → Deprecated
* **Owners:** PO owns meaning (`Success`, `Tolerances`, impact wording). SRE owns computations & live status.
* **Reviews:** `Review_Date` must be set; LOB Overview highlights overdue reviews.
* **Changes:** Any threshold change requires PO approval; log in *Decision Log* (link from BCV).

# Lineage pattern (visible on every BCV)

At the bottom of each BCV page, include a “Lineage” section:

```
PO Intent → Signal Spec (logic & thresholds) → Telemetry Queries → Health Evaluation → BCV (Published) → Playbook & Comms
```

Each arrow is a link to the actual page or query block.

# Starter set you can create today (Home Lending)

* In **BOS — Standards & Templates**: create all 5 templates above.
* In **BOS — Home Lending**:

  * Create **Flows/Credit Check/** with the five pages (Capture, Published, Signal, Playbook, Decisions).
  * Tag with labels; fill *BCV Capture* from your 1:1; publish *BCV (Published)* once thresholds are approved.

---

## Two quick confirmations

1. Confluence Cloud or Data Center? (Macro names/features differ slightly.)
2. Do you want a **single BOS space** with LOB sections, or **one space per LOB**? I can tune the rollup reports accordingly.


---

Here’s exactly what I’ll hand the team to run PO 1:1s smoothly:

* `Email invite (PO-only)` — copy/paste template with micro-brief and agenda.
* `30-minute run sheet` — step-by-step script for the meeting.
* `PO capture sheet` — DOCX + Confluence template for **PO-owned fields**; computed fields deferred.

  * Download: [BCV\_Credit\_Check\_PO\_Capture\_Sheet.docx](sandbox:/mnt/data/BCV_Credit_Check_PO_Capture_Sheet.docx)
* `BCV slide stencil` — one-pager to show the PO; easy to populate post-meeting.

  * Download: [BCV\_Credit\_Check\_vProposed.pptx](sandbox:/mnt/data/BCV_Credit_Check_vProposed.pptx)
* `Thresholds & rules (sim-ready)` — P90 ≤ `3s`; error rate excludes policy denials; Warn/Fail values; health logic.
* `Impact sentence template` — standardized narrative with live numbers injected.
* `Playbook constraint` — **manual failover requires business approval** (documented language).
* `Confluence IA (Data Center)` — page types + labels + rollups:

  * Templates: `BCV Capture`, `BCV (Published)`, `Signal Spec`, `Playbook`, `Decision Log`
  * Rollups via Page Properties / Page Properties Report (Data Center)
  * Label taxonomy for discovery (e.g., `bos-bcv`, `flow-credit-check`, `lob-home-lending`)

If you want, I’ll add the invite text and the Confluence templates to your space so the team can start today.
---

Got it—here are the high-level steps:

1. **Engage the Product Owner & pick one flow.** Schedule a 30-min PO-only session.
2. **Prime the PO.** Send a short micro-brief and the one-page capture form.
3. **Run the session.** Capture `Flow, Purpose, Success, Targets/Tolerances, Impact sentence, Decisions, Next checkpoint`.
4. **Translate to specs.** Convert PO intent into signal definitions, filters (exclude policy denials), and thresholds.
5. **Compute health logic.** Encode On track/Degraded/Failing rules and mock values for review.
6. **Draft the Business Context View.** Produce the single-slide, plain-English health view.
7. **Review & approve with PO.** Confirm tolerances, finalize impact wording, record open decisions.
8. **Publish in Confluence.** Post BCV + capture + signal spec + playbook; label and add to the roll-up page.
9. **Wire dashboards & actions.** Hook up panels/alerts; document that failover is **manual with business approval**.
10. **Operate & govern.** Use the impact sentence in incidents, run SoD checks, close decisions, and review quarterly; then repeat for the next flow.
