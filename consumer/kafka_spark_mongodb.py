#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

"""
 Counts words in UTF8 encoded, '\n' delimited text received from the network every second.
 Usage: kafka_wordcount.py <zk> <topic>
 To run this on your local machine, you need to setup Kafka and create a producer first, see
 http://kafka.apache.org/documentation.html#quickstart
 and then run the example
    `$ ~/spark-2.1.0/bin/spark-submit --jars \
external/kafka-assembly/target/scala-*/spark-streaming-kafka-assembly-*.jar \
examples/src/main/python/streaming/kafka_wordcount.py \
localhost:2181 test`
"""
from __future__ import print_function
from pyspark.sql import SparkSession


import sys

from pyspark import SparkContext
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils


my_spark = SparkSession \
    .builder \
    .appName("Ninox") \
    .config("spark.mongodb.input.uri", "mongodb://172.254.0.4/test.coll") \
    .config("spark.mongodb.output.uri", "mongodb://172.254.0.4/test.coll") \
    .getOrCreate()

people = my_spark.createDataFrame([("Bilbo Baggins",  50), ("Gandalf", 1000), ("Thorin", 195), ("Balin", 178), ("Kili", 77),
   ("Dwalin", 169), ("Oin", 167), ("Gloin", 158), ("Fili", 82), ("Bombur", None)], ["name", "age"])

people.write.format("com.mongodb.spark.sql.DefaultSource").mode("append").save()

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: kafka_wordcount.py <zk> <topic>", file=sys.stderr)
        exit(-1)

    sc = SparkContext(appName="PythonStreamingKafkaWordCount")
    ssc = StreamingContext(sc, 10)

    directKafkaStream = KafkaUtils.createDirectStream(ssc, ["incomingData"], {"metadata.broker.list": "172.254.0.7:9092"})
    
    lines = directKafkaStream.map(lambda x: x[1])
    print(lines)

    counts = lines.flatMap(lambda line: line.split(" ")) \
        .map(lambda word: (word, 1)) \
        .reduceByKey(lambda a, b: a+b)
    counts.pprint()

    ssc.start()
ssc.awaitTermination()