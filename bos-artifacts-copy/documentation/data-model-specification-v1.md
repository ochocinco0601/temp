# Data Model Specification v1.0

## Overview
This specification defines the complete data model for Business Observability System (BOS) Service Level Objectives. The model serves as the single source of truth for generating both human-readable business context and machine-readable OpenSLO configurations.

## Purpose
- **Primary:** Define all fields required to create a complete Business SLO
- **Secondary:** Enable automated transformation to multiple output formats
- **Tertiary:** Maintain traceability between business requirements and technical implementation

---

## Data Model Structure

### Section 1: Service & Business Context

| Field Name | Data Type | Required | Responsible | Description | Example |
|------------|-----------|----------|-------------|-------------|---------|
| `serviceName` | string | Yes | Product Owner | Unique identifier for the service | `credit-check-service` |
| `displayName` | string | No | Product Owner | Human-friendly service name | `Credit Risk Assessment` |
| `businessPurpose` | string | Yes | Product Owner | One-sentence business function description | `Assess credit risk for loan applications` |
| `serviceType` | enum | Yes | Product Owner | Category of service | `customer_facing`, `internal_process`, `batch_job` |
| `tierLevel` | integer | Yes | Product Owner | Criticality tier (1=highest) | `1`, `2`, `3` |
| `businessUnit` | string | Yes | Product Owner | Owning organizational unit | `Consumer Lending` |
| `technicalOwner` | string | Yes | Developer | Team responsible for service | `lending-platform-team` |
| `productOwner` | string | Yes | Product Owner | Business stakeholder name | `Jane Smith` |

### Section 2: Performance Indicator (The SLI)

| Field Name | Data Type | Required | Responsible | Description | Example |
|------------|-----------|----------|-------------|-------------|---------|
| `performanceQuestion` | string | Yes | Product Owner | Business question the SLI answers | `What percentage of credit checks complete successfully?` |
| `sliName` | string | Yes | Product Owner | Short, descriptive SLI identifier | `credit-check-success-rate` |
| `sliDisplayName` | string | No | Product Owner | Human-friendly SLI name | `Credit Check Success Rate` |
| `sliType` | enum | Yes | Developer | Technical measurement type | `ratioMetric`, `thresholdMetric` |
| `goodEventsCriteria_PO` | string | Yes | Product Owner | Business description of "good" events | `Credit check returns valid score within 2 seconds` |
| `goodEventsCriteria_Dev` | string | Yes | Developer | Technical query for good events | `status='SUCCESS' AND score IS NOT NULL AND response_time<2000` |
| `totalEventsCriteria_PO` | string | Yes | Product Owner | Business description of total population | `All credit check requests` |
| `totalEventsCriteria_Dev` | string | Yes | Developer | Technical query for total events | `service='credit-check'` |
| `dataSource` | enum | Yes | Developer | Where metrics are retrieved | `splunk`, `sql`, `prometheus` |
| `dataSourceDetails` | object | Yes | Developer | Connection and query specifics | `{index: 'loans', table: 'credit_checks'}` |

### Section 3: Performance Objective (The SLO)

| Field Name | Data Type | Required | Responsible | Description | Example |
|------------|-----------|----------|-------------|-------------|---------|
| `sloTarget` | decimal | Yes | Product Owner | Success rate target (0-100) | `99.5` |
| `sloTargetRationale` | string | No | Product Owner | Business justification for target | `Industry standard for financial services` |
| `timeWindow` | string | Yes | Product Owner | Measurement period | `28d`, `7d`, `1h` |
| `timeWindowType` | enum | Yes | Product Owner | Window calculation method | `rolling`, `calendar` |
| `budgetingMethod` | enum | Yes | Product Owner | Error budget calculation | `Occurrences`, `Timeslices`, `RatioTimeslices` |
| `alertingThreshold` | decimal | No | Product Owner | When to alert (% of target) | `99.0` |
| `pageThreshold` | decimal | No | Product Owner | When to page on-call (% of target) | `98.0` |

### Section 4: Business Impact

| Field Name | Data Type | Required | Responsible | Description | Example |
|------------|-----------|----------|-------------|-------------|---------|
| `impactCategory` | enum | Yes | Product Owner | Primary impact type | `customer_experience`, `revenue`, `regulatory`, `reputation` |
| `stakeholderType` | string | Yes | Product Owner | Who is affected | `loan applicants`, `traders`, `customers` |
| `stakeholderCount` | string | No | Product Owner | How to count affected stakeholders | `COUNT(DISTINCT customer_id)` |
| `failureScenario` | string | Yes | Product Owner | What happens during failure | `Loan applications cannot proceed to approval` |
| `businessConsequence` | string | Yes | Product Owner | Business outcome of failure | `Delayed loan funding, potential customer loss` |
| `financialImpact` | string | No | Product Owner | Estimated financial exposure | `$50K per hour in lost revenue` |
| `regulatoryImpact` | string | No | Product Owner | Compliance implications | `Potential CFPB violation if > 24 hours` |

### Section 5: Implementation Details

| Field Name | Data Type | Required | Responsible | Description | Example |
|------------|-----------|----------|-------------|-------------|---------|
| `queryImplementation` | object | Yes | Developer | Complete query details | See Query Schema below |
| `dashboardUrl` | string | No | Developer | Link to monitoring dashboard | `https://splunk/dashboard/credit-slo` |
| `runbookUrl` | string | No | Developer | Link to incident runbook | `https://wiki/runbooks/credit-check` |
| `alertingConfigured` | boolean | Yes | Developer | Whether alerts are active | `true`, `false` |
| `lastValidated` | datetime | Yes | Developer | When SLI query last verified | `2024-01-15T10:30:00Z` |
| `implementationNotes` | string | No | Developer | Technical considerations | `Excludes test accounts with customer_type='TEST'` |

### Section 6: Metadata

| Field Name | Data Type | Required | Responsible | Description | Example |
|------------|-----------|----------|-------------|-------------|---------|
| `version` | string | Yes | System | Data model version | `1.0.0` |
| `created` | datetime | Yes | System | When record created | `2024-01-01T00:00:00Z` |
| `modified` | datetime | Yes | System | Last modification time | `2024-01-15T10:30:00Z` |
| `modifiedBy` | string | Yes | System | Who last modified | `jsmith` |
| `status` | enum | Yes | Product Owner | Current lifecycle status | `draft`, `active`, `deprecated` |
| `reviewDate` | date | No | Product Owner | Next review date | `2024-04-01` |
| `tags` | array | No | Product Owner | Categorization tags | `["tier1", "customer-facing", "lending"]` |

---

## Query Schema

### SQL Query Implementation
```json
{
  "type": "sql",
  "connection": {
    "database": "metrics_db",
    "host": "db.example.com",
    "port": 1521
  },
  "goodQuery": "SELECT COUNT(*) FROM credit_checks WHERE status='SUCCESS' AND score IS NOT NULL AND created_at > :start_time",
  "totalQuery": "SELECT COUNT(*) FROM credit_checks WHERE created_at > :start_time",
  "timeField": "created_at",
  "filters": "customer_type != 'TEST'"
}
```

### Splunk Query Implementation
```json
{
  "type": "splunk",
  "connection": {
    "instance": "splunk.example.com",
    "index": "loans"
  },
  "query": "index=loans service=\"credit-check\" | eval is_good=if(status=\"SUCCESS\" AND isnotnull(score), 1, 0) | stats sum(is_good) as good, count as total | eval success_rate=round(good*100/total, 2)",
  "earliest": "-1h",
  "latest": "now"
}
```

---

## Validation Rules

### Required Field Combinations
1. If `sliType` = `ratioMetric`, then both `goodEventsCriteria_Dev` and `totalEventsCriteria_Dev` required
2. If `sliType` = `thresholdMetric`, then `thresholdValue` and `thresholdOperator` required
3. If `budgetingMethod` = `Timeslices`, then `timesliceWindow` required
4. If `timeWindowType` = `calendar`, then `calendarStartTime` and `timeZone` required

### Field Constraints
- `sloTarget`: Must be between 0 and 100 (exclusive)
- `timeWindow`: Must match pattern `^\d+[mhdw]$` (e.g., 5m, 1h, 7d, 4w)
- `serviceName`: Must be lowercase with hyphens only (regex: `^[a-z][a-z0-9-]*$`)
- `tierLevel`: Must be integer between 1 and 4
- All `*_Dev` fields: Must be valid query syntax for specified `dataSource`

### Business Logic Validation
1. `alertingThreshold` must be less than `sloTarget`
2. `pageThreshold` must be less than `alertingThreshold`
3. `reviewDate` must be within 90 days if `tierLevel` = 1
4. `financialImpact` required if `impactCategory` = `revenue`
5. `regulatoryImpact` required if `impactCategory` = `regulatory`

---

## Transformation Rules

### To OpenSLO v1
```yaml
# Mapping transformations
metadata.name: serviceName + "-slo"
metadata.displayName: displayName || serviceName
spec.service: serviceName
spec.description: businessPurpose + ". " + performanceQuestion
spec.indicator.metadata.name: sliName
spec.objectives[0].target: sloTarget / 100
spec.objectives[0].targetPercent: sloTarget
spec.timeWindow[0].duration: timeWindow
spec.budgetingMethod: budgetingMethod
```

### To Prometheus Recording Rule
```yaml
# Template transformation
- record: slo:{{sliName}}:success_rate_1h
  expr: |
    sum(rate({{goodEventsCriteria_Dev}}[1h])) /
    sum(rate({{totalEventsCriteria_Dev}}[1h]))
```

### To Dashboard JSON
```json
{
  "title": "{{displayName}} - Business SLO",
  "panels": [
    {
      "title": "Current Performance",
      "target": "{{sliName}}",
      "thresholds": [
        {"value": "{{pageThreshold}}", "color": "red"},
        {"value": "{{alertingThreshold}}", "color": "yellow"},
        {"value": "{{sloTarget}}", "color": "green"}
      ]
    }
  ]
}
```

---

## CSV Format Specification

### File Structure
- **Encoding:** UTF-8 with BOM
- **Delimiter:** Comma (,)
- **Quote Character:** Double quote (")
- **Header Row:** Required
- **Column Order:** Must match Field Order section

### Field Order
```csv
serviceName,displayName,businessPurpose,serviceType,tierLevel,businessUnit,technicalOwner,productOwner,performanceQuestion,sliName,sliDisplayName,sliType,goodEventsCriteria_PO,goodEventsCriteria_Dev,totalEventsCriteria_PO,totalEventsCriteria_Dev,dataSource,dataSourceDetails,sloTarget,sloTargetRationale,timeWindow,timeWindowType,budgetingMethod,alertingThreshold,pageThreshold,impactCategory,stakeholderType,stakeholderCount,failureScenario,businessConsequence,financialImpact,regulatoryImpact,queryImplementation,dashboardUrl,runbookUrl,alertingConfigured,lastValidated,implementationNotes,version,created,modified,modifiedBy,status,reviewDate,tags
```

### Example CSV Row
```csv
"credit-check-service","Credit Risk Assessment","Assess credit risk for loan applications","customer_facing",1,"Consumer Lending","lending-platform-team","Jane Smith","What percentage of credit checks complete successfully?","credit-check-success-rate","Credit Check Success Rate","ratioMetric","Credit check returns valid score within 2 seconds","status='SUCCESS' AND score IS NOT NULL AND response_time<2000","All credit check requests","service='credit-check'","sql","{""index"": ""loans"", ""table"": ""credit_checks""}",99.5,"Industry standard for financial services","28d","rolling","Occurrences",99.0,98.0,"customer_experience","loan applicants","COUNT(DISTINCT customer_id)","Loan applications cannot proceed to approval","Delayed loan funding, potential customer loss","$50K per hour in lost revenue","","{}","https://splunk/dashboard/credit-slo","https://wiki/runbooks/credit-check",true,"2024-01-15T10:30:00Z","Excludes test accounts","1.0.0","2024-01-01T00:00:00Z","2024-01-15T10:30:00Z","jsmith","active","2024-04-01","[""tier1"", ""customer-facing"", ""lending""]"
```

---

## Usage Examples

### Creating a New SLO
1. Product Owner completes Sections 1, 3, 4
2. Developer completes Sections 2, 5
3. System auto-populates Section 6
4. Validation rules are applied
5. Transformations generate outputs

### Bulk Import Process
1. Export template CSV with headers
2. Fill required fields per responsibility matrix
3. Validate CSV against rules
4. Import with error reporting
5. Generate OpenSLO and dashboards

### Programmatic Access
```python
# Example: Load and validate data model
import pandas as pd
from datetime import datetime

df = pd.read_csv('slo_definitions.csv')

# Validate required fields
required_fields = ['serviceName', 'businessPurpose', 'sliName', 'sloTarget']
missing = df[required_fields].isnull().any()
if missing.any():
    print(f"Missing required fields: {missing[missing].index.tolist()}")

# Apply business logic validation
invalid_targets = df[(df['sloTarget'] <= 0) | (df['sloTarget'] >= 100)]
if not invalid_targets.empty:
    print(f"Invalid SLO targets: {invalid_targets['serviceName'].tolist()}")

# Generate OpenSLO
for _, row in df.iterrows():
    openslo = generate_openslo(row)
    save_openslo(openslo, f"{row['serviceName']}-slo.yaml")
```

---

## Migration Path

### From v0.9 to v1.0
- Add required field `serviceType`
- Migrate `indicator` to `sliName`
- Split `criteria` into `*_PO` and `*_Dev` fields
- Add `queryImplementation` object

### Future Enhancements (v2.0)
- Multi-objective support
- Composite SLI definitions
- Dependency mapping
- Cost allocation fields
- ML-based target recommendations

---

## Appendix

### Enum Values

**serviceType:**
- `customer_facing` - Direct customer interaction
- `internal_process` - Internal business process
- `batch_job` - Scheduled batch processing
- `api` - API service
- `infrastructure` - Infrastructure component

**impactCategory:**
- `customer_experience` - Direct customer impact
- `revenue` - Financial impact
- `regulatory` - Compliance impact
- `reputation` - Brand/reputation impact
- `operational` - Internal operations impact

**budgetingMethod:**
- `Occurrences` - Count of bad events
- `Timeslices` - Time windows in violation
- `RatioTimeslices` - Ratio of bad time windows

**status:**
- `draft` - Under development
- `active` - In production use
- `deprecated` - Scheduled for removal
- `archived` - Historical record

---

*End of Data Model Specification v1.0*