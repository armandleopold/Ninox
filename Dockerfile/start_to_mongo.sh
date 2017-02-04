#!/bin/bash

###########
#
# This batch starts hadoop and spark_batch to build the model
# it then starts kafka, spark_streaming and a data producer
# the results predicted data will then go to mongodb
#
###########

sudo bash rm.sh

sudo docker run --name hadoop --net ninoxnet --ip 172.254.0.2 -d hadoop

sudo docker run --name spark_batch -v $PWD/batch:/home/batch --net ninoxnet --ip 172.254.0.10 -d --add-host='fb16285d8175:172.254.0.2' spark_batch

# Waiting for HDFS to leave safe mode
sleep 45

sudo docker exec spark_batch spark-submit \
	--master local[4] \
	/home/batch/build_model_from_hdfs.py \
	100

echo "################################################################"
echo "# Done building base model, starting streaming now"
echo "################################################################"

sudo docker run --name kafka --net ninoxnet --ip 172.254.0.7 -d --hostname 172.254.0.7 -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST=172.254.0.7 --env ADVERTISED_PORT=9092 kafka

sudo docker run --name spark_streaming -v $PWD/consumer:/home/consumer --net ninoxnet --ip 172.254.0.5 -d --add-host='fb16285d8175:172.254.0.2' spark_streaming

#sleep 20

#sudo docker exec spark_streaming spark-submit \
#	--packages org.mongodb.spark:mongo-spark-connector_2.11:2.0.0 \
#	--jars /usr/local/spark/spark-streaming-kafka-0-8-assembly_2.11-2.1.0.jar \
#	--master local[4] \
#	/home/consumer/kafka_spark_mongodb.py 172.254.0.7:2181 incomingData \
#	100