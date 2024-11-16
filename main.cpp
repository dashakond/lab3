#include <iostream>
#include "FuncA.h"

int main() {
    FuncA func;
    double x = 1.0; // Пример значения x
    int n = 3;      // Пример значения n
    std::cout << "Result: " << func.calculate(n, x) << std::endl;
    return 0;
}
