# hadoop-docker

Docker for Hadoop

## For ARM64
[hadoop-docker-aarch64](/tree/main/hadoop-docker-aarch64)

## For X86_64
[hadoop-docker-x86_64](/tree/main/hadoop-docker-x86_64)

# Publish the new version
```
docker push puppets/hadoop:1.1
```

## For ARM66
```
docker push puppets/hadoop_arm64:1.1
```

## Commands

Build or rebuild the image by new configs on `config` folder.

```shell
sh ./build-image.sh
```

```shell
sh ./start-container.sh
```


```shell
sh ./start-docker-hadoop.sh
```

```shell
sh ./stop-docker-hadoop.sh
```

## Thanks

https://github.com/Weihong-Liu/hadoop-docker