from airflow import DAG
from airflow.operators.bash_operator import BashOperator


def dag_builder(dag, dag_name, tasks):
    task_callables = {}
    for task_name, dependencies in tasks.items():
        task = BashOperator(
            task_id=task_name,
            bash_command='python /home/airflow/tasks/{}/{}.py'.format(dag_name, task_name),
            dag=dag)
        task_callables[task_name] = task

    for task_name, dependencies in tasks.items():
        if None not in dependencies:
            for dep in dependencies:
                task_callables[task_name].set_upstream(task_callables[dep])
