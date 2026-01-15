# FMEA-BOS Integration: AI Assistant Instructions

**Purpose:** This document provides instructions for integrating Business Observability concepts into the FMEA Lightweight Tier 1 Adoption Package.

**How to use:** Upload this file to your workspace. Ask your AI coding assistant to read this file and apply the changes to the specified FMEA documents.

---

## Context

### What is FMEA?
Failure Mode Effects Analysis - a structured 2-hour session where teams identify failure points, score risks (Likelihood × Severity = RPN), and take action on the top 3 highest-risk items. The goal is tangible improvements: alerts, runbooks, circuit breakers, contingencies.

### What is Business Observability?
Business Observability is a framework for connecting technical signals to business outcomes. It organizes observability into four layers:
- **Layer 1 (System):** Infrastructure health - "Is it up?"
- **Layer 2 (Process):** Application correctness - "Is it correct?"
- **Layer 3 (Business Health):** Outcome attainment - "Is the expectation met?"
- **Layer 4 (Business Impact):** Consequence quantification - "How bad when we fail?"

Business Observability structures business impact into 4 categories: Customer, Financial, Legal/Risk, Operational.

### Integration Goal
FMEA produces artifacts that Business Observability structures (alerts, dashboards, playbooks). The FMEA package should reference these concepts where natural, without requiring a formal observability framework for FMEA to be valuable. Light touch integration - enhance, don't restructure.

---

## Changes to Apply

### File 1: `1-quick-start-guide.md`

#### Change 1.1: Enhance "Why Improvements Matter" Table

**Location:** Find the table under "Why Improvements Matter (Outcome Mapping)" (approximately lines 42-51)

**Current table:**
```markdown
| Improvement Type | How It Drives Business Outcomes |
|------------------|--------------------------------|
| **Alert** | Faster detection → Lower TTR |
| **Runbook** | Faster diagnosis → Lower TTR, less human intervention |
| **Circuit Breaker** | Auto-recovery → Fewer incidents, lower customer impact |
| **Contingency** | Manual fallback → Lower customer impact during outages |
| **Observability** | Faster root cause → Lower TTR |
```

**Replace with:**
```markdown
| Improvement Type | Observability Layer | How It Drives Business Outcomes |
|------------------|--------------------|---------------------------------|
| **Alert** | System/Process (L1-2) | Faster detection → Lower TTR |
| **Runbook** | Response artifact | Faster diagnosis → Lower TTR, less human intervention |
| **Circuit Breaker** | Process (L2) | Auto-recovery → Fewer incidents, lower customer impact |
| **Contingency** | Business Impact (L4) | Manual fallback documented → Lower customer impact during outages |
| **Observability Dashboard** | Business Health (L3) | Stakeholder visibility → Proactive response before escalation |
```

---

#### Change 1.2: Enhance Failure Node Focus Areas Table

**Location:** Find the table under "Where to look for failures (focus areas)" in Segment 2 (approximately lines 79-89)

**Current table:**
```markdown
| Focus Area | What to Examine |
|------------|-----------------|
| **External Dependencies** | Vendor APIs, third-party services, downstream systems |
| **Data Quality** | Validation errors, missing fields, format issues, corruption |
| **Capacity/Scale** | Connection pools, queue depth, throughput limits |
| **Timeouts & Latency** | API timeouts, slow queries, network delays |
| **Batch Processing** | Job failures, partial completion, retry handling |
| **Configuration** | Environment drift, feature flags, secrets expiration |
| **Human Touchpoints** | Manual steps, approvals, handoffs between teams |
```

**Replace with:**
```markdown
| Focus Area | What to Examine | Typical Signal Type |
|------------|-----------------|---------------------|
| **External Dependencies** | Vendor APIs, third-party services, downstream systems | Availability ratio, latency threshold |
| **Data Quality** | Validation errors, missing fields, format issues, corruption | Error rate ratio, validation pass % |
| **Capacity/Scale** | Connection pools, queue depth, throughput limits | Utilization threshold (%), saturation |
| **Timeouts & Latency** | API timeouts, slow queries, network delays | Latency threshold (p95, p99) |
| **Batch Processing** | Job failures, partial completion, retry handling | Success rate ratio, completion % |
| **Configuration** | Environment drift, feature flags, secrets expiration | Health check (binary pass/fail) |
| **Human Touchpoints** | Manual steps, approvals, handoffs between teams | Queue depth threshold, aging time |
```

---

#### Change 1.3: Add New Section "From FMEA to Observability"

**Location:** Insert this new section AFTER the "Quick Reference Card" section (before the final closing line)

**Add this content:**
```markdown
---

## From FMEA to Observability

FMEA findings translate directly into observability artifacts. This section helps teams understand how their FMEA outputs become operational monitoring.

### Mapping FMEA Findings to Artifacts

| FMEA Finding | Observability Artifact | Example |
|--------------|----------------------|---------|
| **Failure Point** | Signal Definition | "API timeout > 5s" becomes an alerting signal |
| **Customer Impact** | Business Impact Signal | "Customers blocked" becomes a quantified metric |
| **Top Action (Alert)** | Alert + Dashboard Panel | Alert triggers notification; dashboard shows trend |
| **Top Action (Runbook)** | Playbook | Linked from alert and dashboard for fast response |
| **Top Action (Dashboard)** | Observability Dashboard | Visualizes signal health over time |

### Business Impact Categories

When assessing impact, consider all four categories (not just customer-facing):

| Category | Questions to Ask | Example Impacts |
|----------|-----------------|-----------------|
| **Customer** | Who is blocked? What's their experience? | Users can't complete transactions, see errors, lose trust |
| **Financial** | What revenue is at risk? What penalties? | Transaction value lost, late fees, refund costs |
| **Legal/Risk** | What compliance exposure? Regulatory impact? | Audit findings, regulatory reporting failures |
| **Operational** | What manual work is created? Who gets paged? | Hours of manual intervention, team escalation, overtime |

### For Teams Using Business Observability Frameworks

If your organization uses a business observability framework, FMEA findings can seed your service profile:

- **Failure Points** → Signal trigger conditions (what to measure)
- **Impact Assessments** → Business Impact layer (4 categories, quantified)
- **Improvement Actions** → Signal, Alert, Playbook, Dashboard artifacts

Ask your Principal Engineer or platform team about integrating FMEA findings with your observability framework.
```

---

### File 2: `2-rapid-fmea-template-instructions.md`

#### Change 2.1: Enhance Severity Scale with Business Impact Categories

**Location:** Find the "Severity Scale (1-5)" section (approximately lines 139-145)

**Current content:**
```markdown
#### Severity Scale (1-5)
- **1 - Minimal:** No customer impact, internal only
- **2 - Minor:** Customer notices, but can complete task
- **3 - Moderate:** Customer delayed/blocked temporarily
- **4 - Major:** Transaction fails, customer must retry/call support
- **5 - Critical:** Data loss, security breach, or complete service outage
```

**Replace with:**
```markdown
#### Severity Scale (1-5)
- **1 - Minimal:** No customer impact, internal only
- **2 - Minor:** Customer notices, but can complete task
- **3 - Moderate:** Customer delayed/blocked temporarily
- **4 - Major:** Transaction fails, customer must retry/call support
- **5 - Critical:** Data loss, security breach, or complete service outage

**Tip:** When scoring severity, consider all four impact categories:
| Category | Severity 3 Example | Severity 5 Example |
|----------|-------------------|-------------------|
| **Customer** | Some users delayed | All users blocked |
| **Financial** | Minor revenue delay | Significant revenue loss |
| **Legal/Risk** | Documentation gap | Regulatory violation |
| **Operational** | 1 hour manual work | Full team mobilization |

If ANY category is high-severity, use the higher score.
```

---

### File 3: `3-facilitation-guide.md`

#### Change 3.1: Enhance Define Scope Section

**Location:** Find the "Define Scope" bullet point in "Segment 1: Introduction" (early in document)

**Find this text:**
```markdown
**Key principle:** Focus on end-to-end functional flows, not single components. FMEA on a single API has smaller value than analyzing the full path where failures cascade.
```

**Add after that paragraph:**
```markdown
**Observability framing:** The scope you define here will likely become a "service" in your observability platform - a unit of health monitoring with its own dashboard, alerts, and playbooks. Choose boundaries that make sense for stakeholder communication: "Payment Processing Service" rather than "API endpoint X."
```

---

#### Change 3.2: Enhance Impact Assessment in Segment 2

**Location:** Find the brainstorming questions in Segment 2 about customer impact

**Find this text:**
```markdown
- **"What's the customer impact?"** (transaction fails, incorrect data, delay, etc.)
```

**Replace with:**
```markdown
- **"What's the business impact?"** Consider all four categories:
  - Customer: Who is blocked or degraded?
  - Financial: What revenue or cost is at risk?
  - Legal/Risk: Any compliance or regulatory exposure?
  - Operational: What manual work or escalation is needed?
```

---

### File 4: `6-governance-and-support-structure.md`

#### Change 4.1: Add Related Frameworks Reference

**Location:** At the end of the document, before any closing statement

**Add this new section:**
```markdown
---

## Related Frameworks

### Business Observability

FMEA produces artifacts (alerts, runbooks, dashboards, contingencies) that fit within broader observability frameworks. If your organization uses a business observability framework, consider how FMEA findings integrate:

| FMEA Output | Observability Integration |
|-------------|--------------------------|
| Failure Points | Signal definitions (what to measure) |
| Impact Assessments | Business impact layer (quantified by category) |
| Alerts | Alert rules linked to signals |
| Runbooks | Playbooks linked from dashboards and alerts |
| Observability improvements | Dashboard panels showing service health |

### Four-Layer Observability Model

Many organizations structure observability into layers:
1. **System:** Infrastructure health (uptime, latency, resources)
2. **Process:** Application correctness (validation, error rates)
3. **Business Health:** Outcome attainment (are stakeholder expectations met?)
4. **Business Impact:** Consequence quantification (how bad when we fail?)

FMEA focuses primarily on Layers 3-4: identifying what business outcomes are at risk and quantifying the consequences. The improvements FMEA produces (alerts, dashboards) typically span all four layers.

Ask your Principal Engineer or platform team about how FMEA integrates with your organization's observability framework.
```

---

## Validation Checklist

After applying changes, verify:

- [ ] `1-quick-start-guide.md`: "Why Improvements Matter" table has 3 columns including "Observability Layer"
- [ ] `1-quick-start-guide.md`: Failure Focus Areas table has 3 columns including "Typical Signal Type"
- [ ] `1-quick-start-guide.md`: New section "From FMEA to Observability" exists near end of document
- [ ] `2-rapid-fmea-template-instructions.md`: Severity Scale includes 4-category impact tip table
- [ ] `3-facilitation-guide.md`: Define Scope has "Observability framing" paragraph
- [ ] `3-facilitation-guide.md`: Customer impact question expanded to 4 categories
- [ ] `6-governance-and-support-structure.md`: "Related Frameworks" section exists at end

---

## Notes for AI Assistant

- Preserve all existing content not explicitly modified
- Maintain markdown formatting consistency with surrounding content
- Do not change the 8-column Rapid FMEA template structure
- Do not change RPN scoring methodology
- Do not add observability framework as a requirement - keep integration optional ("if your organization uses...")
- Keep the lightweight 2-hour session philosophy intact
