#include <cmath>
#include "FuncA.h"

double FuncA::calculate(int n, double x) {
    double sum = 0;
    for (int i = 0; i < n; ++i) {
        sum += (pow(-1, i) * pow(x, 2 * i)) / tgamma(2 * i + 1); // tgamma(n) - это (n-1)!
    }
    return sum;
}
