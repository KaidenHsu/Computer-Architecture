#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=/work

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

CC=$(find_compiler)
CFLAGS="-O2 -static -std=c11 -fno-inline -fno-omit-frame-pointer"

echo "Using compiler: $CC"
$CC $CFLAGS -o "${ROOT_DIR}/build/lab1_branch_patterns.riscv" "${ROOT_DIR}/src/lab1_branch_patterns.c"
$CC $CFLAGS -o "${ROOT_DIR}/build/lab2_speculation.riscv"     "${ROOT_DIR}/src/lab2_speculation.c"
$CC $CFLAGS -o "${ROOT_DIR}/build/lab3_targets.riscv"         "${ROOT_DIR}/src/lab3_targets.c"
#$CC $CFLAGS -o custom_ext/custom_demo.riscv custom_ext/custom_demo.c

echo "Built:"
find . -maxdepth 2 -name '*.riscv' -type f -print | sort | xargs ls -lh
