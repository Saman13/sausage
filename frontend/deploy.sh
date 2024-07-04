#!/bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
#Переносим артефакт в нужную папку
sudo rm -f /home/student/sausage-store.tar.gz||true
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.tar.gz ${NEXUS_REPO_URL}/repository/${NEXUS_REPO_FRONTEND_NAME}/${VERSION}/sausage-store-${VERSION}.tar.gz
sudo rm -rf /opt/sausage-store/static2/frontend/dist/frontend/||true
sudo tar -xf sausage-store.tar.gz -C "/opt/sausage-store/static2/frontend/dist"
#Перезапускаем сервис nginx
sudo systemctl restart nginx.service
