# Первый этап: Сборка
FROM ubuntu:latest as builder

# Обновление и установка необходимых пакетов
RUN apt-get update && apt-get install -y g++ wget make

# Скачивание исходного кода из публичного репозитория
WORKDIR /app
RUN wget https://raw.githubusercontent.com/dashakond/lab3/branchHTTPserver/server.cpp
RUN wget https://raw.githubusercontent.com/dashakond/lab3/branchHTTPserver/Makefile

# Скачивание библиотеки httplib.h
RUN wget https://raw.githubusercontent.com/yhirose/cpp-httplib/master/httplib.h

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

