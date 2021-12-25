FROM python:3.9

WORKDIR /airflow
RUN useradd -s /bin/bash -d /airflow airflow
RUN chown -R airflow: /airflow

ENV AIRFLOW_HOME=/airflow

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY airflow.cfg .
