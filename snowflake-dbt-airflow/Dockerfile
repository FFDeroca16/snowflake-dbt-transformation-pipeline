FROM apache/airflow:3.3.0


RUN python -m venv /home/airflow/dbt_venv && \
    /home/airflow/dbt_venv/bin/pip install --no-cache-dir dbt-core==1.12.2 dbt-snowflake==1.12.0