{{ config(materialized='table', schema='audit') }}
SELECT application_id, applicant_id, technical_rejection_reason AS rejection_reason,
       source_payload, source_file, ingested_at, CURRENT_TIMESTAMP() AS rejected_at
FROM {{ ref('int_application_credit') }}
WHERE technical_rejection_reason IS NOT NULL
