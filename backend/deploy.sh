#!/bin/sh

# Имена контейнеров
GREEN_CONTAINER="green"
BLUE_CONTAINER="blue"

# Определяем активный и резервный контейнеры
if [ "$(docker --context remote inspect --format '{{.State.Running}}' "$GREEN_CONTAINER"-1 2>/dev/null)" = "true" ]; then
    CURRENT_CONTAINER=$GREEN_CONTAINER
    NEW_CONTAINER=$BLUE_CONTAINER
elif [ "$(docker --context remote inspect --format '{{.State.Running}}' "$BLUE_CONTAINER"-1 2>/dev/null)" = "true" ]; then
    CURRENT_CONTAINER=$BLUE_CONTAINER
    NEW_CONTAINER=$GREEN_CONTAINER
else
    echo "Ни один контейнер не запущен. Запускаем $GREEN_CONTAINER..."
    docker --context remote compose --env-file deploy.env up backend_$GREEN_CONTAINER -d --pull "always" --force-recreate
    exit 0
fi

# Проверка статуса текущего контейнера
CURRENT_STATUS=$(docker --context remote inspect --format '{{.State.Health.Status}}' $CURRENT_CONTAINER 2>/dev/null)

# Если текущий контейнер работает и имеет статус "healthy"
if [ "$CURRENT_STATUS" = "healthy" ]; then
    echo "$CURRENT_CONTAINER контейнер запущен и работает. Перезапускаем на $NEW_CONTAINER..."
    docker --context remote compose --env-file deploy.env up backend_$NEW_CONTAINER -d --pull "always" --force-recreate
    docker --context remote stop $CURRENT_CONTAINER
    docker --context remote rm $CURRENT_CONTAINER
else
    echo "$CURRENT_CONTAINER контейнер не работает или статус не определен. Запускаем $NEW_CONTAINER..."
    docker --context remote compose --env-file deploy.env up backend_$NEW_CONTAINER -d --pull "always" --force-recreate
fi
