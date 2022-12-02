#!/bin/bash

echo "\nbuild docker hadoop image\n"
docker build -f Dockerfile -t puppets/hadoop:1.0 --build-arg CACHEBUST=$(date +%s) .

echo ""