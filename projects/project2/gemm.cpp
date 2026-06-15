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
        int row_base = i * N;
        for (int j = 0; j < N; ++j) {
            int32_t sum = 0;
            for (int k = 0; k < N; ++k) {
                sum += A[row_base + k] * B[k * N + j];
            }
            C[row_base + j] = sum;
        }
    }
}

void gemm_unrolled2(const std::vector<int32_t>& A,
                    const std::vector<int32_t>& B,
                    std::vector<int32_t>& C,
                    int N) {
    for (int i = 0; i < N; ++i) {
        int row_base = i * N;
        for (int j = 0; j < N; ++j) {
            int32_t sum = 0;
            int k = 0;

            // TODO: student implementation
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
    }
}

// sensitivity analysis
void gemm_unrolled4(const std::vector<int32_t>& A,
                    const std::vector<int32_t>& B,
                    std::vector<int32_t>& C,
                    int N) {
    for (int i = 0; i < N; ++i) {
        int row_base = i * N;
        for (int j = 0; j < N; ++j) {
            int32_t sum = 0;
            int k = 0;

            int A_idx = row_base;
            int B_idx = j;

            for (; k + 3 < N; k += 4) {
                sum += A[A_idx] * B[B_idx];
                A_idx++;
                B_idx += N;

                sum += A[A_idx] * B[B_idx];
                A_idx++;
                B_idx += N;

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
    }
}

void gemm_accum4(const std::vector<int32_t>& A,
                 const std::vector<int32_t>& B,
                 std::vector<int32_t>& C,
                 int N) {
    for (int i = 0; i < N; ++i) {
        int row_base = i * N;
        for (int j = 0; j < N; ++j) {
            int32_t s0 = 0, s1 = 0, s2 = 0, s3 = 0;
            int k = 0;

            // TODO: student implementation
            // use 4 accumulators
            int A_idx = row_base;
            int B_idx = j;

            for (; k + 3 < N; k += 4) {
                s0 += A[A_idx] * B[B_idx];
                A_idx++;
                B_idx += N;

                s1 += A[A_idx] * B[B_idx];
                A_idx++;
                B_idx += N;

                s2 += A[A_idx] * B[B_idx];
                A_idx++;
                B_idx += N;

                s3 += A[A_idx] * B[B_idx];
                A_idx++;
                B_idx += N;
            }
            
            // handle remaining products
            int32_t tail = 0;
            for (; k < N; ++k) {
                tail += A[A_idx] * B[B_idx];
                A_idx++;
                B_idx += N;
            }

            // write to element
            C[row_base + j] = s0 + s1 + s2 + s3 + tail;
        }
    }
}

// sensitivity analysis
void gemm_accum2(const std::vector<int32_t>& A,
                 const std::vector<int32_t>& B,
                 std::vector<int32_t>& C,
                 int N) {
    for (int i = 0; i < N; ++i) {
        int row_base = i * N;
        for (int j = 0; j < N; ++j) {
            int32_t s0 = 0, s1 = 0;
            int k = 0;

            int A_idx = row_base;
            int B_idx = j;

            for (; k + 1 < N; k += 2) {
                s0 += A[A_idx] * B[B_idx];
                A_idx++;
                B_idx += N;

                s1 += A[A_idx] * B[B_idx];
                A_idx++;
                B_idx += N;
            }
            
            // handle remaining products
            int32_t tail = 0;
            for (; k < N; ++k) {
                tail += A[A_idx] * B[B_idx];
                A_idx++;
                B_idx += N;
            }

            // write to element
            C[row_base + j] = s0 + s1 + tail;
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

    std::vector<int32_t> A(N * N), B(N * N), C(N * N), Cref(N * N); // fill constructor

    init_matrix(A, N, 1);
    init_matrix(B, N, 2);

    auto t0 = std::chrono::high_resolution_clock::now();

    if (mode == "baseline") {
        gemm_baseline(A, B, C, N);
    } else if (mode == "unrolled2") {
        gemm_unrolled2(A, B, C, N);
    } else if (mode == "unrolled4") { // for sensitivity analysis
        gemm_unrolled4(A, B, C, N);
    } else if (mode == "accum2") { // for sensitivity analysis
        gemm_accum2(A, B, C, N);
    } else if (mode == "accum4") {
        gemm_accum4(A, B, C, N);
    } else {
        std::cerr << "Unknown mode. Use: baseline | raw_ptrs | unrolled2 | accum4 | accum2\n";
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
