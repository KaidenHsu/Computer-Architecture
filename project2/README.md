# Project 2. Loop Unrolling and Multiple Accumulators

## Usage

``` bash
$ ./task1_baseline.sh
$ ./task2_unrolled2.sh
$ ./task2_accum4.sh
$ ./task5_sen_accum2.sh
$ ./task5_sen_unrolled4
```

## gem5 Results

| Method | Metric | 64 (TimingSimpleCPU) | 128 (TimingSimpleCPU) | 256 (TimingSimpleCPU) | 64 (MinorCPU) | 128 (MinorCPU) | 256 (MinorCPU) |
|---|---|---:|---:|---:|---:|---:|---:|
| baseline | simTicks | 3,796,890,500 | 69,145,992,500 | 683,895,369,500 | 2,459,738,000 | 65,330,726,000 | 683,895,369,500 |
| baseline | simInsts | 5,009,751 | 31,249,382 | 238,959,804 | 5,009,954 | 31,249,312 | 238,959,804 |
| baseline | checksum | 4954776778722876215 | 14888976725022512033 | 8784188603516690629 | 4954776778722876215 | 14888976725022512033 | 8784188603516690629 |
| baseline | correctness | yes | yes | yes | yes | yes | yes |
| unrolled2 | simTicks | 3,767,940,000 | ***73,302,017,500*** | ***862,116,301,500*** | 2,285,261,500 | ***66,310,263,000*** | ***805,770,982,000*** |
| unrolled2 | simInsts | 4,768,177 | 29,210,597 | 222,390,199 | 4,768,365 | 29,210,577 | 222,390,224 |
| unrolled2 | checksum | 4954776778722876215 | 14888976725022512033 | 8784188603516690629 | 4954776778722876215 | 14888976725022512033 | 8784188603516690629 |
| unrolled2 | correctness | yes | yes | yes | yes | yes | yes |
| unrolled4 | simTicks | 3,708,877,500 | ***97,506,505,000*** | ***1,237,411,476,500*** | 2,225,538,500 | ***80,919,277,000*** | ***1,005,057,351,500*** |
| unrolled4 | simInsts | 4,653,927 | 28,228,086 | 214,264,328 | 4,654,159 | 28,228,126 | 214,264,405 |
| unrolled4 | checksum | 4954776778722876215 | 14888976725022512033 | 8784188603516690629 | 4954776778722876215 | 14888976725022512033 | 8784188603516690629 |
| unrolled4 | correctness | yes | yes | yes | yes | yes | yes |
| accum2 | simTicks | 3,674,980,000 | ***72,316,246,500*** | ***853,868,468,000*** | ***2,552,756,000*** | ***66,151,433,500*** | ***803,935,136,000*** |
| accum2 | simInsts | 4,792,806 | 29,308,775 | 222,782,813 | 4,793,037 | 29,308,809 | 222,782,867 |
| accum2 | checksum | 4954776778722876215 | 14888976725022512033 | 8784188603516690629 | 4954776778722876215 | 14888976725022512033 | 8784188603516690629 |
| accum2 | correctness | yes | yes | yes | yes | yes | yes |
| accum4 | simTicks | 3,547,963,500 | ***96,045,579,500*** | ***1,225,734,373,000*** | 2,214,330,500 | ***79,423,389,500*** | ***989,480,707,500*** |
| accum4 | simInsts | 4,694,512 | 28,391,452 | 214,919,382 | 4,682,842 | 28,391,556 | 214,919,380 |
| accum4 | checksum | 4954776778722876215 | 14888976725022512033 | 8784188603516690629 | 4954776778722876215 | 14888976725022512033 | 8784188603516690629 |
| accum4 | correctness | yes | yes | yes | yes | yes | yes |

* Note: ***Bold-italic values*** represent performance degradation compared to baseline.
* this experiment is based on **-O2** optimization

## Conclusion

- **Loop unrolling alone**
    - Slightly decreases instruction count (`simInsts`).
    - Runtime (`simTicks`):
        - `N = 64`: slightly decreases.
        - `N = 128` or `N = 256`: increases significantly.
    - Likely reason: the working set exceeds the L1 data cache capacity (32 KiB), which increases memory pressure.

- **Address calculation simplification (`A_idx`, `B_idx`) alone**
    - Slightly decreases instruction count (`simInsts`), especially for small `N`.
    - Runtime (`simTicks`) changes only marginally.
    - The unsimplified version is not included in this submission.

- **Multiple accumulators alone**
    - Slightly increases instruction count (`simInsts`).
    - Runtime (`simTicks`):
        - Slightly increases at `N = 64` due to overhead.
        - Slightly decreases at `N = 128` and `N = 256` due to improved ILP from breaking the dependency chain.
## Design

### gemm_baseline

``` cpp
int row_base = i * N;
for (int j = 0; j < N; ++j) {
    int32_t sum = 0;
    for (int k = 0; k < N; ++k) {
        sum += A[row_base + k] * B[k * N + j];
    }
    C[row_base + j] = sum;
}
```

### gemm_unrolled2

``` cpp
int row_base = i * N;
for (int j = 0; j < N; ++j) {
    int32_t sum = 0;
    int k = 0;

    // unrolled by 2
    int A_idx = row_base;
    int B_idx = j;

    for (; k + 1 < N; k += 2) {
        sum += A[A_idx] * B[B_idx];
        A_idx++;
        B_idx += N;

        sum += A[A_idx] * B[B_idx];
        A_idx++;
        B_idx += N;
    }

    // handle remaining product
    for (; k < N; ++k) {
        sum += A[A_idx] * B[B_idx];
        A_idx++;
        B_idx += N;
    }

    // write to element
    C[row_base + j] = sum;
}
```

### gemm_accum4

``` cpp
int row_base = i * N;
for (int j = 0; j < N; ++j) {
    int32_t sum = 0;
    int k = 0;

    // unrolled by 2
    int A_idx = row_base;
    int B_idx = j;

    for (; k + 1 < N; k += 2) {
        sum += A[A_idx] * B[B_idx];
        A_idx++;
        B_idx += N;

        sum += A[A_idx] * B[B_idx];
        A_idx++;
        B_idx += N;
    }

    // handle remaining product
    for (; k < N; ++k) {
        sum += A[A_idx] * B[B_idx];
        A_idx++;
        B_idx += N;
    }

    // write to element
    C[row_base + j] = sum;
}
```

## Analysis

``` bash
$ ./task6_disassemble.sh
```

### gemm_baseline

``` asm
// ======================= O(N^3) ==========================
        for (int k = 0; k < N; ++k) {
109b8:	0711                	addi	a4,a4,4
109ba:	96aa                	add	a3,a3,a0

            sum += A[row_base + k] * B[k * N + j];
109bc:	02b787bb          	mulw	a5,a5,a1
109c0:	9e3d                	addw	a2,a2,a5

        for (int k = 0; k < N; ++k) {
109c2:	ff0719e3          	bne	a4,a6,109b4 <gemm_baseline(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0x2c>
// ======================= END O(N^3) ==========================
```

### gemm_unrolled2

``` asm
// ======================= O(N^3) ==========================
            sum += A[A_idx] * B[B_idx];
10aa8:	0005aa03          	lw	s4,0(a1) // load A[A_idx]
10aac:	00082703          	lw	a4,0(a6) // load B[B_idx]

            sum += A[A_idx] * B[B_idx];
10ab0:	00680433          	add	s0,a6,t1 // calcualte address for B[B_idx+N]
10ab4:	41d4                	lw	a3,4(a1) // load A[A_idx+1]
10ab6:	4000                	lw	s0,0(s0) // load B[B_idx+1]

            sum += A[A_idx] * B[B_idx];
10ab8:	0347073b          	mulw	a4,a4,s4 // a4 = A[A_idx] * B[B_idx]

        for (; k + 1 < N; k += 2) {
10abc:	05a1                	addi	a1,a1,8 // A_idx += 2
10abe:	9872                	add	a6,a6,t3 // B_idx += 2*N

            sum += A[A_idx] * B[B_idx];
10ac0:	028686bb          	mulw	a3,a3,s0 // a3 = A[A_idx+1] * B[B_idx+N]
            sum += A[A_idx] * B[B_idx];
10ac4:	9f3d                	addw	a4,a4,a5 // 
            sum += A[A_idx] * B[B_idx];
10ac6:	00e687bb          	addw	a5,a3,a4 // a5 = A[A_idx]*B[B_idx] + A[A_idx+1]*B[B_idx+N]



        for (; k + 1 < N; k += 2) {
10aca:	fcbf9fe3          	bne	t6,a1,10aa8 <gemm_unrolled2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0xb2>
// ======================= END O(N^3) ==========================
```

### gemm_accum2

``` asm
// ======================= O(N^3) ==========================
            s1 += A[A_idx] * B[B_idx];
10f22:	01158a33          	add	s4,a1,a7
            s0 += A[A_idx] * B[B_idx];
10f26:	4218                	lw	a4,0(a2)
10f28:	419c                	lw	a5,0(a1)
            s1 += A[A_idx] * B[B_idx];
10f2a:	00462d03          	lw	s10,4(a2)
10f2e:	000a2a03          	lw	s4,0(s4)
            s0 += A[A_idx] * B[B_idx];
10f32:	02e787bb          	mulw	a5,a5,a4

        for (; k + 1 < N; k += 2) {
10f36:	0621                	addi	a2,a2,8

10f38:	95fa                	add	a1,a1,t5
            s1 += A[A_idx] * B[B_idx];
10f3a:	034d0a3b          	mulw	s4,s10,s4
            s0 += A[A_idx] * B[B_idx];
10f3e:	0067833b          	addw	t1,a5,t1
            s1 += A[A_idx] * B[B_idx];
10f42:	01da0ebb          	addw	t4,s4,t4



        for (; k + 1 < N; k += 2) {
10f46:	fd861ee3          	bne	a2,s8,10f22 <gemm_accum2(std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> > const&, std::vector<int, std::allocator<int> >&, int)+0xb0>
10f4a:	6a42                	ld	s4,16(sp)
10f4c:	6d22                	ld	s10,8(sp)
// ======================= END O(N^3) ==========================
```

### Final Verdict

* From the disassembled kernels, we can observe that for **-O2** compiler optimization, both the **unrolled** and **accum** versions generate equivalent assembly instructions.
* Therefore, there is no noticeable difference between the two versions (it is unclear why **accum** versions’ **simTicks** is slightly lower than that of **unroll**)
