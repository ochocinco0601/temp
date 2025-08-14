## **Purpose and Problem**

If tech health not equal to business health, how do i know the app is doing what its supposed to?

When its not, how can i know the business impact?

The traditional approach to monitoring incorrectly assumes technical health equals business health. We saw the direct impact of this during recent loan funding incidents where technical dashboards were green, but treasury orders were failing silently. This plan delivers a capability that answers—in minutes—if we are meeting our business goals.

## **The Commitment**

We currently support XYZ applications for LOB, but lack a consistent way to identify which services matter most to our business outcomes. We will move from monitoring technical health to validating business outcomes through a **shared delivery contract** between Product, Development, and Platform teams.

### **Phase 1 (Now): Achieve Minutes-to-Clarity for business impact**

The business impact of an incident will be known in minutes through a **hard SLO**.  

**Making Business Goals Explicit** 

We will translate abstract business goals into clear, measurable outcomes. This replaces ambiguity with precision.

**Initial Phase 1 Flows:**

* example a 
* example B
* example c 
* example d

  ### **Phase 2 (Next): Achieve Minutes-to-Hypothesis**

Fast diagnosis will become a hard SLO and a change gate for services that have completed the Phase 1 enhancements.

### **What Changes in an Incident**

A single Impact Panel returns, within minutes:

* Customer and volume risk  
* Financial (dollars) at risk  
* Legal and compliance risk  
* Operational efficiency risk

**Example of an Explicit Business SLO:**

*"Loan funding service: 100% of scheduled closings funded by 8:00 AM CT, else alert at 7:30 AM if projected shortfall \> 1%."*

Triage then uses that clarity to focus investigation and mitigation.

### **SLOs & Targets**

| Capability | Phase 1 Target | Phase 2 Target |
| :---- | :---- | :---- |
| **Time-to-Clarity (P95)** | ≤ 10 minutes (**hard SLO**) | Maintain ≤ 10 minutes |
| **Coverage of top business-critical flows** | ≥ 80% with full clarity artifacts by Day 90 | ≥ 95% |
| **Start-of-Day (SoD) readiness pass rate** | ≥ 99% for covered flows | ≥ 99% |
| **Time-to-Hypothesis (P95)** | Baseline first 30 days; \+20–30% improvement by Day 90 (**reported**) | ≤ 15–20 minutes (**hard SLO**) |

*The Time-to-Hypothesis baseline will be established from real incidents (all severities) and structured drills/back-tests.*

### **Enabler Capabilities**

To move beyond ad-hoc documentation and make this capability scalable and repeatable, we require **A Single Source of Truth for Business Services**. Core SRE will engineer this through three components:

1. A **system of record** for business definitions, SLOs, and impact rules.  
2. A **service registry** to map services to business flows.  
3. An **impact engine** to power real-time dashboards and alerts.

### **Effort, Resourcing & Coverage** 

**Temporary capacity diversion:** Product/App Dev will redirect limited sprint capacity from existing plans to adopt shared enablers; we will show monthly evidence of effort trending down.

SRE will deliver shared enablers (Impact Panel tile, Start-of-Day check, SLO/SLI templates).  Product/App Dev will redirect capacity to adopt them. We will record actual hours on the first flows, calibrate, and scale accordingly.

| Mode | Product | Dev | Platform | Scope |
| :---- | ----: | ----: | ----: | :---- |
| **Manual (current reality)** | \~50h | \~200h | \~150h | Ad hoc analysis \+ bespoke wiring for a single flow (e.g., Treasury Orders) |
| **Systematic (target run-rate)** | **4h** | **\~40h** | **\~40h** | Apply reusable patterns (Impact Panel tile, SoD check, SLO/SLI template), no bespoke re-work |

*Planning note:* Where existing telemetry/business data already expose needed signals, Dev hours decline (no new application code required).

**Impact Coverage Tracker:** We will maintain a visible list of critical flows with `Green/Yellow/Red` status, backlog link, target date, and interim plan. **Minutes-to-Clarity SLO** applies to `Green/Yellow`. `Red` carries a time-boxed waiver tied to a backlog item.

The tracker provides transparent visibility into which flows are fully covered, partially covered, or not yet instrumented (`Red`). Flows that remain `Red` for more than one PI will be explicitly highlighted to prompt discussion during PI planning and leadership forums. This enables Product, Development, and Platform to align on priorities and address gaps, while giving Platform and Development a clear reference during incidents.

| Flow Name | Business Owner | Coverage Status | SLO Ready? | Backlog Item | Target Date | Notes / Interim Plan |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| Svc A | Jane Smith | 🔴 Red | No | JIRA-4521 | PI-2 End | Manual analysis via treasury ops \+ Dev query; \~4 hrs ETA |
| Svc b | Mark Davis | 🟡 Yellow | Partial | JIRA-4620 | PI-1 Mid | Partial metrics available; dependency mapping in progress |
| Svc c | Sarah Lee | 🟢 Green | Yes | N/A | Complete | Fully instrumented; automated SoD check in place |

**Evidence & Cadence:**

* Capture Product/Dev/Platform hours for first 1–2 flows, split `manual` vs `capability-build`.  
* Report monthly: per-flow hours trend and % flows `Green/Yellow/Red`.  
* 60-day gate: confirm downward trend toward the target run-rate or request additional enabler investment.

### **Operating Model & Accountability**

This model requires an explicit delivery contract grounded in shared responsibility:

* **Product Owners** — Are the definitive owners of business outcomes. They will define the critical business flows, success criteria (SLIs/KPIs), and impact rules required to measure performance.  
* **Application Development** — Instrument applications to emit the business-critical telemetry needed to measure the SLOs and validate that the data is accurate.  
* **Platform SRE (Home Lending)** — Partners with Application Development to integrate services with the central BOS capabilities, configuring the Start-of-Day checks, alerts, and dashboards for each flow.  
* **Core SRE (Horizontal)** — Designs and provides the standard models, shared tooling (e.g., the Impact Panel), and governance blueprints that make business observability repeatable across the enterprise.  
* **Governance** — Gate “critical” services on Business SLIs \+ impact rules \+ telemetry; audit via release/change checklists.

### **Scope & Governance**

* **Phase 1 Gate** (enforced for BOS-covered services): Business SLIs, Impact Rules, Signals, SoD check, Impact Panel, Validation evidence.  
* **Phase 2 Gate** (scope-guarded): Applies only to services that completed Phase 1 BOS enhancements. Adds Golden Queries, critical Dependency Map, Runbook links, and Time-to-Hypothesis telemetry (**hard SLO** begins).

### **90-Day Plan (high level)**

* **Weeks 1–2**: Lock flows/owners, publish impact model, bring up coverage tracker; Impact Panel v0 for first flow.  
* **Weeks 3–6**: Signals live \+ SoD checks for early flows; tabletop validations; start baseline timing for triage.  
* **Weeks 7–10**: Remaining flows reach Clarity; exec update on SLO attainment/coverage; publish triage baseline \+ early trend.  
* **Weeks 11–13**: Phase 1 complete (Clarity). Kick off Phase 2 and activate triage gate for services that have completed Phase 1 Clarity enhancements.

### **What You Will See in 14 Days**

* **Live demo**: Impact Panel producing a minutes-level business answer for the first flow.  
* **Coverage tracker**: Owner/status per flow; Clarity SLO telemetry; SoD pass rate.  
* **Baseline in progress**: Triage timing collection started; initial golden queries/maps in place.

### **Decisions Requested**

1. **Endorse**: Phase 1 hard SLO for Minutes-to-Clarity; Phase 2 hard SLO for Minutes-to-Hypothesis.  
2. **Approve**: Phase 1 clarity gate now; Phase 2 triage gate for BOS-enhanced services.  
3. **Commit**: Named Product Owners and App Dev sprint capacity for Phase 1 flows.
