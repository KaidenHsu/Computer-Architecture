#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static volatile uint64_t sink;

int main(int argc, char **argv) {
    int acc = (argc >= 2) ? atoi(argv[1]) : 1;
    long n = (argc >= 3) ? atol(argv[2]) : 400000;

    uint64_t a0 = 1, a1 = 2, a2 = 3, a3 = 4;
    uint64_t a4 = 5, a5 = 6, a6 = 7, a7 = 8;

    for (long i = 0; i < n; i++) {
        if (acc >= 1) a0 = a0 * 3 + 1;
        if (acc >= 2) a1 = a1 * 5 + 1;
        if (acc >= 4) {
            a2 = a2 * 7 + 1;
            a3 = a3 * 11 + 1;
        }
        if (acc >= 8) {
            a4 = a4 * 13 + 1;
            a5 = a5 * 17 + 1;
            a6 = a6 * 19 + 1;
            a7 = a7 * 23 + 1;
        }
    }

    uint64_t ans = a0 + a1 + a2 + a3 + a4 + a5 + a6 + a7;
    sink = ans;
    printf("%llu\n", (unsigned long long)ans);
    return 0;
}
