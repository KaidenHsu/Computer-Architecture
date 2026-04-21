RISCV_CXX ?= riscv64-linux-gnu-g++
CXXFLAGS = -O2 -std=c++17 -static
DEBUG_CXXFLAGS = -g -O2 -std=c++17 -static

all: gemm.riscv

debug: gemm_debug.riscv

gemm.riscv: gemm.cpp
	$(RISCV_CXX) $(CXXFLAGS) gemm.cpp -o gemm.riscv

gemm_debug.riscv: gemm.cpp
	$(RISCV_CXX) $(DEBUG_CXXFLAGS) gemm.cpp -o gemm_debug.riscv

clean:
	rm -f gemm.riscv gemm_debug.riscv
