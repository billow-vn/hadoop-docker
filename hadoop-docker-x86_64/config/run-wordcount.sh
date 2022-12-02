#!/bin/bash

HADOOP_VERSION=${1:-3.3.4}

# test the hadoop cluster by running wordcount

# create input files
mkdir input
echo "Hello Docker" >input/file2.txt
echo "Hello Hadoop" >input/file1.txt

# create input directory on HDFS
hadoop fs -mkdir -p input

# put input files to HDFS
hdfs dfs -put ./input/* input

# run wordcount
hadoop jar "$HADOOP_HOME/share/hadoop/mapreduce/sources/hadoop-mapreduce-examples-${HADOOP_VERSION}-sources.jar" \
    org.apache.hadoop.examples.WordCount \
    input output

# print the input files
echo "\ninput file1.txt:"
hdfs dfs -cat input/file1.txt

echo "\ninput file2.txt:"
hdfs dfs -cat input/file2.txt

# print the output of wordcount
echo "\nwordcount output:"
hdfs dfs -cat output/part-r-00000
