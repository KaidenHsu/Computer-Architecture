#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static volatile uint64_t sink;

static uint64_t run_loop(long iters) {
    volatile long x = 128;
    uint64_t acc = 0;
    for (long i = 0; i < iters; ++i) {
        x--;
        if (x != 0) {
            acc += (uint64_t)i ^ 0x55aa55aaULL;
        } else {
            acc += 3;
            x = 128;
        }
    }
    return acc;
}

static uint64_t run_alt(long iters) {
    uint64_t acc = 0;
    for (long i = 0; i < iters; ++i) {
        if (i & 1) {
            acc += (uint64_t)i * 3 + 1;
        } else {
            acc ^= ((uint64_t)i << 1) | 1ULL;
        }
    }
    return acc;
}

static uint64_t run_corr(long iters) {
    uint64_t acc = 0;
    int prev_taken = 1;
    for (long i = 0; i < iters; ++i) {
        int driver = ((i >> 2) ^ i) & 1;
        if (driver)
            prev_taken = !prev_taken;

        if (prev_taken) {
            acc += (uint64_t)i + 7;
        } else {
            acc ^= ((uint64_t)i * 5) + 9;
        }
    }
    return acc;
}

int main(int argc, char **argv) {
    const char *mode = argc > 1 ? argv[1] : "loop";
    long iters = argc > 2 ? atol(argv[2]) : 800000;
    uint64_t ans = 0;

    if (!strcmp(mode, "loop")) ans = run_loop(iters);
    else if (!strcmp(mode, "alt")) ans = run_alt(iters);
    else if (!strcmp(mode, "corr")) ans = run_corr(iters);
    else {
        fprintf(stderr, "usage: %s [loop|alt|corr] [iters]\n", argv[0]);
        return 2;
    }

    sink = ans;
    printf("mode=%s iters=%ld result=%llu\n", mode, iters,
           (unsigned long long)ans);
    return 0;
}
