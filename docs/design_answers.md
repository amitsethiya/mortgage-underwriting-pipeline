# Design answers

## a. How would you handle a scenario where credit bureau API is delayed?
I would use Airflow to wait for both data sources, will set alert on delays, keep incomplete applications pending, and reprocess them safely when the credit data arrives.
I can set up delay alerts in Airflow using a sensor timeout and an email or Slack notification.

## b. Audit profile from 30 days ago using Time Travel feature?
If the required Snowflake Time Travel retention window covers the approval timestamp, query the relevant table `AT (TIMESTAMP => '<approval timestamp>'::TIMESTAMP_TZ)` or use `BEFORE (STATEMENT => '<query id>')` for the exact statement boundary. 

## c. How would your design handle an end of quarter rush where application submission spike by 1,000x over a weekend?
I would use S3 and Snowpipe for scalable ingestion, process data in batches, and scale up Snowflake warehouses during peak loads.