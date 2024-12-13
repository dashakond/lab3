#!/bin/bash

# Функція для зупинки та видалення контейнера, якщо він існує
stop_and_remove_container() {
    container_name=$1
    if [ "$(docker ps -a -q -f name=$container_name)" ]; then
        echo "Контейнер $container_name вже існує. Зупиняю та видаляю старий контейнер."
        docker stop $container_name
        docker rm $container_name
    fi
}

# Функція для запуску контейнера
start_container() {
    container_name=$1
    cpu_core=$2
    echo "Запуск контейнера $container_name на ядрі CPU $cpu_core..."
    stop_and_remove_container $container_name
    docker run -d --name $container_name --cpuset-cpus=$cpu_core dashakond/my-http-server:latest
}

# Функція для перевірки активності контейнера
check_container_activity() {
    container_name=$1
    idle_time=0
    while true; do
        # Перевіряємо використання CPU контейнером
        cpu_usage=$(docker stats --no-stream --format "{{.CPUPerc}}" $container_name)
        cpu_usage=${cpu_usage%?} # Очищаємо відсотки

        if (( $(echo "$cpu_usage < 0.1" | bc -l) )); then
            # Якщо використання CPU менше 0.1% (контейнер бездіяльний)
            idle_time=$((idle_time + 1))
            echo "Контейнер $container_name бездіяльний. Час бездіяльності: $idle_time хвилин."
        else
            # Якщо контейнер активний
            idle_time=0
        fi

        # Якщо контейнер бездіяльний 2 хвилини
        if [ $idle_time -ge 2 ]; then
            echo "Контейнер $container_name бездіяльний протягом 2 хвилин. Зупиняю контейнер."
            docker stop $container_name
            docker rm $container_name
            break
        fi

        sleep 60
    done
}

# Перевірка нової версії контейнера
check_new_version() {
    echo "Перевірка нової версії контейнера..."
    docker pull dashakond/my-http-server:latest
}

# Основна частина скрипту

# Запуск контейнерів та перевірка їх активності
start_container "srv1" 0
sleep 120 # Чекаємо 2 хвилини
check_container_activity "srv1"

start_container "srv2" 1
sleep 120 # Чекаємо 2 хвилини
check_container_activity "srv2"

start_container "srv3" 2
sleep 120 # Чекаємо 2 хвилини
check_container_activity "srv3"

# Перевірка нової версії контейнера
check_new_version

