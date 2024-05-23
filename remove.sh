#!/bin/sh

docker container stop myMariaDB
docker container rm myMariaDB
docker volume rm mdb1
