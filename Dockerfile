# Етап 1: Збірка
FROM ubuntu:20.04 as builder

# Встановлення залежностей
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    make \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Клонування коду з публічного репозиторію
WORKDIR /usr/src/app
RUN curl -o server.c https://raw.githubusercontent.com/dashakond/lab3/branchHTTPserver/server.c

# Компіляція програми
RUN gcc -o server server.c -lm

# Етап 2: Створення кінцевого образу
FROM alpine:latest

# Копіювання виконуваного файлу із попереднього етапу
WORKDIR /usr/local/bin
COPY --from=builder /usr/src/app/server .

# Відкриття порту
EXPOSE 8081

# Запуск програми
CMD ["./server"]
