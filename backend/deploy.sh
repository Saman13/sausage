#! /bin/bash
#остановим скрипт в случае ошибок
set -xe
#логинимнся на докер реджистори
sudo docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
#создаем сеть
sudo docker network create -d bridge sausage_network || true
#удаляем старый образ
sudo docker rm -f sausage-backend || true
#запускаем контейнер с переменными
sudo docker run --rm -d --name sausage-backend \
     --env SPRING_DATASOURCE_URL="jdbc:postgresql://${PSQL_HOST}:${PSQL_PORT}/${PSQL_DBNAME}?ssl=true" \
     --env SPRING_DATASOURCE_USERNAME="${PSQL_USER}" \
     --env SPRING_DATASOURCE_PASSWORD="${PSQL_PASSWORD}" \
     --env SPRING_DATA_MONGODB_URI="mongodb://${MONGO_USER}:${MONGO_PASSWORD}@${MONGO_HOST}:27018/${MONGO_DATABASE}?tls=true" \
     --network=sausage_network \
     "${CI_REGISTRY_IMAGE}"/sausage-backend:${VERSION}