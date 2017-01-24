#!/bin/bash

##################################################
##################################################
#			      ARMAND LEOPOLD			 	 #
#		COMPTE REDUS MONGODB DOCKER 			 #
#			   Le 13 Janvier 2017				 #
##################################################
##################################################

# dockerfile : 

FROM       ubuntu:latest
MAINTAINER A.L <armand.leopold@outlook.com>

# Installation:

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list

# Update apt-get sources AND install MongoDB
RUN apt-get update && apt-get install -y mongodb-org

# Create the MongoDB data directory
RUN mkdir -p /data/db

# Expose port 27017 from the container to the host
EXPOSE 27017

# Set usr/bin/mongod as the dockerized entry-point application
ENTRYPOINT ["/usr/bin/mongod"]


# FOR STARTING THE DOCKER FILE :
sudo docker run -it -p 27017:27017 mongodb

# on vérifie que la machine communique bien avec la source :
netstat --listen
sudo docker ps
ping 0.0.0.0 -p 27017

# Remove all dockers
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)