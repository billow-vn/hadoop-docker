#!/bin/bash

# the default node number is 3
N=${1:-3}

docker exec -it hadoop-master bash -- mapred --daemon stop historyserver
docker exec -it hadoop-master bash -- stop-all.sh
docker exec -it hadoop-slave1 bash -- stop-all.sh
docker exec -it hadoop-slave2 bash -- stop-all.sh


exit 0

docker exec -it hadoop-master bash -- hdfs namenode -format -force
docker exec -it hadoop-master bash -- hdfs datanode -format -force

# start hadoop slave container
i=1
while [ $i -lt $N ]
do
     docker exec -it hadoop-slave$i bash -- hdfs namenode -format -force
     docker exec -it hadoop-slave$i bash -- hdfs datanode -format -force

	i=$(( $i + 1 ))
done

# docker stop hadoop-master hadoop-slave1 hadoop-slave2