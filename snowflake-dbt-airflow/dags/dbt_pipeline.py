from airflow.sdk import DAG, TaskGroup
from airflow.providers.standard.operators.bash import BashOperator
from datetime import datetime

DBT = "/home/airflow/dbt_venv/bin/dbt"
PROJECT_DIR = "/opt/airflow/dbt_project"

with DAG(
    dag_id="dbt_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False
):
    ## Staging Group
    with TaskGroup(group_id="staging_group"):
        staging_models = ["stg_customer", "stg_lineitem", "stg_nation", "stg_orders", "stg_part", "stg_partsupp", "stg_region" ,"stg_supplier"]
        run_tasks = [] 

        for model in staging_models:
            task = BashOperator(
                task_id=f"run_{model}",
                bash_command=f"{DBT} run --select {model} --project-dir {PROJECT_DIR} --target-path /tmp/target_{model}",
                pool="dbt_pool",
                retries=1
            )
            run_tasks.append(task)

        test_staging = BashOperator(
            task_id="test_staging",
            bash_command=f"{DBT} test --select path:models/stg --indirect-selection=buildable --project-dir {PROJECT_DIR} --target-path /tmp/target_test_staging",
            pool="dbt_pool"
        )

        run_tasks >> test_staging


    ## Intermediate Group
    with TaskGroup(group_id="intermediate_group"):
        int_models = ["int_orders_deduped", "int_lineitem_deduped", "int_customer_scd", "int_lineitem_calcs", "int_orders_agg_from_lineitem"]
        
        run_int_orders_deduped = BashOperator(
            task_id = f"run_{int_models[0]}",
            bash_command = f"{DBT} run --select {int_models[0]} --project-dir {PROJECT_DIR} --target-path /tmp/target_{int_models[0]}",
            pool="dbt_pool",
            retries=1
        )

        run_int_lineitem_deduped = BashOperator(
            task_id = f"run_{int_models[1]}",
            bash_command = f"{DBT} run --select {int_models[1]} --project-dir {PROJECT_DIR} --target-path /tmp/target_{int_models[1]}",
            pool="dbt_pool",
            retries=1
        )

        snapshot_int_customer_scd = BashOperator(
            task_id = f"snapshot_{int_models[2]}",
            bash_command = f"{DBT} snapshot --select {int_models[2]} --project-dir {PROJECT_DIR} --target-path /tmp/target_{int_models[2]}",
            pool="dbt_pool",
            retries=1
        )

        run_int_lineitem_calcs = BashOperator(
            task_id = f"run_{int_models[3]}",
            bash_command = f"{DBT} run --select {int_models[3]} --project-dir {PROJECT_DIR} --target-path /tmp/target_{int_models[3]}",
            pool="dbt_pool",
            retries=1
        )
        
        run_int_orders_agg_from_lineitem = BashOperator(
            task_id = f"run_{int_models[4]}",
            bash_command = f"{DBT} run --select {int_models[4]} --project-dir {PROJECT_DIR} --target-path /tmp/target_{int_models[4]}",
            pool="dbt_pool",
            retries=1
        )

        test_intermediate = BashOperator(
            task_id="test_intermediate",
            bash_command=f"{DBT} test --select path:models/int --indirect-selection=buildable --project-dir {PROJECT_DIR} --target-path /tmp/target_test_intermediate",
            pool="dbt_pool"
        )

        test_staging >> [run_int_orders_deduped, run_int_lineitem_deduped, snapshot_int_customer_scd] 
        run_int_lineitem_deduped >> run_int_lineitem_calcs >> run_int_orders_agg_from_lineitem
        [run_int_orders_deduped, snapshot_int_customer_scd, run_int_orders_agg_from_lineitem] >> test_intermediate

    ## Marts Group
    with TaskGroup(group_id="marts_group"):
        mart_models = ["dim_customer", "dim_date", "dim_geography", "dim_part", "dim_supplier", "fct_orders", "fct_lineitem"]

        run_dim_customer = BashOperator(
            task_id = f"run_{mart_models[0]}",
            bash_command = f"{DBT} run --select {mart_models[0]} --project-dir {PROJECT_DIR} --target-path /tmp/target_{mart_models[0]}",
            pool = "dbt_pool",
            retries = 1
        )

        run_dim_date = BashOperator(
            task_id = f"run_{mart_models[1]}",
            bash_command = f"{DBT} run --select {mart_models[1]} --project-dir {PROJECT_DIR} --target-path /tmp/target_{mart_models[1]}",
            pool = "dbt_pool",
            retries = 1
        )

        run_dim_geography = BashOperator(
            task_id = f"run_{mart_models[2]}",
            bash_command = f"{DBT} run --select {mart_models[2]} --project-dir {PROJECT_DIR} --target-path /tmp/target_{mart_models[2]}",
            pool = "dbt_pool",
            retries = 1
        )

        run_dim_part = BashOperator(
            task_id = f"run_{mart_models[3]}",
            bash_command = f"{DBT} run --select {mart_models[3]} --project-dir {PROJECT_DIR} --target-path /tmp/target_{mart_models[3]}",
            pool = "dbt_pool",
            retries = 1
        )

        run_dim_supplier = BashOperator(
            task_id = f"run_{mart_models[4]}",
            bash_command = f"{DBT} run --select {mart_models[4]} --project-dir {PROJECT_DIR} --target-path /tmp/target_{mart_models[4]}",
            pool = "dbt_pool",
            retries = 1
        )

        run_fct_orders = BashOperator(
            task_id = f"run_{mart_models[5]}",
            bash_command = f"{DBT} run --select {mart_models[5]} --project-dir {PROJECT_DIR} --target-path /tmp/target_{mart_models[5]}",
            pool = "dbt_pool",
            retries = 1
        )

        run_fct_lineitem = BashOperator(
            task_id = f"run_{mart_models[6]}",
            bash_command = f"{DBT} run --select {mart_models[6]} --project-dir {PROJECT_DIR} --target-path /tmp/target_{mart_models[6]}",
            pool = "dbt_pool",
            retries = 1
        )

        test_marts = BashOperator(
            task_id="test_marts",
            bash_command=f"{DBT} test --select path:models/marts --exclude fct_daily_sales_summary+ --indirect-selection=buildable --project-dir {PROJECT_DIR} --target-path /tmp/target_test_marts",
            pool="dbt_pool"
        )

        test_intermediate >> [run_dim_customer, run_dim_date, run_dim_geography, run_dim_part, run_dim_supplier] >> run_fct_orders >> run_fct_lineitem >> test_marts

    ## Summary Group
    with TaskGroup(group_id="summary_group"):
        run_fct_daily_sales_summary = BashOperator(
            task_id = "run_fct_daily_sales_summary",
            bash_command = f"{DBT} run --select fct_daily_sales_summary --project-dir {PROJECT_DIR} --target-path /tmp/target_fct_daily_sales_summary",
            pool = "dbt_pool",
            retries = 1
        )

        test_summary = BashOperator(
            task_id = "test_summary",
            bash_command=f"{DBT} test --select fct_daily_sales_summary --project-dir {PROJECT_DIR} --target-path /tmp/target_test_summary",
            pool = "dbt_pool"
        )

        test_marts >> run_fct_daily_sales_summary >> test_summary

## Every save: run this inside snowflake-dbt-airflow: docker compose exec airflow-scheduler airflow dags list-import-errors