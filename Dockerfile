FROM ubuntu:latest as builder

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    make \
    curl \
    netcat \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/dashakond/lab3/branchHTTPserver/server.cpp
RUN wget https://raw.githubusercontent.com/dashakond/lab3/branchHTTPserver/Makefile

# Сборка программы
RUN make server

# Второй этап: Минимальный образ
FROM alpine:latest

# Установка необходимых зависимостей
RUN apk add --no-cache libstdc++

# Копирование исполняемого файла из первого этапа
COPY --from=builder /app/server /app/server

# Определение команды запуска
CMD ["/app/server"]
