# Dockerized Airflow

This is a dockerized implementation of the open-source job scheduler: [Airflow](https://airflow.apache.org). This uses the Celery message broker with Redis as a backend to support running multiple tasks in parallel.

### Requirements

    • Docker

### Build Local Copy

    • docker-compose build
    • docker-compose up -d --scale worker=2

This builds the postgres, redis, webserver, scheduler, flower, and 2 worker containers locally in the background.

    • docker-compose down (to shutdown)

### Adding new DAGs

Create a new python file in the dags/ directory, making sure that all of the underlying tasks have their upstream dependencies designated correctly, a unique name has been assigned, and that other configuration arguments are set as desired.
