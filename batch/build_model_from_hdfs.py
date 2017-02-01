"""
 Get data from HDFS, build a model and save it to mongoDb.

 @Author : Romain CHATEAU
"""

from __future__ import print_function


from pyspark import SparkContext

sc = SparkContext(appName="BatchBuildModel")
text_file = sc.textFile("hdfs://172.254.0.2:9000/initial.csv")

parsedData = text_file.flatMap(lambda line: line.split(","))
parsedData.pprint()

sc.stop()