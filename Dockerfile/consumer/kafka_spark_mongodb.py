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

from pyspark.mllib.regression import LabeledPoint, LinearRegressionWithSGD, LinearRegressionModel
from pyspark.mllib.linalg import Vectors

def parsePoint(rdd):
    values = [float(x) for x in rdd.collect().split(',')]
    return LabeledPoint("1", values[2:])

def predict(rdd, model):
    count = rdd.count()
    if (count > 0):
        features = rdd.map(lambda s: Vectors.dense(s[1].split(",")))
        
        predicted = model.predict(features)
        predicted.foreach(print)
        return predicted

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
    #ssc = StreamingContext(sc, 10)

    # Load model from HDFS
    model = LinearRegressionModel.load(sc, "hdfs://172.254.0.2:9000/user/root/models/first.model")

    # Create stream to get kafka messages
    #directKafkaStream = KafkaUtils.createDirectStream(ssc, ["incomingData"], {"metadata.broker.list": "172.254.0.7:9092"})
    
    #features = directKafkaStream.foreachRDD(lambda rdd: rdd.map(lambda s: Vectors.dense(s[1].split(","))))
    #directKafkaStream.foreachRDD(lambda rdd: predict(rdd, model))

    # Prediction working with this !!
    features = Vectors.dense(91,74070.25,1,48.02,3.409,13925.06,6927.23,101.64,8471.88,6886.04,220.2651783,7.348,1,151315)

    predicted = model.predict(features)
    print("HELLO !")
    print(predicted)

    #ssc.start()
    #ssc.awaitTermination()
    sc.stop()