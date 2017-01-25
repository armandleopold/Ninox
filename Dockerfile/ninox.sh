#!/bin/bash

##################################################
##################################################
#			NINOX ARCHITECTURE LAUNCHER 		 #
#			   Le 22 Janvier 2017				 #
#			   	     v 1.1						 #
##################################################
##################################################

###################################
#### Building docker images :

# MongoDB 
sudo docker build -t mongodb mongodb/

# Hadoop
sudo docker build -t hadoop hadoop/
# J'ai passé le hadoop avec la dernière version 2.7.3 dans le git "officiel"
# c'est 2.7.1
# Voici les commandes pour créer un docker simple après avec télécharger 
# l'archive et dézippé dans votre dossier docker

# Spark
sudo docker build -t spark spark/

# Kafka
sudo docker build -t kafka kafka/

# Gobblin
sudo docker build -t gobblin gobblin/

# Nginx
#sudo docker build -t nginx nginx/
#rockerMongodb
sudo docker build -t rocker rockermongo-master/

###################################
#### Creating docker network :

sudo docker network create --subnet=172.254.0.0/16 ninoxnet

###################################
### Running Docker Images :

#### Kafka : 
sudo docker run --net ninoxnet --ip 172.254.0.7 -d --hostname 172.254.0.7 -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST=172.254.0.7 --env ADVERTISED_PORT=9092 kafka 
### Hadoop :
# sudo docker run --net ninoxnet --ip 172.254.0.2 -d hadoop /etc/bootstrap.sh -bash 

sudo docker run  --net ninoxnet --ip 172.254.0.3 -d --add-host='kafka:172.254.0.1' gobblin 

#### MongoDB :
# FOR STARTING THE DOCKER FILE :
sudo docker run --net ninoxnet --ip 172.254.0.4 -d -p 27017:27017 mongodb 

# on vérifie que la machine communique bien avec la source :
# netstat --listen
# sudo docker ps
# ping 0.0.0.0 -p 27017

sudo docker run --net ninoxnet --ip 172.254.0.5 -d spark 
# On peut lancer le custom producer (depuis le dossier custom producer) : java -cp ".:libs/*" TestProducer 2
# Rem. : si on a une socket exception, il faut ajouter dans le host /etc/hosts l'ip de kafka

#phpmyadmin-like pour mongodb accessible depuis localhost:8080 admin/password 
sudo docker run -d -p 8080:80 --net ninoxnet --ip 172.254.0.7 --env MONGO_HOST=mongo rocker

#sudo docker run --net ninoxnet --ip 172.254.0.6 -d nginx 