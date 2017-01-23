FROM gobblin/gobblin-base:ubuntu

ENV RELEASE_VERSION "0.8.0"

RUN mkdir -p /opt/gobblin/
WORKDIR /opt/gobblin/

# Download gobblin-distribution-$RELEASE_VERSION
RUN curl -OL --progress-bar https://github.com/linkedin/gobblin/releases/download/gobblin_$RELEASE_VERSION/gobblin-distribution-$RELEASE_VERSION.tar.gz

# Un-tar gobblin-distribution-$RELEASE_VERSION
RUN tar -xf gobblin-distribution-$RELEASE_VERSION.tar.gz

# Download and install nano to view log files
RUN apt-get update
RUN apt-get install nano

# Set up gobblin env
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN mkdir /opt/gobblin/working_dir
RUN mkdir /opt/gobblin/job_config_dir

ENV GOBBLIN_JOB_CONFIG_DIR /opt/gobblin/job_config_dir
ENV GOBBLIN_WORK_DIR /opt/gobblin/working_dir

ADD kafka.pull /opt/gobblin/job_config_dir

# Install supervisor
RUN apt-get install -y supervisor

# Supervisor config
ADD supervisor/gobblin.conf supervisor/gobblin.conf /etc/supervisor/conf.d/

CMD ["supervisord", "-n"]