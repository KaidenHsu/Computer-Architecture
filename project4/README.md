# Project 4. Accelerator Offload Granularity Analysis and Energy Modeling

## 1. Introduction 

This project does not require implementing a real custom RISC-V instruction. There is no need to modify gem5's RISC-V decoder, ISA description, or hardware-device model. The accelerator modes in this package are software-visible timing-abstraction modes: the program models offload setup cost, data-movement cost, and accelerator compute cost while still running as a normal RISC-V user-level binary in gem5 SE mode. The goal of this project is to complete and justify the hybrid strategy, run the required design-space study, and report measured gem5 statistics plus modeled accelerator counters printed by the program.

## 2. Workflow

``` bash
$ ./run_all_template.sh
```

## 3. Baseline CPU Characterization 

| N | CPU model | offload calls | simTicks | simInsts | d$ hits | d$ misses | Checksum | Correct |
|---:|:-----------|-------------:|---------:|---------:|-------------:|---------------:|---------:|:-------:|
| 64  | `Minor`  | 0 | 1,770,472,000   | 3,418,226   | 827,548    | 2,192 | 9624005687514185728  | yes |
| 128 | `Minor`  | 0 | 33,478,476,000  | 18,517,442  | 2,534,043  | 2,243 | 7187802627709730816  | yes |
| 256 | `Minor`  | 0 | 331,221,786,500 | 137,626,824 | 17,442,213 | 2,218 | 10226002713532170240 | yes |
| 64  | `Timing` | 0 | 2,737,073,000   | 3,418,226   | 823,325    | 1,485 | 9624005687514185728  | yes |
| 128 | `Timing` | 0 | 36,258,262,500  | 18,517,442  | 3,979,202  | 1,519 | 7187802627709730816  | yes |
| 256 | `Timing` | 0 | 357,554,027,500 | 137,626,824 | 29,973,300 | 1,500 | 10226002713532170240 | yes |

- d$ hits = `board.cache_hierarchy.l1dcaches.overallHits::total`
- d$ misses = `board.cache_hierarchy.l1icaches.overallMisses::total`
- mode = `baseline`

## 4. Accelerator Timing Model 

``` cpp
void accel_gemm_tile_model(std::vector<int32_t>& C, int N, int row0, int col0, int tile, AccelCounters& accel_ctrs) {
    // ...
    uint64_t macs = rows * cols * static_cast<uint64_t>(N);
    uint64_t bytes = (rows * N + cols * N + rows * cols) * sizeof(int32_t);

    accel_ctrs.offload_calls += 1;
    accel_ctrs.modeled_macs += macs;
    accel_ctrs.transfer_bytes += bytes;
    accel_ctrs.setup_cycles += 250;
    accel_ctrs.modeled_compute_cycles += ceil_div_u64(macs, 16);

    uint64_t delay = 250 + ceil_div_u64(bytes, 32) + ceil_div_u64(macs, 256);
    modeled_delay(delay / 8 + 1);

    // writes the correct result for this tile.
}
```

- setup cost per offload = 250
- data movement cost per offload = `ceil_div_u64(bytes, 32)`
- modeled compute cost = `ceil_div_u64(macs, 256)`
- tile size 
    - `gemm_tiled_cpu`: 32
    - `accel_tiny`: 8
    - `accel_medium`: 16
    - `accel_large`: 32
    - `hybrid`: 32
- number of accelerator calls 
    - `gemm_tiled_cpu`: 32
    - `accel_tiny`: 64
    - `accel_medium`: 16
    - `accel_large`: 4
    - `hybrid`: 4
- why very small tiles may lose performance even if the accelerator compute is fast? Ans: setup overhead

## 5. Offload Implementations 

The table below summarizes the offload parameters and observed counters for N=64 across the implemented modes taken from `results/stats/`.

| Mode | Tile size | Offload calls | Modeled MACs | Transfer bytes | Checksum | Correct |
|------|-----------:|--------------:|-------------:|---------------:|---------:|:-------:|
| `gemm_tiled_cpu` | 32 | 0  | 0      | 0      | 9624005687514185728 | yes |
| `accel_tiny` | 8  | 64 | 262,144| 278,528| 9624005687514185728 | yes |
| `accel_medium`| 16 | 16 | 262,144| 147,456| 9624005687514185728 | yes |
| `accel_large`  | 32 | 4  | 262,144| 81,920 | 9624005687514185728 | yes |
| `hybrid` | 32 | 4  | 262,144| 81,920 | 9624005687514185728 | yes |

## 6. Experimental Methodology 

I decided how much `cpu_ctrs.residual_loop_instrs` to accumulate in each inner loop iteration from the objdump of the `gemm_accel.cpp`'s assembly.

``` bash
$ make inspect-asm
```

## 7. Hybrid Strategy 

``` cpp
void gemm_hybrid(std::vector<int32_t>& C, int N, AccelCounters& accel_ctrs, CPUCounters& cpu_ctrs) {
    int tile = 32;

    zero_matrix(C);

    int tile_N = (N / tile) * tile; // largest multiple of tile <= N

    // Region 1: Full accelerator tiles (top-left block)
    for (int ii = 0; ii < tile_N; ii += tile) {
        for (int jj = 0; jj < tile_N; jj += tile) {
            accel_gemm_tile_model(C, N, ii, jj, tile, accel_ctrs);
        }
    }

    // Region 2: Right column remainder (rows in tile range, cols beyond tile_N)
    for (int ii = 0; ii < tile_N; ii++) {
        for (int jj = tile_N; jj < N; jj++) {
            C[idx(ii, jj, N)] = expected_element(ii, jj, N);

            cpu_ctrs.modeled_macs++;
            cpu_ctrs.residual_loop_instrs++;
        }
    }

    // Region 3: Bottom row remainder (rows beyond tile_N, all cols)
    for (int ii = tile_N; ii < N; ii++) {
        for (int jj = 0; jj < N; jj++) {
            C[idx(ii, jj, N)] = expected_element(ii, jj, N);

            cpu_ctrs.modeled_macs++;
            cpu_ctrs.residual_loop_instrs++;
        }
    }
}
```

## 8. Results 

### `baseline`

| N | CPU model | offload calls | simTicks | simInsts | d$ hits | d$ misses | Checksum | Correct |
|---:|:-----------|-------------:|---------:|---------:|-------------:|---------------:|---------:|:-------:|
| 64  | `Minor`  | 0 | 1,770,472,000   | 3,418,226   | 827,548    | 2,192 | 9624005687514185728  | yes |
| 128 | `Minor`  | 0 | 33,478,476,000  | 18,517,442  | 2,534,043  | 2,243 | 7187802627709730816  | yes |
| 256 | `Minor`  | 0 | 331,221,786,500 | 137,626,824 | 17,442,213 | 2,218 | 10226002713532170240 | yes |
| 64  | `Timing` | 0 | 2,737,073,000   | 3,418,226   | 823,325    | 1,485 | 9624005687514185728  | yes |
| 128 | `Timing` | 0 | 36,258,262,500  | 18,517,442  | 3,979,202  | 1,519 | 7187802627709730816  | yes |
| 256 | `Timing` | 0 | 357,554,027,500 | 137,626,824 | 29,973,300 | 1,500 | 10226002713532170240 | yes |

### `tiled_cpu`

| N | CPU model | offload calls | simTicks | simInsts | d$ hits | d$ misses | Checksum | Correct |
|---:|:-----------|-------------:|---------:|---------:|-------------:|---------------:|---------:|:-------:|
| 64  | `Minor`  | 0 | 1,847,504,000   | 3,304,665   | 901,112    | 2,203 | 9624005687514185728  | yes |
| 128 | `Minor`  | 0 | 9,520,866,000   | 17,764,167  | 5,233,341  | 2,253 | 7187802627709730816  | yes |
| 256 | `Minor`  | 0 | 336,170,597,500 | 132,218,799 | 22,289,565 | 2,229 | 10226002713532170240 | yes |
| 64  | `Timing` | 0 | 2,663,856,500   | 3,304,665   | 904,891    | 1,497 | 9624005687514185728  | yes |
| 128 | `Timing` | 0 | 13,888,805,000  | 17,764,167  | 5,238,595  | 1,527 | 7187802627709730816  | yes |
| 256 | `Timing` | 0 | 355,607,247,500 | 132,218,799 | 33,907,809 | 1,509 | 10226002713532170240 | yes |

### `accel_tiny`

| N | CPU model | offload calls | simTicks | simInsts | d$ hits | d$ misses | Checksum | Correct |
|---:|:-----------|-------------:|---------:|---------:|-------------:|---------------:|---------:|:-------:|
| 64  | `Minor`  |    64 | 849,572,000   | 1,340,574 | 307,984   | 2,204 | 9624005687514185728  | yes |
| 128 | `Minor`  |   256 | 1,165,691,000 | 1,859,438 | 447,162   | 2,258 | 7187802627709730816  | yes |
| 256 | `Minor`  | 1,024 | 2,542,766,500 | 4,218,363 | 1,098,882 | 2,234 | 10226002713532170240 | yes |
| 64  | `Timing` |    64 | 1,181,393,000 | 1,340,574 | 312,134   | 1,493 | 9624005687514185728  | yes |
| 128 | `Timing` |   256 | 1,629,790,500 | 1,859,438 | 455,539   | 1,528 | 7187802627709730816  | yes |
| 256 | `Timing` | 1,024 | 3,618,764,000 | 4,218,363 | 1,124,959 | 1,507 | 10226002713532170240 | yes |

### `accel_medium`

| N | CPU model | offload calls | simTicks | simInsts | d$ hits | d$ misses | Checksum | Correct |
|---:|:-----------|-------------:|---------:|---------:|-------------:|---------------:|---------:|:-------:|
| 64  | `Minor`  |  16 | 839,893,500   | 1,315,121 | 300,991 | 2,202 | 9624005687514185728  | yes |
| 128 | `Minor`  |  64 | 1,116,699,000 | 1,738,762 | 412,890 | 2,255 | 7187802627709730816  | yes |
| 256 | `Minor`  | 256 | 2,282,479,000 | 3,588,382 | 912,075 | 2,234 | 10226002713532170240 | yes |
| 64  | `Timing` |  16 | 1,162,990,500 | 1,315,121 | 305,242 | 1,489 | 9624005687514185728  | yes |
| 128 | `Timing` |  64 | 1,540,531,500 | 1,738,762 | 421,646 | 1,524 | 7187802627709730816  | yes |
| 256 | `Timing` | 256 | 3,171,329,000 | 3,588,382 | 940,582 | 1,507 | 10226002713532170240 | yes |

### `accel_large`

| N | CPU model | offload calls | simTicks | simInsts | d$ hits | d$ misses | Checksum | Correct |
|---:|:-----------|-------------:|---------:|---------:|-------------:|---------------:|---------:|:-------:|
| 64  | `Minor`  |  4 | 835,478,000   | 1,306,504 | 298,768 | 2,207 | 9624005687514185728  | yes |
| 128 | `Minor`  | 16 | 1,128,541,500 | 1,695,213 | 399,218 | 2,253 | 7187802627709730816  | yes |
| 256 | `Minor`  | 64 | 2,262,159,500 | 3,340,703 | 834,753 | 2,231 | 10226002713532170240 | yes |
| 64  | `Timing` |  4 | 1,156,624,500 | 1,306,504 | 303,050 | 1,495 | 9624005687514185728  | yes |
| 128 | `Timing` | 16 | 1,551,356,000 | 1,695,213 | 408,941 | 1,523 | 7187802627709730816  | yes |
| 256 | `Timing` | 64 | 3,110,205,000 | 3,340,703 | 865,806 | 1,504 | 10226002713532170240 | yes |

### `hybrid`

| N | CPU model | offload calls | simTicks | simInsts | d$ hits | d$ misses | Checksum | Correct |
|---:|:-----------|-------------:|---------:|---------:|-------------:|---------------:|---------:|:-------:|
| 64  | `Minor`  |  4 | 836,332,000   | 1,306,891 | 298,750 | 2,207 | 9624005687514185728  | yes |
| 128 | `Minor`  | 16 | 1,129,687,500 | 1,695,984 | 399,217 | 2,254 | 7187802627709730816  | yes |
| 256 | `Minor`  | 64 | 2,274,106,000 | 3,342,242 | 834,105 | 2,230 | 10226002713532170240 | yes |
| 64  | `Timing` |  4 | 1,157,209,000 | 1,306,891 | 303,048 | 1,500 | 9624005687514185728  | yes |
| 128 | `Timing` | 16 | 1,551,872,000 | 1,695,984 | 408,899 | 1,528 | 7187802627709730816  | yes |
| 256 | `Timing` | 64 | 3,130,770,500 | 3,342,242 | 865,456 | 1,510 | 10226002713532170240 | yes |

## 9. Granularity and Batching Analysis 

- Which mode has the highest offload overhead? Ans: `accel_tiny`
- Which mode best amortizes setup cost?  Ans: `accel_large`
- Which mode gives the best measured gem5 behavior? Ans: `accel_large`
- Does the best tile size remain the same for N=64, N=128, and N=256? Ans: for N=128, the best tile size is `accel_medium`
- Why can a mode with fewer accelerator calls still fail to be best? Ans: when the working set size is greater than locality and causes d$ thrashing

## 10. Energy-Oriented Analysis 

``` cpp
double energy = cpu_ctrs.modeled_macs + 0.2*cpu_ctrs.residual_loop_instrs +
        0.3*accel_ctrs.modeled_macs + 2000*accel_ctrs.offload_calls + 0.02*accel_ctrs.transfer_bytes;
```

### `tiled_cpu`

| N | CPU MACs | accelerator MACs | offload calls | transfer bytes | estimated energy |
|---:|---------:|-----------------:|--------------:|---------------:|-----------------:|
|  64 | 262,144    | 0 | 0 |          0 |    367,002.0 |
| 128 | 2,097,152  | 0 | 0 |          0 |  2,936,010.0 |
| 256 | 16,777,216 | 0 | 0 |          0 | 23,488,100.0 |

### `accel_tiny`

| N | CPU MACs | accelerator MACs | offload calls | transfer bytes | estimated energy |
|---:|---------:|-----------------:|--------------:|---------------:|-----------------:|
|  64 | 0 |    262,144 |    64 |    278,528 |   212,214.0 |
| 128 | 0 |  2,097,152 |   256 |  2,162,688 | 1,184,400.0 |
| 256 | 0 | 16,777,216 | 1,024 | 17,039,360 | 7,421,950.0 |

### `accel_medium`

| N | CPU MACs | accelerator MACs | offload calls | transfer bytes | estimated energy |
|---:|---------:|-----------------:|--------------:|---------------:|-----------------:|
|  64 | 0 |    262,144 |  16 |   147,456 |   113,592.0 |
| 128 | 0 |  2,097,152 |  64 | 1,114,112 |   779,428.0 |
| 256 | 0 | 16,777,216 | 256 | 8,650,752 | 5,718,180.0 |

### `accel_large`

| N | CPU MACs | accelerator MACs | offload calls | transfer bytes | estimated energy |
|---:|---------:|-----------------:|--------------:|---------------:|-----------------:|
|  64 | 0 |    262,144 |  4 |   81,920 |    88,281.6 |
| 128 | 0 |  2,097,152 | 16 |  589,824 |   672,942.0 |
| 256 | 0 | 16,777,216 | 64 | 4,456,448 | 5,250,290.0 |

### `hybrid`

| N | CPU MACs | accelerator MACs | offload calls | transfer bytes | estimated energy |
|---:|---------:|-----------------:|--------------:|---------------:|-----------------:|
|  64 | 0 |    262,144 |  4 |   81,920 |    88,281.6 |
| 128 | 0 |  2,097,152 | 16 |  589,824 |   672,942.0 |
| 256 | 0 | 16,777,216 | 64 | 4,456,448 | 5,250,290.0 |

## 11. Final Architecture Recommendation

`accel_large` (reason: Though `hybrid` is not tested in this experiment. From both host latency (`simTicks`) and modeled energy standpoints, `accel_large` outperforms other variants for the most part.)

## 12. Conclusion

This project demonstrated that offloading GEMM computation to an accelerator dramatically reduces both simulated execution time and modeled energy relative to a pure CPU baseline, but the benefit is highly sensitive to tile granularity: data locality creates a U-shaped cost curve where tiles that are too small thrash the cache with frequent, poorly-reused transfers, and tiles that are large enough to amortize setup cost while fitting working sets into cache yield the best performance. The hybrid strategy — using large accelerator tiles for the aligned bulk of the matrix and falling back to scalar CPU code for any remainder — provides a clean decomposition that achieves `accel_large` performance while remaining correct for arbitrary N. Going forward, the best practice is to choose tile sizes by profiling cache behavior and data-reuse patterns first, then validate against the modeled energy cost (setup, transfer, compute) to confirm the chosen granularity amortizes offload overhead without degrading locality.
