# Run application locally on 8 cores
sudo ~/spark-2.1.0-bin-hadoop2.7/bin/spark-submit \
	--packages org.apache.spark:spark-streaming-kafka-0-8_2.11:2.1.0 \
	--master local[4] \
	~/kafka_spark_mongodb.py \
	100