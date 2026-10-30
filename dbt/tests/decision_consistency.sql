SELECT application_id
FROM {{ ref('underwriting_decisions') }}
WHERE (decision_status = 'DECLINED' AND reason_codes = 'APPROVED')
   OR (decision_status = 'APPROVED' AND reason_codes <> 'APPROVED')
