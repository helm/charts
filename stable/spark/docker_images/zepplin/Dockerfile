FROM java:openjdk-8-jdk
MAINTAINER Dalitso Banda <dalitsohb@gmail.com>

# `Z_VERSION` will be updated by `dev/change_zeppelin_version.sh`
ENV Z_VERSION="git_master"
ENV Z_COMMIT="2ea945f548a4e41312026d5ee1070714c155a11e"
ENV LOG_TAG="[ZEPPELIN_${Z_VERSION}]:" \
    Z_HOME="/zeppelin" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN echo "$LOG_TAG Install essentials" && \
    apt-get -y update && \
    apt-get install -y locales && \
    locale-gen $LANG && \
    apt-get install -y git wget grep curl sed && \
    apt-get autoclean &&  apt-get autoremove

RUN echo "$LOG_TAG Getting maven" && \
    wget http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    tar -zxf apache-maven-3.3.9-bin.tar.gz -C /usr/local/ && \
    ln -s /usr/local/apache-maven-3.3.9/bin/mvn /usr/local/bin/mvn 

ADD patch_beam.patch /tmp/patch_beam.patch

RUN echo "$LOG_TAG install nodejs" && \
    curl -sL https://deb.nodesource.com/setup_11.x | bash - && apt-get install -y nodejs && \
    echo "$LOG_TAG Download Zeppelin source" && \
    git clone https://github.com/apache/zeppelin.git /zeppelin-${Z_VERSION}-bin-all && \
    mv /zeppelin-${Z_VERSION}-bin-all ${Z_HOME}_src && \
    mkdir ${Z_HOME}/notebook/mmlspark -p && \
    cd ${Z_HOME}_src && \
    git checkout ${Z_COMMIT} && \
    echo '{ "allow_root": true }' > /root/.bowerrc && \
    echo "$LOG_TAG building zeppelin" && \
    # setup \
    cd ${Z_HOME}_src && \
    git status  && \
    mv /tmp/patch_beam.patch . && \
    git apply --ignore-space-change --ignore-whitespace patch_beam.patch && \
     ./dev/change_scala_version.sh 2.11 && \
    # dendencies
    apt-get -y update && \
    apt-get install -y git libfontconfig r-base-dev r-cran-evaluate wget grep curl sed && \
    # setup zeppelin-web
    cd ${Z_HOME}_src/zeppelin-web && \
    rm package-lock.json && \
    mkdir -p /usr/local/lib/node_modules && \
    npm install -g @angular/cli && \
    npm install -g grunt-cli bower && \
    bower install && \
    cd ${Z_HOME}_src && \
    export MAVEN_OPTS="-Xmx2g -Xss128M -XX:MetaspaceSize=512M -XX:MaxMetaspaceSize=1024M -XX:+CMSClassUnloadingEnabled" && \
    mvn -e -B package -DskipTests -Pscala-2.11 -Pbuild-distr && \
    tar xvf ${Z_HOME}_src/zeppelin-distribution/target/zeppelin-0.9.0-SNAPSHOT.tar.gz && \
    rm -rf ${Z_HOME}/* && \
    mv zeppelin-0.9.0-SNAPSHOT ${Z_HOME}_dist && \
    mv ${Z_HOME}_dist/* ${Z_HOME} && \
    echo "$LOG_TAG Cleanup" && \
    apt-get remove --purge -y r-base-dev r-cran-evaluate libfontconfig && \
    npm uninstall -g @angular/cli grunt-cli bower && \
    apt-get autoclean &&  apt-get autoremove -y && \
    rm -rf ${Z_HOME}_dist && \
    rm -rf ${Z_HOME}_src && \
    rm -rf /root/.ivy2 && \
    rm -rf /root/.m2 && \
    rm -rf /root/.npm && \
    rm -rf /root/.cache && \
    rm -rf /tmp/*

RUN echo "$LOG_TAG install tini related packages" && \
    apt-get install -y wget curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb

RUN echo "$LOG_TAG installing python related packages" && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py && \
    apt-get install -y python-dev libpython3-dev build-essential pkg-config gfortran && \
    pip install -U pip setuptools wheel && \
    pip install numpy && \
    pip install matplotlib && \
    pip install pandas && \
    apt-get update && \
    apt-get upgrade -y && \
    echo "deb http://deb.debian.org/debian stretch main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y g++ gcc-6 libstdc++-6-dev && \
    echo "$LOG_TAG Cleanup" && \
    apt-get purge -y --auto-remove build-essential pkg-config gfortran libpython3-dev && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    apt-get clean && \
    rm -rf /root/.npm && \
    rm -rf /root/.m2 && \
    rm -rf /root/.cache && \
    rm -rf /tmp/*

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
    apt-get install -y make && \
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

# add notebooks
ADD mmlsparkExamples/ ${Z_HOME}/notebook/mmlspark/

ADD spark-defaults.conf /opt/spark/conf/spark-defaults.conf
ADD zeppelin-env.sh ${Z_HOME}/conf/

EXPOSE 8080

ENTRYPOINT [ "/usr/bin/tini", "--" ]
WORKDIR ${Z_HOME}
CMD ["sh", "-c", "echo '\nspark.driver.host' $(hostname -i) >> /opt/spark/conf/spark-defaults.conf && bin/zeppelin.sh"]
