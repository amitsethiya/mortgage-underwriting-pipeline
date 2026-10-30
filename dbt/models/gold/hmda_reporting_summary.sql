{{ config(materialized='table') }}
SELECT decision_status, reason_codes, COUNT(*) AS application_count,
       SUM(loan_amount) AS total_loan_amount
FROM {{ ref('underwriting_decisions') }}
GROUP BY decision_status, reason_codes
