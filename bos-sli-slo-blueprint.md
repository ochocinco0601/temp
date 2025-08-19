This document provides a comprehensive, integrated blueprint for defining, measuring, and acting on Service Level Objectives (SLOs) for the funding service. It moves from strategic guidance to actionable implementation details.

-----

## 1\. SLO Framework: Measuring Service Health 📊

Service Level Objectives (SLOs) establish quantifiable targets for the performance and reliability of a service. This framework organizes SLOs into three tiers, providing a holistic view of service health and impact:

  * **Business Health**: Top-level metrics assessing the service's success in meeting core business goals and customer expectations.

  * **Business Impact**: Quantifiable measures of the consequences when a service fails, crucial for incident management and stakeholder communication.

  * **Technical Health**: Leading indicators that monitor internal process performance, enabling proactive identification and resolution of bottlenecks.

The following tables serve as the blueprint for defining and monitoring these objectives, with example "Current Values" and "Statuses" for illustrative purposes.

### Business Health SLOs

| **Metric Name** | **Service Level Indicator (SLI)** | **Service Level Objective (SLO)** | **Time Component** | **Current Value** | **Status** | **Purpose** |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Daily Funding Success Rate** | The percentage of orders that reach a **`complete`** status by their **`funds to arrive date`**. | **\> 99.9%** | **Daily (EOD)** | 99.8% | 🔴 Breached | Measures the real-time health of mission-critical operations. A failure here is a high-severity incident. |
| **Overall Timeliness** | The **median time** in minutes from an order's **`created`** status to its **`complete`** status. | **\< 90 minutes** | **Daily (EOD)** | 85 minutes | 🟢 OK | Measures the end-to-end customer experience in terms of speed for all orders funded today. |

### Business Impact SLOs

| **Metric Name** | **Service Level Indicator (SLI)** | **Service Level Objective (SLO)** | **Time Component** | **Current Value** | **Status** | **Purpose** | **Impact in a Major Incident** |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Financial Impact** | The **sum of wire amounts** for orders that have not yet reached the `complete` status by their **`funds to arrive date`**. | **$0** at EOD | **Daily (EOD)** | $5.1 million | 🔴 Breached | Measures the direct financial and reputational cost of failure. This is an explicit sum of money at risk. | A breach of the SLO impacts **100 orders**, representing **$5.1 million** in delayed funding. |
| **Customer Impact** | The number of orders that have not yet reached the `complete` status by their **`funds to arrive date`**. | **0 orders** at EOD | **Daily (EOD)** | 100 orders | 🔴 Breached | Measures the direct impact on customers. This quantifies the number of customers whose loans were not funded on time. | A breach of the SLO affects **100 customers**, leading to an increase in support calls and complaints. |

### Technical Health SLOs

| **Metric Name** | **Service Level Indicator (SLI)** | **Service Level Objective (SLO)** | **Time Component** | **Current Value** | **Status** | **Purpose** |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Submitted to Pending Latency** | The **median time** in minutes for an order to transition from **`submitted`** to **`pending`**. | **\< 5 minutes** | **Daily (EOD)** | 7 minutes | 🔴 Breached | Measures the efficiency of a critical process step for today's orders. |
| **Pending to Complete Latency** | The **median time** in minutes for an order to transition from **`pending`** to **`complete`**. | **\< 5 minutes** | **Daily (EOD)** | 15 minutes | 🔴 Breached | Monitors the final stages of the process for today's orders. It's an **urgent leading indicator** signaling that a deadline is at risk. |

## 2\. Instrumentation: SQL Queries for Metrics 💻

The following SQL queries are designed for an Oracle database with an `order_status_history` table (and `treasury_orders` for `wire_amount`) and serve as the data source for each SLO's **Service Level Indicator (SLI)**. Each query is designed to be executed at the End of Day (EOD) or at intervals specified by its "Time Component."

### Business Health Queries

**Daily Funding Success Rate**

```sql
SELECT
    CAST(SUM(CASE
        WHEN status = 'complete' AND status_change_date <= funds_to_arrive_date THEN 1
        ELSE 0
    END) AS REAL) / COUNT(*) AS current_sli_funding_success
FROM
    treasury_orders
WHERE
    funds_to_arrive_date = TRUNC(SYSDATE);
```

**Overall Timeliness**

```sql
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (T2.timestamp - T1.timestamp) * 24 * 60) AS median_overall_timeliness_minutes
FROM
    order_status_history T1
JOIN
    order_status_history T2 ON T1.order_id = T2.order_id
WHERE
    T1.status = 'created'
    AND T2.status = 'complete'
    AND TRUNC(T2.timestamp) = TRUNC(SYSDATE)
    AND NOT EXISTS (
        SELECT 1
        FROM order_status_history T3
        WHERE T3.order_id = T1.order_id
        AND T3.timestamp > T1.timestamp AND T3.timestamp < T2.timestamp
    );
```

### Business Impact Queries

**Financial Impact**

```sql
SELECT
    SUM(T1.wire_amount) AS current_sli_financial_impact
FROM
    treasury_orders T1
WHERE
    T1.status <> 'complete' AND T1.funds_to_arrive_date = TRUNC(SYSDATE);
```

**Customer Impact**

```sql
SELECT
    COUNT(T1.order_id) AS current_sli_customer_impact
FROM
    treasury_orders T1
WHERE
    T1.status <> 'complete' AND T1.funds_to_arrive_date = TRUNC(SYSDATE);
```

### Technical Health Queries

**Submitted to Pending Latency**

```sql
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (T2.timestamp - T1.timestamp) * 24 * 60) AS median_submitted_to_pending_minutes
FROM
    order_status_history T1
JOIN
    order_status_history T2 ON T1.order_id = T2.order_id
WHERE
    T1.status = 'submitted'
    AND T2.status = 'pending'
    AND TRUNC(T2.timestamp) = TRUNC(SYSDATE)
    AND NOT EXISTS (
        SELECT 1
        FROM order_status_history T3
        WHERE T3.order_id = T1.order_id
        AND T3.timestamp > T1.timestamp AND T3.timestamp < T2.timestamp
    );
```

**Pending to Complete Latency**

```sql
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (T2.timestamp - T1.timestamp) * 24 * 60) AS median_pending_to_complete_minutes
FROM
    order_status_history T1
JOIN
    order_status_history T2 ON T1.order_id = T2.order_id
WHERE
    T1.status = 'pending'
    AND T2.status = 'complete'
    AND TRUNC(T2.timestamp) = TRUNC(SYSDATE)
    AND NOT EXISTS (
        SELECT 1
        FROM order_status_history T3
        WHERE T3.order_id = T1.order_id
        AND T3.timestamp > T1.timestamp AND T3.timestamp < T2.timestamp
    );
```

## 3\. Practical Implementation: Building Dashboards and Alerts 🛠️

To implement this blueprint, integrate these components into your monitoring solution (e.g., Grafana).

1.  **Dashboard Creation**: Build a new dashboard.
2.  **Panel Configuration**: For each metric, create a panel using its corresponding SQL query as the data source. Utilize **Stat** or **Gauge** visualizations to display the `Current Value` against the `SLO`.
3.  **Alerting**: Configure alerts for each panel. Alerts should trigger when the `Current Value` violates the defined `SLO` threshold, escalating appropriately based on the SLO's tier and urgency.

This integrated approach ensures that service performance is continuously measured, communicated, and addressed based on its actual impact on the business.

```
```
