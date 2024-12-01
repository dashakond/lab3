# Використовуємо офіційний образ Ubuntu як базовий
FROM ubuntu:20.04

# Встановлюємо змінні середовища, щоб уникнути інтерактивних запитів під час інсталяції пакетів
ENV DEBIAN_FRONTEND=noninteractive

# Оновлюємо список пакетів та встановлюємо залежності
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    make \
    curl \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# Створюємо та встановлюємо робочу директорію
WORKDIR /usr/src/app

# Копіюємо ваш вихідний код сервера в контейнер
COPY server.c .

# Компілюємо C програму (сервер)
RUN gcc -o server server.c -lm

# Відкриваємо порт, на якому буде працювати ваш сервер
EXPOSE 8081

# Команда для запуску вашого сервера
CMD ["./server"]
