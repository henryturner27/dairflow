from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator


dag_name = 'test3'
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


def print_task(task_str: str, *args):
    print(task_str)


with DAG(dag_name, default_args=default_args, schedule_interval=None) as dag:
    task1 = PythonOperator(python_callable=print_task, task_id='task1', op_args=[
                           'this is task_1'], dag=dag)
    task2 = PythonOperator(python_callable=print_task, task_id='task2', op_args=[
                           'this is task_2'], dag=dag)
    task3 = PythonOperator(python_callable=print_task, task_id='task3', op_args=[
                           'this is task_3'], dag=dag)
    task4 = PythonOperator(python_callable=print_task, task_id='task4', op_args=[
                           'this is task_4'], dag=dag)
    task5 = PythonOperator(python_callable=print_task, task_id='task5', op_args=[
                           'this is task_5'], dag=dag)

    task1 >> [task2, task3, task4] >> task5
