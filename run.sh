# Installing gnome terminal
sudo apt-get install -y gnome-terminal

# Run architecture core
#sudo gnome-terminal -e "bash Dockerfile/ninox.sh"
#sleep 15

# ln -s producer/compile.sh compile.sh
# ln -s producer/libs libs
# ln -s producer/data.csv data.csv
# ln -s producer/DataProducer.class DataProducer.class
# ln -s producer/DataProducer.java DataProducer.java

# compile & run producer
cd producer
sudo bash compile.sh

# sudo gnome-terminal -e "bash producer/compile.sh"

# Run application locally on 8 cores
sudo docker exec spark_streaming spark-submit \
	--packages org.mongodb.spark:mongo-spark-connector_2.11:2.0.0 \
	--jars /usr/local/spark/spark-streaming-kafka-0-8-assembly_2.11-2.1.0.jar \
	--master local[4] \
	/home/consumer/kafka_spark_mongodb.py 172.254.0.7:2181 incomingData \
	100