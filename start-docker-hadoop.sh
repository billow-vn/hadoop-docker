#!/bin/bash

# the default node number is 3
N=${1:-3}

docker start hadoop-slave2  hadoop-slave1 hadoop-master

#read -t 5 -p "I am going to wait for 5 seconds only ..\n"

docker exec -it hadoop-master bash -- start-dfs.sh
docker exec -it hadoop-master bash -- mapred --daemon start historyserver
docker exec -it hadoop-master bash -- start-yarn.sh
