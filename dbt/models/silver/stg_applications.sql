{{ config(materialized='view') }}
SELECT
  PAYLOAD:application_id::VARCHAR AS application_id,
  PAYLOAD:applicant_id::VARCHAR AS applicant_id,
  PAYLOAD:applicant_name::VARCHAR AS applicant_name,
  TRY_TO_DECIMAL(PAYLOAD:loan_amount::VARCHAR, 12, 2) AS loan_amount,
  TRY_TO_DECIMAL(PAYLOAD:property_value::VARCHAR, 12, 2) AS property_value,
  TRY_TO_DECIMAL(PAYLOAD:monthly_gross_income::VARCHAR, 12, 2) AS monthly_gross_income,
  TRY_TO_TIMESTAMP_TZ(PAYLOAD:application_ts::VARCHAR) AS application_ts,
  SOURCE_FILE AS source_file,
  INGESTED_AT AS ingested_at,
  PAYLOAD AS source_payload
FROM {{ source('bronze', 'raw_applications') }}
