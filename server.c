#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/sendfile.h>
#include <sys/stat.h>
#include <errno.h>
#include <math.h>
#include <time.h>

#define PORT 8081

// Функція обчислення суми елементів ряду (як у попередньому коді)
double calculate(int n, double x) {
    double sum = 0;
    for (int i = 0; i < n; ++i) {
        sum += (pow(-1, i) * pow(x, 2 * i)) / tgamma(2 * i + 1); // tgamma(n) = (n-1)!
    }
    return sum;
}

// Функція для відправки GET відповіді
void sendGETresponse(int fd, const char *strFilePath, const char *strResponse) {
    char response[4096];
    snprintf(response, sizeof(response),
             "HTTP/1.1 200 OK\r\n"
             "Content-Type: text/plain\r\n\r\n"
             "Calculation completed in %s\n",
             strResponse);
    send(fd, response, strlen(response), 0);
}

// Функція для відправки PUT відповіді
void sendPUTresponse(int fd, const char *strFilePath, const char *strBody, const char *strResponse) {
    char response[4096];
    snprintf(response, sizeof(response),
             "HTTP/1.1 201 CREATED\r\n"
             "Content-Type: text/plain\r\n\r\n"
             "Body received: %s\n",
             strBody);
    send(fd, response, strlen(response), 0);
}

// Функція для відправки HEAD відповіді
void sendHEADresponse(int fd, const char *strFilePath, const char *strResponse) {
    char response[4096];
    snprintf(response, sizeof(response),
             "HTTP/1.1 200 OK\r\n"
             "Content-Type: text/plain\r\n\r\n"
             "HEAD request received\n");
    send(fd, response, strlen(response), 0);
}

// Основна функція
int main(int argc, char const *argv[]) {
    int server_fd, new_socket, valread;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    char buffer[30000] = {0};

    // Створення сокету
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("Socket failed");
        exit(EXIT_FAILURE);
    }

    // Налаштування сокету
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))) {
        perror("setsockopt");
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // Прив'язка сокету до порту
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("Bind failed");
        exit(EXIT_FAILURE);
    }

    // Слухання вхідних з'єднань
    if (listen(server_fd, 3) < 0) {
        perror("Listen failed");
        exit(EXIT_FAILURE);
    }

    printf("HTTP Server is running on port %d\n", PORT);

    while (1) {
        printf("\nWaiting for connection...\n");
        if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t *)&addrlen)) < 0) {
            perror("Accept failed");
            exit(EXIT_FAILURE);
        }

        printf("Connection established.\n");
        valread = read(new_socket, buffer, sizeof(buffer));
        printf("Received request:\n%s\n", buffer);

        // Перевірка на GET, PUT, HEAD запити
        if (strncmp(buffer, "GET", 3) == 0) {
            // Виконання обчислень та відправка відповіді
            clock_t start_time = clock();
            double results[28000];
            for (int i = 0; i < 28000; ++i) {
                results[i] = calculate(i + 1, 1.0);
            }
            clock_t end_time = clock();
            double elapsed_time = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;

            char response[100];
            snprintf(response, sizeof(response), "%.2f", elapsed_time);
            sendGETresponse(new_socket, "GET", response);
            } else if (strncmp(buffer, "PUT", 3) == 0) {
            sendPUTresponse(new_socket, "PUT", buffer, "Data received");
        } else if (strncmp(buffer, "HEAD", 4) == 0) {
            sendHEADresponse(new_socket, "HEAD", "Header received");
        } else {
            // Відповідь для незрозумілих запитів
            const char *not_supported = "HTTP/1.1 405 Method Not Allowed\r\n"
                                         "Content-Type: text/plain\r\n\r\n"
                                         "Only GET, PUT, and HEAD requests are supported.\n";
            send(new_socket, not_supported, strlen(not_supported), 0);
            printf("Unsupported request sent.\n");
        }

        close(new_socket);
    }

    return 0;
}
