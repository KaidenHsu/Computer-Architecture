/*
 * Project 4 accelerator model scope:
 *
 * This header supports a software-visible timing abstraction for accelerator-aware
 * GEMM experiments. It is intentionally not a real RISC-V custom instruction,
 * not a gem5 decoder modification, and not a real gem5 hardware device.
 *
 * The program uses normal C++ function calls to model accelerator offload behavior.
 * The counters below expose the architectural quantities students must analyze:
 *   - offload_calls: number of submitted accelerator-like tile requests
 *   - modeled_macs: GEMM multiply-accumulate operations assigned to the abstraction
 *   - transfer_bytes: estimated A/B/C data movement associated with offload
 *   - setup_cycles: fixed per-offload setup overhead accumulated by the model
 *   - modeled_compute_cycles: idealized accelerator compute time estimate
 *
 * The delay loop is only a lightweight timing proxy so that gem5 observes some
 * CPU-side cost for offload management. Students should distinguish measured
 * gem5 statistics from modeled accelerator counters in their reports.
 */

#ifndef ACCEL_MODEL_H
#define ACCEL_MODEL_H

#include <cstdint>

struct AccelCounters {
    uint64_t offload_calls = 0;
    uint64_t modeled_macs = 0;
    uint64_t transfer_bytes = 0;
    uint64_t setup_cycles = 0;
    uint64_t modeled_compute_cycles = 0;
};

static inline void modeled_delay(uint64_t iterations) {
    volatile uint64_t sink = 0;
    for (uint64_t i = 0; i < iterations; ++i) {
        sink += (i ^ (sink << 1));
    }
}

static inline uint64_t ceil_div_u64(uint64_t a, uint64_t b) {
    return (a + b - 1) / b;
}

#endif
