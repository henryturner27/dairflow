FROM python:3.9

RUN mkdir /airflow
WORKDIR /airflow

ENV AIRFLOW_HOME=/airflow

COPY entrypoint.sh .
COPY airflow.cfg .
COPY dags/ dags/
COPY requirements.txt .

RUN pip install -r requirements.txt

ENTRYPOINT ["sh", "entrypoint.sh"]
CMD ["webserver"]
