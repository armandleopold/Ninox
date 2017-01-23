#!/bin/bash

##################################################
##################################################
#			NINOX ARCHITECTURE LAUNCHER 		 #
#			   Le 22 Janvier 2017				 #
#			   	     v 1.0						 #
##################################################
##################################################

#### Building docker images :
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
sudo docker build -t nginx nginx/

###################################
### Running Docker Images :

#### MongoDB :
# FOR STARTING THE DOCKER FILE :
sudo docker run -d -p 27017:27017 mongodb

# on vérifie que la machine communique bien avec la source :
# netstat --listen
# sudo docker ps
# ping 0.0.0.0 -p 27017

#### Kafka : 
sudo docker run -d --hostname kafka -p 2181:2181 -p 9092:9092 --env ADVERTISED_HOST=kafka --env ADVERTISED_PORT=9092 kafka

### Hadoop :
sudo docker run -d hadoop /etc/bootstrap.sh -bash

sudo docker run -d --add-host='kafka:172.17.0.2' gobblin

sudo docker run -d spark
# On peut lancer le custom producer (depuis le dossier custom producer) : java -cp ".:libs/*" TestProducer 2
# Rem. : si on a une socket exception, il faut ajouter dans le host /etc/hosts l'ip de kafka