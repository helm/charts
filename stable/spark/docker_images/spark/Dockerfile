FROM java:openjdk-8-jdk

# Get Spark from US Apache mirror.
ENV APACHE_SPARK_VERSION 2.4.0
ENV HADOOP_VERSION 3.2.0
ENV HADOOP_GIT_COMMIT="release-3.2.0-RC1"

RUN echo "$LOG_TAG Getting SPARK_HOME" && \
    mkdir -p /opt && \
    cd /opt && \
    curl http://apache.claz.org/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-without-hadoop.tgz  | \
        tar -xz && \
    ln -s spark-${APACHE_SPARK_VERSION}-bin-without-hadoop spark && \
    echo Spark ${APACHE_SPARK_VERSION} installed in /opt/spark && \
    export SPARK_HOME=/opt/spark

RUN echo "$LOG_TAG Getting maven" && \
    wget http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    tar -zxf apache-maven-3.3.9-bin.tar.gz -C /usr/local/ && \
    ln -s /usr/local/apache-maven-3.3.9/bin/mvn /usr/local/bin/mvn 

RUN echo "$LOG_TAG building hadoop" && \
    echo "deb http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list && \
    apt-get update && \
    # build deps and deps for c bindings for cntk
    apt-get install -y g++ gcc-6 libstdc++-6-dev make build-essential && \
    apt-get install -y autoconf automake libtool curl make unzip && \
    cd  / && \
    git clone https://github.com/apache/hadoop.git  hadoop_src&& \
    mkdir /hadoop_deps && cd /hadoop_deps && \
    wget https://github.com/protocolbuffers/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.bz2 && \
    tar xvf protobuf-2.5.0.tar.bz2 && \
    cd protobuf-2.5.0 && \
    ./configure && make && make install && ldconfig && \
    cd /hadoop_src && git checkout ${HADOOP_GIT_COMMIT} && mvn package -Pdist -DskipTests -Dtar && \
    mv hadoop-dist/target/hadoop-${HADOOP_VERSION} /opt/hadoop && \
    rm -r /hadoop_src && \
    export HADOOP_HOME=/opt/hadoop && \
    echo "\nexport HADOOP_CLASSPATH=/opt/hadoop/share/hadoop/tools/lib/*" >> /opt/hadoop/etc/hadoop/hadoop-env.sh && \
    echo Hadoop ${HADOOP_VERSION} installed in /opt/hadoop && \
    apt-get purge -y --auto-remove g++ make build-essential autoconf automake && \
    cd  / && rm -rf /hadoop_deps

RUN echo "\nSPARK_DIST_CLASSPATH=/jars:/jars/*:$(/opt/hadoop/bin/hadoop classpath)" >> /opt/spark/conf/spark-env.sh
ENV HADOOP_HOME=/opt/hadoop
ADD jars /jars


# if numpy is installed on a driver it needs to be installed on all
# workers, so install it everywhere
RUN apt-get update && \
    apt-get install -y g++ python-dev build-essential python3-dev && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py && \
    pip install -U pip setuptools wheel && \
    pip install numpy && \
    pip install matplotlib && \
    pip install pandas && \
    apt-get purge -y --auto-remove python-dev build-essential python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD log4j.properties /opt/spark/conf/log4j.properties
ADD start-common.sh start-worker start-master /
ADD core-site.xml /opt/spark/conf/core-site.xml
ADD spark-defaults.conf /opt/spark/conf/spark-defaults.conf
ENV PATH $PATH:/opt/spark/bin
