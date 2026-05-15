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

void zero_matrix(std::vector<int32_t>& M) {
    for (size_t i = 0; i < M.size(); ++i) {
        M[i] = 0;
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

void transpose_matrix(const std::vector<int32_t>& B,
                      std::vector<int32_t>& BT,
                      int N) {
    for (int r = 0; r < N; ++r) {
        for (int c = 0; c < N; ++c) {
            BT[idx(c, r, N)] = B[idx(r, c, N)];
        }
    }
}

void gemm_transpose_b(const std::vector<int32_t>& A,
                      const std::vector<int32_t>& B,
                      std::vector<int32_t>& C,
                      int N) {
    std::vector<int32_t> BT(N * N);
    transpose_matrix(B, BT, N);

    // TODO: Replace this placeholder with the intended transpose-B GEMM.
    // Required idea: in the inner k loop, access A[i][k] and BT[j][k]
    // with unit stride. The current fallback is correct, but it does not
    // demonstrate the intended memory-system transformation.

    // gemm_baseline(A, B, C, N);

    for (int i = 0; i < N; ++i) {
        int row_base = i * N;
        for (int j = 0; j < N; ++j) {
            int col_base = j * N;
            int32_t sum = 0;
            for (int k = 0; k < N; ++k) {
                sum += A[row_base + k] * BT[col_base + k];
            }
            C[row_base + j] = sum;
        }
    }
}

void gemm_ikj_stream(const std::vector<int32_t>& A,
                     const std::vector<int32_t>& B,
                     std::vector<int32_t>& C,
                     int N) {
    zero_matrix(C);

    // TODO: Replace this placeholder with the intended i-k-j loop order.
    // Required idea: load A[i][k] once, then stream across B[k][j] and C[i][j]
    // using unit-stride accesses in the inner j loop. The current fallback is
    // correct, but it does not demonstrate the intended memory-system transformation.

    // gemm_baseline(A, B, C, N);

    for (int i = 0; i < N; ++i) {
        int AC_base = i * N;
        for (int k = 0; k < N; ++k) {
            int32_t input_stationary = A[idx(i, k, N)];
            int B_base = k * N;
            for (int j = 0; j < N; ++j) {
                C[AC_base + j] += input_stationary * B[B_base + j];
            }
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

    if (N <= 0) {
        std::cerr << "N must be positive\n";
        return 1;
    }

    std::vector<int32_t> A(N * N), B(N * N), C(N * N), Cref(N * N);

    init_matrix(A, N, 1);
    init_matrix(B, N, 2);

    auto t0 = std::chrono::high_resolution_clock::now();

    if (mode == "baseline") {
        gemm_baseline(A, B, C, N);
    } else if (mode == "transpose_b") {
        gemm_transpose_b(A, B, C, N);
    } else if (mode == "ikj_stream") {
        gemm_ikj_stream(A, B, C, N);
    } else {
        std::cerr << "Unknown mode. Use: baseline | transpose_b | ikj_stream\n";
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
