#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static volatile uint64_t sink;

typedef uint64_t (*fn_t)(uint64_t, uint64_t);

// four distinct, non-mergeable targets for branch predictor to track
__attribute__((noinline)) static uint64_t step_a(uint64_t x, uint64_t y) {
    return (x + y) ^ 0x1234ULL;
}
__attribute__((noinline)) static uint64_t step_b(uint64_t x, uint64_t y) {
    return (x * 3 + y) ^ 0x5678ULL;
}
__attribute__((noinline)) static uint64_t step_c(uint64_t x, uint64_t y) {
    return (x ^ (y << 1)) + 0x9abcULL;
}
__attribute__((noinline)) static uint64_t step_d(uint64_t x, uint64_t y) {
    return (x + (y * 5)) ^ 0xdef0ULL;
}

// direct control flow
static uint64_t run_direct(long iters) {
    uint64_t x = 1;
    for (long i = 0; i < iters; ++i) {
        x = step_a(x, (uint64_t)i);
        x = step_b(x, (uint64_t)i + 1);
        x = step_c(x, (uint64_t)i + 2);
        x = step_d(x, (uint64_t)i + 3);
    }
    return x;
}

// inderect control flow
static uint64_t run_indirect(long iters) {
    uint64_t x = 1;
    // jump table
    fn_t table[4] = {step_a, step_b, step_c, step_d};
    for (long i = 0; i < iters * 4; ++i) {
        fn_t f = table[(i ^ (i >> 2)) & 3];
        x = f(x, (uint64_t)i);
    }
    return x;
}

int main(int argc, char **argv) {
    const char *mode = argc > 1 ? argv[1] : "direct";
    long iters = argc > 2 ? atol(argv[2]) : 250000;
    uint64_t ans = 0;

    if (!strcmp(mode, "direct")) ans = run_direct(iters);
    else if (!strcmp(mode, "indirect")) ans = run_indirect(iters);
    else {
        fprintf(stderr, "usage: %s [direct|indirect] [iters]\n", argv[0]);
        return 2;
    }

    sink = ans;
    printf("mode=%s iters=%ld result=%llu\n", mode, iters,
           (unsigned long long)ans);
    return 0;
}
