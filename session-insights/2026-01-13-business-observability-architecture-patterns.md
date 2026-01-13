# Session Insights: Business Observability Architecture Patterns

**Date:** 2026-01-13
**Topic:** Architectural patterns for extracting business health signals from operational databases, enterprise monitoring strategy, and Splunk ITSI pilot positioning
**Status:** Complete (checkpoint)

---

## Context

The discussion began with a fundamental monitoring question: Business applications store transaction lifecycle data in operational databases (e.g., wire transfer with states: started → pending → complete → cancelled). A business health signal is needed to detect transactions stuck in "pending" for more than 60 minutes.

The initial question: Is SQL polling via Grafana sustainable, or should this be a time-series metric? This led to a comprehensive exploration of enterprise monitoring architecture.

## Key Insights

### The Workaround vs Root Solution Distinction

All approaches that extract business signals after the fact are workarounds:
- **DB Connect:** Poll database for state
- **CDC:** Capture DB changes as events
- **Log parsing:** Extract signals from logs
- **Sidecar agents:** Query locally, emit metrics

The root solution is **applications emit business signals by design**. The app knows context the database doesn't (why something is pending, business priority, retry status).

### Pilot Strategy Creates Organizational Pull

The pilot demonstrates value → creates organizational demand → justifies cultural shift toward app instrumentation.

Trying to mandate app instrumentation without demonstrated value faces resistance. Showing the value first creates pull rather than push. The workaround (DB Connect) is acceptable in the pilot phase because it creates demand for the root solution.

### BOS Methodology Provides the Specification Layer

BOS artifacts remain stable regardless of implementation mechanism:
- **Service definitions** → Which databases/apps to monitor
- **Signal definitions** → The actual queries or metrics
- **Thresholds** → ITSI KPI threshold configuration
- **Impact categories** → ITSI service health scoring weights

Only the implementation changes (from DB Connect polling to app-emitted signals). BOS becomes the contract that tells app teams what to instrument.

### ITSI Constructs Map to BOS Concepts

| BOS Concept | ITSI Construct |
|-------------|----------------|
| BOS Service | ITSI Service |
| Signal definition | KPI definition |
| Signal threshold | KPI threshold |
| Service hierarchy (L4/L3/L2) | Service tree |
| Impact categories | Health score weights |
| Executive dashboard | Glass table |

### Enterprise Pattern Viability Assessment

Not all patterns scale to enterprise level:
- **GoldenGate CDC:** Works but expensive licensing, Oracle-only, doesn't scale as enterprise pattern
- **DB Connect:** More scalable—JDBC-based, works across database types, uniform approach
- **App instrumentation:** Most scalable but requires cultural shift

### Tiered Architecture by Criticality

A pragmatic enterprise pattern may be tiered:
| Tier | Latency Need | Pattern |
|------|--------------|---------|
| Tier 1 | Real-time (<1 min) | CDC where exists |
| Tier 2 | Near-real-time (5 min) | DB Connect |
| Tier 3 | Periodic (15+ min) | Scheduled jobs |

### Integration Events ≠ Observability Events

Kafka carries business events for application integration, but integration events are designed for "System B needs to know X happened." They may skip intermediate states that no downstream system needs but observability requires.

Example: "Transfer completed" event exists (downstream needs it), but "Transfer entered pending" may not (no integration consumer cares). This gap explains why CDC or DB polling is needed even when Kafka exists.

## Quotable Passages

> "The app knows things the database doesn't—why a transaction is pending, business context, intent."

> "The pilot creates demand for the root solution."

> "DB Connect solves the immediate problem. But the sustainable answer is apps emitting business signals by design."

> "Integration events are designed for 'System B needs to know X happened.' Observability events need the full lifecycle for monitoring purposes. These may overlap but aren't guaranteed to."

> "BOS becomes the specification layer that tells app teams: 'For business observability, your app should emit these signals.'"

> "App-emitted metrics represent the 'root solution'—the ideal architecture. DB Connect queries are a 'workaround' that approximates app-emitted patterns without requiring application changes."

> "Rather than designing DB Connect queries in isolation, design them to approximate what the application would emit if properly instrumented."

> "Count alone is insufficient for business impact. Impact signals must include transactional context."

## Vocabulary Clarifications

| Term | Definition in This Context |
|------|---------------------------|
| **Business health signal** | A metric indicating whether business outcomes are being achieved (e.g., transactions completing within SLA), distinct from technical health (is the service up?) |
| **CDC (Change Data Capture)** | Pattern that captures database changes from transaction logs and publishes as events, enabling real-time event streams without polling |
| **DB Connect** | Splunk's database connectivity tool that runs scheduled SQL queries and ingests results as Splunk events |
| **ITSI** | Splunk IT Service Intelligence—service-centric monitoring with KPIs, service trees, and glass tables |
| **Glass table** | ITSI's executive dashboard visualization showing service health scores |
| **KPI (in ITSI context)** | Key Performance Indicator—a metric tied to an ITSI service that contributes to health scoring |
| **Workaround (architectural)** | Approaches that extract signals after the fact because applications don't emit them natively |
| **Root solution** | Applications designed to emit business signals directly, eliminating need for extraction |

## Conceptual Distinctions

### Technical Health vs Business Health
- **Technical health:** Is the service running? Are requests succeeding?
- **Business health:** Are business outcomes being achieved? Are SLAs met?

Traditional monitoring focuses on technical health. BOS adds business health as a distinct observability layer.

### Polling vs Event-Driven
- **Polling:** Periodically query for current state (DB Connect, SQL)
- **Event-driven:** React to state changes as they happen (CDC, app-emitted events)

Polling is simpler but has latency and computes repeatedly. Event-driven is more efficient but requires infrastructure or app changes.

### Integration Events vs Observability Events
- **Integration events:** Designed for system-to-system communication, contain what downstream systems need
- **Observability events:** Designed for monitoring, contain full lifecycle for health assessment

The same event stream may serve both purposes, but gaps often exist.

### Point Solution vs Enterprise Pattern
- **Point solution:** Works for one app (e.g., GoldenGate for this Oracle DB)
- **Enterprise pattern:** Repeatable across hundreds of apps with different technologies

A pattern's viability changes dramatically when considering enterprise scale (cost, operational complexity, technology diversity).

## Open Questions

1. What specific KPIs are being configured in the ITSI pilot?
2. How is the ITSI service tree being structured (mapping to L4/L3/L2)?
3. What's the path from Grafana Cloud Mimir metrics to Splunk Observability Cloud? (Two metrics destinations exist)
4. When OpenTelemetry is adopted, will it feed Splunk Observability Cloud, Grafana Cloud, or both?
5. Is there a target ratio of apps on "root solution" (app-emitted) vs "workaround" (DB Connect)?

## Real-Life Signal Patterns (Wire Transfer Service)

**Important clarification:** The wire transfer examples in the repo simulation are hypothetical. Real-life signals follow this pattern:

### Business Health Signals (SLIs - How is the service performing?)

| Signal | Type | Description |
|--------|------|-------------|
| Wire processing success rate | Ratio | % of transactions completing successfully |
| Total transactions | Count | Volume of transactions |
| In-progress percent | Ratio | % currently being processed |
| Submitted percent | Ratio | % submitted awaiting processing |
| Complete percent | Ratio | % finished processing |

### Business Impact Signals (Consequence measurements)

| Signal | Type | Description |
|--------|------|-------------|
| Transactions pending > 1 hour | Count + Value | Transactions stuck beyond threshold |
| Rejected count | Count + Value | Transactions that failed |
| Cancelled count | Count + Value | Transactions that were cancelled |
| Max wait time | Duration | Longest any transaction has been waiting |

### Critical Pattern: Impact Signals Require Operational Context

**Count alone is insufficient for business impact.** Impact signals must include transactional context:

- "5 transactions pending > 60 minutes" → Incomplete
- "5 transactions pending > 60 minutes = $1.8M at risk" → Business impact

**Implication for DB Connect:** Queries must return both count AND dollar value for impact signals. Actual table/field names are unknown—would need to be determined from the Oracle schema.

## Key Insight: App-Emitted as Ideal, DB Connect as Approximation

**Core Principle:** App-emitted metrics represent the "root solution"—the ideal architecture. DB Connect queries are a "workaround" that approximates app-emitted patterns without requiring application changes.

This framing is important: rather than designing DB Connect queries in isolation, design them to approximate what the application would emit if properly instrumented.

### Standard Metric Primitives (Prometheus/OpenTelemetry Model)

| Type | Behavior | Use For |
|------|----------|---------|
| **Counter** | Only increments, resets on restart | Events that happen (transactions, errors) |
| **Gauge** | Can go up or down | Current state (queue depth, active count) |
| **Histogram** | Buckets of observations | Distributions (latency, duration) |

### Signal Buckets by Query Pattern

| Bucket | Characteristic | App-Emitted Primitive | DB Connect Pattern | Events per Poll |
|--------|----------------|----------------------|-------------------|-----------------|
| **Ratio** | Percentage/rate | Counters → computed ratio | SQL computes ratio | 1 |
| **Volume** | Count/sum | Counter increments | SQL COUNT in window | 1 |
| **State %** | Distribution across states | Gauges per state | SQL COUNT by status | 1 |
| **Threshold Breach** | Count + context exceeding limit | Gauge or delayed event | SQL filters by threshold | 1 (aggregate) + N (detail) |
| **Extreme Value** | MAX/MIN measurement | Histogram | SQL MAX/MIN | 1 |

### Detailed Mapping: App-Emitted → DB Connect Approximation

#### Bucket 1: Ratio Metrics (e.g., Success Rate)

**App-Emitted (Ideal):**
- Counter: `wire_transfer_completed_total{status="success"}` increments on success
- Counter: `wire_transfer_completed_total{status="failed"}` increments on failure
- Metrics layer computes: `success / (success + failed)`
- Real-time, increments at event time

**DB Connect (Approximation):**
- SQL computes ratio at poll time: COUNT successes / COUNT attempts
- Returns: `{timestamp, success_rate: 98.5}`
- Periodic snapshot, not real-time

**What's Lost:** Real-time visibility, sub-interval granularity
**What's Preserved:** The metric value itself, trend over time (at poll resolution)

#### Bucket 2: Volume Metrics (e.g., Total Transactions)

**App-Emitted (Ideal):**
- Counter: `wire_transfer_initiated_total` increments exactly when transaction starts
- Metrics layer computes: `rate()` or `increase()`

**DB Connect (Approximation):**
- SQL counts transactions in time window
- Returns: `{timestamp, transaction_count: 847}`
- Point-in-time count, not continuous increment

**What's Lost:** Exact timing of each transaction, sub-interval spikes
**What's Preserved:** Volume per interval, trend over time

#### Bucket 3: State Metrics (e.g., In-Progress %, Submitted %, Complete %)

**App-Emitted (Ideal):**
- Gauge: `wire_transfer_current{state="submitted"}` updated on each state transition
- Gauge: `wire_transfer_current{state="in_progress"}`
- Gauge: `wire_transfer_current{state="complete"}`
- Always reflects current state in real-time

**DB Connect (Approximation):**
- SQL counts current state distribution: COUNT grouped by status
- Returns: `{timestamp, submitted_pct: 5, in_progress_pct: 12, complete_pct: 83}`
- Snapshot of state at poll time

**What's Lost:** State transitions between polls, brief spikes in a state
**What's Preserved:** Current distribution, trend of distribution over time

#### Bucket 4: Threshold Breach Metrics (e.g., Pending > 60 min)

**App-Emitted (Ideal):**
- Option A (Gauge): `wire_transfer_pending_over_threshold{threshold="60m"}` with count and dollars
- Option B (Delayed event): When entering pending, schedule T+60 check; if still pending, emit
- Real-time detection, no continuous polling needed (Option B)

**DB Connect (Approximation):**
- SQL identifies items exceeding threshold at poll time
- Returns aggregate: `{timestamp, pending_over_60_count: 5, pending_over_60_dollars: 1800000}`
- Only detects breach at poll time

**What's Lost:** Immediate detection when threshold crossed (worst case: breach exists for poll interval - 1 before detection)
**What's Preserved:** Count and dollar value of breaches, trend over time

**Detail Query (Optional):** SQL returns individual breaching transactions for drill-down (N events)

#### Bucket 5: Extreme Value Metrics (e.g., Max Wait Time)

**App-Emitted (Ideal):**
- Histogram: `wire_transfer_pending_duration_seconds` with full distribution
- Metrics layer computes: `histogram_quantile(1.0, ...)` for max, any percentile available

**DB Connect (Approximation):**
- SQL computes MAX at poll time
- Returns: `{timestamp, max_wait_minutes: 94}`
- Single extreme value, not distribution

**What's Lost:** Full distribution, percentiles (p50, p90, p99)
**What's Preserved:** The extreme value itself, trend of max over time

**Enhanced Version:** SQL can include item identifier for max value if needed for investigation

### Wire Transfer Signals Mapped to Buckets

| Signal | Bucket | App-Emitted Equivalent |
|--------|--------|------------------------|
| Wire processing success rate | Ratio | Counters by completion status |
| Total transactions | Volume | Counter increments |
| In-progress percent | State % | Gauge per state |
| Submitted percent | State % | Gauge per state |
| Complete percent | State % | Gauge per state |
| Pending > 60 min | Threshold Breach | Gauge or delayed event |
| Rejected count | Threshold Breach | Counter + context |
| Cancelled count | Threshold Breach | Counter + context |
| Max wait time | Extreme Value | Histogram |

### The Core Trade-off

```
APP-EMITTED (Root Solution)
• Emits primitives (counters, gauges, histograms)
• Metrics layer does aggregation
• Real-time, event-driven

            ▼ approximates ▼

DB CONNECT (Workaround)
• SQL computes aggregations directly
• Returns pre-computed values
• Periodic, poll-driven

Trade-off: Lose real-time granularity, preserve metric values
```

### Why This Mapping Matters

1. **Design guidance:** DB Connect queries should approximate what apps would emit
2. **Future migration path:** When apps instrument, the metrics already have defined semantics
3. **Consistency:** Same signal buckets apply regardless of implementation mechanism
4. **Evaluation criteria:** "How well does this query approximate the ideal app-emitted metric?"

## Conclusions

### Pilot Approach Confirmed
- **Mechanism:** DB Connect polling Oracle
- **Destination:** Splunk Cloud → ITSI
- **Scope:** Complete demo (services, KPIs, service trees, glass tables)
- **Purpose:** Prove business observability value, create organizational pull

### Architecture Progression Established
| Phase | Approach | Purpose |
|-------|----------|---------|
| Now | DB Connect (workaround) | Prove value, low barrier |
| Scale | DB Connect across apps | Expand coverage |
| Future | App-emitted signals (root) | Sustainable architecture |

### Enterprise Stack Clarified
| Platform | Role |
|----------|------|
| Splunk Cloud | Logs, events |
| Splunk Observability Cloud | Metrics, APM |
| Splunk ITSI | Business/service intelligence |
| Grafana Cloud Mimir | Metrics (via Grafana Agent) |
| Cribl | Log routing to Splunk |
| Kafka | Business event transport (app integration) |
| AppDynamics | APM |
| ThousandEyes | Network monitoring |
| OpenTelemetry | Roadmap for app instrumentation |

---

## Context Reconstruction

### Files Referenced
- `/bos-story-mapping/bos-simulation-wire-transfer.md` - Hypothetical tabletop simulation (useful structure but not real-life signals)
- `/images/wires/runbook-delayed-wire-transfers.md` - Real operational runbook with impact tiers
- `/images/wires/final-outcome-summary.md` - Framework outcomes for wire transfer monitoring
- `/system-of-record/templates/signal_definitions.csv` - Signal definitions including SIG001 for wire transfer
- `/system-of-record/templates/stakeholder_expectations_context.csv` - Stakeholder expectations for wire transfer service

### Files Modified
- `/documentation/sessions/insights/2026-01-13-business-observability-architecture-patterns.md` - Created this capture file

### Related Documentation
- `/documentation/principles/four-layer-model.md` - Business health signals relate to Layer 3 (Business Health) and Layer 4 (Business Impact)
- `/documentation/domain/wf-object-model.md` - BOS Service, Signal concepts discussed
- `/documentation/principles/foundational-principles.md` - "Business observability begins with defining success in business health terms"

### CLAUDE.md Sections Applied
- **Business Observability Core Principles** - Four-layer model context (technical vs business health)
- **Work Context Protocol** - Enterprise infrastructure discussion grounded in real WF context
- **Walking Skeleton + Continuous Delivery Approach** - Pilot as incremental value demonstration

### Related Sessions
- None identified yet

### Follow-On Topics Identified
- **DB Connect → Time-Series Metrics (Implementation):** What does it actually look like to use DB Connect to create time-series metrics? Moving from architectural patterns to practical implementation—query structure, how results become metrics, how they feed ITSI KPIs, configuration specifics. Should use real-life wire transfer signals as the example:
  - Business Health: success rate, total transactions, in-progress/submitted/complete percentages
  - Business Impact: pending > 1 hour (with dollar value), rejected count (with value), cancelled count (with value), max wait time

---

*This document captures reasoning for future documentation and enables context reconstruction.*
