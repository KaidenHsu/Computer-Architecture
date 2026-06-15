# Week 6 Lab. Branch Patterns, Predictability, and Control Flow

## 1. Introduction

This lab explores **how branch prediction affects CPU performance** by running three exercises that progressively isolate different sources of prediction overhead — branch pattern regularity, predictability, and direct versus indirect control flow. Students will learn to recognize which code patterns stress the branch predictor, interpret simulation metrics such as IPC and cycle count to quantify that stress, and connect low-level microarchitectural behavior to decisions made at the source-code level.

## 2. Workflow

``` bash
$ bash run.sh
```

## 3. Lab Exercise 1: Branch Pattern Sensitivity

### 3.1 Loop

A counter `x` starts at 128 and decrements each iteration; the branch is taken 127 out of every 128 times, creating a highly predictable, mostly-taken pattern that modern predictors learn quickly.

``` c
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
```

### 3.2 Alternating Branch

The branch alternates on every iteration based on whether `i` is odd or even, producing a perfectly regular T/N/T/N pattern that a 2-bit saturating counter predictor can track with near-zero mispredictions.

``` c
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
```

### 3.3 Correlated Branches

A driver signal derived from `i` periodically flips `prev_taken`, so the second branch's outcome depends on the first branch's history — testing whether the predictor can exploit inter-branch correlation.

``` c
static uint64_t run_corr(long iters) {
    uint64_t acc = 0;
    int prev_taken = 1;
    for (long i = 0; i < iters; ++i) {
        int driver = ((i >> 2) ^ i) & 1;
        if (driver) prev_taken = !prev_taken;

        if (prev_taken) {
            acc += (uint64_t)i + 7;
        } else {
            acc ^= ((uint64_t)i * 5) + 9;
        }
    }
    return acc;
}
```

### 3.4 Results

| Mode | sim_insts | sim_seconds | num_cycles | IPC |
|------|----------:|------------:|-----------:|----:|
| loop | 7,323,981 | 0.001713 | 3,425,093 | 2.138 |
| alt | 7,717,401 | 0.001869 | 3,738,245 | 2.064 |
| corr | 9,317,497 | 0.002069 | 4,138,013 | 2.252 |

- All three modes achieve similar IPC (2.06–2.25), showing the predictor handles all patterns well.
- `loop` is easiest — the branch is taken 127/128 times, so a simple saturating counter stays biased taken.
- `alt` is slightly harder since the predictor must switch direction every iteration, costing a small IPC dip.
- `corr` has the most instructions because it contains two branches per iteration (the `driver` check and the `prev_taken` check), but its IPC is the highest, suggesting the two-level history provides strong correlation signal.

## 4. Lab Exercise 2: Predictable vs Unpredictable Branches

### 4.1 Workload Design

Runs the same arithmetic workload under two branch patterns — `pred` (taken 63/64 times, easily learned) and `unpred` (random coin flip) — to isolate the cycle cost of branch mispredictions on otherwise identical code.

``` c
int main(int argc, char **argv) {
    // ...
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

        if (take) {
            acc = payload_a(acc + (uint64_t)i);
        } else {
            acc = payload_b(acc ^ (uint64_t)(i * 3 + 1));
        }

        // independent work to expose speculative opportunity / waste
        acc += (uint64_t)(i * 13 + 7);
        acc ^= (acc << 3);
    }

    // ...
}
```

### 4.2 Result

| Mode | sim_insts | sim_seconds | num_cycles | IPC |
|------|----------:|------------:|-----------:|----:|
| pred | 60,078,874 | 0.008862 | 17,723,251 | 3.390 |
| unpred | 87,367,716 | 0.014940 | 29,880,535 | 2.924 |

`unpred` uses 69% more cycles (29.9M vs 17.7M) and executes 45% more instructions (87.4M vs 60.1M) despite running the same number of iterations. The extra instructions come from pipeline flushes — when the predictor guesses wrong on the `xorshift32`-driven coin flip (~50% of the time), the speculatively executed work is discarded and the correct path must be re-fetched and re-executed. The IPC drop (3.390 → 2.924) reflects the CPU spending more cycles stalled on mispredict recovery rather than doing useful work. `pred`'s `(i & 63) != 0` pattern, taken 63/64 times, is learned almost instantly, keeping the pipeline full.

## 5. Lab Exercise 3: Direct vs Indirect Control Flow

### 5.1 Direct Control Flow

Calls four fixed functions (`step_a`–`step_d`) in a hard-coded sequence every iteration; the call targets are compile-time constants, so the CPU's branch target buffer can predict them with no overhead.

``` c
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
```

### 5.2 Indirect Control Flow

Selects a function from a table using a computed index `(i ^ (i >> 2)) & 3`, making each call target data-dependent and forcing the indirect branch predictor to track a non-trivial pattern.

``` c
static uint64_t run_indirect(long iters) {
    uint64_t x = 1;
    fn_t table[4] = {step_a, step_b, step_c, step_d};
    for (long i = 0; i < iters * 4; ++i) {
        fn_t f = table[(i ^ (i >> 2)) & 3];
        x = f(x, (uint64_t)i);
    }
    return x;
}
```

### 5.3 Result

| Mode | sim_insts | sim_seconds | num_cycles | IPC |
|------|----------:|------------:|-----------:|----:|
| direct | 14,118,455 | 0.003319 | 6,637,217 | 2.127 |
| indirect | 22,368,596 | 0.005881 | 11,762,779 | 1.902 |

- `indirect` runs `iters * 4` iterations (vs `iters * 4` fixed calls in `direct`), so both modes make the same total number of `step_*` calls — the higher instruction count (22.4M vs 14.1M) reflects the overhead of loading and dereferencing the function pointer each iteration.
- `indirect` uses 77% more cycles (11.8M vs 6.6M) with a lower IPC (1.902 vs 2.127). In `direct`, the four call targets are encoded as fixed addresses at compile time, so the branch target buffer predicts them with zero misses.
- In `indirect`, the target is computed as `table[(i ^ (i >> 2)) & 3]` at runtime — the bit-mixing makes the sequence non-trivially periodic, causing frequent indirect branch mispredictions and pipeline stalls.

## 6. Conclusion

The three labs together paint a consistent picture of where branch prediction overhead actually lives.

**Lab 1** showed that the predictor handles structural regularity well regardless of pattern shape — loop, alternating, and correlated branches all landed within a narrow 2.06–2.25 IPC band. The correlated mode, despite having two branches per iteration, achieved the highest IPC (2.252), confirming that a history-based predictor exploits inter-branch correlation effectively.

**Lab 2** revealed the true cost of unpredictability: replacing a 63/64-taken pattern with a random coin flip increased cycle count by 69% (17.7M → 29.9M) and inflated instruction count by 45% (60.1M → 87.4M) due to pipeline flushes forcing re-execution of discarded speculative work. IPC dropped from 3.390 to 2.924 — the gap is entirely attributable to mispredict recovery stalls, since the arithmetic payload is identical.

**Lab 3** showed that indirect branches carry overhead even when the dispatch sequence is periodic. Switching from direct calls to function-pointer dispatch through a `(i ^ (i >> 2)) & 3` index increased cycles by 77% (6.6M → 11.8M) and dropped IPC from 2.127 to 1.902. The extra instruction count (14.1M → 22.4M) reflects the pointer load and dereference overhead on top of the target mispredictions themselves.

Going forward, avoid function pointer dispatch in tight loops whenever the call targets can be statically encoded — the indirect branch predictor carries measurable overhead even for periodic patterns, and that cost compounds quickly at high iteration counts.
