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
sudo docker build -t spark spark/

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
sudo gnome-terminal -e "docker run --net ninoxnet --ip 172.254.0.2 -d hadoop /etc/bootstrap.sh -bash"

#### Gobblin :
sudo gnome-terminal -e "docker run  --name gobblin --net ninoxnet --ip 172.254.0.3 -it --add-host='kafka:172.254.0.1' gobblin "

#### MongoDB :
sudo gnome-terminal -e "docker run --name mongo --net ninoxnet --ip 172.254.0.4 -it -p 27017:27017 mongodb"

#### Spark :
sudo gnome-terminal -e "docker run --name spark -v $PWD/consumer:/home/consumer --net ninoxnet --ip 172.254.0.5 -it spark"

#### MongoRocker :
sudo gnome-terminal -e "docker run -it -p 8080:80 --net ninoxnet --ip 172.254.0.9 --env MONGO_HOST=mongo rocker"
# phpmyadmin-like pour mongodb accessible depuis localhost:8080 admin/password 

#### NodeJs :
sudo gnome-terminal -e " docker run -p 49160:9090 -p 49161:3000 --name nodejs --net ninoxnet --ip 172.254.0.8 --link mongo:mongo -it -v $PWD/siteweb/:/usr/src/app/public nodetest"
#node.js driver pour connecter à la bddmongo
#voir readme.txt dans le dockerfile/node
#mise en place du serveur express avec le siteweb accessible depuis localhost:49160/HTML/index.html
