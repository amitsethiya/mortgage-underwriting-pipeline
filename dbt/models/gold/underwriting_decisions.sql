{{ config(materialized='table') }}
WITH evaluated AS (
  SELECT application_id, applicant_id, loan_amount, property_value,
         monthly_gross_income, fico_score, monthly_debt, application_ts,
         ROUND(loan_amount / NULLIF(property_value, 0) * 100, 2) AS ltv_pct,
         ROUND(monthly_debt / NULLIF(monthly_gross_income, 0) * 100, 2) AS dti_pct,
         ARRAY_CONSTRUCT_COMPACT(
           IFF(fico_score < 620, 'DECLINED_FICO_BELOW_620', NULL),
           IFF(loan_amount / NULLIF(property_value, 0) * 100 > 95, 'DECLINED_LTV_EXCEEDED', NULL),
           IFF(monthly_debt / NULLIF(monthly_gross_income, 0) * 100 > 43, 'DECLINED_DTI_EXCEEDED', NULL)
         ) AS decline_reasons
  FROM {{ ref('silver_applications') }}
), final AS (
  SELECT *,
    CASE WHEN ARRAY_SIZE(decline_reasons) > 0 THEN 'DECLINED'
         WHEN fico_score BETWEEN 620 AND 660 AND dti_pct BETWEEN 36 AND 43 THEN 'REQUIRES_CO_SIGNER'
         ELSE 'APPROVED' END AS decision_status,
    CASE WHEN ARRAY_SIZE(decline_reasons) > 0 THEN ARRAY_TO_STRING(decline_reasons, '|')
         WHEN fico_score BETWEEN 620 AND 660 AND dti_pct BETWEEN 36 AND 43 THEN 'REQUIRES_CO_SIGNER'
         ELSE 'APPROVED' END AS reason_codes
  FROM evaluated
)
SELECT application_id, applicant_id, loan_amount, property_value, monthly_gross_income,
       fico_score, monthly_debt, ltv_pct, dti_pct, decision_status, reason_codes,
       application_ts, CURRENT_TIMESTAMP() AS decision_ts
FROM final
