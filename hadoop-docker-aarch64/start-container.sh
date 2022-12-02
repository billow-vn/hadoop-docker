#!/bin/bash

# the default node number is 3
N=${1:-3}

# start hadoop hadoop-master container
docker rm -f hadoop-master &>/dev/null
echo "start hadoop-master container..."
docker run -itd \
    --net=hadoop \
    -p 9870:9870 \
    -p 8033:8033 \
    -p 9864:9864 \
    --name hadoop-master \
    --mount type=bind,source="$(pwd)/data",target=/mnt/data \
    --hostname hadoop-master \
    puppets/hadoop:1.0 &>/dev/null

# docker exec -it hadoop-master bash -- hdfs namenode -format -force
# docker exec -it hadoop-master bash -- hdfs getconf -namenodes

i=1
# start hadoop slave container
if [ $i -lt $N ]; then
    docker rm -f hadoop-slave$i &>/dev/null
    echo "start hadoop-slave$i container..."
    docker run -itd \
        --net=hadoop \
        -p 8088:8088 \
        -p 8188:8188 \
        -p 19888:19888 \
        --name hadoop-slave$i \
        --hostname hadoop-slave$i \
        puppets/hadoop:1.0 &>/dev/null
fi

i=2
while [ $i -lt $N ]; do
    docker rm -f hadoop-slave$i &>/dev/null
    echo "start hadoop-slave$i container..."
    docker run -itd \
        --net=hadoop \
        --name hadoop-slave$i \
        --hostname hadoop-slave$i \
        puppets/hadoop:1.0 &>/dev/null

#    docker exec -it hadoop-slave$i bash -- hdfs namenode -format -force
    # docker exec -it hadoop-slave$i bash -- hdfs getconf -namenodes

    i=$(($i + 1))
done

# get into hadoop master container
# docker exec -it hadoop-master bash

# docker run -itd --net=hadoop --name hadoop-slave1 --hostname hadoop-slave1 puppets/hadoop:1.0
# docker run -itd --net=hadoop --name hadoop-slave2 --hostname hadoop-slave2 puppets/hadoop:1.0
