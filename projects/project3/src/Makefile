RISCV_CXX ?= riscv64-linux-gnu-g++
CXXFLAGS = -O2 -std=c++17 -static

all: gemm.riscv

gemm.riscv: gemm.cpp
	$(RISCV_CXX) $(CXXFLAGS) gemm.cpp -o gemm.riscv

host: gemm.cpp
	g++ -O2 -std=c++17 gemm.cpp -o gemm.host

clean:
	rm -f gemm.riscv gemm.host
