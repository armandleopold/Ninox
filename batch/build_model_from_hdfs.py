"""
 Get data from HDFS, build a model and save it to HDFS.
"""

from __future__ import print_function
from pyspark import SparkContext
from pyspark.mllib.linalg import Vectors

# Libraries for predictive analytics
from pyspark.mllib.regression import LabeledPoint, LinearRegressionWithSGD, LinearRegressionModel

# Load and parse the data
def parsePoint(line):
    values = [float(x) for x in line.split(",")]
    return LabeledPoint(values[0], values[1:16])

sc = SparkContext(appName="NinoxBatch")

# Load data
data_file = sc.textFile("hdfs://172.254.0.2:9000/user/root/initial.csv")

# Parse data to labeledPoint
parsedData = data_file.map(parsePoint)

# Train model
model = LinearRegressionWithSGD.train(parsedData, 50, 0.00000000000001, intercept=True)

# Save model to HDFS
model.save(sc, "hdfs://172.254.0.2:9000/user/root/models/first.model")

#model = RandomForest.trainRegressor(parsedData, categoricalFeaturesInfo={}, numTrees=3, featureSubsetStrategy="auto", impurity='variance', maxDepth=4, maxBins=32)

sc.stop()