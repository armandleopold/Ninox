#!/bin/bash

# Remove all dockers
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)