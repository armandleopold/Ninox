FROM sequenceiq/hadoop-docker:2.7.0
MAINTAINER A.L <armand.leopold@outlook.com>

# install spark

RUN yum install wget -y wget
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-2.1.0-bin-hadoop2.7 spark

ENV SPARK_HOME /usr/local/spark

RUN mkdir $SPARK_HOME/yarn-remote-clientt

WORKDIR .
RUN wget http://armand-leopold.fr/ninox/yarn-remote-client.tar.gz
RUN cd $SPARK_HOME/
RUN tar -zxvf yarn-remote-client.tar.gz 
RUN ls /usr/local/spark-2.1.0-bin-hadoop2.7/

ENV SPARK_PUBLIC_DNS 172.254.0.10
ENV SPARK_LOCAL_IP 172.254.0.10

RUN $BOOTSTRAP && $HADOOP_PREFIX/bin/hdfs dfsadmin -safemode leave && $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-2.1.0-bin-hadoop2.7/bin /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV HADOOP_USER_NAME root

RUN mkdir /home/consumer

# install numpy library for python
RUN yum install -y numpy

ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin
