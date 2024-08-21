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
     --env SPRING_DATASOURCE_URL="jdbc:postgresql://rc1a-kylrrnh13yjqhvlv.mdb.yandexcloud.net:6432/std-030-13?ssl=true" \
     --env SPRING_DATASOURCE_USERNAME="${DB_USER}" \
     --env SPRING_DATASOURCE_PASSWORD="${DB_PASS}" \
     --env SPRING_DATA_MONGODB_URI="mongodb://${DB_USER}:${DB_PASS}@rc1a-3nb7p7jsmbup6crt.mdb.yandexcloud.net:27018/std-030-13?tls=true" \
     --network=sausage_network \
     "${CI_REGISTRY_IMAGE}"/sausage-backend:${VERSION}