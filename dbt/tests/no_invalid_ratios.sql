SELECT application_id
FROM {{ ref('underwriting_decisions') }}
WHERE ltv_pct IS NULL OR dti_pct IS NULL
