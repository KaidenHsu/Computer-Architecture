#include <chrono>
#include <cstdint>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

static inline int idx(int r, int c, int N) {
    return r * N + c;
}

void init_matrix(std::vector<int32_t>& M, int N, int seed_base) {
    for (int i = 0; i < N * N; ++i) {
        M[i] = (i * 17 + seed_base * 13) % 97;
    }
}

void gemm_baseline(const std::vector<int32_t>& A,
                   const std::vector<int32_t>& B,
                   std::vector<int32_t>& C,
                   int N) {
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            int32_t sum = 0;
            for (int k = 0; k < N; ++k) {
                sum += A[idx(i, k, N)] * B[idx(k, j, N)];
            }
            C[idx(i, j, N)] = sum;
        }
    }
}

// my proposed instruction
static inline void dmac (int32_t &sum,
    int32_t a0, int32_t a1, int32_t b0, int32_t b1) {
    sum += (a0 * b0) + (a1 * b1);
}

/*
 * Students will modify this function for their Week 4 approximation study.
 * The result must remain mathematically identical to gemm_baseline().
 */
void gemm_approx(const std::vector<int32_t>& A,
                 const std::vector<int32_t>& B,
                 std::vector<int32_t>& C,
                 int N) {
    // 1. Calculate the padded dimension (Round UP to the next even number)
    // If N is 65, padded_N becomes 66. If N is 64, padded_N stays 64.
    int padded_N = (N + 1) & ~1; 

    // 2. microarchitecture tax: memory allocation, cache pollution
    std::vector<int32_t> pad_A(padded_N * padded_N, 0);
    std::vector<int32_t> pad_B(padded_N * padded_N, 0);
    std::vector<int32_t> pad_BT(padded_N * padded_N, 0); 

    // copy original data into the top-left of the padded buffers
    for (int i = 0; i < N; ++i) {
        for (int j = 0; j < N; ++j) {
            pad_A[idx(i, j, padded_N)] = A[idx(i, j, N)];
            pad_B[idx(i, j, padded_N)] = B[idx(i, j, N)];
        }
    }

    // 3. matrix transposition O(N^2)
    // I adjusted the B matrix data layout, which MASSIVELY mitigates
    // the L1-d$ miss and significantly improves performance 
    for (int i = 0; i < padded_N; i += 2) {
        for (int j = 0; j < padded_N; j += 2) {
            // SWAR (SIMD within a Register)
            uint64_t r0 = *reinterpret_cast<const uint64_t*>(&pad_B[idx(i,     j, padded_N)]);
            uint64_t r1 = *reinterpret_cast<const uint64_t*>(&pad_B[idx(i + 1, j, padded_N)]);

            uint64_t out0 = (r0 & 0xFFFFFFFF) | (r1 << 32);
            uint64_t out1 = (r0 >> 32)        | (r1 & 0xFFFFFFFF00000000);

            // write 2 transposed elements per cycle
            *reinterpret_cast<uint64_t*>(&pad_BT[idx(j,     i, padded_N)]) = out0;
            *reinterpret_cast<uint64_t*>(&pad_BT[idx(j + 1, i, padded_N)]) = out1;
        }
    }

    // 4. matrix multiplication O(N^3)
    for (int i = 0; i < N; ++i) {
        int32_t row_offset_padded = i * padded_N;
        int32_t row_offset_original = i * N;
        
        for (int j = 0; j < N; ++j) {
            int32_t sum = 0;
            int32_t A_offset = row_offset_padded;
            int32_t B_offset = j * padded_N;

            // use padded_N for the inner dot product to allow the
            // 64-bit load to safely pull the padded '0' at the edge.
            for (int k = 0; k < padded_N; k += 2) {
                uint64_t valA = *reinterpret_cast<const uint64_t*>(&pad_A[A_offset]);
                uint64_t valB = *reinterpret_cast<const uint64_t*>(&pad_BT[B_offset]);

                int32_t a0 = static_cast<int32_t>(valA & 0xFFFFFFFF);
                int32_t a1 = static_cast<int32_t>(valA >> 32);
                int32_t b0 = static_cast<int32_t>(valB & 0xFFFFFFFF);
                int32_t b1 = static_cast<int32_t>(valB >> 32);

                sum += (a0 * b0) + (a1 * b1);

                A_offset += 2;
                B_offset += 2;
            }
            
            // direct write to the final memory location without cache pollution
            C[row_offset_original + j] = sum;
        }
    }
}

uint64_t checksum(const std::vector<int32_t>& M) {
    uint64_t s = 0;
    for (auto v : M) {
        s = (s * 1315423911ull) ^ static_cast<uint32_t>(v);
    }
    return s;
}

bool verify_equal(const std::vector<int32_t>& X,
                  const std::vector<int32_t>& Y) {
    if (X.size() != Y.size()) return false;
    for (size_t i = 0; i < X.size(); ++i) {
        if (X[i] != Y[i]) return false;
    }
    return true;
}

int main(int argc, char** argv) {
    int N = 128;
    std::string mode = "baseline";

    if (argc >= 2) N = std::atoi(argv[1]);
    if (argc >= 3) mode = argv[2];

    std::vector<int32_t> A(N * N), B(N * N), C(N * N), Cref(N * N);

    init_matrix(A, N, 1);
    init_matrix(B, N, 2);

    auto t0 = std::chrono::high_resolution_clock::now();

    if (mode == "baseline") {
        gemm_baseline(A, B, C, N);
    } else if (mode == "approx") {
        gemm_approx(A, B, C, N);
    } else {
        std::cerr << "Unknown mode. Use: baseline | approx\n";
        return 1;
    }

    auto t1 = std::chrono::high_resolution_clock::now();
    double ms = std::chrono::duration<double, std::milli>(t1 - t0).count();

    gemm_baseline(A, B, Cref, N);
    bool ok = verify_equal(C, Cref);

    std::cout << "N=" << N << "\n";
    std::cout << "mode=" << mode << "\n";
    std::cout << "checksum=" << checksum(C) << "\n";
    std::cout << "correct=" << (ok ? "yes" : "no") << "\n";
    std::cout << "host_ms=" << std::fixed << std::setprecision(3) << ms << "\n";

    return ok ? 0 : 2;
}
