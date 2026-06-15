#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static volatile uint64_t sink;

int main(int argc, char **argv) {
    long n = (argc >= 2) ? atol(argv[1]) : 200000;
    long sz = (argc >= 3) ? atol(argv[2]) : 32768;

    uint64_t *a = (uint64_t *)malloc((size_t)sz * sizeof(uint64_t));
    if (!a) return 1;

    for (long i = 0; i < sz; i++) a[i] = (uint64_t)(i * 17 + 3);

    uint64_t sum = 0;
    uint64_t x = 1, y = 3, z = 5;

    for (long i = 0; i < n; i++) {
        uint64_t v = a[(i * 64) % sz];   // sparse-ish access to create noticeable memory traffic
        x += 13;                         // independent arithmetic stream 1
        y ^= (x << 1);                   // independent arithmetic stream 2
        z += y + 7;                      // independent arithmetic stream 3
        sum += v + x + y + z;            // the load is consumed here, but younger independent ops exist
    }

    sink = sum;
    printf("%llu\n", (unsigned long long)sum);
    free(a);
    return 0;
}
