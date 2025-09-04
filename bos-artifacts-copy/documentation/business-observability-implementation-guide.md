# Business Observability Implementation Guide

## Phase 1: Foundation (Days 1-5)

### Day 1: Select Pilot Service
**Objective:** Choose the right service for initial implementation

**Selection Criteria:**
- ✅ Well-understood business function
- ✅ Clear success/failure conditions
- ✅ Data accessible via SQL or Splunk
- ✅ Active product owner engagement
- ✅ Impacts measurable stakeholders

**Good Pilot Candidates:**
- Credit check service (loan applications)
- Payment processing (customer transactions)
- Account opening (new customers)
- Trade execution (investment operations)

**Poor Pilot Candidates:**
- Internal batch processes
- Infrastructure services
- Services with ambiguous success criteria
- Services without clear business ownership

### Day 2: Stakeholder Alignment
**Morning Session (2 hours)**
- Product Owner defines business success
- Developer identifies data sources
- Agreement on pilot scope

**Afternoon Session (2 hours)**
- Review Business SLI Guide together
- Complete initial questionnaire
- Document decisions

**Deliverable:** Completed data model spreadsheet

### Day 3: Technical Discovery
**SQL Path:**
```sql
-- Test query for data availability
SELECT COUNT(*), MIN(created_at), MAX(created_at)
FROM [service_table]
WHERE created_at > SYSDATE - 1;

-- Validate good/bad conditions exist
SELECT status, COUNT(*)
FROM [service_table]
WHERE created_at > SYSDATE - 1
GROUP BY status;
```

**Splunk Path:**
```
index=[your_index] earliest=-24h
| stats count by status
| table status count
```

**Validation Checklist:**
- [ ] Data exists for time window
- [ ] Good condition identifiable
- [ ] Sufficient volume for meaningful SLI
- [ ] Query performance acceptable (<5 seconds)

### Day 4: Build First Query
**Transform discoveries into SLI query**

Template application:
1. Copy appropriate template (SQL/Splunk)
2. Fill in service-specific values
3. Test with different time windows
4. Validate results match expectations

**Testing Matrix:**
| Time Window | Expected Result | Actual Result | Pass/Fail |
|-------------|-----------------|---------------|-----------|
| Last hour | ~99.5% | [actual] | [status] |
| Last 24h | ~99.5% | [actual] | [status] |
| Last week | ~99.5% | [actual] | [status] |

### Day 5: Create Dashboard
**Minimum Viable Dashboard:**
```
┌─────────────────────────────────────┐
│ Credit Check Service Health         │
├─────────────────────────────────────┤
│ Current: 98.7% | Target: 99.5%     │
│ Status: ⚠️ DEGRADED                 │
│                                     │
│ Failed: 13 applications             │
│ Impact: $5.2M in delayed loans      │
│                                     │
│ [Refresh] Last updated: 10:32:15    │
└─────────────────────────────────────┘
```

---

## Phase 2: Operationalization (Days 6-10)

### Day 6: Automation Setup
**Query Automation:**
```bash
# Cron job for SQL path
*/5 * * * * /path/to/sli_checker.sh credit_check

# Splunk saved search
| outputlookup credit_check_sli.csv
```

**Metric Export (Future State):**
```python
# Pushgateway example
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway

registry = CollectorRegistry()
g = Gauge('credit_check_success_rate', 'Success rate', registry=registry)
g.set(success_rate)
push_to_gateway('localhost:9091', job='credit_check', registry=registry)
```

### Day 7: Alert Configuration
**Alert Thresholds:**
- **Warning:** < Target for 5 minutes
- **Critical:** < (Target - 1%) for 5 minutes
- **Page:** < (Target - 2%) for 5 minutes

**Alert Template:**
```
Subject: [SEVERITY] Credit Check Service Below SLO

Current Rate: {current_rate}%
Target Rate: {target_rate}%
Duration: {duration_minutes} minutes
Failed Count: {failed_count}
Estimated Impact: {impact_amount}

Dashboard: {dashboard_link}
Runbook: {runbook_link}
```

### Day 8: Documentation
**Required Documentation:**
1. **Service Profile**
   - Business purpose
   - Technical architecture
   - Data flow diagram
   - Dependency map

2. **SLI Definition**
   - Good event criteria
   - Total event criteria
   - Query implementation
   - Data source details

3. **Runbook**
   - Common failure modes
   - Investigation steps
   - Escalation path
   - Recovery procedures

### Day 9: Team Training
**Training Agenda (2 hours):**
1. BOS Concepts (30 min)
   - SLI vs metrics
   - Business impact focus
   - Error budgets

2. Dashboard Usage (30 min)
   - Reading the dashboard
   - Understanding trends
   - Identifying issues

3. Incident Response (45 min)
   - Alert interpretation
   - Investigation process
   - Communication protocol

4. Q&A (15 min)

### Day 10: Go-Live
**Launch Checklist:**
- [ ] Dashboard accessible to team
- [ ] Alerts configured and tested
- [ ] Runbook published
- [ ] Team trained
- [ ] Stakeholders notified
- [ ] Baseline metrics captured

**Success Criteria:**
- Dashboard updates every 5 minutes
- Alerts fire appropriately
- Team can interpret results
- Business stakeholders engaged

---

## Phase 3: Expansion (Days 11-30)

### Week 3: Add Services
**Prioritization Matrix:**
| Service | Business Critical | Data Ready | Owner Engaged | Priority |
|---------|------------------|------------|---------------|----------|
| Payment | ✅ High | ✅ Yes | ✅ Yes | 1 |
| Account | ✅ High | ✅ Yes | ⚠️ Partial | 2 |
| Transfer | ⚠️ Medium | ✅ Yes | ✅ Yes | 3 |
| Report | ❌ Low | ✅ Yes | ✅ Yes | 4 |

**Parallel Development:**
- 2-3 services per week
- Reuse patterns from pilot
- Share queries and dashboards
- Standardize naming conventions

### Week 4: Portfolio View
**Executive Dashboard:**
```
┌─────────────────────────────────────────────┐
│ Business Service Portfolio Health           │
├─────────────────────────────────────────────┤
│ Service        | SLO  | Current | Impact    │
│----------------|------|---------|-----------|│
│ Credit Check   | 99.5 | 99.7 ✅ | $0        │
│ Payment Proc   | 99.9 | 99.2 ⚠️ | $47K      │
│ Account Open   | 99.0 | 98.1 🔴 | 13 blocked│
│ Wire Transfer  | 99.5 | 99.8 ✅ | $0        │
│                                             │
│ Total At Risk: $47K | Affected: 13 customers│
└─────────────────────────────────────────────┘
```

---

## Common Patterns & Solutions

### Pattern: Composite Services
**Problem:** Service depends on multiple sub-services
**Solution:** 
```sql
-- Composite SLI
WITH sub_services AS (
  SELECT 'auth' as service, 
         COUNT(CASE WHEN auth_status='SUCCESS' THEN 1 END)*100.0/COUNT(*) as rate
  FROM auth_log WHERE created_at > SYSDATE - INTERVAL '1' HOUR
  UNION ALL
  SELECT 'credit' as service,
         COUNT(CASE WHEN credit_status='SUCCESS' THEN 1 END)*100.0/COUNT(*) as rate
  FROM credit_log WHERE created_at > SYSDATE - INTERVAL '1' HOUR
)
SELECT MIN(rate) as composite_rate FROM sub_services;
```

### Pattern: Latency-Based SLI
**Problem:** Success includes response time
**Solution:**
```sql
SELECT 
  ROUND(COUNT(CASE WHEN status='SUCCESS' 
    AND response_time_ms < 1000 THEN 1 END)*100.0/COUNT(*), 2) as success_rate
FROM service_metrics
WHERE created_at > SYSDATE - INTERVAL '1' HOUR;
```

### Pattern: Business Hours Only
**Problem:** SLO only applies during business hours
**Solution:**
```sql
SELECT 
  ROUND(COUNT(CASE WHEN status='SUCCESS' THEN 1 END)*100.0/COUNT(*), 2) as success_rate
FROM service_metrics
WHERE created_at > SYSDATE - INTERVAL '1' HOUR
  AND TO_CHAR(created_at, 'HH24') BETWEEN '08' AND '17'
  AND TO_CHAR(created_at, 'D') BETWEEN '2' AND '6'; -- Mon-Fri
```

---

## Troubleshooting Guide

### Issue: No Data in Query Results
**Diagnosis:**
1. Check table/index name spelling
2. Verify time window has data
3. Confirm permissions to data source
4. Test with wider time window

**Resolution:**
```sql
-- Debug query
SELECT COUNT(*), MIN(created_at), MAX(created_at)
FROM service_table
WHERE created_at > SYSDATE - 7; -- Week window for testing
```

### Issue: SLI Calculation Seems Wrong
**Diagnosis:**
1. Verify good condition logic
2. Check for NULL handling
3. Validate time zone handling
4. Compare manual count with query

**Resolution:**
```sql
-- Validation query
SELECT 
  status,
  COUNT(*) as count,
  ROUND(COUNT(*)*100.0/(SELECT COUNT(*) FROM service_table 
    WHERE created_at > SYSDATE - INTERVAL '1' HOUR), 2) as percentage
FROM service_table
WHERE created_at > SYSDATE - INTERVAL '1' HOUR
GROUP BY status
ORDER BY count DESC;
```

### Issue: Query Performance Slow
**Diagnosis:**
1. Check index usage
2. Review time window size
3. Examine query complexity
4. Monitor database load

**Resolution:**
- Add index on created_at column
- Use materialized view for complex queries
- Implement summary table pattern
- Schedule during off-peak hours

---

## Success Metrics

### Week 1 Success
- ✅ One service with working SLI
- ✅ Dashboard displaying real-time data
- ✅ Team understands the metrics

### Month 1 Success
- ✅ 5+ services monitored
- ✅ Portfolio dashboard live
- ✅ Incident response improved by 30%
- ✅ Business stakeholders engaged

### Quarter 1 Success
- ✅ All Tier 1 services covered
- ✅ Automated alerting in place
- ✅ SLO reviews in business meetings
- ✅ Measurable MTTR improvement

---

## Next Steps

1. **Immediate:** Start with pilot service selection
2. **Week 1:** Complete first implementation
3. **Month 1:** Expand to 5 services
4. **Quarter 1:** Full Tier 1 coverage
5. **Year 1:** Enterprise-wide adoption

---

## Resources

- [Quick Start Card](./quick-start-reference.md) - Essential templates
- [Data Model Specification](./data-model-specification-v1.md) - Complete field reference
- [OpenSLO Mapping](./openslo-mapping-reference.md) - Specification details
- [Executive Summary](./executive-summary-business-observability.md) - Leadership overview

---

*This is a living document. Updates based on implementation learnings.*