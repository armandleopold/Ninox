from pyspark import SparkContext
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils

 kafkaStream = KafkaUtils.createStream(streamingContext, \
     [ZK quorum], [consumer group id], [per-topic number of Kafka partitions to consume])

