# Dockerized Airflow
This is a dockerized implementation of the open-source job scheduler: [Airflow](https://airflow.apache.org). This uses the Celery message broker with Redis as a backend to support running multiple tasks in parallel, both in a distributed cluster and locally.

### Requirements
	• Docker

### Build Local Copy
	• docker-compose build
	• docker-compose up -d --scale worker=2

This builds the postgres, redis, webserver, scheduler, flower, and 2 worker containers locally in the background. Because there are so many containers running together on one host this is meant more for testing purposes than for a production implementation.

	• docker-compose down (to shutdown)

### Build Distributed Copy
	• docker swarm init (initialize docker swarm on leader node)
	• docker swarm join --token {token} (join workers to the docker swarm)
	• docker stack deploy --compose-file docker-compose.yaml airflow (build and run containers across the swarm)

The docker-compose.yaml file constrains airflow worker containers to being built on worker nodes. If no worker nodes have been added to the swarm, then no tasks will be executed. The default settings builds 4 worker containers distributed across all available worker nodes. To increase the number of airflow workers that get distributed you can run `docker service scale worker={num_workers}`

	• docker swarm leave (remove nodes from the swarm and shut it down)

### Adding tasks to DAGs
Create a new python file in the tasks/{relevant_DAG}/ directory that performs your desired task. Then, in the dags/{relevant_DAG}.py file, add your new task to the dag_structure dictionary, adding the tasks that are directly upstream to the associated list.

### Adding new DAGs
Create a new python file in the dags/ directory, making sure that all of the underlying tasks have their upstream dependencies designated correctly, a unique name has been assigned, and that other configuration arguments are set as desired. Add tasks to the DAG as outlined above.

### Email
Gmail smtp has been setup by default. Just input a working gmail address and pw (or auth token if you use 2fa) under the [smtp] header in airflow.cfg.

### Password Encryption
Connections stored in the postgres database container that airflow uses are encrypted using a fernet key that is set using the fernet_key variable in airflow.cfg. **YOU SHOULD CHANGE THE DEFAULT FERNET KEY BEFORE STORING ANY SENSITIVE CONNECTIONS IN THIS DATABASE.**