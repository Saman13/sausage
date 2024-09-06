#! /bin/bash
#остановим скрипт в случае ошибок
set -xe
#логинимнся на докер реджистори
echo CI_REGISTRY_USER=${CI_REGISTRY_USER} && ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
sudo docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
#создаем сеть
sudo docker network create -d bridge sausage_network || true
#удаляем старый образ
sudo docker rm -f sausage-frontend || true
#запускаем контейнер с переменными
sudo docker run -d --name sausage-frontend \
     --network=sausage_network \
     --restart unless-stopped \
     -v /tmp/${CI_PROJECT_DIR}/frontend/default.conf:/etc/nginx/conf.d/default.conf \
     -p 80:80 \
     "${CI_REGISTRY_IMAGE}"/sausage-frontend:${VERSION}