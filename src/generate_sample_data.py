"""Generate synthetic mortgage application JSON and credit bureau CSV inputs."""
import csv, json
from pathlib import Path

# Create output folder
OUT = Path("data/raw")
OUT.mkdir(parents=True, exist_ok=True)

# Mortgage application data
applications = [
    {"application_id":"APP1001","applicant_id":"C1001","applicant_name":"Alex Example","loan_amount":380000,"property_value":400000,"monthly_gross_income":12000,"application_ts":"2026-10-01T10:00:00Z"},
    {"application_id":"APP1002","applicant_id":"C1002","applicant_name":"Jordan Sample","loan_amount":390000,"property_value":400000,"monthly_gross_income":9000,"application_ts":"2026-10-01T10:05:00Z"},
    {"application_id":"APP1003","applicant_id":"C1003","applicant_name":"Taylor Demo","loan_amount":250000,"property_value":350000,"monthly_gross_income":8000,"application_ts":"2026-10-01T10:10:00Z"},
    {"application_id":"APP1004","applicant_id":"C1004","applicant_name":"Casey Test","loan_amount":200000,"property_value":300000,"monthly_gross_income":7000,"application_ts":"2026-10-01T10:15:00Z"},
    {"application_id":"APP1005","applicant_id":"C1005","applicant_name":"Morgan Fiction","loan_amount":180000,"property_value":None,"monthly_gross_income":6500,"application_ts":"2026-10-01T10:20:00Z"},
]

# Credit bureau data
credits = [
    {"applicant_id":"C1001","ssn":"900-00-1001","fico_score":720,"monthly_debt":2500},
    {"applicant_id":"C1002","ssn":"900-00-1002","fico_score":650,"monthly_debt":3400},
    {"applicant_id":"C1003","ssn":"900-00-1003","fico_score":600,"monthly_debt":1000},
    {"applicant_id":"C1004","ssn":"900-00-1004","fico_score":680,"monthly_debt":3100},
    {"applicant_id":"C1005","ssn":"900-00-1005","fico_score":710,"monthly_debt":900},
]

# Write JSON file
with open(out / "mortgage_applications.json", "w") as f:
    json.dump(applications, f, indent=2)

# Write CSV file
with open(out / "credit_bureau.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=credits[0].keys())
    writer.writeheader()
    writer.writerows(credits)

print("Files created successfully!")
