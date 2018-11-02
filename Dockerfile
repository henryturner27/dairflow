FROM ubuntu:18.04

ENV PATH=/opt/miniconda/bin/:$PATH
ENV AIRFLOW_HOME=/home/airflow
ENV SLUGIFY_USES_TEXT_UNIDECODE=yes
ENV PYTHONPATH=/opt/airflow_utils

COPY pip-requirements.txt /opt/
COPY conda-requirements.txt /opt/

RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y gcc
RUN rm -rf /var/lib/apt/lists/*
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /opt/miniconda.sh
RUN bash /opt/miniconda.sh -b -p /opt/miniconda
RUN conda env create -n airflow_env -f=/opt/conda-requirements.txt
RUN /bin/bash -c "source activate airflow_env; pip install -r /opt/pip-requirements.txt"
RUN rm /opt/miniconda.sh
RUN rm /opt/pip-requirements.txt
RUN rm /opt/conda-requirements.txt

RUN useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow
RUN chown -R airflow: ${AIRFLOW_HOME}
USER airflow
RUN echo 'PYTHONPATH="/opt/airflow_utils/:${PYTHONPATH}"' >> /home/airflow/.bashrc
RUN echo 'source activate airflow_env' >> /home/airflow/.bashrc

COPY airflow.cfg /home/airflow/
COPY entrypoint.sh .entrypoint.sh
COPY dags /home/airflow/dags
COPY tasks /home/airflow/tasks
COPY utils.py /opt/airflow_utils/

ENTRYPOINT ["sh", ".entrypoint.sh"]
CMD ["webserver"]
