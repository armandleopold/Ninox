<p align="center">
  <img src="http://armand-leopold.fr/ninox/logo.jpg" width="350"/>
</p>

# Ninox :
Ninox is a new Scalable BIG-DATA Architecture Database System with machine-learning oriented features.

# Database Architecture : 
<p align="center">
  <img src="http://armand-leopold.fr/ninox/ninox%20architecture.png" widt h="100%"/>
</p>

# Getting Started : 

*	If you want to install and run an exemple use case of the application, just run the start.sh bash script at the root directory. And go to http://172.254.0.11/index.html on the host computer to visualize the exemple of real time refreshed by streaming data graph page.
*	If you just want to install and run the architecture, go on /Dockerfile and run ninox.sh bash script.

# Using Ninox the proper way :

There is 3 ways of using this big-data architecture :
* Kafka -> Goblin -> HDFS
This way is the easiest way to go. If you just want to take advantage of the kafka/gobblin/HDFS configuration setup.
* Kafka -> Spark-Stream -> MongoDB (->) Apache
If you want to make fast real time stream report on a webapplication. Running with php and mongodb
* Both ways !
If you want to take advantage of the whole configuration, this is the way it meant to be used !
You can do whatever you want, espacially use the HDFS/MongoDB, for doing replications and historical data storing into HDFS, and real time accesing data for web-application with MongoDB. In our exemple, we make a prediction model with python and the last 1 days of historical data of HDFS. We then, run predictions model with spark-stream data into MongoDB and visualize it on a real-time graph on a web-app !

There is 3 steps if you want to use this architecture for your project :

1. Create a Producer Kafka :

You can create an external kafka producer which will communicate with the kafka container at 172.254.0.7 on the docker network.
Or you can edit or replace the java file in the producer folder to do whatever you want.

2. Create a Consumer kafka :

3. Make the batch for prediction modelling :

4. Create your web-application !

# Troubleshooting : 
No error report for now.

# Technologies :
## Apache Kafka :

Kafka™ is a distributed streaming platform.
https://kafka.apache.org/intro

## Hadoop Distributed File System (HDFS) : 

Distributed database system working with the hadoop environnement.
https://hadoop.apache.org/docs/r1.2.1/hdfs_design.html

## Apache Spark : 

Apache Spark™ is a fast and general engine for large-scale data processing.
http://spark.apache.org/

## MongoDB : 

Distributed database system.
https://www.mongodb.com/