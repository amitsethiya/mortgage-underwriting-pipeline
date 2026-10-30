{{ config(materialized='table') }}
SELECT application_id, applicant_id,
       -- Use Snowflake masking policy / governed role access for raw PII. This view omits SSN by default.
       applicant_name, loan_amount, property_value, monthly_gross_income,
       application_ts, fico_score, monthly_debt,
       CASE WHEN ssn IS NULL THEN NULL ELSE 'XXX-XX-XXXX' END AS ssn_masked,
       technical_rejection_reason, source_file, ingested_at
FROM {{ ref('int_application_credit') }}
WHERE technical_rejection_reason IS NULL
