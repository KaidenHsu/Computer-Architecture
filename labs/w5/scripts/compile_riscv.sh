#!/usr/bin/env bash
set -euo pipefail

find_compiler() {
  for cc in riscv64-linux-gnu-gcc riscv64-unknown-linux-gnu-gcc riscv64-unknown-elf-gcc; do
    if command -v "$cc" >/dev/null 2>&1; then
      echo "$cc"
      return 0
    fi
  done
  echo "No RISC-V cross-compiler found." >&2
  exit 1
}

ROOT_DIR=/work

CC=$(find_compiler)
CFLAGS="-O2 -static -std=c11"

echo "Using compiler: $CC"
$CC $CFLAGS -o "${ROOT_DIR}/build/lab1_ilp.riscv" "${ROOT_DIR}/src/lab1_ilp.c"
$CC $CFLAGS -o "${ROOT_DIR}/build/lab2_ooo.riscv" "${ROOT_DIR}/src/lab2_ooo.c"
$CC $CFLAGS -o "${ROOT_DIR}/build/lab3_accumulators.riscv" "${ROOT_DIR}/src/lab3_accumulators.c"

echo "Built:"
ls -lh *.riscv
