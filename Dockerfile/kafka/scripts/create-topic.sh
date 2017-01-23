#!/bin/sh
/bin/bash $KAFKA_HOME/bin/kafka-topics.sh --create --topic incomingData --partitions 1 --zookeeper 172.254.0.1:2181 --replication-factor 1

exit 0