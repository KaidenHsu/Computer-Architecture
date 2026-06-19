# Week 5 Lab. Instruction-Level Parallelism and Out-of-Order Execution

## 1. Introduction

This lab measures how microarchitectural features — superscalar, out-of-order execution affect CPU throughput. Three exercises are covered: Exercise 1 isolates the impact of data dependencies by comparing a loop with four independent accumulators against a single-variable dependency chain; Exercise 2 runs a memory-bound workload on both an in-order (`MinorCPU`) and an out-of-order (`O3CPU`) model to observe how a reorder buffer hides load latency; and Exercise 3 scales the number of independent multiply-add chains to find where execution units saturate. Together, the exercises build intuition for why the same algorithm can perform very differently depending on how its operations are ordered and how much independent work (ILP) is exposed to the hardware.

## 2. Workflow

``` bash
$ bash run.sh
```

## 3. Exercise 1: Instruction Level Parallelism (ILP)

### 3.1 Independent Instructions

``` c
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
```

Four independent accumulators (`a`, `b`, `c`, `d`) are updated in parallel each iteration, allowing the CPU to execute multiple add and XOR operations simultaneously without data hazards.

### 3.2 Dependency Chain

``` c
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
```

A single variable (`x`) is updated through four chained operations each iteration, where each operation depends on the result of the previous one, forcing strictly sequential execution.

### 3.4 Result

| Metric | Independent | Chain |
|--------|-------------|-------|
| sim_insts | 3,614,169 | 5,114,961 |
| sim_seconds | 0.000567 | 0.002067 |
| num_cycles | 1,133,938 | 4,134,687 |
| IPC | 3.19 | 1.24 |

- Both use the `O3CPU`.
- The independent version achieves an IPC of 3.19 — roughly 2.6× higher than the chain's 1.24. Because the four accumulators have no data dependencies on each other, the CPU can issue multiple operations per cycle.
- The chain version is bottlenecked by the four-operation dependency sequence per iteration: each operation must wait for the previous result, so the effective throughput is limited to one operation at a time regardless of available execution units.
- The cycle count difference (1.1M vs 4.1M) reflects our observation directly.

## 4. Exercise 2: Out-of-Order Execution

### 4.1 Workload

``` c
uint64_t sum = 0;
uint64_t x = 1, y = 3, z = 5;

for (long i = 0; i < n; i++) {
    uint64_t v = a[(i * 64) % sz];   // sparse-ish access to create noticeable memory traffic
    x += 13;                         // independent arithmetic stream 1
    y ^= (x << 1);                   // independent arithmetic stream 2
    z += y + 7;                      // independent arithmetic stream 3
    sum += v + x + y + z;            // the load is consumed here, but younger independent ops exist
}
```

A loop performing sparse array reads combined with three independent arithmetic streams. The load result is consumed only after younger independent operations, giving an out-of-order CPU the opportunity to issue arithmetic instructions while waiting for memory.

### 4.2 CPU Models

| Feature | MinorCPU | O3CPU |
|---------|----------|-------|
| Execution order | In-order | Out-of-order |
| Pipeline stages | 4 (Fetch1, Fetch2, Decode, Execute) | 6 (Fetch, Decode, Rename, Issue, Execute, Commit) |
| Issue / fetch width | 2 | 8 |
| Reorder buffer (ROB) | None | 192 entries |
| Register renaming | No | Yes (256 int, 256 fp physical regs) |

### 4.3 Result

| Metric | MinorCPU | O3CPU |
|--------|----------|-------|
| sim_insts | 3,246,357 | 3,246,357 |
| sim_seconds | 0.011974 | 0.002937 |
| num_cycles | 23,948,949 | 5,873,091 |
| IPC | 0.14 | 0.55 |

- Both models execute the same number of instructions, but the `O3CPU` completes in 4× fewer cycles (5.9M vs 23.9M), yielding a 4× IPC advantage (0.55 vs 0.14).
- `MinorCPU` stalls in program order whenever the sparse load misses in cache, blocking all subsequent instructions even though the three arithmetic streams are completely independent of the load.
- The `O3CPU` uses its ROB and issue queue to keep those arithmetic operations in flight while the load is pending, hiding most of the memory latency.
- The IPC of both models is still well below 1, indicating that the strided access pattern causes frequent cache misses that even out-of-order execution cannot fully hide.

## 5. Exercise 3: Multiple Accumulators

### 5.1 Workload

``` c
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
```

The number of active accumulators is controlled by `acc`, which is passed to the main function by each script. Each accumulator carries an independent multiply-add dependency chain, allowing the CPU to pipeline multiple chains in parallel as more accumulators are activated.

### 5.2 Result

| Accumulators | sim_insts | sim_seconds | num_cycles | IPC |
|:---:|---:|---:|---:|---:|
| 1 | 3,714,938 | 0.000867 | 1,733,901 | 2.14 |
| 2 | 12,515,005 | 0.001867 | 3,733,816 | 3.35 |
| 4 | 13,715,005 | 0.001867 | 3,733,816 | 3.67 |
| 8 | 15,315,005 | 0.002067 | 4,134,126 | 3.70 |

- Both use the `O3CPU`.
- IPC rises sharply from 1 to 2 accumulators (2.14 → 3.35) as the CPU overlaps the multiply latency of one chain with operations from the other. The gains diminish by 4 accumulators (3.67) and nearly plateau at 8 (3.70), indicating the execution units are saturated and additional independent chains yield little further throughput.
- The identical cycle counts for `acc`=2 and `acc`=4 (3,733,816) confirm that 4 chains fit within the same scheduling window as 2 — the extra instructions are absorbed without extending runtime.
- The slight cycle increase at `acc`=8 most likely reflects instruction fetch and decode overhead rather than a true execution bottleneck.

## 6. Conclusion

**Exercise 1** showed that eliminating data dependencies between loop iterations is the single most effective way to improve IPC — the independent version ran 2.6× faster than the functionally-equivalent chain simply because a superscalar machine can exploit this ILP.

**Exercise 2** demonstrated that out-of-order execution is most valuable when independent work exists alongside slow operations: the `O3CPU` achieved a 4× cycle reduction over `MinorCPU` by issuing arithmetic while waiting on cache misses, though neither model approached high IPC because the memory bottleneck ultimately dominates. **Exercise 3** revealed that the benefit of parallelism has a hardware ceiling — IPC improved significantly going from 1 to 2 accumulators, but gains were marginal beyond 4, pointing to execution unit saturation rather than a software limit.

These exercises demonstrated that performance is determined by what the hardware can see and schedule. The key takeaway is to structure loops to expose ILP to a superscalar machine: break long dependency chains when possible, interleave independent operations to keep execution units busy, and avoid memory access patterns that serialize otherwise-parallel work. Going forward, the right approach is to first identify whether the bottleneck is a dependency chain, a throughput limit, or memory latency, and then restructure the code to target that specific constraint rather than applying optimizations blindly.
