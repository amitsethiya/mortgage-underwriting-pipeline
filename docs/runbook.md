# Runbook

## Local generation
`python src/generate_sample_data.py` writes synthetic JSON and CSV samples to `data/raw/`.

## Load to Snowflake (outline)
1. Execute `sql/bootstrap.sql` with an appropriately privileged role.
2. Upload `data/raw/mortgage_applications.json` and `data/raw/credit_bureau.csv` to `@MORTGAGE_DB.BRONZE.MORTGAGE_STAGE` using SnowSQL or Snowsight.
3. Load JSON with `COPY INTO MORTGAGE_DB.BRONZE.RAW_APPLICATIONS (PAYLOAD, SOURCE_FILE) FROM (SELECT $1, METADATA$FILENAME FROM @MORTGAGE_DB.BRONZE.MORTGAGE_STAGE/mortgage_applications.json) FILE_FORMAT=(FORMAT_NAME='MORTGAGE_DB.BRONZE.JSON_FF');`
4. Load CSV with a matching staged path and `FILE_FORMAT=(FORMAT_NAME='MORTGAGE_DB.BRONZE.CSV_FF')`, mapping columns to the raw credit table and setting `SOURCE_FILE=METADATA$FILENAME`.
5. Set up `~/.dbt/profiles.yml` for account, user, role, warehouse, database `MORTGAGE_DB`, schema `DBT_DEV`, and authenticator/secret configuration appropriate for your organization. Never commit profiles or secrets.
6. From `dbt/`, run `dbt debug`, `dbt run`, and `dbt test`. The `technical_rejections` model writes failed validation rows to the audit schema.