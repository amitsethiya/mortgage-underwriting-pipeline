"""Airflow DAG template; replace commands with deployment-specific operators."""
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

DEFAULT_ARGS = {"owner": "data-engineering", "retries": 2, "retry_delay": timedelta(minutes=5)}
with DAG(
    dag_id="mortgage_underwriting_pipeline",
    description="Land both sources before dbt Silver and Gold models",
    start_date=datetime(2026, 1, 1), schedule=None, catchup=False,
    default_args=DEFAULT_ARGS, tags=["snowflake", "dbt", "mortgage"],
) as dag:
    # These commands are intentionally placeholders. Configure environment/credentials securely.
    ingest_applications = BashOperator(task_id="ingest_applications", bash_command="echo 'Run approved application JSON ingestion job'")
    ingest_credit = BashOperator(task_id="ingest_credit_bureau", bash_command="echo 'Run approved credit CSV ingestion job'")
    dbt_silver = BashOperator(task_id="dbt_silver", bash_command="cd /opt/airflow/dbt && dbt run --select stg_applications stg_credit_bureau int_application_credit silver_applications")
    dbt_gold = BashOperator(task_id="dbt_gold", bash_command="cd /opt/airflow/dbt && dbt run --select underwriting_decisions hmda_reporting_summary")
    dbt_tests = BashOperator(task_id="dbt_tests", bash_command="cd /opt/airflow/dbt && dbt test")
    [ingest_applications, ingest_credit] >> dbt_silver >> dbt_gold >> dbt_tests
