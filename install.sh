#!/bin/sh

docker volume create mdb1
docker build -t kingpancakedb:latest .

docker run -d \
    --name myMariaDB \
    -v mdb1:/var/lib/mysql \
    -p 3306:3306 \
    kingpancakedb:latest
