# Business Observability Quick Start Card

## The 5-Minute Process

### 1️⃣ **Define Success** (Product Owner)
**Question:** "What percentage of [transactions] should succeed?"  
**Example:** "99.5% of credit checks should return a valid score"  
**Your Answer:** _______%

### 2️⃣ **Identify Good Events** (Product Owner)
**Question:** "What makes a single event 'good'?"  
**Example:** "Status = SUCCESS and score is not null"  
**Your Answer:** _______________________

### 3️⃣ **Find the Data** (Developer)
**Question:** "Where does this data live today?"  
**Options:** ☐ Database (SQL) ☐ Splunk logs  
**Table/Index:** _______________________

### 4️⃣ **Define Impact** (Product Owner)
**Question:** "Who can't do what when this fails?"  
**Example:** "Loan applicants can't proceed to approval"  
**Your Answer:** _______________________

### 5️⃣ **Write the Query** (Developer)
**Pick your template below and fill in the blanks**

---

## Essential Query Templates

### 📊 **Success Rate Calculation**
```
Success Rate = (Good Events / Total Events) × 100
```

### 🗄️ **SQL Template**
```sql
-- Basic SLI Query
SELECT 
    ROUND(COUNT(CASE WHEN [good_condition] THEN 1 END)*100.0/COUNT(*), 2) as success_rate,
    COUNT(*) - COUNT(CASE WHEN [good_condition] THEN 1 END) as failed,
    COUNT(*) as total
FROM [your_table]
WHERE created_at > SYSDATE - INTERVAL '1' HOUR;

-- Example filled in:
SELECT 
    ROUND(COUNT(CASE WHEN status='SUCCESS' AND score IS NOT NULL THEN 1 END)*100.0/COUNT(*), 2) as success_rate,
    COUNT(*) - COUNT(CASE WHEN status='SUCCESS' AND score IS NOT NULL THEN 1 END) as failed,
    COUNT(*) as total
FROM credit_checks
WHERE created_at > SYSDATE - INTERVAL '1' HOUR;
```

### 🔍 **Splunk Template**
```splunk
index=[your_index] service="[service_name]" earliest=-1h
| eval is_good=if([good_condition], 1, 0)
| stats count as total, sum(is_good) as good
| eval success_rate=round(good*100/total, 2)
| eval failed=total-good
| eval status=if(success_rate>=[target], "✓ MEETING SLO", "✗ BREACHING")

# Example filled in:
index=loans service="credit-check" earliest=-1h
| eval is_good=if(status="SUCCESS" AND isnotnull(score), 1, 0)
| stats count as total, sum(is_good) as good
| eval success_rate=round(good*100/total, 2)
| eval failed=total-good
| eval status=if(success_rate>=99.5, "✓ MEETING SLO", "✗ BREACHING")
```

---

## Common "Good" Conditions

| Use Case | SQL | Splunk |
|----------|-----|--------|
| **Status-based** | `status='SUCCESS'` | `status="SUCCESS"` |
| **No errors** | `error_count=0` | `NOT error="*"` |
| **Fast enough** | `response_time_ms < 1000` | `response_time < 1000` |
| **Has result** | `result IS NOT NULL` | `isnotnull(result)` |
| **Multiple** | `status='SUCCESS' AND score IS NOT NULL` | `status="SUCCESS" AND isnotnull(score)` |

---

## Time Windows

| Database | Last Hour | Last 24 Hours | Last 5 Minutes |
|----------|-----------|---------------|----------------|
| **Oracle** | `created_at > SYSDATE - INTERVAL '1' HOUR` | `created_at > SYSDATE - 1` | `created_at > SYSDATE - INTERVAL '5' MINUTE` |
| **MySQL** | `created_at > NOW() - INTERVAL 1 HOUR` | `created_at > NOW() - INTERVAL 24 HOUR` | `created_at > NOW() - INTERVAL 5 MINUTE` |
| **PostgreSQL** | `created_at > NOW() - INTERVAL '1 HOUR'` | `created_at > NOW() - INTERVAL '24 HOURS'` | `created_at > NOW() - INTERVAL '5 MINUTES'` |
| **Splunk** | `earliest=-1h` | `earliest=-24h` | `earliest=-5m` |

---

## Quick Dashboard Layout

```
┌──────────────────────────────────────┐
│ SERVICE NAME - Business SLO          │
├──────────────────────────────────────┤
│ Current: [RATE]% | Target: [TARGET]% │
│ Status: [✓ OK or ✗ BREACH]          │
│                                      │
│ Impact: [COUNT] [WHO] affected       │
│         [BUSINESS CONSEQUENCE]       │
└──────────────────────────────────────┘
```

---

## The 10 Essential Fields

| # | Field | Who Fills | Example |
|---|-------|-----------|---------|
| 1 | Service Name | PO | credit-check-service |
| 2 | Business Purpose | PO | Assess credit risk |
| 3 | Good Condition | PO | Returns valid score |
| 4 | SLO Target | PO | 99.5% |
| 5 | Time Window | PO | 1 hour |
| 6 | Stakeholder | PO | Loan applicants |
| 7 | Impact | PO | Can't proceed |
| 8 | Data Location | Dev | Database/Splunk |
| 9 | Good Query | Dev | status='SUCCESS' |
| 10 | Total Query | Dev | All records |

---

## Incident Message Formula

```
"[Service] degradation: [Failed Count] [Stakeholder Type] affected.
Impact: [Business Consequence].
Current success rate: [Rate]% (target: [Target]%)"

Example:
"Credit check degradation: 12 loan applicants affected.
Impact: Cannot proceed to approval.
Current success rate: 98.7% (target: 99.5%)"
```

---

## Next Steps After Query Works

1. **Schedule It** - Run every 5 minutes via cron/scheduler
2. **Display It** - Add to existing dashboard
3. **Alert on It** - When rate < target for 5+ minutes
4. **Track It** - Record daily/weekly trends
5. **Improve It** - Refine threshold based on data

---

## Remember

✅ **Good SLI:** "99.2% of credit checks succeed"  
❌ **Bad SLI:** "CPU usage is 45%"

✅ **Good Impact:** "27 loan applications blocked"  
❌ **Bad Impact:** "Service is down"

✅ **Start Simple:** One service, one metric  
❌ **Don't:** Try to do everything at once

---

*Keep this card handy - it's all you need to get started!*