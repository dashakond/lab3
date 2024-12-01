#include "httplib.h"
#include "Func.h"
#include <vector>
#include <algorithm>
#include <chrono>

using namespace httplib;

double compute_trigonometric_function(int n) {
    Func f;
    return f.FuncA(n);
}

int main() {
    Server svr;

    svr.Get("/calculate", [](const Request &req, Response &res) {
        int n = 10; 
        std::vector<double> values;

        auto start = std::chrono::high_resolution_clock::now();

        for (int i = 0; i < n; ++i) {
            values.push_back(compute_trigonometric_function(i));
        }

        std::sort(values.begin(), values.end());

        auto end = std::chrono::high_resolution_clock::now();
        std::chrono::duration<double> elapsed = end - start;

        std::string body = "Elapsed time: " + std::to_string(elapsed.count()) + " seconds\n";
        res.set_content(body, "text/plain");
    });

    svr.listen("0.0.0.0", 8080);
}

