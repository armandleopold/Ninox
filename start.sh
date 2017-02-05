#!/bin/bash

###########
#
# This batch starts hadoop and spark_batch to build the model
# it then starts kafka, spark_streaming and a data producer
# the results predicted data will then go to mongodb
#
###########

echo ""
echo "###############################################################################"
echo "#"
echo "# 				NINOX"
echo "#"
echo "###############################################################################"
echo ""


echo ""
echo "###############################################################################"
echo "# Building and launching images by running ninox.sh"
echo "###############################################################################"
echo ""

cd Dockerfile

sudo bash ninox.sh

# Waiting for HDFS to leave safe mode
sleep 60

echo ""
echo "###############################################################################"
echo "# Starting spark batch to build the model, appName : NinoxBatch"		      "			      "
echo "###############################################################################"
echo ""

sudo docker exec spark_batch spark-submit \
	--master local[4] \
	/home/batch/build_model_from_hdfs.py \
	100

echo ""
echo "###############################################################################"
echo "# Done building base model, starting streaming now"
echo "###############################################################################"
echo ""

echo ""
echo "###############################################################################"
echo "# Launching data producer"
echo "###############################################################################"
echo ""

# Start data producer
cd ../producer
sudo gnome-terminal -e "bash compile.sh"

echo ""
echo "###############################################################################"
echo "# Starting spark streaming appName : SparkStreaming"
echo "###############################################################################"
echo ""

sudo docker exec spark_streaming spark-submit \
	--packages org.mongodb.spark:mongo-spark-connector_2.11:2.0.0 \
	--jars /usr/local/spark/spark-streaming-kafka-0-8-assembly_2.11-2.1.0.jar \
	--master local[4] \
	/home/consumer/kafka_spark_mongodb.py 172.254.0.7:2181 incomingData \
	100