# Run application locally on 8 cores
sudo docker exec spark_batch spark-submit \
	--packages org.mongodb.spark:mongo-spark-connector_2.11:2.0.0 \
	--master local[4] \
	/home/batch/build_model_from_hdfs.py \
	100