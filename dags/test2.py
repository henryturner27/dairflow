from airflow import DAG
from datetime import datetime, timedelta
from utils import dag_builder


dag_name = 'test2'
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2018, 1, 1),
    'email': ['airflow@example.com'],
    'email_on_failure': True,
    'email_on_retry': True,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2016, 1, 1),
}

# add the task to this dict, with a list of immediately upstream dependencies to add to the DAG
dag_structure = {
    'task_1': [None],
    'task_2': ['task_1'],
    'task_3': ['task_2'],
    'task_4': ['task_2'],
    'task_5': ['task_3', 'task_4'],
}

dag = DAG(dag_name, default_args=default_args, schedule_interval=None)

dag_builder(dag_name=dag_name, dag=dag, tasks=dag_structure)
