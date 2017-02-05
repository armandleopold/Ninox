"""
 Get streaming data from Kafka, use a trained model to make prediction 
 and save them to MongoDb every ten seconds.
"""

from __future__ import print_function
from pyspark.sql import SparkSession

import sys

from pyspark.sql import SQLContext
from pyspark import SparkContext
from pyspark.streaming import StreamingContext
from pyspark.streaming.kafka import KafkaUtils

from pyspark.mllib.regression import LabeledPoint, LinearRegressionWithSGD, LinearRegressionModel
from pyspark.mllib.linalg import Vectors


def predict(rdd, model, sparkSession, time):
    count = rdd.count()
    if (count > 0):
        features = rdd.map(lambda s: Vectors.dense(s[1].split(",")))
        predicted = model.predict(features)
        result = float(predicted.collect()[0])
        df = sparkSession.createDataFrame([(time.strftime("%Y-%m-%d %H:%M:%S"), result)], ["timePredicted", "value"])
        df.write.format("com.mongodb.spark.sql.DefaultSource").mode("append").save()

        return predicted
    else:
	print("No data received")

if __name__ == "__main__":
    sc = SparkContext(appName="NinoxStreaming")

    my_spark = SparkSession \
        .builder \
        .appName("Ninox") \
        .config("spark.mongodb.input.uri", "mongodb://172.254.0.4:27017/predictions.data") \
        .config("spark.mongodb.output.uri", "mongodb://172.254.0.4:27017/predictions.data") \
        .getOrCreate()

    ssc = StreamingContext(sc, 10)

    # Load model from HDFS
    model = LinearRegressionModel.load(sc, "hdfs://172.254.0.2:9000/user/root/models/first.model")

    # Create stream to get kafka messages
    directKafkaStream = KafkaUtils.createDirectStream(ssc, ["incomingData"], {"metadata.broker.list": "172.254.0.7:9092"})
    
    # Predict and save to mongo
    directKafkaStream.foreachRDD(lambda time, rdd: predict(rdd, model, my_spark, time))

    ssc.start()
    ssc.awaitTermination()
    sc.stop()