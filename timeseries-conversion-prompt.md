# LLM Prompt for Fed Wire SLI Timeseries Query (Grafana POC)

  ## Context
  I need to create a Fed Wire SLI query for proof-of-concept visualization in enterprise Grafana. This query will transform wire
   transfer status lifecycle data into timeseries metrics for immediate dashboard deployment.

  **Objective:** Generate timeseries data showing Fed Wire processing performance with complex business logic embedded.

  ## Input Data Structure
  My query produces rows with these key elements:
  - Order identifier
  - Status value (inprogress, submitted, pending, complete)
  - Timestamp of the status update
  - `funds_to_arrive_date` field for Fed Wire business day calculations
  - [I will provide my actual query output schema after this prompt]

  ## Critical Fed Wire Business Logic

  ### Status Lifecycle
  **Progression:** inprogress → submitted → pending → complete

  ### Fed Wire System Rules
  - **Fed Wire opens:** 11:30 AM UTC each business day
  - **Processing day:** Determined by `funds_to_arrive_date`
  - **Pre-processing:** Orders can reach 'pending' before Fed Wire opens

  ### Effective Pending Start Time
  Use the **most recent** time between:
  1. Actual pending status timestamp
  2. Fed Wire system start time (funds_to_arrive_date + 11:30 AM UTC)

  ```sql
  -- Core logic pattern:
  GREATEST(
    pending_start_timestamp,
    funds_to_arrive_date + TIME '11:30:00' AT TIME ZONE 'UTC'
  ) as effective_pending_start
  ```

  ### Duration Calculation
  ```sql
  -- For in-flight orders, use current time
  COALESCE(complete_timestamp, NOW()) - effective_pending_start
  ```

  ### Success Criteria
  - **Good:** Effective pending duration < 120 minutes
  - **Total:** All orders that reached 'pending' status

  ## Required SQL Query Structure

  ### Step 1: Pivot Status Lifecycle
  Transform status rows into pending start/end timestamps per order:
  - Extract timestamp where status = 'pending' 
  - Extract timestamp where status = 'complete' (NULL if missing)

  ### Step 2: Apply Fed Wire Logic
  - Calculate effective_pending_start using GREATEST()
  - Calculate duration using COALESCE() for in-flight orders
  - Determine good/bad based on 120-minute threshold

  ### Step 3: Create Timeseries Aggregation
  - Use `DATE_TRUNC('hour', effective_pending_start)` for bucketing
  - Group by hourly buckets
  - Calculate success metrics per bucket

  ## Required Output Columns (Grafana-Ready)
  | Column | Purpose | Format |
  |--------|---------|--------|
  | `timestamp` | X-axis for time charts | YYYY-MM-DD HH:00:00 |
  | `success_rate` | Primary SLI metric | Decimal (91.30) |
  | `total_orders` | Volume context | Integer |
  | `good_orders` | Success count | Integer |
  | `avg_duration_minutes` | Operational trending | Decimal (95.4) |

  ## SQL Requirements
  1. **Handle NULL complete status** - Use NOW() for in-flight orders
  2. **Exclude orders without 'pending'** - Only measure orders that entered pending
  3. **Time zone consistency** - All timestamps in UTC
  4. **Hourly bucketing** - Use DATE_TRUNC('hour', ...)
  5. **Precision** - success_rate to 2 decimals, duration to 1 decimal
  6. **Order results** - BY timestamp ASC

  ## Sample Expected Output
  ```
  timestamp           | success_rate | total_orders | good_orders | avg_duration_minutes
  2024-09-05 09:00:00 | 91.30       | 23          | 21          | 95.4
  2024-09-05 10:00:00 | 93.55       | 31          | 29          | 87.2
  2024-09-05 11:00:00 | 96.43       | 28          | 27          | 76.8
  ```

  ## Your Task
  Generate a complete SQL query that:
  1. Pivots my status lifecycle data into pending start/end timestamps
  2. Applies all Fed Wire business logic (GREATEST, COALESCE, 11:30 AM UTC)
  3. Creates hourly timeseries output ready for Grafana visualization
  4. Handles all edge cases (in-flight orders, pre-processed orders, same-day orders)

  **My actual query output schema:**

  **[PASTE YOUR ACTUAL QUERY OUTPUT SCHEMA AND COLUMN NAMES HERE]**
