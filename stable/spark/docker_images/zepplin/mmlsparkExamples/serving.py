import mmlspark
from pyspark.sql.types import *
from pyspark.sql import SparkSession

from pyspark.sql.functions import length, col

spark = SparkSession.builder.appName("SimpleContServing").getOrCreate()
sc = spark.sparkContext
sc.setLogLevel("WARN")

print("creating df")
df = spark.readStream.continuousServer() \
    .address("0.0.0.0", 8888, "my_api") \
    .load() \
    .parseRequest(StructType().add("foo", StringType()).add("bar", IntegerType()))

replies = df.withColumn("fooLength", length(col("foo")))\
    .makeReply("fooLength")

print("creating server")
server = replies\
    .writeStream \
    .continuousServer() \
    .trigger(continuous="1 second") \
    .replyTo("my_api") \
    .queryName("my_query") \
    .option("checkpointLocation", "file:///tmp/checkpoints")

print("starting server")
query = server.start()
query.awaitTermination()
