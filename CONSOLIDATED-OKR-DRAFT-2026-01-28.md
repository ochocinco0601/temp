# Consolidated OKR Draft - Stability Obj 1

**For Review:** Jan 28, 2026 Huddle
**Prepared by:** Chad
**Status:** DRAFT - Pending Group Approval

---

## Key Result

**Build a business-centric observability framework to improve MTTR and quantify business impact**

---

## Strategic Measures

### Part A: Framework Delivery (Chad)

*Build the generic, reusable BOS framework that any flow can be instrumented through*

| # | Strategic Measure | Target | Timeline |
|---|------------------|--------|----------|
| A1 | Deliver BOS framework with business health signal model, impact quantification methodology, and dashboard templates | Framework complete and documented | Q2 2026 |
| A2 | Define business success criteria structure (purpose, baseline, impact categories) for critical services | Template and process defined | Q2 2026 |
| A3 | Establish SLO mapping methodology appropriate for organizational maturity level | Methodology documented with at least one SLO type per identified journey | Q2 2026 |
| A4 | Reduce time-to-business-impact identification | ≤15 minutes for onboarded services | Q4 2026 |

**Framework Principle:** Agnostic of specific flows. Works for Lending, Payments, Insurance, or any product area. Generic and reusable.

---

### Part B: Flow Application (L3 Leads + Chad Partnership)

*L3 leads identify critical flows from their product areas; Chad partners to instrument them through the framework*

| # | Strategic Measure | Target | Timeline | Owner |
|---|------------------|--------|----------|-------|
| B1 | Each L3 lead identifies top 3 critical customer journeys/flows for their product area | 3 flows per L3 lead | Q2 2026 | L3 Leads |
| B2 | Instrument identified flows with business health and impact signals visible in observability platform | ≥50 critical flows instrumented | Q4 2026 | Chad + L3 Leads |
| B3 | Onboard product teams to BOS | ≥20 product teams | Q4 2026 | Chad |
| B4 | Visualize SLA adherence for critical applications via Grafana/observability platform | ≥99.9% adherence visible | Q4 2026 | Chad |

**Application Principle:** L3 leads own flow identification and business context. Chad owns instrumentation through the framework. Partnership model.

---

## Dependency

```
┌─────────────────────────────────────────────────────────────────┐
│                         DEPENDENCY                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Part A: Framework          Part B: Application                 │
│   ─────────────────    ───►  ──────────────────                  │
│   (Chad builds)              (L3 Leads apply)                    │
│                                                                  │
│   • Framework is INDEPENDENT   • Application DEPENDS on          │
│     of specific flows            framework existing               │
│                                                                  │
│   • Can succeed at A           • Cannot succeed at B             │
│     without B                    without A                        │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│   Team members are APPLYING the framework, not BUILDING it       │
└─────────────────────────────────────────────────────────────────┘
```

---

## What This Consolidation Removes from Transform

The following Transform Row 3 items are now covered under this consolidated Stability KR:

| Former Transform Item | Now Covered By |
|----------------------|----------------|
| "Map 100% of known critical user journeys to backend services with SLOs" | B1 + B2 (scoped to top 3 per L3) |
| "95% of known services Journey-to-SLO mapping" | A3 (reframed for organizational maturity) |
| "SLO adherence ≥99.9%" | B4 |
| "99.95% availability for top 3 Customer Journeys" | B2 (instrumentation provides visibility) |

---

## Open Scoping Questions (For Huddle Discussion)

| Question | Proposed Resolution |
|----------|---------------------|
| What does "95% of known services" mean? | **Reframe:** Focus on identified journeys having at least one SLO type, not exhaustive service coverage |
| What does "SLO mapping" mean for our organization? | **Accept current maturity:** Start with basic SLO types; don't assume Google-level sophistication |
| How many flows per L3? | **Propose:** 3 critical flows per L3 lead (per accountability model) |
| Exhaustive vs pragmatic coverage? | **Pragmatic:** Identified journey + at least one SLO type, not every nook and cranny |

---

## Stakeholder Message

> "We have an OKR. We want to get you business criticality monitoring of these critical flows. This is what we think we can do. And here's where we need your partnership in order to achieve it."

**To partner teams:**
- Chad delivers the framework (the "Chad process")
- L3 leads feed flows into that framework
- Partnership required to achieve business criticality monitoring

---

## Spreadsheet-Ready Format

For direct entry into OKR tracking spreadsheet:

| Objective | Outcome | Key Result | Strategic Measure | Assigned |
|-----------|---------|------------|-------------------|----------|
| Stability | Reduce Incident Impact and Improve Recovery | Build a business-centric observability framework to improve MTTR and quantify impact | **[A1]** Deliver BOS framework with business health signal model, impact quantification methodology, and dashboard templates by Q2 2026 | Chad |
| | | | **[A2]** Define business success criteria structure for critical services by Q2 2026 | Chad |
| | | | **[A3]** Establish SLO mapping methodology appropriate for organizational maturity by Q2 2026 | Chad |
| | | | **[A4]** Reduce time-to-business-impact identification to ≤15 minutes for onboarded services by Q4 2026 | Chad |
| | | | **[B1]** Each L3 lead identifies top 3 critical customer journeys for their product area by Q2 2026 *(depends on A1-A3)* | L3 Leads |
| | | | **[B2]** Instrument ≥50 critical flows with business health signals visible in observability platform by Q4 2026 *(depends on A1-A3, B1)* | Chad + L3 Leads |
| | | | **[B3]** Onboard ≥20 product teams to BOS by Q4 2026 | Chad |
| | | | **[B4]** Visualize ≥99.9% SLA adherence for critical applications via Grafana/observability platform by Q4 2026 | Chad |

---

## Review Checklist for Huddle

- [ ] Does the Framework/Application split make sense?
- [ ] Are the dependencies clear?
- [ ] Is "3 flows per L3 lead" the right target?
- [ ] Are the timelines realistic (Q2 for framework, Q4 for application)?
- [ ] Any strategic measures to add/remove/modify?
- [ ] Weightage assignment needed?
