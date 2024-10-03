#!/bin/sh

# Названия контейнеров
GREEN_CONTAINER="green"
BLUE_CONTAINER="blue"

# Функция для проверки статуса контейнера (Healthy/Unhealthy/None)
get_container_status() {
    container_name=$1
    status=$(docker --context remote inspect --format '{{.State.Health.Status}}' "$container_name" 2>/dev/null)
    echo "$status"
}

# Функция для проверки, запущен ли контейнер
is_container_running() {
    container_name=$1
    docker --context remote inspect --format '{{.State.Running}}' "$container_name" 2>/dev/null
}

# Проверяем статус контейнеров
green_status=$(get_container_status $GREEN_CONTAINER)
blue_status=$(get_container_status $BLUE_CONTAINER)

# Проверяем, запущен ли green и blue контейнеры
green_running=$(is_container_running $GREEN_CONTAINER)
blue_running=$(is_container_running $BLUE_CONTAINER)

if [ "$green_running" = "true" ] && [ "$green_status" = "healthy" ]; then
    echo "Green контейнер запущен и работает. Перезапускаем на Blue..."
    docker --context remote compose --env-file deploy.env up backend_blue -d --pull "always" --force-recreate
    docker stop $GREEN_CONTAINER
    docker rm $GREEN_CONTAINER

elif [ "$blue_running" = "true" ] && [ "$blue_status" = "healthy" ]; then
    echo "Blue контейнер запущен и работает. Перезапускаем на Green..."
    docker --context remote compose --env-file deploy.env up backend_green -d --pull "always" --force-recreate
    docker stop $BLUE_CONTAINER
    docker rm $BLUE_CONTAINER

elif [ "$green_running" = "false" ] && [ "$blue_running" = "false" ]; then
    echo "Ни один контейнер не запущен. Запускаем Green..."
    docker --context remote compose --env-file deploy.env up backend_green -d --pull "always" --force-recreate

elif [ "$green_running" = "true" ] && [ "$blue_running" = "true" ]; then
    echo "Оба контейнера запущены. Останавливаем Blue..."
    docker stop $BLUE_CONTAINER
    docker rm $BLUE_CONTAINER
else
    echo "Состояние контейнеров не определено. Попробуйте вручную."
fi


