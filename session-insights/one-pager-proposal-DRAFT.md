# Business Observability: Shared OKR Proposal for App Dev Partnership

---

## The Problem

Our monitoring can tell us whether systems are up, fast, and processing requests. It cannot reliably tell us whether the business outcome is being achieved — which customers are affected, what the revenue exposure is, or which business processes are blocked when something degrades.

That business context exists — across our people, wiki pages, alerts, and dashboards — but it's fragmented and implicit. During major incidents, we spend significant time assembling context that could have been documented once and reused every time. App Dev teams get pulled into P1 bridges to answer questions that could have been pre-documented. The scramble is the same work as proactive documentation — just higher stress, lower quality, and more people involved.

## The Shared Objective (Proposed — For Discussion)

**Enable teams to understand and quantify business impact in real-time when systems degrade.**

This requires all three organizations working together: Product defines what business success looks like, App Dev translates that intent into working instrumentation, and Platform sustains the monitoring framework. No single organization can deliver this alone — each contributes knowledge the others don't have.

**Proposed Key Results:**
- **Shared outcome:** Reduce time from incident declaration to confirmed business impact identification from [baseline] to ≤15 minutes for onboarded flows
- **Contextualized:** ≥X critical flows have documented business context — stakeholders, expectations, health targets, and impact definitions completed by Product Owners (Pipeline Stage 2)
- **Instrumented:** ≥X flows have business health and impact signals operational against PO definitions in the observability platform (Pipeline Stage 3)

These are our starting proposal. The specific targets (X) are outcomes of the initial flow selection conversation, not prerequisites. We expect this discussion to refine the scope based on what makes sense for both organizations.

**What App Dev gets:** Fewer reactive scrambles during incidents. Pre-documented business context that answers leadership questions without pulling engineers into bridges. A stronger stability story for App Dev's own OKRs.

## The Model: Three Actors, Structured Requirements

Business observability follows the same SDLC pattern teams already use — with a new requirement type flowing through it. Three actors each contribute knowledge the others don't have:

| Actor | What They Contribute | Layer Ownership |
|-------|---------------------|-----------------|
| **Product Owner** | Defines stakeholders, expectations, health targets, and business impact definitions | Business Health (L3) + Business Impact (L4) |
| **App Dev Engineer** | Assesses existing telemetry (logs, APM, dashboards), maps it to PO's business definitions, instruments for gaps, and identifies process-level signals from architectural knowledge | Process (L2) + implements L3/L4 |
| **Platform** | Identifies system-level signals; sets alert thresholds; builds dashboards, alerts, and playbooks from upstream inputs | System (L1) + operationalizes all layers |

This is an existing SDLC pattern — epic in the backlog, stories per actor, acceptance criteria that are checkable. The new element is a structured requirement type for business observability flowing through the machinery teams already operate.

### What This Looks Like Per Flow

For each business flow onboarded, three stories are produced — one per actor. Each story has specific acceptance criteria with defined fields. Here is what each actor actually fills out:

**Product Owner Story — Define Business Observability Requirements**

The PO captures business context that exists in their head or across scattered documentation:

| What PO Defines | Example (Credit Check Service) |
|----------------|-------------------------------|
| Service context | Name, business purpose, product line, CMDB ID |
| Stakeholder expectations | "Loan applicants expect credit checks return valid scores within acceptable timeframe" |
| What failure means | "Customer Impact: Loan applicants unable to proceed with application" |
| Impact categories | Customer experience, financial, legal/compliance, operational |
| Health signal targets | "Credit Check Success Rate — 85% over 1 hour" |
| Impact signal definitions | "Customers Blocked — count of applicants unable to proceed" |

**App Dev Engineer Story — Assess Existing Telemetry, Map to Business Definitions, Fill Gaps**

The engineer's work follows the same pattern as any NFR adoption into the SDLC — the same progression organizations use when adding SLO, security, or accessibility requirements to existing services:

1. **Assess** what telemetry already exists (logs, APM transactions, existing dashboards, application metrics)
2. **Map** existing telemetry to PO's business definitions — for mature services, this resolves many signals without new code
3. **Identify gaps** where PO defined something and no telemetry path exists
4. **Instrument** for gaps — targeted development work, scoped as backlog stories
5. **Contribute** process-level signals from architectural knowledge the PO doesn't have

| What Dev Contributes | Example (Credit Check Service) |
|---------------------|-------------------------------|
| Existing telemetry assessment | Application logs already capture `status` and `score` fields per request; APM tooling tracks transaction response times |
| Signal mapping (brownfield) | PO's "Credit Check Success Rate" maps to existing log data: good events = `status='SUCCESS' AND score BETWEEN 300 AND 850`; total events = `request_type='CREDIT_CHECK'` |
| Data source identification | SQL, APM, log-based — specifies where each signal's data lives |
| Process signals Dev identifies | "Credit Check Response Time — 5 second threshold" (Dev knows the architecture's timeout behavior; PO doesn't define this) |
| Gap instrumentation (greenfield) | `COUNT(DISTINCT applicant_id) WHERE credit_score IS NULL` → "Customers Blocked" — impact quantification that may require a new query or log enrichment |
| Technical ownership | Who maintains each signal's configuration |

**This is the core of the App Dev ask.** The effort varies by service maturity. For services with established logging and APM coverage, most signals resolve through assessment and mapping — the engineer is looking at their own systems through the PO's business lens, using tools they already use every day. New instrumentation is for targeted gaps, entered into the existing backlog as stories with specific acceptance criteria.

**Platform Story — Operationalize All Layers**

Platform takes upstream inputs and creates the operational artifacts:

| What Platform Contributes | Example (Credit Check Service) |
|--------------------------|-------------------------------|
| System signals Platform identifies | "Bureau Connection Health — 95% threshold" (Platform knows infrastructure dependencies) |
| Alert thresholds per signal | Alert at 80%, page at 75% (set below PO's 85% target based on operational judgment) |
| Alert routing configuration | Slack channel, PagerDuty rotation, escalation path |
| Four-layer dashboard | Business context + L3 health + L2 process + L1 system + L4 impact panels |
| Cross-layer playbook | Bureau drops (L1) → response times spike (L2) → success rate falls (L3) → customers blocked (L4) |

### The Readiness Pipeline

Each flow progresses through stages. Value exists at every stage, but the full payoff requires all four:

| Stage | What Happens | Who's Involved | Effort per Flow |
|-------|-------------|----------------|-----------------|
| **1. Identified** | Flow named, described, criticality ranked | Product + Platform | Hours |
| **2. Contextualized** | PO Story completed — stakeholders, expectations, health targets, impact definitions documented | Product Owner + SMEs | 1-2 working sessions |
| **3. Instrumented** | Dev Story completed — existing telemetry mapped, gaps instrumented, process signals identified | App Dev engineers + Platform | Varies by service maturity — brownfield mapping may be a working session; gap instrumentation enters the backlog as stories |
| **4. Operationalized** | Platform Story completed — system signals, alerts, dashboards, playbooks live in production | Platform + SRE | Days — Platform-led |

**Stage 3 is where App Dev engineering effort is concentrated.** The work follows the standard NFR adoption pattern: assess what exists, map it to the new requirement definitions, and instrument for gaps. For mature services with established logging and APM, the assessment and mapping phase resolves most signals — the same finding organizations see when adopting SLOs for existing services. Gap instrumentation is targeted development work scoped by what Stages 1-2 identify, not open-ended.

**Not always linear.** Some flows already have monitoring without documented business context. Bootstrapping means starting where value is.

## The Ask

**App Dev engineering and SME time** — scoped to 3-5 initial flows, not an open-ended initiative.

**Per flow, App Dev contributes:**
- **Stage 2 (PO Story):** 1-2 working sessions. PO and SMEs document stakeholders, expectations, health targets, and impact definitions. Guided by structured templates — the fields drive the thinking. App Dev engineers often have strong business context from building the system.
- **Stage 3 (Dev Story):** Engineers assess their service's existing telemetry (logs, APM, dashboards), map what exists to PO's business definitions, and instrument for gaps. For services with established observability, the mapping phase is the bulk of the work — engineers are looking at their own systems through a business lens using tools they use daily. Where gaps exist, instrumentation enters the team's existing backlog as user stories with checkable acceptance criteria. Effort varies by service maturity, not by a fixed "days per flow" estimate.

**Flow selection:** We propose choosing together — no single criterion works alone. The goal is flows where there's both business importance and a willing, available team.

**How this fits:** No new recurring meetings. No separate workstream. Stage 2 sessions scheduled as needed. Stage 3 work prioritized in existing backlogs. Platform drives the process and provides embedded support.

## What Platform Provides

- **Structured requirements framework** — signal model, field definitions, and templates that guide each actor's thinking. The template IS the methodology — filling it out IS doing business observability.
- **Embedded support** — Platform Engineering works directly with teams through each flow, facilitating the PO sessions and supporting Dev instrumentation decisions.
- **Operational artifact generation** — dashboards, alerts, and playbooks built from the documented business context. Platform takes Dev's validated queries and PO's business definitions and produces the operational layer.
- **Ongoing sustainment** — monitoring layer maintained by Platform. Teams don't inherit operational overhead.

## What We're NOT Asking

- **Not a complete inventory.** We start with 3-5 flows and build from there.
- **Not all new instrumentation.** Most teams already have logging, APM, and dashboards. The primary work is mapping existing telemetry to business definitions — the same assessment-first approach used in SLO adoption. New instrumentation is only for targeted gaps the assessment reveals.
- **Not all at once.** Early flows teach the pattern. Later flows go faster.
- **Not a separate initiative.** This flows through the existing SDLC — same backlog, same sprint process, new requirement type.

## Proposed Next Step

A working session between Platform and App Dev leadership to align on the shared objective, discuss flow selection criteria, and identify candidates to start. No commitment beyond that conversation.

We have a working interactive tool that demonstrates the full three-actor workflow with a real example (Credit Check Service — 4 stakeholders, 9 signals across all four layers). We can walk through it in that session.
