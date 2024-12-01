#include <iostream>
#include <cassert>
#include "FuncA.h"
#include <ctime>

int main() {
    FuncA funcA;
    
    // Вимірювання часу
    clock_t start_time = clock();
    double results[28000];
    
    for (int i = 0; i < 28000; ++i) {
        results[i] = funcA.calculate(i + 1, 1.0);
    }

    clock_t end_time = clock();
    double elapsed_time = ((double)(end_time - start_time)) / CLOCKS_PER_SEC;

    // Перевірка, чи час виконання знаходиться в межах від 5 до 20 секунд
    assert(elapsed_time >= 5.0 && elapsed_time <= 20.0);

    std::cout << "Calculation completed in " << elapsed_time << " seconds." << std::endl;
    return 0;
}
