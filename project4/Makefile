# Project 4 build file
# Build a RISC-V Linux ELF binary for gem5 SE mode.
# Do not use Make's default host C++ compiler here: gem5 RISCV cannot run x86-64 binaries.

CXX := riscv64-linux-gnu-g++
CXXFLAGS := -O2 -std=c++17 -static -g -Wall -Wextra -march=rv64gc -mabi=lp64d

OBJDUMP := riscv64-linux-gnu-objdump
OBJDUMP_FLAGS := -d -S -C

TARGET := gemm_accel.riscv
SRC := src/gemm_accel.cpp
HDR := src/accel_model.h

all: $(TARGET)

$(TARGET): $(SRC) $(HDR)
	$(CXX) $(CXXFLAGS) $(SRC) -o $(TARGET)
	@echo "Built $(TARGET)"
	@file $(TARGET)

check-binary: $(TARGET)
	@file $(TARGET) | grep -q "RISC-V" && echo "OK: $(TARGET) is a RISC-V ELF binary" || \
	  (echo "ERROR: $(TARGET) is not a RISC-V binary"; file $(TARGET); exit 1)

inspect_asm: $(TARGET)
	$(OBJDUMP) $(OBJDUMP_FLAGS) $(TARGET) > src/gemm_accel.asm

clean:
	rm -f $(TARGET) *.o *.riscv
