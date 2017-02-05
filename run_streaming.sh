#!/bin/bash

sudo docker exec spark_streaming spark-submit \
	--packages org.mongodb.spark:mongo-spark-connector_2.11:2.0.0 \
	--jars /usr/local/spark/spark-streaming-kafka-0-8-assembly_2.11-2.1.0.jar \
	--master local[4] \
	/home/consumer/kafka_spark_mongodb.py 172.254.0.7:2181 incomingData \
	100