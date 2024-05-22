docker volume create mdb1

docker build -t KingPancakeDB:latest .

docker run -d \
    --name myMariaDB \
    -v mdb1:/var/lib/mysql \
    -p 3306:3306 \
    KingPancakeDB:latest

docker exec myMariaDB chmod 777 -R /var/lib/mysql

docker exec myMariaDB ls -al /var/lib/mysql

docker stop myMariaDB
