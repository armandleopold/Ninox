# Launching Spark Docker
sudo docker run --net ninoxnet --ip 172.254.0.5 -d spark -h sandbox 

# Creating symbolic link
sudo ln -s ~/Ninox/kafka_custom_producer/DataProducer.class DataProducer.class
sudo ln -s ~/Ninox/kafka_custom_producer/DataProducer.java DataProducer.java
sudo ln -s ~/Ninox/kafka_custom_producer/libs/ libs
sudo ln -s ~/Ninox/kafka_custom_producer/data.csv data.csv

export YARN_CONF_DIR="`pwd`/yarn-remote-client"
export HADOOP_USER_NAME=root
export SPARK_PUBLIC_DNS=172.254.0.5
export SPARK_LOCAL_IP=172.254.0.5

sudo gnome-terminal -e "java -cp ".:libs/*" DataProducer"
sudo gnome-terminal -e "docker run --net ninoxnet --ip 172.254.0.5 -it spark -h sandbox"

# Run application locally on 8 cores
sudo ~/spark-2.1.0/bin/spark-submit \
	--packages org.apache.spark:spark-streaming-kafka-0-8_2.11:2.1.0 \
	--master local[4] \
	~/Ninox/Spark_Stream/kafka_spark_mongodb.py \
	100