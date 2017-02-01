"""
 Get data from HDFS, build a model and save it to mongoDb.
"""

from __future__ import print_function

# Libraries for predictive analytics
from pyspark.mllib.tree import RandomForest, RandomForestModel
from pyspark.mllib.util import MLUtils
from pyspark.mllib.regression import LabeledPoint


from pyspark.sql import SQLContext
from pyspark.sql import Row
from pyspark import SparkContext

def parsePoint(line):
    values = [x for x in line.split(',')]

    return LabeledPoint(values[0], values[1:])

sc = SparkContext(appName="BatchBuildModel")
data_file = sc.textFile("hdfs://172.254.0.2:9000/user/root/initial.csv")
parts = data_file.map(lambda l: l.split(","))
people = parts.map(lambda p: Row(name=p[0], age=p[1]))
#people = parts.map(lambda p: Row(store=int(p[0]), date=p[1], dept=int(p[2]), weekly_sales=float(p[3]),is_holliday.x=p[4], temperature=float(p[5]), fuel_price=float(p[6]),markdown1=float(p[7]), markdown2=float(p[8]), markdown3=float(p[9]),markdown4=float(p[10]), markdown5=float(p[11]), cpi=float(p[12]),unemployment=float(p[13]), is_holliday.y=p[14], typed=p[15], size=int(p[16])))

sqlContext = SQLContext(sc)
df = sqlContext.createDataFrame(people)
#parsedData = data_file.map(parsePoint)

model = RandomForest.trainClassifier(df, numClasses=2, categoricalFeaturesInfo={},
                                     numTrees=3, featureSubsetStrategy="auto",
                                     impurity='gini', maxDepth=4, maxBins=32)


sc.stop()