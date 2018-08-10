FROM openjdk:8-alpine

# Default Args
ARG APACHE_MIRROR_SERVER=http://www-us.apache.org
ARG SPARK_VERSION=2.3.1
ARG HADOOP_VERSION=2.7

RUN apk update && \
    apk add bash curl git python3 wget vim openssl ca-certificates && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /opt \
    && wget -q -O - ${APACHE_MIRROR_SERVER}/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz | tar -xzf - -C /opt \
    && mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark

ENV SPARK_HOME /opt/spark
ENV PATH=$PATH:${SPARK_HOME}/sbin:${SPARK_HOME}/bin

WORKDIR $SPARK_HOME
