FROM ubuntu:18.04

LABEL maintainer="puppets"

WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y openssh-server openssh-client openssl wget ssh \
    zlib1g-dev libssl-dev libsasl2-dev \
    bzip2 libbz2-dev \
    fuse libfuse-dev \
    libzstd1-dev \
    iasl acpica-tools

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

ADD resources/hadoop-3.3.4-aarch64.tar.gz /usr/local/hadoop
ADD resources/jdk-8u301-linux-aarch64.tar.gz /usr/local/hadoop
ADD resources/scala-2.12.14.tgz /usr/local/hadoop
ADD resources/spark-3.3.1-bin-hadoop3.tgz /usr/local/hadoop

RUN mv /usr/local/hadoop/hadoop-* /usr/local/hadoop/hadoop && \
    mv /usr/local/hadoop/jdk* /usr/local/hadoop/jdk1.8 && \
    mv /usr/local/hadoop/scala* /usr/local/hadoop/scala2.12 && \
    mv /usr/local/hadoop/spark* /usr/local/hadoop/spark3.2.1

# set environment variable

ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root
ENV HDFS_DATANODE_SECURE_USER=root
#ENV HADOOP_SECURE_DN_USER=root

ENV HADOOP_ROOT="/usr/local/hadoop"
ENV HADOOP_HOME=${HADOOP_ROOT}/hadoop
ENV HADOOP_INSTALL="${HADOOP_HOME}"
ENV HADOOP_MAPRED_HOME=${HADOOP_HOME}
ENV HADOOP_COMMON_HOME="${HADOOP_HOME}"
ENV HADOOP_HDFS_HOME="${HADOOP_HOME}"
ENV HADOOP_YARN_HOME="${HADOOP_HOME}"
ENV HADOOP_YARNSTART=0
ENV HADOOP_COMMON_LIB_NATIVE_DIR="${HADOOP_HOME}/lib/native"
ENV PATH="${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin:${PATH}"
ENV HADOOP_OPTS="${HADOOP_OPTS} -Djava.library.path=${HADOOP_COMMON_LIB_NATIVE_DIR}"
ENV YARN_HOME="${HADOOP_HOME}"
ENV YARNSTART=0

ENV JAVA_HOME="${HADOOP_ROOT}/jdk1.8"
ENV JRE_HOME="${JAVA_HOME}/jre"
ENV CLASSPATH=".:${CLASSPATH}:${JAVA_HOME}/lib:${JRE_HOME}/lib"
ENV PATH="${PATH}:${JAVA_HOME}/bin:${JRE_HOME}/bin"

ENV SCALA_HOME="${HADOOP_ROOT}/scala2.12"
ENV PATH="${PATH}:${SCALA_HOME}/bin:${SCALA_HOME}/sbin"

ENV SPARK_HOME="${HADOOP_ROOT}/spark3.2.1"
ENV PATH="${PATH}:${SPARK_HOME}/bin:${SPARK_HOME}/sbin"

RUN mkdir -p ${HADOOP_HOME}/hdfs/namenode && \
    mkdir -p ${HADOOP_HOME}/hdfs/datanode && \
    mkdir -p ${HADOOP_HOME}/logs && \
    mkdir -p ${HADOOP_HOME}/tmp

RUN cp -rf ${HADOOP_HOME}/etc ${HADOOP_HOME}/etc.bak/

# My custom
RUN apt-get install -y cmake gcc g++ libssl-dev sqlite3 libsqlite3-dev \
    libtiff-dev libcurl4-openssl-dev \
    libtirpc-dev libc6-dev libsocket++-dev socket libtool-bin

ADD resources/proj-9.1.0_build.tar.gz /usr/local/hadoop

RUN mv /usr/local/hadoop/proj* /tmp/proj-9.1.0 \
    && cd /tmp/proj-9.1.0/build && cmake .. && make -j4 && make install

# Custom cache invalidation
ARG CACHEBUST=1

RUN cp -rf /${HADOOP_HOME}/etc.bak/* ${HADOOP_HOME}/etc/

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml && \
    mv /tmp/core-site.xml ${HADOOP_HOME}/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml ${HADOOP_HOME}/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml ${HADOOP_HOME}/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves ${HADOOP_HOME}/etc/hadoop/slaves && \
    mv /tmp/workers ${HADOOP_HOME}/etc/hadoop/workers && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh

RUN chmod +x ~/run-wordcount.sh && \
    chmod +x ${HADOOP_HOME}/sbin/start-dfs.sh && \
    chmod +x ${HADOOP_HOME}/sbin/start-yarn.sh

RUN cat /tmp/profile >> /etc/profile && \
    rm -rf $HADOOP_HOME/share/doc

# format namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]

