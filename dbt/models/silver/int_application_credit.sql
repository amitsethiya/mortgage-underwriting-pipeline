{{ config(materialized='view') }}
WITH joined AS (
  SELECT a.*, c.ssn, c.fico_score, c.monthly_debt,
         CASE
           WHEN a.application_id IS NULL THEN 'MISSING_APPLICATION_ID'
           WHEN a.applicant_id IS NULL THEN 'MISSING_APPLICANT_ID'
           WHEN a.loan_amount IS NULL OR a.loan_amount <= 0 THEN 'INVALID_LOAN_AMOUNT'
           WHEN a.property_value IS NULL OR a.property_value <= 0 THEN 'MISSING_OR_INVALID_PROPERTY_VALUE'
           WHEN a.monthly_gross_income IS NULL OR a.monthly_gross_income <= 0 THEN 'MISSING_OR_INVALID_GROSS_INCOME'
           WHEN c.applicant_id IS NULL THEN 'MISSING_CREDIT_RECORD'
           WHEN c.fico_score IS NULL THEN 'MISSING_CREDIT_SCORE'
           WHEN c.monthly_debt IS NULL OR c.monthly_debt < 0 THEN 'MISSING_OR_INVALID_MONTHLY_DEBT'
           ELSE NULL
         END AS technical_rejection_reason
  FROM {{ ref('stg_applications') }} a
  LEFT JOIN {{ ref('stg_credit_bureau') }} c ON a.applicant_id = c.applicant_id
)
SELECT * FROM joined
