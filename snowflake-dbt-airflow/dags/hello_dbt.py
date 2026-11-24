from airflow.sdk import DAG
from airflow.providers.standard.operators.bash import BashOperator
from datetime import datetime

with DAG(
    dag_id="hello_dbt",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False
):

    run_models = BashOperator(
        task_id="run_models",
        bash_command="echo 'running dbt models'"
    )

    run_tests = BashOperator(
        task_id="run_tests",
        bash_command="echo 'runnning tests'"
    )

    run_models >> run_tests