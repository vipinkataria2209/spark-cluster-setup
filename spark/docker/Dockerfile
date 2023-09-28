FROM openjdk:11.0.11-jre-slim-buster as base_image

# Add Dependencies for PySpark
RUN apt-get update && apt-get install -y curl vim wget software-properties-common ssh net-tools ca-certificates python3 python3-pip python3-numpy python3-matplotlib python3-scipy python3-pandas python3-simpy

RUN update-alternatives --install "/usr/bin/python" "python" "$(which python3)" 1

# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV SPARK_VERSION=${SPARK_VERSION:-3.4.1} HADOOP_VERSION=${HADOOP_VERSION:-3} PYTHONHASHSEED=${PYTHONHASHSEED:-1}
ENV SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
ENV HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}

# Download and uncompress spark from the apache archive
RUN wget --no-verbose -O apache-spark.tgz "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" \
&& mkdir -p ${SPARK_HOME} && mkdir -p ${HADOOP_HOME} \
&& tar -xf apache-spark.tgz -C ${SPARK_HOME} --strip-components=1 \
&& rm apache-spark.tgz


# Apache spark environment

WORKDIR "${SPARK_HOME}"

FROM base_image as apache-spark

# Install python deps
COPY requirements.txt .
RUN pip3 install -r requirements.txt

ENV PATH="/opt/spark/sbin:/opt/spark/bin:${PATH}"
ENV SPARK_MASTER_PORT=${SPARK_MASTER_PORT:-7077} \
SPARK_MASTER_WEBUI_PORT=${SPARK_MASTER_WEBUI_PORT:-8080} \
SPARK_LOG_DIR=${SPARK_LOG_DIR:-/opt/spark/logs} \
SPARK_MASTER_LOG=${SPARK_MASTER_LOG:-/opt/spark/logs/spark-master.out} \
SPARK_WORKER_LOG=${SPARK_WORKER_LOG:-/opt/spark/logs/spark-worker.out} \
SPARK_WORKER_WEBUI_PORT=${SPARK_WORKER_WEBUI_PORT:-8080} \
SPARK_WORKER_PORT=${SPARK_WORKER_PORT:-7000} \
SPARK_MASTER=${SPARK_MASTER:-spark://spark-master:7077} \
SPARK_WORKLOAD=${SPARK_WORKLOAD:-master}

EXPOSE 8080 7077 6066

RUN mkdir -p $SPARK_LOG_DIR && \
touch $SPARK_MASTER_LOG && \
touch $SPARK_WORKER_LOG && \
ln -sf /dev/stdout $SPARK_MASTER_LOG && \
ln -sf /dev/stdout $SPARK_WORKER_LOG

ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
COPY start-spark.sh .
#
ENTRYPOINT ["./entrypoint.sh"]