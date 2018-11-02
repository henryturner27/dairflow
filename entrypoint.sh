: "${POSTGRES_HOST:="postgres"}"
: "${POSTGRES_PORT:="5432"}"
: "${POSTGRES_USER:="airflow"}"
: "${POSTGRES_PASSWORD:="example_pw"}"
: "${POSTGRES_DB:="airflow"}"

: "${REDIS_HOST:="redis"}"
: "${REDIS_PORT:="6379"}"
: "${REDIS_PASSWORD:=""}"

: "${AIRFLOW__CORE__EXECUTOR:=$EXECUTOR}"

export \
	AIRFLOW__CELERY__BROKER_URL \
	AIRFLOW__CELERY__RESULT_BACKEND \
	AIRFLOW__CORE__EXECUTOR \
	AIRFLOW__CORE__SQL_ALCHEMY_CONN \

if [ "$REDIS_PASSWORD" != "" ]; then
	REDIS_PREFIX=:"${REDIS_PASSWORD}@"
else
	REDIS_PREFIX=
fi

if [ "$AIRFLOW__CORE__EXECUTOR" != "SequentialExecutor" ]; then
	AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql+psycopg2://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB"
	AIRFLOW__CELERY__RESULT_BACKEND="db+postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB"
fi

if [ "$AIRFLOW__CORE__EXECUTOR" = "CeleryExecutor" ]; then
	AIRFLOW__CELERY__BROKER_URL="redis://$REDIS_PREFIX$REDIS_HOST:$REDIS_PORT/1"
fi


case "$1" in
	webserver-scheduler)
		exec /bin/bash -c "sleep 5; source activate airflow_env; airflow initdb; airflow webserver & airflow scheduler"
		;;
	webserver)
		exec /bin/bash -c "sleep 5; source activate airflow_env; airflow initdb; airflow webserver"
		;;
	scheduler)
		exec /bin/bash -c "sleep 5; source activate airflow_env; airflow scheduler"
		;;
	worker)
		exec /bin/bash -c "sleep 5; source activate airflow_env; airflow worker"
		;;
	flower)
		exec /bin/bash -c "sleep 5; source activate airflow_env; airflow flower"
		;;
	*)
	echo "$1 not recognized. please specify either webserver, scheduler, or worker."
esac