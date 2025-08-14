# BOS Dashboard v1.1 Specification - Reorganized

## PART A: CORE SPECIFICATION

### 0. Design Philosophy

**Core Principle:** Business health is determined by business indicators with technical states as contributing factors.

**Hierarchy of Truth:**
1. Business SLIs and KPIs are authoritative for business status
2. Technical degradation influences but doesn't dictate business impact
3. Forecast models incorporate both business metrics and technical capacity
4. Manual overrides permitted when business context requires

**Primary Question:** "What's the business impact?" - Answered explicitly in quantified terms.

**Design Drivers:**
- Prevent silent business failures when technical metrics show healthy
- Quantify cross-LOB impact in business terms (items, dollars, deadlines)
- Enable business-first triage during incidents
- Support mixed observability maturity (gaps handled gracefully)

**Origin:** Fed Wire Data Enrichment Service incident - loans failed funding deadline while technical monitoring showed green. Root cause: queue depth wasn't mapped to business throughput requirements.

### 1. Header & Version Control

**BOS Dashboard Design Specification — v1.1**  
**Date:** 2025-08-09 (America/Chicago)  
**Audience:** SRE, Production Support, Platform/Observability Engineering, Product

**Change Log (v1.1):**
- Added `[SITUATION INSIGHT]` (single-sentence, computed)
- Added `[QUICK PIVOTS]` (templated links with `[Open]` label)
- Added `[ON-DEMAND TESTS]` (env-based; run policy TBD; result capture defined)
- Added `[ROLL-UP EXPLANATION]` (top 3 drivers; tied to bottleneck/forecast)
- Coverage metrics remain out of scope

### 2. Formatting Conventions

**Must follow:**
- **Square brackets** `[...]` = categorical states / section labels (e.g., `[At Risk]`, `[DEGRADED]`, `[SERVICE FLOW]`)
- **Parentheses** `(...)` = contextual qualifiers (SLO rules, forecasts, notes), e.g., `(SLO < 500 ms)`, `(On Track)`
- Units and TZ are explicit (e.g., `ms`, `%`, `CT`)

### 3. Status Taxonomy

**Technical:** `OK` | `WARN` | `DEGRADED` | `FAIL`  
**Business:** `On Track` | `At Risk` | `Missed`  
**Meta:** `Unknown` | `Maintenance` | `Upstream`

#### Technical States
- `OK` — SLI within SLO margin
- `WARN` — Fast/slow burn-rate indicates probable near-term breach (multi-window)
- `DEGRADED` — SLI outside SLO; still delivering partial value
- `FAIL` — Hard breach or non-functional path

#### Business States
- `On Track` — Forecast meets goal/deadline; business SLIs green
- `At Risk` — Forecast or weighted dependency indicates probable miss
- `Missed` — Business SLI violated (deadline passed/throughput shortfall)

#### Meta-States
- `Unknown` — No data or stale data
- `Maintenance` — Suppressed by planned change window
- `Upstream` — Degraded due to external or upstream dependency

### 4. Visual Layout

```yaml
+==================================================================================================+
| [SITUATION INSIGHT]                                                                              |
| <single-sentence computed summary; e.g., "Validation risk: Doc Val [DEGRADED], MQ [WARN]; KPI on track."> |
+==================================================================================================+
|  SERVICE DASHBOARD — <Service Name>                                             [Today: <Date>]  |
+==================================================================================================+
| [ID & PURPOSE]  Service: <Service Name>  |  Purpose: <Business purpose sentence>                 |
+--------------------------------------------------------------------------------------------------+
| [BUSINESS GOAL HEALTH]                         | [TECHNICAL HEALTH]                              |
| SLO Window: <HH:MM TZ> → <HH:MM TZ>            | <Tech SLI 1>: <value> (<SLO rule>)       [STATE]|
| <Business KPI>: <value>/<target>        [STATE]| <Tech SLI 2>: <value> (<SLO rule>)       [STATE]|
| ETA to goal: <HH:MM TZ> (<status>)             | <Tech SLI 3>: <value> (<SLO rule>)       [STATE]|
+--------------------------------------------------------------------------------------------------+
| [QUICK PIVOTS]                                                                                   |
| transaction_id=<id> | stage=<Stage> | service=<Service>   [Open]                                |
+--------------------------------------------------------------------------------------------------+
| [ON-DEMAND TESTS]                                                                                |
| <Test A>: [pass|fail|none] last run HH:MM (env: prod|staging)  [Run Now]                         |
| <Test B>: [none configured]                                                                      |
+--------------------------------------------------------------------------------------------------+
| [ROLL-UP EXPLANATION]                                                                            |
| Business [On Track|At Risk|Missed] because: (1) <Primary tech>  (2) <Upstream dep>  (3) <Forecast>|
+--------------------------------------------------------------------------------------------------+
| [BUSINESS IMPACT]  (auto-computed)                                                               |
| At-risk items: <count>  • Est. value: <currency> [est.|exact]  • Bottleneck: <stage/node>        |
| Window remaining: <mm:ss>  • Forecast completions: <count>  • Outstanding: <count>               |
+--------------------------------------------------------------------------------------------------+
| [SERVICE FLOW]  (business status from SLIs + weighted tech inputs + forecast)                    |
| Business:  <Stage1> [On Track|At Risk|Missed] --> <Stage2> [...] --> <StageN> [...]             |
|            ───────────────────────────────────────────────────────────────────────────────────── |
| Technical: <Svc1> [OK|WARN|DEGRADED|FAIL] --> <Svc2> [...] --> <SvcN> [...]                      |
|              |             |              |                                                       |
|              v             v              v                                                       |
|            <Deps with states: DB/MQ/Kafka/API/...>                                               |
|                               ↑ Upstream contributing condition                                   |
+--------------------------------------------------------------------------------------------------+
| [CURRENT ALERTS / EXCEPTIONS]  • <headline>  • Suppressed: <n>                                   |
| [CONTEXTUAL TIMELINE]          Today: <change>  |  Recent: <YYYY-MM-DD> <note>                   |
+--------------------------------------------------------------------------------------------------+
| [OWNERSHIP & CONTACTS]  Product Owner: <name> | Tech Lead: <name> | Runbook | Pager              |
+--------------------------------------------------------------------------------------------------+
| [LEGEND]  Technical:[OK|WARN|DEGRADED|FAIL]  Business:[On Track|At Risk|Missed]  Meta:[Upstream…]|
| Formatting: [Square]=states/labels  (Parens)=rules/notes                                         |
+==================================================================================================+
```

### 5. Business Impact Roll-Up Calculation

#### 5.1 Core Algorithm

**Inputs:**
- Business SLIs (actual/target per stage)
- Technical states (per service/dependency)
- Current queue depths
- Processing rates (historical/current)
- SLO windows and thresholds
- Criticality weights

**Output:** At-risk count, value, bottleneck identification, forecast

#### 5.2 Calculation Rules

##### Stage-Level Roll-Up
```
if forecast.miss_within_window(stage): business = "At Risk"
if any critical technical.status == FAIL: business = max(business, "At Risk")
if SLO breach on business KPI: business = "Missed"
if cumulative_weighted_degrade(technical) >= threshold: business = "At Risk"
```

##### Burn-Rate Calculation
```
fast = error_budget_burn(rate_window=5m/1h)
slow = error_budget_burn(rate_window=1h/24h)
if fast or slow above warn: technical = "WARN"
if sustained breach: technical = "DEGRADED"
if hard outage or path cut: technical = "FAIL"
```

##### At-Risk Item Calculation
```
bottleneck_capacity = min(stage.effective_capacity for stage in flow)
current_throughput = bottleneck_capacity * (1 - degradation_factor)
time_remaining = window_end - now
forecast_completions = current_throughput * time_remaining
at_risk_count = max(0, outstanding - forecast_completions)
```

##### Value Estimation
```
if exact_value_per_item_known:
    at_risk_value = at_risk_count * item_value
else:
    at_risk_value = (at_risk_count / total_items) * total_business_value
    confidence = "est."
```

### 6. Data Schema (YAML)

```yaml
service_dashboard:
  date: "YYYY-MM-DD"
  situation_insight: "<single sentence computed summary>"
  
  service:
    name: "<Business Service>"
    purpose: "<Business purpose sentence>"
    window: { start: "HH:MM TZ", end: "HH:MM TZ" }
  
  business_goal_health:
    status: "On Track|At Risk|Missed|Unknown|Maintenance|Upstream"
    kpis:
      - { name: "<Business Signal>", value: <num|str>, target: <num|str>, status: "On Track|At Risk|Missed|Unknown" }
    forecast:
      eta_to_goal: "HH:MM TZ"
      rationale: "<short text>"
  
  technical_health:
    slis:
      - { name: "<Performance Signal>", value: <num|str>, slo: "<operator target>", status: "OK|WARN|DEGRADED|FAIL|Unknown|Maintenance" }
  
  quick_pivots:
    - { key: "transaction_id", value: "abc-123", link_label: "Open", link_href: "<logs-url?service={service}&stage={stage}&txn={transaction_id}>" }
    - { key: "stage", value: "Validation", link_label: "Open", link_href: "<traces-url?service={service}&stage={stage}>" }
    - { key: "service", value: "Doc Val Service", link_label: "Open", link_href: "<dash-url?service={service}>" }
  
  on_demand_tests:
    - name: "Validation Path Smoke"
      env: "prod|staging"
      last_result: "pass|fail|none"
      last_run: "HH:MM TZ|none"
      run_link: { link_label: "Run Now", link_href: "<trigger-url?test={name}&env={env}>" }
  
  rollup_explanation:
    headline_state: "On Track|At Risk|Missed"
    drivers: ["<Primary tech driver>", "<Upstream dep (optional)>", "<Forecast factor (optional)>"]
  
  business_impact:
    at_risk_count: <int>
    at_risk_value: <number>
    value_confidence: "est.|exact"
    bottleneck: { stage: "<name>", node: "<svc/dep>", state: "<state>" }
    window_remaining: "MM:SS"
    forecast_completions: <int>
    outstanding_to_goal: <int>
  
  service_flow:
    stages:
      - name: "<Stage 1>"
        business_status: "On Track|At Risk|Missed|..."
        technical:
          services:
            - name: "<Technical Service 1>"
              status: "OK|WARN|DEGRADED|FAIL|..."
              criticality: "primary|supporting|optional"
              deps:
                - { kind: "DB|Kafka|MQ|API|File|Other", name: "<dep name>", status: "OK|WARN|DEGRADED|FAIL|..." }
          upstream_note: "<optional>"
  
  alerts_exceptions:
    active: ["<summary line>", "..."]
    suppressed: <int>
    notes: ["<note>", "..."]
  
  timeline:
    today: ["<change note>"]
    recent: [{ date: "YYYY-MM-DD", note: "<event>" }]
    peak_badge: { count: <int>, value: <number>, when: "HH:MM TZ" }
  
  ownership_contacts:
    product_owner: { name: "<name>", org: "<org>" }
    tech_lead: { name: "<name>", org: "<org>" }
    runbook: "<link or slug>"
    pager: "<how to page>"
```

### 7. Semantic Model Mapping (MVSM)

| Dashboard Element | MVSM Entity/Field |
| ----- | ----- |
| `Service` | `Business Service.Service Name` |
| `Purpose` | `Business Function.Function Name` + `Business Capability` (summarized) |
| Business KPIs | `Business Signal.Signal Name`, `SLO Defined/Measured` |
| Technical SLIs | `Performance Signal.Signal Name`, `Target Threshold`, `SLO Defined/Measured` |
| Flow stages (top row) | `Business Service` or `Business Function` (stage) |
| Technical services (2nd row) | `Technical Service.Service Name`, `Type`, `Team Owner` |
| Dependencies (DB/Kafka/MQ/API) | `Technical Service` or `External Dependency` + `Interface Type` |
| Ownership | `Signal Owner`, `Team Owner`, runbook presence |
| Suppression | `Maintenance` window in governance metadata |
| Change history | Governance `Change Audit Log` |

*Justification: Direct mapping to MVSM lets the dashboard be generated programmatically and keeps runtime views consistent with the system of record.*

---

## PART B: IMPLEMENTATION REFERENCE

### 8. Computation Rules & Pseudocode

#### 8.1 Propagation Rules

**Within a Stage:**
- **Tech → Business:**
  - If any critical technical node = `FAIL` → Business `At Risk` (or `Missed` if inevitability/goal window passed)
  - If one or more critical nodes = `DEGRADED` → Business `At Risk`
  - `WARN` does not auto-degrade business unless forecast indicates miss in the business window
- **Forecast override:** If business forecast misses target (deadline/throughput), set `At Risk` or `Missed` regardless of technical states

**Across Dependencies:**
- **Weighted roll-up:** Each technical node has a `criticality` weight (`primary`, `supporting`, `optional`). Only `primary` or cumulative weighted impact may degrade the stage
- **Upstream annotation:** If root cause is upstream, annotate `[Upstream:<node>]` on the affected stage; do not paint all downstream nodes red

**Page-Level Summaries:**
- **Business Goal Health** tile is derived from the slowest/riskiest stage forecast and any `Missed` stage
- **Technical Health** tile summarizes key SLIs (latency/error/backlog) using multi-window burn rates to avoid flapping

#### 8.2 Feature-Specific Computation

**Situation Insight:**
- Source: Derived from current business state, top driver(s), and forecast
- Healthy: "All stages on track; no active incidents. KPIs and SLIs within targets."
- Degraded example: "Validation risk: Doc Val Service [DEGRADED], MQ [WARN]; KPI still on track."
- Rule: 1 sentence ≤ ~140 chars

**Roll-up Explanation:**
- Show up to 3 drivers in order:
  1. Primary technical driver (e.g., "Doc Val Service [DEGRADED]")
  2. Upstream dependency (e.g., "MQ: validation.q [WARN]")
  3. Forecast factor (e.g., "expected < outstanding" or clamp rule)
- Thresholds: List a driver if state ≥ `WARN` and contributes ≥ 20% of capacity shortfall; always include any `FAIL` on a primary node
- Consistency: Reference the same bottleneck stage/node used in Business Impact calc
- Healthy message: If none apply, show "No contributing drivers; all inputs within SLO and forecast on track."

### 9. Visual Conventions

- **Two-row flow:** Business stages (top), Technical services (second)
- **Dependencies:** Listed under each technical node with their states
- **Alignment:** Business and technical states vertically aligned per stage
- **Legend:** Always present; meta-states included
- **No color requirement:** Status words must be readable in monochrome

### 10. Complete Example Page

```yaml
+==================================================================================================+
| [SITUATION INSIGHT]                                                                              |
| Validation risk: Doc Val Service [DEGRADED], MQ [WARN]; KPI still on track.                      |
+==================================================================================================+
|  SERVICE DASHBOARD — Loan Funding Service                                    [Today: 2025-08-09] |
+==================================================================================================+
| [ID & PURPOSE]  Service: Loan Funding Service  |  Purpose: Ensure all approved loans are funded  |
|                before 08:00 CT                                                                   |
+--------------------------------------------------------------------------------------------------+
| [BUSINESS GOAL HEALTH]                         | [TECHNICAL HEALTH]                              |
| SLO Window: 00:00 → 08:00 CT                   | Error Rate: 0.15% (SLO < 0.5%)           [OK]   |
| Loans funded: 1,923 / 1,950            [On Track] | API p95 Latency: 420 ms (SLO < 500 ms)  [OK]    |
| ETA to goal: 07:52 CT                  (On Track) | Queue Backlog: 142 (SLO < 200)          [OK]    |
+--------------------------------------------------------------------------------------------------+
| [QUICK PIVOTS]                                                                                   |
| transaction_id=abc-123 | stage=Validation | service=Doc Val Service   [Open]                     |
+--------------------------------------------------------------------------------------------------+
| [ON-DEMAND TESTS]                                                                                |
| Validation Path Smoke: [pass] last run 07:10 (env: prod)  [Run Now]                              |
| End-to-End Funding BDD: [none configured]                                                        |
+--------------------------------------------------------------------------------------------------+
| [ROLL-UP EXPLANATION]                                                                            |
| Business [At Risk] because: (1) Doc Val Service [DEGRADED]  (2) MQ: validation.q [WARN]          |
| (3) Forecast: expected < outstanding                                                             |
+--------------------------------------------------------------------------------------------------+
| [BUSINESS IMPACT]  (auto-computed)                                                               |
| At-risk items: 27  • Est. value: $5.4M [est.]  • Bottleneck: Validation (Doc Val Service)        |
| Window remaining: 00:38  • Forecast completions: 0  • Outstanding: 27                            |
+--------------------------------------------------------------------------------------------------+
| [SERVICE FLOW]                                                                                   |
| Business:  Loan Intake [On Track] --> Validation [At Risk] --> Funding [On Track] --> Settlement [On Track] |
|            ───────────────────────────────────────────────────────────────────────────────────── |
| Technical: LOS Intake API [OK] --> Doc Val Service [DEGRADED] --> Funding Module [OK] --> Treasury API [OK] |
|              |                    |                          |                       |            |
|              v                    v                          v                       v            |
|            DB: Loan_Records [OK]  DB: Docs_DB [OK]        DB: Funding_DB [OK]      DB: Treasury_DB [OK]     |
|            Kafka:intake.events[OK] MQ: validation.q [WARN] Kafka: funding.out[OK]  API: bank.wire.submit[OK]|
|                               ↑ Upstream contributing condition (rising queue)                   |
+--------------------------------------------------------------------------------------------------+
| [CURRENT ALERTS / EXCEPTIONS]  • Validation At Risk; upstream MQ WARN.  • Suppressed: 2          |
| [CONTEXTUAL TIMELINE]          Today: none  |  2025-08-05: Minor incident; SLO tuned.            |
+--------------------------------------------------------------------------------------------------+
| [OWNERSHIP & CONTACTS]  Product Owner: Jane Smith | Tech Lead: Mark Liu | Runbook | Pager       |
+--------------------------------------------------------------------------------------------------+
| [LEGEND]  Tech:[OK|WARN|DEGRADED|FAIL]  Biz:[On Track|At Risk|Missed]  Meta:[Upstream…]          |
| Formatting: [Square]=states/labels  (Parens)=rules/notes                                         |
+==================================================================================================+
```

### 11. Acceptance Criteria

#### Core Features
- Service, Purpose, and per-stage names match MVSM
- All business signals have `SLO Defined` and `SLO Measured`
- All technical signals have target thresholds and owners
- At least one fast and one slow burn-rate alert per critical signal
- Forecast calculation verified against historical workload
- Legend present; meta-states tested (`Unknown`, `Maintenance`, `Upstream`)
- Ownership and runbook links resolve

#### New Features (v1.1)
**Situation Insight:**
- Computed string appears; healthy vs degraded messages render correctly; length ≤ 140 chars

**Quick Pivots:**
- Templated links resolve with `{service}`, `{stage}`, `{transaction_id}`
- `[Open]` renders; if no pivots configured, show "[none configured]"

**On-Demand Tests:**
- Shows last result and time per env; `[Run Now]` present (policy TBD)
- Test runs append a ledger entry with `result`, `trace_id`, `response_snippet`, `executor`

**Roll-up Explanation:**
- Lists ≤ 3 drivers; prioritization and 20% threshold respected
- Names the same bottleneck as Business Impact; healthy message displays when applicable

### 12. Change Control Process

- Treat this spec as a controlled artifact
- Any layout, taxonomy, or rule changes require a version bump
- Update MVSM mappings to keep UI and system-of-record aligned
- All changes must preserve backward compatibility with existing dashboards

### Future Roadmap Items

#### Coverage Metrics (Deferred from v1.1)
**Premise:** Dashboard must function with incomplete instrumentation while making gaps visible.

**Planned Capabilities:**
- Telemetry coverage percentage: (instrumented signals / required signals) per stage
- Coverage types: Business KPIs, Technical SLIs, Dependencies, Traces
- Gap classification: Missing signal type and criticality
- Coverage indicator per section: Denotes completeness level
- Gap identification: List specific missing signals

**Justification:** 
- Mixed observability maturity is current reality
- Dashboard must degrade gracefully with partial data
- Visibility of gaps drives instrumentation priorities

#### Advanced Impact History (Deferred from v1.1)
**Premise:** Impact magnitude and duration are lost when service recovers, impeding analysis.

**Planned Capabilities:**
- Configurable retention periods for inline display
- Peak value persistence beyond recovery
- Historical impact pattern storage
- Multi-incident comparison capability

**Open Design Questions:**
- Peak badge visibility when At Risk = 0
- Default inline retention period: 24h vs business window vs 7 days
- Storage granularity for different time ranges

**Justification:**
- Post-incident review requires impact timeline
- Pattern detection requires historical data
- Business stakeholders need impact duration and magnitude for decisions

### 13. Impact History Patterns

*Note: Core patterns defined below. Advanced visualizations and retention policies are roadmap items pending product decisions on user experience trade-offs.*

#### 13.1 High-Water Mark Badge (Today's Window)
- **Purpose:** Keep the "worst so far" visible even after recovery
- **Data:** `peak_count`, `peak_value`, `peak_timestamp`
- **UI:** Small badge in BUSINESS IMPACT: `Peak: 27 loans ($5.4M) at 07:18`

#### 13.2 Impact Timeline Strip
- **Purpose:** Show when risk first appeared and how it evolved
- **Data:** Minute/5-min buckets of business SLI deltas
- **UI Example:**
```
[IMPACT TIMELINE 06:00–08:00]
06:10 06:20 06:30 06:40 06:50 07:00 07:10 07:20 07:30 07:40 07:50 08:00
..|....|....|....|....|....|....|....|....|....|....|....
  ^first_at_risk(06:42)           ^peak(07:18, 27)         ^cleared(07:47)
```

#### 13.3 State Transition Ledger
- **Purpose:** Precisely record when business/tech states changed
- **Data:** `{ts, stage, business_state, tech_state, at_risk_count, cause}`
- **Format:**
```
06:42  Validation  Business:At Risk  Tech:DEGRADED  AtRisk:5   Cause: MQ[WARN]
07:05  Validation  Business:At Risk  Tech:DEGRADED  AtRisk:18  Cause: MQ[WARN]
07:18  Validation  Business:At Risk  Tech:DEGRADED  AtRisk:27  Cause: MQ[WARN]
07:47  Validation  Business:On Track Tech:OK        AtRisk:0   Cleared
```

#### 13.4 Storage & Mechanics
- **Timeseries tags:** `service`, `stage`, `incident_id`, `stakeholder_cat`
- **Rollups:** 1m/5m buckets for strip; `max()` for high-water; `first()/last()` for first/clear times
- **Retention:** Live (7–14 days) in dashboard; long-term in governance store or data warehouse

#### 13.5 On-Demand Test Result Capture
**Required per run:**
```yaml
test_run:
  name: "<test name>"
  env: "prod|staging"
  started_at: "2025-08-09T07:22:10-05:00"
  duration_ms: 1830
  result: "pass|fail|error"
  trace_id: "<root/span id>"
  response_snippet: "<sanitized first ~200 chars or normalized code>"
  executor: "<user or automation>"
  links:
    - { label: "Trace", href: "<trace-url>" }
    - { label: "Logs",  href: "<logs-url>"  }
```

---

## PART C: TEAM GUIDANCE

### 14. Walking Skeleton Approach

#### Phase 1: Foundation (MVP)
- Basic dashboard layout with static example data
- Business Goal Health and Technical Health tiles
- Service Flow visualization (two-row format)
- Status taxonomy implementation

#### Phase 2: Dynamic Data
- Real-time data integration
- Business Impact calculation
- Propagation rules implementation
- State transition tracking

#### Phase 3: Enhanced Features
- Situation Insight computation
- Quick Pivots with templated links
- On-Demand Tests integration
- Roll-up Explanation logic

#### Phase 4: History & Analytics
- Impact History Patterns
- State Transition Ledger
- Peak badges and timeline strips
- Long-term storage integration

### 15. Bounded Context Analysis

#### Business Domain
- Owner: Product teams
- Data: Business KPIs, SLO windows, business goals
- Integration: Read-only from business systems

#### Technical Domain
- Owner: Engineering teams
- Data: SLIs, technical states, dependencies
- Integration: Real-time metrics and logs

#### Governance Domain
- Owner: Platform/Observability team
- Data: MVSM mappings, change audit logs
- Integration: Bi-directional sync

### 16. Implementation Phases

#### Prerequisites
- MVSM semantic model populated
- Business and technical SLIs defined
- Ownership and runbook links established

#### Phase 1: Static Dashboard (Week 1-2)
- Implement ASCII layout
- Create example with hardcoded data
- Validate with stakeholders

#### Phase 2: Data Pipeline (Week 3-4)
- Connect to metrics sources
- Implement YAML schema parsing
- Build state computation engine

#### Phase 3: Business Logic (Week 5-6)
- Implement roll-up calculations
- Add forecast algorithms
- Build impact computation

#### Phase 4: Interactive Features (Week 7-8)
- Add Quick Pivots
- Integrate On-Demand Tests
- Implement state history tracking

### 17. Build Notes & QA Checklist

#### Build Notes
- **Inputs:** Logs (business counters), metrics (latency/error/backlog), traces (path health), synthetic checks (external reachability), SLO configs
- **Derivations:** Forecast ETA and "At Risk" come from throughput vs. deadline and dependency states
- **Refresh:** UI tiles 15–60s; forecast every 1–5 min; burn-rate windows per signal
- **Suppression:** Honor maintenance windows; show meta-state `Maintenance`
- **Drift detection:** Nightly compare dashboard config vs. BOS/MVSM artifacts and runtime tool configs

#### QA Checklist (Before Go-Live)
- [ ] Service, Purpose, and per-stage names match MVSM
- [ ] All business signals have `SLO Defined` and `SLO Measured`
- [ ] All technical signals have target thresholds and owners
- [ ] At least one fast and one slow burn-rate alert per critical signal
- [ ] Forecast calculation verified against historical workload
- [ ] Legend present; meta-states tested
- [ ] Ownership and runbook links resolve
- [ ] Quick Pivots generate correct URLs
- [ ] On-Demand Tests capture results with trace IDs
- [ ] Roll-up Explanation identifies correct bottlenecks
- [ ] Impact History preserves peak values after recovery
- [ ] State transitions logged to ledger

---

## Validation Report

### Content Preservation
- All technical specifications preserved verbatim
- ASCII art maintained with exact formatting
- YAML schemas complete and unmodified
- Formulas and pseudocode retained in full

### Structure Improvements
- Eliminated redundant formatting explanations (3 instances consolidated to 1)
- Merged duplicate example pages (2 versions → 1 authoritative)
- Separated team guidance from technical specification
- Added Impact History Patterns section (new in Part B)

### Change Mapping
- Sections 1-7: Core specification from v1.1 final
- Sections 8-12: Implementation details from throughout document
- Section 13: New Impact History Patterns from reflection discussion
- Sections 14-17: Team guidance extracted from mixed content

