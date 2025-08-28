# People & Roles

* **Product Owners —** Define business needs/requirements; provide inputs on customer/business goals. Source: “Business and product…identify their needs…define the requirements.”  When: 2025-08-28 (from file name); Observed: explicit; Confidence: high
* **Development Team —** Implements requirements and creates telemetry/metrics for validation. Source: “Our development team implements the requirements.”  When: 2025-08-28; Observed: explicit; Confidence: high
* **Platform Operations Team —** Facilitates visualization, alerting, and incident management when requirements aren’t met. Source: “Platform operations…will facilitate visualizing and alerting…And Incident Management.”  When: 2025-08-28; Observed: explicit; Confidence: high
* **Senior Leaders (audience) —** Technology/product leaders and at least two architect leaders. Source: “Our group today…with you as senior leaders”; later: “audience of…Technology leaders…Product… architect leaders.”   When: 2025-08-28; Observed: explicit; Confidence: high
* **Ben Sigelman (referenced) —** External observability leader cited for “observability is about detecting change.” Source: “Ben siegelman…Observability is fundamentally about detecting change…planned/unplanned.”  When: 2025-08-28; Observed: explicit; Confidence: high

# Authority & Decision Rights

* **Requirements definition authority resides with Product/Business;** Development implements; Platform Ops runs visualization/alerting/incident response. Source: role split above.  Observed: explicit; Confidence: high
* **Proposed pipeline “hard gate” for Business-Health metric** (not yet adopted); author warns humanless enforcement fails. Source: “Hard gate…delivery pipeline…defined Business Health metric…But humanless change fails.”  Observed: explicit (proposal); Confidence: high
* **Escalation paths not specified.** Observed: absence in transcript; Confidence: medium

# Teams & Structure

* **Product Operating Model** with cross-team experimentation. Source: “Product operating model transformation…We perform these experiments.”  Observed: explicit; Confidence: high
* **Service topology:** Primary “funding service” depends on downstream services (MQ, data enrichment) impacting end-to-end health. Source: “Message queue…downstream…data enrichment…downstream from funding service.”  Observed: explicit; Confidence: high

# Work / Initiatives (Current → Target)

* **Initiative:** Establish Business Observability as the process of defining, implementing, and measuring business requirements, delivering near-real-time feedback loops. Source: “Business observability…defining…developing/implementing…and measuring…Providing near real time data…feedback loop to the business and product owners.”   Observed: explicit; Confidence: high
* **Example domain:** Treasury order wire funding. Current: BH objectives are hard to define; Target: statistical norms with outlier alerts and completion/on-time guarantees. Source: “Treasury order wire funding…Business Health objectives are difficult to define…Statistical analysis of what is normal…Outliers generate alerts…Every treasury order needs to be complete.”  Observed: explicit; Confidence: high

# Decisions & Rationale

* **Working mode decision (experiments + learning):** Run experiments with retrospectives to capture “what we learned/achieved.” Rationale: improve insight and value delivery. Source: “We perform these experiments…retrospectives…what we learned…what we achieved.”  Observed: explicit; Confidence: high
* **Not a decision yet:** Considering pipeline gates for BH metrics; rejected as “humanless change fails” unless culture/engagement is present. Source: gate + caveat lines.  Observed: explicit; Confidence: high

# Timeline Anchors

* **Start-of-Day (SoD) reporting** exists and is referenced as a baseline. Source: “report…from the start of day.”  Observed: explicit; Confidence: high
* **Weekly/Monthly objectives** referenced for BH review cadence. Source: “Are we meeting weekly or monthly objectives.”  Observed: explicit; Confidence: high
* **When:** File timestamp suggests Aug 28, 2025 context; live leadership session “today.” Source: file name; “our group today.”  Inferred: from filename; Confidence: medium

# Metrics / SLOs / Thresholds

* **Completion SLO (proposed):** 100% of funds/treasury orders processed each day. Source: “Every treasury order needs to be complete.” and “All…funds…for a given day are successfully processed.”   Observed: explicit; Confidence: high
* **Latency/Timeliness SLO (proposed):** ≥90% processed within a defined time window. Source: “Rule two…90 percent…processed…X amount of time.”  Observed: explicit; Confidence: high
* **Compliance/Outcome KPIs:** e.g., legal/risk documents sent on time; “customers happy,” “making money.” Source: “Monitoring for legal risk compliance…Document packages…on time…customers…making money.”   Observed: explicit; Confidence: high

# Time-to-Clarity & Readiness

* **Current:** Ad-hoc understanding; reliance on individual knowledge; incident clarity is slow. Source: “Feedback loop…today…ad hoc at best…relying on the individual person’s experience…during a production incident.”  Observed: explicit; Confidence: high
* **Target:** Near real-time feedback loops to business/product; faster identification of business impacts. Source: “Providing near real time data for a feedback loop to the business and product owners.”  Observed: explicit; Confidence: high

# Dependencies & Interfaces

* **Downstream services (MQ, data enrichment)** influence funding service health and BH outcomes. Source: “Message queue…downstream…data enrichment…downstream.”  Observed: explicit; Confidence: high
* **Roll-up design needed:** Primary + secondary service indicators should aggregate to overall BH status. Source: “List of health indicators…roll up for an overall status.”  Observed: explicit; Confidence: high

# Environment (Systems/Tools/Locations/Regulatory)

* **ServiceNow CMDB & App IDs** used to map services/flows; entry-point service defines flow boundaries. Source: “servicenow cmdb…app ID…top level…entry point for the flow…BO defined from the entry point.”  Observed: explicit; Confidence: high
* **Compliance context** (legal/risk documents). Source: “Monitoring for legal risk compliance…document packages…on time.”  Observed: explicit; Confidence: high

# Constraints & Risks

* **Cultural adoption risk:** “Humanless change fails”; engagement required from Product/Business. Source: repeated “humanless change fails…business/product must choose to participate.”  Observed: explicit; Confidence: high
* **Architectural visibility gaps:** Silent degradation across components obscures BH; current architecture doesn’t surface completion/on-time status. Source: “multiple places where silent degradation can happen…Architecture…doesn’t facilitate that information.”  Observed: explicit; Confidence: high
* **Definition difficulty:** BH objectives are hard to define; risk of noise if rules are vague. Source: “Business Health objectives are difficult to define…alerts and dashboards…don’t have good rules…noise.”   Observed: explicit; Confidence: high

# Incidents & Resilience

* **Recent issues:** Treasury orders delayed/failed silently while technical dashboards were green; downstream MQ/data enrichment contributed. Source: “systems…up…not telling us…making money…message queue…data enrichment…downstream.”   Observed: explicit; Confidence: medium
* **Operational fallback:** Business teams ensure 100% completion when tech fails. Source: “There’s no such thing as not completing a trade/wire…business teams…enable that if there are technology problems.”  Observed: explicit; Confidence: high

# Governance & Comms

* **Business Reviews:** Weekly/Monthly BH review is implied. Source: “weekly or monthly objectives…weekly business review or monthly business review.”  Observed: explicit; Confidence: high
* **Learning cadence:** Retrospectives on experiments are contemplated. Source: “retrospectives…what we learned…what we achieved.”  Observed: explicit; Confidence: high

# Adoption & Enablement

* **Behavior change required:** PO completes BO template; Dev implements & validates; Platform/Dev facilitate viz/alerting/playbooks. Source: “Product owner…fills out a template…developer implements…platform operations…facilitates visualization, alerting, playbooks.”  Observed: explicit; Confidence: high
* **Job aids/artifacts and Gen-AI support** contemplated to scale enablement. Source: “Robbie used the phrase job aids…Gen AI…could have a big role.”  Observed: explicit; Confidence: medium

# Stakeholder Stances (Execution-relevant only)

* **Leaders must be advocates;** engagement is prerequisite to cultural change. Observed: “Are they going to be engaged…Culture change is difficult…humanless change fails.” Source:  Confidence: high
* **Joe (Technology Director) stresses scope;** scope perceived as “huge.” Source: “To Joe’s…point about scope…the scope is huge!”  Observed: explicit; Confidence: high

# Contradictions / Unknowns / Assumptions

* **Unknown:** Who owns final BH rule-setting (PO vs analytics vs shared)? Source: “Who comes up with these rules?”  Observed: explicit; Confidence: high
* **Assumption:** Entry-point service is the correct boundary for defining named flows. Source: “BO is primarily defined from the perspective of the entry point.”  Observed: explicit; Confidence: high
* **Contradiction risk:** Desire for pipeline hard-gates vs stated belief “humanless change fails.” Source: gate proposal vs caution.  Observed: explicit; Confidence: high

# Open Questions / Follow-ups

* **Where to start (scoping flows)?** Which business flows are highest-value to define first? Owner: Product + Architecture. Source: “What flows are important? How many flows are there?”  Observed: explicit; Confidence: high
* **BH Rules & Thresholds:** Finalize completion and timeliness SLOs (100% daily completion; 90% within time X). Owner: Product/Analytics with Platform input. Source: rules proposal.  Observed: explicit; Confidence: high
* **E2E Roll-up Design:** Define how downstream service signals roll up to overall BH status. Owner: Architecture + Platform. Source: “roll up for an overall status.”  Observed: explicit; Confidence: high


---
