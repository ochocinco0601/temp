# OpenSLO Mapping Reference

## Overview
This reference provides complete mapping between BOS data model fields and OpenSLO specification (v1 and v2alpha). It serves as the authoritative guide for transforming business requirements into vendor-neutral SLO definitions.

---

## OpenSLO Structure Overview

### Basic OpenSLO v1 Structure
```yaml
apiVersion: openslo/v1
kind: SLO
metadata:
  name: string              # Unique identifier
  displayName: string       # Human-friendly name
spec:
  description: string       # Business context
  service: string          # Service identifier
  indicator:               # SLI definition
    metadata:
      name: string
    spec:
      ratioMetric:         # Or thresholdMetric
        good:              # Numerator
        total:             # Denominator
  objectives:              # Array of targets
    - displayName: string
      target: decimal      # 0.0 to 1.0
      targetPercent: decimal # 0 to 100
  timeWindow:             # Measurement period
    - duration: string
      isRolling: boolean
  budgetingMethod: string # Error budget method
  alertPolicies:          # Alert configurations
```

---

## Field-by-Field Mapping

### Metadata Section

| BOS Field | OpenSLO v1 Path | OpenSLO v2alpha Path | Transformation |
|-----------|-----------------|---------------------|----------------|
| `serviceName` + "-slo" | `metadata.name` | `metadata.name` | Concatenate with suffix |
| `displayName` | `metadata.displayName` | `metadata.labels.displayName` | Direct map or fallback to serviceName |
| `tags` | N/A | `metadata.labels.*` | Array to label key-value pairs |
| `version` | N/A | `metadata.labels.version` | Direct map to label |

**Example Transformation:**
```yaml
# BOS Input
serviceName: "credit-check-service"
displayName: "Credit Risk Assessment"
tags: ["tier1", "customer-facing"]

# OpenSLO v1 Output
metadata:
  name: credit-check-service-slo
  displayName: Credit Risk Assessment

# OpenSLO v2alpha Output  
metadata:
  name: credit-check-service-slo
  labels:
    displayName: Credit Risk Assessment
    tier: tier1
    type: customer-facing
```

### Service & Description

| BOS Field | OpenSLO v1 Path | OpenSLO v2alpha Path | Transformation |
|-----------|-----------------|---------------------|----------------|
| `serviceName` | `spec.service` | `spec.service` | Direct map |
| `businessPurpose` + `performanceQuestion` | `spec.description` | `spec.description` | Concatenate with ". " |

**Example Transformation:**
```yaml
# BOS Input
businessPurpose: "Assess credit risk for loan applications"
performanceQuestion: "What percentage of credit checks complete successfully?"

# OpenSLO Output
spec:
  description: "Assess credit risk for loan applications. What percentage of credit checks complete successfully?"
```

### SLI Definition

| BOS Field | OpenSLO v1 Path | OpenSLO v2alpha Path | Transformation |
|-----------|-----------------|---------------------|----------------|
| `sliName` | `spec.indicator.metadata.name` | `spec.sli.metadata.name` | Direct map |
| `sliDisplayName` | `spec.indicator.metadata.displayName` | N/A | Direct map |
| `sliType` | Determines `ratioMetric` or `thresholdMetric` | Same | Conditional structure |

#### Ratio Metric Mapping

| BOS Field | OpenSLO v1 Path | OpenSLO v2alpha Path | Transformation |
|-----------|-----------------|---------------------|----------------|
| `dataSource` | `spec.indicator.spec.ratioMetric.good.metricSource.type` | `spec.sli.spec.ratioMetric.good.dataSourceRef` | Map to source type |
| `goodEventsCriteria_Dev` | `spec.indicator.spec.ratioMetric.good.metricSource.spec` | `spec.sli.spec.ratioMetric.good.spec` | Query syntax per source |
| `totalEventsCriteria_Dev` | `spec.indicator.spec.ratioMetric.total.metricSource.spec` | `spec.sli.spec.ratioMetric.total.spec` | Query syntax per source |

**SQL Example:**
```yaml
# BOS Input
sliType: "ratioMetric"
dataSource: "sql"
goodEventsCriteria_Dev: "status='SUCCESS' AND score IS NOT NULL"
totalEventsCriteria_Dev: "service='credit-check'"

# OpenSLO v1 Output
spec:
  indicator:
    spec:
      ratioMetric:
        good:
          metricSource:
            type: SQL
            spec:
              query: |
                SELECT COUNT(*) FROM credit_checks 
                WHERE status='SUCCESS' AND score IS NOT NULL 
                AND created_at > :start_time
        total:
          metricSource:
            type: SQL
            spec:
              query: |
                SELECT COUNT(*) FROM credit_checks 
                WHERE service='credit-check' 
                AND created_at > :start_time
```

**Splunk Example:**
```yaml
# BOS Input
dataSource: "splunk"
goodEventsCriteria_Dev: "status=\"SUCCESS\" AND isnotnull(score)"
totalEventsCriteria_Dev: "service=\"credit-check\""

# OpenSLO Output
spec:
  indicator:
    spec:
      ratioMetric:
        good:
          metricSource:
            type: Splunk
            spec:
              index: loans
              query: |
                search status="SUCCESS" AND isnotnull(score)
                | stats count as good_count
        total:
          metricSource:
            type: Splunk
            spec:
              index: loans
              query: |
                search service="credit-check"
                | stats count as total_count
```

#### Threshold Metric Mapping

| BOS Field | OpenSLO v1 Path | OpenSLO v2alpha Path | Transformation |
|-----------|-----------------|---------------------|----------------|
| `thresholdValue` | Used in `objectives.value` | Same | Direct map |
| `thresholdOperator` | Used in `objectives.op` | Same | Map operator |
| `thresholdQuery_Dev` | `spec.indicator.spec.thresholdMetric.metricSource.spec` | `spec.sli.spec.thresholdMetric.spec` | Query syntax |

### Objectives Section

| BOS Field | OpenSLO v1 Path | OpenSLO v2alpha Path | Transformation |
|-----------|-----------------|---------------------|----------------|
| `sloTarget` | `spec.objectives[0].target` | `spec.objectives[0].target` | Divide by 100 |
| `sloTarget` | `spec.objectives[0].targetPercent` | `spec.objectives[0].targetPercent` | Direct map |
| Static: "Primary" | `spec.objectives[0].displayName` | `spec.objectives[0].displayName` | Default value |

**Example Transformation:**
```yaml
# BOS Input
sloTarget: 99.5

# OpenSLO Output
spec:
  objectives:
    - displayName: Primary
      target: 0.995
      targetPercent: 99.5
```

### Time Window

| BOS Field | OpenSLO v1 Path | OpenSLO v2alpha Path | Transformation |
|-----------|-----------------|---------------------|----------------|
| `timeWindow` | `spec.timeWindow[0].duration` | `spec.timeWindow[0].duration` | Direct map |
| `timeWindowType` | `spec.timeWindow[0].isRolling` | `spec.timeWindow[0].isRolling` | "rolling" → true, "calendar" → false |

**Duration Format Mapping:**
- `1h` → `1h` (hours)
- `1d` → `1d` (days)
- `7d` → `7d` or `1w` (week)
- `28d` → `28d` or `4w` (4 weeks)
- `30d` → `30d` or `1M` (month approximation)

### Budgeting Method

| BOS Field | OpenSLO Value | Description |
|-----------|---------------|-------------|
| `Occurrences` | `Occurrences` | Count of bad events |
| `Timeslices` | `Timeslices` | Count of bad time windows |
| `RatioTimeslices` | `RatioTimeslices` | Ratio of bad time windows |

---

## Complete Transformation Examples

### Example 1: Simple Ratio Metric SLO

**BOS Input:**
```csv
serviceName,sliName,sliType,dataSource,goodEventsCriteria_Dev,totalEventsCriteria_Dev,sloTarget,timeWindow,budgetingMethod
payment-service,payment-success-rate,ratioMetric,sql,status='COMPLETED',service='payment',99.9,28d,Occurrences
```

**OpenSLO v1 Output:**
```yaml
apiVersion: openslo/v1
kind: SLO
metadata:
  name: payment-service-slo
  displayName: payment-service
spec:
  description: "Process customer payments"
  service: payment-service
  indicator:
    metadata:
      name: payment-success-rate
    spec:
      ratioMetric:
        good:
          metricSource:
            type: SQL
            spec:
              query: |
                SELECT COUNT(*) FROM payments
                WHERE status='COMPLETED'
                AND created_at > :start_time
        total:
          metricSource:
            type: SQL
            spec:
              query: |
                SELECT COUNT(*) FROM payments
                WHERE service='payment'
                AND created_at > :start_time
  objectives:
    - displayName: Primary
      target: 0.999
      targetPercent: 99.9
  timeWindow:
    - duration: 28d
      isRolling: true
  budgetingMethod: Occurrences
```

### Example 2: Threshold Metric SLO

**BOS Input:**
```csv
serviceName,sliName,sliType,dataSource,thresholdQuery_Dev,thresholdOperator,thresholdValue,sloTarget,timeWindow
api-gateway,response-time,thresholdMetric,prometheus,http_request_duration_seconds_p99,lt,1.0,99.0,1h
```

**OpenSLO Output:**
```yaml
apiVersion: openslo/v1
kind: SLO
metadata:
  name: api-gateway-slo
  displayName: api-gateway
spec:
  service: api-gateway
  indicator:
    metadata:
      name: response-time
    spec:
      thresholdMetric:
        metricSource:
          type: Prometheus
          spec:
            query: http_request_duration_seconds_p99
  objectives:
    - displayName: Primary
      op: lt
      value: 1.0
      target: 0.99
      targetPercent: 99.0
  timeWindow:
    - duration: 1h
      isRolling: true
  budgetingMethod: Occurrences
```

### Example 3: Complex Business SLO with Splunk

**BOS Input:**
```csv
serviceName,displayName,businessPurpose,sliName,dataSource,goodEventsCriteria_Dev,totalEventsCriteria_Dev,sloTarget,timeWindow,budgetingMethod,alertingThreshold,impactCategory,stakeholderType
loan-origination,Loan Origination System,Process loan applications from submission to approval,loan-processing-sli,splunk,"status=""APPROVED"" OR status=""DECLINED""","eventtype=""loan-application""",98.5,7d,Timeslices,98.0,customer_experience,loan applicants
```

**OpenSLO v2alpha Output:**
```yaml
apiVersion: openslo.com/v2alpha
kind: SLO
metadata:
  name: loan-origination-slo
  labels:
    displayName: "Loan Origination System"
    impact: customer_experience
    stakeholder: loan_applicants
spec:
  description: "Process loan applications from submission to approval. Measuring successful processing rate."
  service: loan-origination
  sli:
    metadata:
      name: loan-processing-sli
    spec:
      ratioMetric:
        counter: false
        good:
          dataSourceSpec:
            type: Splunk
          spec:
            index: loans
            query: |
              search eventtype="loan-application" (status="APPROVED" OR status="DECLINED")
              | stats count as good_count
        total:
          dataSourceSpec:
            type: Splunk
          spec:
            index: loans
            query: |
              search eventtype="loan-application"
              | stats count as total_count
  objectives:
    - displayName: Primary Processing Target
      target: 0.985
      targetPercent: 98.5
      timeSliceTarget: 0.95  # Required for Timeslices
      timeSliceWindow: 1h     # 1-hour time slices
  timeWindow:
    - duration: 7d
      isRolling: true
  budgetingMethod: Timeslices
  alertPolicies:
    - metadata:
        name: loan-processing-alert
      spec:
        conditions:
          - kind: burnrate
            threshold: 0.98  # Alert at 98% of target
        notificationTarget:
          - service: pagerduty
```

---

## Data Source Specific Mappings

### SQL Sources
```yaml
metricSource:
  type: SQL
  connectionDetails:
    # From dataSourceDetails field
    database: metrics_db
    host: db.example.com
    port: 1521
  spec:
    # From *_Dev fields with template expansion
    query: |
      SELECT COUNT(*) FROM {{ table }}
      WHERE {{ criteria }}
      AND {{ time_field }} > :start_time
```

### Splunk Sources
```yaml
metricSource:
  type: Splunk
  connectionDetails:
    # From dataSourceDetails field
    instance: splunk.example.com
    token: ${SPLUNK_TOKEN}  # From environment
  spec:
    # From *_Dev fields
    index: {{ index }}
    query: |
      search {{ criteria }}
      | stats count
```

### Prometheus Sources
```yaml
metricSource:
  type: Prometheus
  connectionDetails:
    # From dataSourceDetails field
    url: http://prometheus:9090
  spec:
    # From *_Dev fields
    query: |
      sum(rate({{ metric }}[{{ window }}]))
```

---

## Alert Policy Mapping

| BOS Field | OpenSLO Path | Transformation |
|-----------|--------------|----------------|
| `alertingThreshold` | `spec.alertPolicies[0].spec.conditions[0].threshold` | Direct map |
| `pageThreshold` | `spec.alertPolicies[1].spec.conditions[0].threshold` | Separate policy |

**Example:**
```yaml
# BOS Input
alertingThreshold: 99.0
pageThreshold: 98.0

# OpenSLO Output
alertPolicies:
  - metadata:
      name: warning-alert
    spec:
      conditions:
        - kind: burnrate
          threshold: 0.99
      notificationTarget:
        - service: email
  - metadata:
      name: critical-page
    spec:
      conditions:
        - kind: burnrate
          threshold: 0.98
      notificationTarget:
        - service: pagerduty
```

---

## Validation Requirements

### Pre-Transformation Validation
1. **Required Fields Check**
   - Ensure all mandatory BOS fields present
   - Validate field formats and ranges

2. **Consistency Validation**
   - Check threshold relationships (page < alert < target)
   - Verify query syntax for data source type

3. **Reference Validation**
   - Confirm service names exist
   - Validate data source connections

### Post-Transformation Validation
1. **YAML Syntax**
   - Valid YAML structure
   - Correct indentation

2. **OpenSLO Schema**
   - Required fields present
   - Correct data types
   - Valid enum values

3. **Semantic Validation**
   - Time window format correct
   - Target values in valid range
   - Budgeting method compatibility

---

## Programmatic Transformation

### Python Example
```python
import yaml
from typing import Dict, Any

def transform_bos_to_openslo(bos_record: Dict[str, Any]) -> Dict[str, Any]:
    """Transform BOS data model to OpenSLO v1 format"""
    
    openslo = {
        'apiVersion': 'openslo/v1',
        'kind': 'SLO',
        'metadata': {
            'name': f"{bos_record['serviceName']}-slo",
            'displayName': bos_record.get('displayName', bos_record['serviceName'])
        },
        'spec': {
            'description': f"{bos_record['businessPurpose']}. {bos_record['performanceQuestion']}",
            'service': bos_record['serviceName'],
            'indicator': transform_indicator(bos_record),
            'objectives': [{
                'displayName': 'Primary',
                'target': float(bos_record['sloTarget']) / 100,
                'targetPercent': float(bos_record['sloTarget'])
            }],
            'timeWindow': [{
                'duration': bos_record['timeWindow'],
                'isRolling': bos_record['timeWindowType'] == 'rolling'
            }],
            'budgetingMethod': bos_record['budgetingMethod']
        }
    }
    
    # Add alert policies if defined
    if 'alertingThreshold' in bos_record:
        openslo['spec']['alertPolicies'] = transform_alerts(bos_record)
    
    return openslo

def transform_indicator(bos_record: Dict[str, Any]) -> Dict[str, Any]:
    """Transform SLI definition based on type"""
    
    indicator = {
        'metadata': {
            'name': bos_record['sliName']
        }
    }
    
    if bos_record['sliType'] == 'ratioMetric':
        indicator['spec'] = {
            'ratioMetric': {
                'good': create_metric_source(
                    bos_record['dataSource'],
                    bos_record['goodEventsCriteria_Dev'],
                    bos_record.get('dataSourceDetails', {})
                ),
                'total': create_metric_source(
                    bos_record['dataSource'],
                    bos_record['totalEventsCriteria_Dev'],
                    bos_record.get('dataSourceDetails', {})
                )
            }
        }
    elif bos_record['sliType'] == 'thresholdMetric':
        indicator['spec'] = {
            'thresholdMetric': create_metric_source(
                bos_record['dataSource'],
                bos_record['thresholdQuery_Dev'],
                bos_record.get('dataSourceDetails', {})
            )
        }
    
    return indicator

def create_metric_source(source_type: str, query: str, details: Dict) -> Dict[str, Any]:
    """Create metric source configuration"""
    
    source_map = {
        'sql': 'SQL',
        'splunk': 'Splunk',
        'prometheus': 'Prometheus'
    }
    
    return {
        'metricSource': {
            'type': source_map.get(source_type.lower(), source_type),
            'spec': {
                'query': query,
                **details
            }
        }
    }

# Usage
bos_data = load_bos_record()
openslo_config = transform_bos_to_openslo(bos_data)
with open('output.yaml', 'w') as f:
    yaml.dump(openslo_config, f)
```

---

## Migration Notes

### OpenSLO v1 to v2alpha
Key differences requiring transformation:
1. `indicator` → `sli`
2. `metricSource` → `dataSourceRef` or `dataSourceSpec`
3. `displayName` moves to labels
4. URL format: `openslo/v1` → `openslo.com/v2alpha`

### Legacy Format Support
For systems using proprietary formats:
1. Export to BOS CSV format
2. Apply standard transformation
3. Validate against OpenSLO schema
4. Deploy to target platform

---

## Troubleshooting

### Common Mapping Issues

**Issue:** Query syntax incompatible with OpenSLO
**Solution:** Wrap queries in appropriate metricSource spec

**Issue:** Time window format mismatch
**Solution:** Use standard duration format (1h, 1d, 1w)

**Issue:** Missing required OpenSLO fields
**Solution:** Provide defaults in transformation logic

**Issue:** Invalid target values
**Solution:** Ensure proper decimal conversion (99.5% → 0.995)

---

## References

- [OpenSLO Specification v1](https://github.com/OpenSLO/OpenSLO)
- [OpenSLO v2alpha Enhancement](https://github.com/OpenSLO/OpenSLO/blob/main/enhancements/v2alpha.md)
- [BOS Data Model Specification](./data-model-specification-v1.md)

---

*Last Updated: January 2024*