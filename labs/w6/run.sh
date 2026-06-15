#!/usr/bin/env bash
set -euo pipefail

# get script directory instead of current directory
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

mkdir -p "${ROOT_DIR}/build" "${ROOT_DIR}/logs"

printf "\n"
echo "==============================="
echo "        compiliing..."
echo "==============================="
bash "${ROOT_DIR}/scripts/compile_riscv.sh"

printf "\n\n"
echo "==============================="
echo "     lab 1: branch patterns"
echo "==============================="
bash "$ROOT_DIR/scripts/run_lab1.sh"

printf "\n\n"
echo "==============================="
echo "  lab 2: branch predictability"
echo "==============================="
bash "$ROOT_DIR/scripts/run_lab2.sh"

printf "\n\n"
echo "=============================="
echo "     lab 3: control flow"
echo "=============================="
bash "$ROOT_DIR/scripts/run_lab3.sh"
