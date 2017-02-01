"""
 Get streaming data from Kafka, use a trained model to make prediction 
 and save them to MongoDb every second.

 @Author : Romain CHATEAU
"""

from __future__ import print_function
from pyspark.sql import SparkSession

import sys

from pyspark import SparkContext
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils

def parsePoint(line):
    values = [float(x) for x in line.replace(',', ' ').split(' ')]
    return LabeledPoint(values[0], values[1:])

#my_spark = SparkSession \
#    .builder \
#    .appName("Ninox") \
#    .config("spark.mongodb.input.uri", "mongodb://172.254.0.4:27017/test.coll") \
#    .config("spark.mongodb.output.uri", "mongodb://172.254.0.4:27017/test.coll") \
#    .getOrCreate()


#people = my_spark.createDataFrame([("Bilbo Baggins",  50), ("Gandalf", 1000), ("Thorin", 195), ("Balin", 178), ("Kili", 77),
#   ("Dwalin", 169), ("Oin", 167), ("Gloin", 158), ("Fili", 82), ("Bombur", None)], ["name", "age"])

#people.write.format("com.mongodb.spark.sql.DefaultSource").mode("append").save()

#df = my_spark.read.format("com.mongodb.spark.sql.DefaultSource").load()

#for row in df.rdd.collect():
 #   print(row)


if __name__ == "__main__":
    sc = SparkContext(appName="PythonStreamingKafkaForecast")
    ssc = StreamingContext(sc, 10)

    directKafkaStream = KafkaUtils.createDirectStream(ssc, ["incomingData"], {"metadata.broker.list": "172.254.0.7:9092"})
    
    lines = directKafkaStream.map(lambda x: x[1])

    parsedData = lines.flatMap(lambda line: line.split(","))
    parsedData.pprint()

    ssc.start()
    ssc.awaitTermination()
    #sc.stop()