#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static volatile uint64_t sink;

// PRNG (pseudo-random number generator)
static inline uint32_t xorshift32(uint32_t *s) {
    uint32_t x = *s;
    x ^= x << 13;
    x ^= x >> 17;
    x ^= x << 5;
    *s = x;
    return x;
}

// two different hash number generators
static uint64_t payload_a(uint64_t x) {
    x = (x * 1664525ULL) + 1013904223ULL;
    x ^= x >> 7;
    x += 0x9e3779b97f4a7c15ULL;
    return x;
}

static uint64_t payload_b(uint64_t x) {
    x ^= x << 9;
    x += 0x7f4a7c159e3779b9ULL;
    x ^= x >> 11;
    return x;
}

int main(int argc, char **argv) {
    const char *mode = argc > 1 ? argv[1] : "pred";
    long iters = argc > 2 ? atol(argv[2]) : 500000;
    uint64_t acc = 1;
    uint32_t state = 0x12345678u;

    for (long i = 0; i < iters; ++i) {
        int take;

        if (!strcmp(mode, "pred")) {
            // mostly taken (taken 63 out of 64 times)
            take = ((i & 63) != 0);
        } else if (!strcmp(mode, "unpred")) {
            // pseudo-random coin flip
            take = (xorshift32(&state) & 1u);
        } else {
            fprintf(stderr, "usage: %s [pred|unpred] [iters]\n", argv[0]);
            return 2;
        }

        // two different input transformations just ensure the
        // two paths different values, so neither path can
        // be trivially dead-coded away by the compiler
        if (take) { // branch predictor predicts correctly
            acc = payload_a(acc + (uint64_t)i);
        } else { // branch predictor predicts wrong half of the time
            acc = payload_b(acc ^ (uint64_t)(i * 3 + 1));
        }

        // independent work to expose speculative opportunity / waste
        acc += (uint64_t)(i * 13 + 7);
        acc ^= (acc << 3);
    }

    sink = acc;
    printf("mode=%s iters=%ld result=%llu\n", mode, iters,
           (unsigned long long)acc);
    return 0;
}
