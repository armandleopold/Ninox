from __future__ import print_function

from pyspark import SparkContext
from pyspark.sql import SparkSession
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils

import sys

# Kafka Consumer 
if __name__ == "__main__":
    if len(sys.argv) > 999:
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

    # Mongodb connection and input line
    my_spark = SparkSession \
    .builder \
    .appName("Ninox") \
    .config("spark.mongodb.input.uri", "mongodb://172.254.0.4:27017/test.coll") \
    .config("spark.mongodb.output.uri", "mongodb://172.254.0.4:27017/test.coll") \
    .getOrCreate()

    people = my_spark.createDataFrame([("Bilbo Baggins",  50), ("Gandalf", 1000), ("Thorin", 195), ("Balin", 178), ("Kili", 77),
       ("Dwalin", 169), ("Oin", 167), ("Gloin", 158), ("Fili", 82), ("Bombur", None)], ["name", "age"])

    people.write.format("com.mongodb.spark.sql.DefaultSource").mode("append").save()

    df = my_spark.read.format("com.mongodb.spark.sql.DefaultSource").load()

    for row in df.rdd.collect():
        print(row)

    print(df)

    print("HELLO WORLD !")

    ssc.start()
ssc.awaitTermination()