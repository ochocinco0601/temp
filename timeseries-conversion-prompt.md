  # LLM Prompt for Wire Transfer SQL Timeseries Conversion

  ## Context
  I need to transform raw wire transfer status data into timeseries metrics for Business Observability System (BOS) monitoring.

  **Background:**
  - I have a table with wire transfer records containing timestamp pairs
  - Each row shows when a transfer entered 'pending' status and when it exited
  - Orders have a `funds_to_arrive_date` which determines Fed Wire processing schedule
  - **SUCCESS CRITERIA:** A transfer is "good" if effective pending duration < 120 minutes
  - **OBJECTIVE:** Create hourly timeseries data showing success rate and average duration

  ## Input Data Structure
  My table contains rows with these key elements:
  - A timestamp when the transfer entered 'pending' status
  - A timestamp when the transfer exited 'pending' status (can be NULL for in-flight orders)
  - A `funds_to_arrive_date` field
  - [I will provide my actual table schema after this prompt]

  ## Required Output Columns
  - `timestamp` (hourly buckets)
  - `total_orders` (count of transfers in that hour)
  - `good_orders` (count with effective pending duration < 120 minutes)
  - `success_rate` (good_orders/total_orders * 100)
  - `avg_duration_minutes` (average effective pending duration for that hour)

  ## Critical Business Logic
  **Fed Wire System:** Opens at 11:30 AM UTC each business day for processing that day's `funds_to_arrive_date` orders.

  **Effective Pending Start Time:** Use the **most recent** time between:
  1. Actual pending start timestamp
  2. Fed Wire system start time (funds_to_arrive_date + 11:30 AM UTC)

  ```sql
  -- Effective pending start calculation
  GREATEST(
    pending_start_timestamp,
    funds_to_arrive_date + TIME '11:30:00' AT TIME ZONE 'UTC'
  ) as effective_pending_start

  Requirements

  1. Use DATE_TRUNC('hour', ...) for hourly bucketing
  2. Calculate effective pending duration using the GREATEST logic above
  3. Duration calculation: COALESCE(end_timestamp, NOW()) - effective_pending_start
  4. Include both completed and in-flight transfers
  5. Order results by timestamp
  6. Round success_rate to 2 decimal places, duration to 1 decimal

  Sample Output Format

  | timestamp           | total_orders | good_orders | success_rate | avg_duration_minutes |
  |---------------------|--------------|-------------|--------------|----------------------|
  | 2024-01-15 09:00:00 | 23           | 21          | 91.30        | 95.4                 |
  | 2024-01-15 10:00:00 | 31           | 29          | 93.55        | 87.2                 |

  Your Task

  Please generate the SQL query using my actual table schema below:

  [PASTE YOUR ACTUAL TABLE SCHEMA AND COLUMN NAMES HERE]
