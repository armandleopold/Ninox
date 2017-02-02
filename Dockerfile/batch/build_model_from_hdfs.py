"""
 Get data from HDFS, build a model and save it to mongoDb.
"""

from __future__ import print_function

# Libraries for predictive analytics
from pyspark.ml import Pipeline
from pyspark.ml.classification import RandomForestClassifier as RF
from pyspark.ml.feature import StringIndexer, VectorIndexer, VectorAssembler, SQLTransformer
from pyspark.ml.evaluation import MulticlassClassificationEvaluator, BinaryClassificationEvaluator
from pyspark.ml.tuning import CrossValidator, ParamGridBuilder
from pyspark.ml.feature import OneHotEncoder

from pyspark.sql import SQLContext
from pyspark.sql import Row
from pyspark import SparkContext

from pyspark.sql.functions import udf
from pyspark.sql.types import StringType

import numpy as np
import functools

sc = SparkContext(appName="BatchBuildModel")

# Load data
data_file = sc.textFile("hdfs://172.254.0.2:9000/user/root/initial.csv")
parts = data_file.map(lambda l: l.split(","))
data_mapped = parts.map(lambda p: Row(store=int(p[0]), date=p[1], dept=int(p[2]), weekly_sales=float(p[3]), is_hollidayx=p[4], temperature=float(p[5]), fuel_price=float(p[6]),markdown1=float(p[7]), markdown2=float(p[8]), markdown3=float(p[9]),markdown4=float(p[10]), markdown5=float(p[11]), cpi=float(p[12]),unemployment=float(p[13]), is_hollidayy=p[14], typed=p[15], size=int(p[16])))

sqlContext = SQLContext(sc)
df = sqlContext.createDataFrame(data_mapped)

# Parse categorical data by applying one hot enconding method to convert them
# to dummy cols
column_vec_in = ['date', 'is_hollidayx', 'is_hollidayy', 'typed']
column_vec_out = ['date_catVect', 'is_hollidayx_catVect', 'is_hollidayy_catVect', 'typed_catVect']
 
indexers = [StringIndexer(inputCol=x, outputCol=x+'_tmp')
            for x in column_vec_in ]
 
encoders = [OneHotEncoder(dropLast=False, inputCol=x+"_tmp", outputCol=y)
for x,y in zip(column_vec_in, column_vec_out)]
tmp = [[i,j] for i,j in zip(indexers, encoders)]
tmp = [i for sublist in tmp for i in sublist]

# prepare labeled sets
cols_now = ['store', 'dept', 'temperature', 'fuel_price', 'markdown1', 'markdown2', 'markdown3', 'markdown4', 'markdown5', 'cpi', 'unemployment', 'size', 'date_catVect', 'is_hollidayx_catVect', 'is_hollidayy_catVect', 'typed_catVect']
assembler_features = VectorAssembler(inputCols=cols_now, outputCol='features')
labelIndexer = StringIndexer(inputCol='weekly_sales', outputCol="label")
tmp += [assembler_features, labelIndexer]
pipeline = Pipeline(stages=tmp)

allData = pipeline.fit(df).transform(df)
allData.cache()

# Build model
rf = RF(labelCol='label', featuresCol='features',numTrees=200)
model = rf.fit(allData)
model.save("/user/root/models")

sc.stop()