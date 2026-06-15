#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static volatile uint64_t sink;

static uint64_t run_indep(long n) {
    uint64_t a = 1, b = 2, c = 3, d = 4;
    for (long i = 0; i < n; i++) {
        a += 3;
        b += 5;
        c += 7;
        d += 11;
        a ^= (b << 1);
        c ^= (d << 1);
    }
    return a + b + c + d;
}

static uint64_t run_chain(long n) {
    uint64_t x = 1;
    for (long i = 0; i < n; i++) {
        x = x * 3 + 1;
        x = x ^ (x >> 7);
        x = x + 5;
        x = x ^ (x << 3);
    }
    return x;
}

int main(int argc, char **argv) {
    long n = (argc >= 3) ? atol(argv[2]) : 500000;
    if (argc < 2) {
        fprintf(stderr, "usage: %s indep|chain [iters]\n", argv[0]);
        return 1;
    }
    uint64_t ans = 0;
    if (strcmp(argv[1], "indep") == 0) ans = run_indep(n);
    else if (strcmp(argv[1], "chain") == 0) ans = run_chain(n);
    else {
        fprintf(stderr, "mode must be indep or chain\n");
        return 1;
    }
    sink = ans;
    printf("%llu\n", (unsigned long long)ans);
    return 0;
}
