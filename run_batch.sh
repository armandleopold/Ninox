# Run application locally on 8 cores
sudo docker exec spark_batch spark-submit \
	--master local[4] \
	/home/batch/build_model_from_hdfs.py \
	100