FROM java:openjdk-8-jdk
MAINTAINER Dalitso Banda <dalitsohb@gmail.com>

ENV LIVY_VERSION="git_master"
ENV LIVY_COMMIT="02550f7919b7348b6a7270cf806e031670037b2f"
ENV LOG_TAG="[LIVY_${LIVY_VERSION}]:" \
    LIVY_HOME="/livy" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN echo "$LOG_TAG Install essentials" && \
    apt-get -y update && \
    apt-get install -y locales && \
    locale-gen $LANG && \
    apt-get install -y git wget grep curl sed && \
    apt-get install -y python-setuptools && \
    apt-get autoclean &&  apt-get autoremove && \
    echo "$LOG_TAG Install python dependencies" && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py && \
    apt-get install -y python-dev libpython3-dev build-essential pkg-config gfortran && \
    pip install -U pip setuptools wheel && \
    echo "$LOG_TAG Getting maven" && \
    wget http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    tar -zxf apache-maven-3.3.9-bin.tar.gz -C /usr/local/ && \
    ln -s /usr/local/apache-maven-3.3.9/bin/mvn /usr/local/bin/mvn && \
    echo "$LOG_TAG Download and build Livy source" && \
    git clone https://github.com/apache/incubator-livy.git ${LIVY_HOME}_src && \
    cd ${LIVY_HOME}_src  && \
    git checkout ${LIVY_COMMIT} && \
    mvn package -DskipTests && \
    ls ${LIVY_HOME}_src && \
    echo "$LOG_TAG Cleanup" && \
    apt-get purge -y --auto-remove build-essential pkg-config gfortran libpython3-dev  && \
    apt-get autoremove && \
    apt-get autoclean && \
    apt-get clean && \
    rm -rf /root/.ivy2 && \
    rm -rf /root/.npm && \
    rm -rf /root/.m2 && \
    rm -rf /root/.cache && \
    rm -rf /tmp/*

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

RUN echo "$LOG_TAG building hadoop" && \
    apt-get update && \
    apt-get install -y make autoconf automake libtool g++ unzip && \
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
    rm -rf /root/.ivy2 && \
    rm -rf /root/.m2 && \
    export HADOOP_HOME=/opt/hadoop && \
    echo "\nexport HADOOP_CLASSPATH=/opt/hadoop/share/hadoop/tools/lib/*" >> /opt/hadoop/etc/hadoop/hadoop-env.sh && \
    echo Hadoop ${HADOOP_VERSION} installed in /opt/hadoop && \
    apt-get purge -y --auto-remove g++ make build-essential autoconf automake && \
    cd  / && rm -rf /hadoop_deps

RUN echo "\nSPARK_DIST_CLASSPATH=/jars:/jars/*:$(/opt/hadoop/bin/hadoop classpath)" >> /opt/spark/conf/spark-env.sh
ENV HADOOP_HOME=/opt/hadoop
ADD jars /jars

ENV HADOOP_CONF_DIR /opt/hadoop/conf
ENV CONF_DIR /livy/conf
ENV SPARK_CONF_DIR /opt/spark/conf

RUN mv ${LIVY_HOME}_src ${LIVY_HOME}
ADD livy.conf ${LIVY_HOME}/conf
EXPOSE 8998

WORKDIR ${LIVY_HOME}

RUN mkdir logs && export SPARK_HOME=/opt/spark && export HADOOP_HOME=/opt/hadoop && export SPARK_CONF_DIR=/opt/spark/conf

#hive needed for livy pyspark
RUN wget http://central.maven.org/maven2/org/apache/spark/spark-hive_2.11/2.4.0/spark-hive_2.11-2.4.0.jar -P /opt/spark/jars

CMD ["sh", "-c", "echo '\nspark.driver.host' $(hostname -i) >> /opt/spark/conf/spark-defaults.conf && echo '\nlivy.spark.master' $SPARK_MASTER >> /livy/conf/livy.conf && bin/livy-server"]
