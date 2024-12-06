# Перший етап: Сборка на базі Ubuntu 20.04
FROM ubuntu:20.04 as builder

# Встановлюємо змінні середовища, щоб уникнути інтерактивних запитів під час інсталяції пакетів
ENV DEBIAN_FRONTEND=noninteractive

# Оновлюємо список пакетів та встановлюємо залежності
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    make \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Створюємо робочу директорію
WORKDIR /usr/src/app

# Завантажуємо необхідні файли з публічного GitHub репозиторію
RUN wget https://raw.githubusercontent.com/dashakond/lab3/branchHTTPserver/server.cpp -O server.cpp
RUN wget https://raw.githubusercontent.com/dashakond/lab3/branchHTTPserver/Makefile -O Makefile

# Скачування бібліотеки httplib.h
RUN wget https://raw.githubusercontent.com/yhirose/cpp-httplib/master/httplib.h -O httplib.h

# Компілюємо C програму (сервер)
RUN make server

# Другий етап: Мінімальний образ на базі Alpine
FROM alpine:latest

# Встановлюємо необхідні залежності
RUN apk add --no-cache libstdc++

# Копіюємо з першого етапу компільований сервер в мінімальний образ
COPY --from=builder /usr/src/app/server /app/server

# Відкриваємо порт, на якому буде працювати ваш сервер
EXPOSE 8081

# Команда для запуску сервера
CMD ["/app/server"]

