# Installing gnome terminal
sudo apt-get install -y gnome-terminal

# Run architecture core
sudo gnome-terminal -e "bash ../Dockerfile/ninox.sh"
sleep 11

# Creating symbolic link
sudo ln -s ../kafka_custom_producer/DataProducer.class DataProducer.class
sudo ln -s ../kafka_custom_producer/DataProducer.java DataProducer.java
sudo ln -s ../kafka_custom_producer/libs/ libs
sudo ln -s ../kafka_custom_producer/data.csv data.csv
sudo ln -s ../kafka_custom_producer/compile.sh compile.sh

export YARN_CONF_DIR="`pwd`/yarn-remote-client"
export HADOOP_USER_NAME=root
export SPARK_PUBLIC_DNS=172.254.0.5
export SPARK_LOCAL_IP=172.254.0.5

sudo gnome-terminal -e "bash compile.sh"
# sudo gnome-terminal -e "docker run --net ninoxnet --ip 172.254.0.5 -it spark"

# Run application locally on 8 cores
sudo ../../spark-2.1.0/bin/spark-submit \
	--packages org.apache.spark:spark-streaming-kafka-0-8_2.11:2.1.0 \
	--master local[4] \
	kafka_spark_mongodb.py 172.254.0.7:2181 incomingData
	100
