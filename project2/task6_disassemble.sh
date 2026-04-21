#!/usr/bin/env bash
set -euo pipefail

# get script directory instead of current directory
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
OUT_DIR="${ROOT_DIR}/disasm"

# compiles gemm_debug.riscv
make debug

mkdir -p $OUT_DIR

# -d, --d: disassemble executable sections
# -S, --source: interleaves source
# -C: demangle low-level symbol names into user-level names
riscv64-linux-gnu-objdump -dSC "${ROOT_DIR}/gemm_debug.riscv" > "${OUT_DIR}/gemm_dbg.asm"
