#!/bin/bash

#Comment
##################################################
##################################################
#			NINOX ARCHITECTURE LAUNCHER 		 #
#			   Le 22 Janvier 2017				 #
#			   	     v 1.1						 #
##################################################
##################################################

sudo bash rm.sh

###################################
#### Building docker images :

# MongoDB 
sudo docker build -t mongodb mongodb/

# Hadoop
sudo docker build -t hadoop hadoop/

# Spark
sudo docker build -t spark_streaming spark_streaming/
sudo docker build -t spark_batch spark_batch/

# Kafka
sudo docker build -t kafka kafka/

# Gobblin
sudo docker build -t gobblin gobblin/

# rockerMongodb
sudo docker build -t rocker rockermongo-master/
#
 node.js
sudo  docker build -t nodetest node/

###################################
#### Creating docker network :

sudo docker network create --subnet=172.254.0.0/16 ninoxnet

###################################
### Running Docker Images :

#### Kafka : 
sudo gnome-terminal -e "docker run --name kafka --net ninoxnet --ip 172.254.0.7 -it --hostname 172.254.0.7 -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST=172.254.0.7 --env ADVERTISED_PORT=9092 kafka"

#### Hadoop :
sudo gnome-terminal -e "docker run --name hadoop --net ninoxnet --ip 172.254.0.2 -d hadoop"

#### Gobblin :
sudo gnome-terminal -e "docker run  --name gobblin --net ninoxnet --ip 172.254.0.3 -it --add-host='kafka:172.254.0.1' gobblin "

#### MongoDB :
sudo gnome-terminal -e "docker run --name mongo --net ninoxnet --ip 172.254.0.4 -it -p 27017:27017 mongodb"

#### Spark streaming :
sudo gnome-terminal -e "docker run --name spark_streaming -v $PWD/consumer:/home/consumer --net ninoxnet --ip 172.254.0.5 -it spark_streaming"

#### Spark batch:
sudo gnome-terminal -e "docker run --name spark_batch -v $PWD/batch:/home/batch --net ninoxnet --ip 172.254.0.10 -it --add-host='fb16285d8175:172.254.0.2' spark_batch"

#### MongoRocker :
sudo gnome-terminal -e "docker run -it -p 8080:80 --net ninoxnet --ip 172.254.0.9 --env MONGO_HOST=mongo rocker"
# phpmyadmin-like pour mongodb accessible depuis localhost:8080 admin/password 

#### NodeJs :
sudo gnome-terminal -e " docker run -p 49160:9090 -p 49161:3000 --name nodejs --net ninoxnet --ip 172.254.0.8 --link mongo:mongo -it -v $PWD/siteweb/:/usr/src/app/public nodetest"
#node.js driver pour connecter à la bddmongo
#voir readme.txt dans le dockerfile/node
#mise en place du serveur express avec le siteweb accessible depuis localhost:49160/HTML/index.html
