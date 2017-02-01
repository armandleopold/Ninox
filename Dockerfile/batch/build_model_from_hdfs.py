"""
 Get data from HDFS, build a model and save it to mongoDb.

 @Author : Romain CHATEAU
"""

from __future__ import print_function


from pyspark import SparkContext

sc = SparkContext(appName="BatchBuildModel")
text_file = sc.textFile("hdfs://172.254.0.2:9000/user/root/initial.csv")

#parsedData = text_file.flatMap(lambda line: line.split(","))

#output = parsedData.collect()

#for(text) in output:
#	print(text)

nonempty_lines = text_file.filter(lambda x: len(x) > 0)
print ('Nonempty lines', nonempty_lines.count())

words = nonempty_lines.flatMap(lambda x: x.split(' '))

wordcounts = words.map(lambda x: (x, 1)) \
                  .reduceByKey(lambda x, y: x+y) \
                  .map(lambda x: (x[1], x[0])).sortByKey(False)

print ('Top 100 words:')
print (wordcounts.take(100))

sc.stop()