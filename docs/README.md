# Mortgage Application & Underwriting Pipeline

Reference implementation for the supplied case study using Snowflake, dbt, Python and Airflow infrastructure examples.

## Architecture

```mermaid
flowchart LR
  A[Mortgage JSON] --> B[Python / Snowflake stage]
  C[Credit bureau CSV] --> B
  B --> D[BRONZE raw tables]
  D --> E[dbt Silver: join + validation]
  E --> F[Technical rejections]
  E --> G[dbt Gold: underwriting rules]
  G --> H[Compliance decisions / BI]
  I[Airflow] -. orchestrates .-> B
  I -. orchestrates .-> E
  I -. orchestrates .-> G
```

## Decision rules
- `LTV_PCT = loan_amount / property_value * 100`; decline when `> 95`.
- `DTI_PCT = monthly_debt / monthly_gross_income * 100`; decline when `> 43`.