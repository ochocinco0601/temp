## PROMPT START

You are helping define a Business Observability System (BOS) service. BOS focuses on BUSINESS health, not just technical health.

### Key BOS Concepts

**BOS Service ≠ CMDB Application**
- A BOS Service is defined by BUSINESS CAPABILITY and STAKEHOLDER PERSPECTIVE
- Multiple technical applications/microservices may support ONE BOS service
- Ask: "What business outcome do stakeholders care about?"

**Three-Signal Model:**
1. **Traditional Signals** - System health (uptime, latency, errors)
2. **Business Health Signals** - Are we achieving the business goal?
3. **Business Impact Signals** - What's the consequence when we don't?

**Four Impact Categories** (always define all four, even if "Not Defined"):
- **Customer** - Experience, ability to achieve their goals
- **Financial** - Revenue, cost, penalties
- **Legal/Risk** - Compliance, regulatory exposure
- **Operational** - Internal process efficiency, productivity

### Your Task

Analyze the provided engineering specification or feature list and extract the following. **CRITICAL: For every item you extract, include a SOURCE REFERENCE showing where it came from (Jira row number, spec section, entity name, or application ID).**

---

**1. SERVICE DEFINITION**

| Field | Value | Source Reference |
|-------|-------|------------------|
| BOS Service Name | [business-focused name] | [derived from...] |
| Business Capability | [one sentence] | [spec section/feature] |
| Primary Application ID | [main app] | [from entity table/Jira] |
| Supporting Applications | [list] | [entity names from spec] |
| External Dependencies | [vendors/systems] | [entity table reference] |

---

**2. STAKEHOLDERS**

For each stakeholder identified, include lineage:

| Stakeholder | Interaction System | Goal | Source Reference |
|-------------|-------------------|------|------------------|
| [Role] | [App/UI they use] | [Why they care] | [Use case #, Jira row, or entity] |

---

**3. STAKEHOLDER EXPECTATIONS**

| Stakeholder | Expectation | Source Reference |
|-------------|-------------|------------------|
| [Role] | "[Stakeholder] expects [specific outcome]" | [Feature row, use case, or requirement] |

---

**4. BUSINESS IMPACT BY CATEGORY**

| Category | Impact if Service Fails | Source Reference |
|----------|------------------------|------------------|
| Customer | [specific consequence] | [inferred from use case/feature] |
| Financial | [specific consequence] | [if mentioned in requirements] |
| Legal/Risk | [specific consequence] | [compliance refs in spec] |
| Operational | [specific consequence] | [from NFRs or process flows] |

Mark as "Not Defined - needs stakeholder input" if not derivable from source documents.

---

**5. BUSINESS FLOWS IDENTIFIED**

List the key business flows with their source:

| Flow Name | Actors Involved | Source Reference |
|-----------|-----------------|------------------|
| [Flow] | [Actor → System → Outcome] | [Use case #, sequence diagram #] |

---

**6. PROPOSED SIGNALS** (for discussion with engineering team)

| Signal Type | Proposed Metric | Rationale | Source Reference |
|-------------|-----------------|-----------|------------------|
| Business Health | [measurement] | [why this matters] | [derived from expectation #] |
| Business Impact | [measurement] | [what it quantifies] | [derived from impact category] |

---

### Output Instructions

1. Use tables for easy review with engineering team
2. **Every row must have a Source Reference** - this enables validation
3. Flag assumptions clearly: "[ASSUMPTION: ...]"
4. Note gaps: "Source documents do not specify [X] - recommend stakeholder discussion"
5. If multiple applications support one capability, group them under the single BOS service

---

**Paste your engineering specification, Jira features export, or system documentation below:**

## PROMPT END
