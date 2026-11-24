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