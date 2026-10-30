{{ config(materialized='view') }}
SELECT APPLICANT_ID::VARCHAR AS applicant_id, SSN::VARCHAR AS ssn,
       TRY_TO_NUMBER(FICO_SCORE) AS fico_score,
       TRY_TO_DECIMAL(MONTHLY_DEBT, 12, 2) AS monthly_debt,
       SOURCE_FILE AS source_file, INGESTED_AT AS ingested_at
FROM {{ source('bronze', 'raw_credit_bureau') }}
