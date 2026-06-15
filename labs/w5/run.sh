#!/usr/bin/env bash
set -euo pipefail

# get script directory instead of current directory
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

mkdir -p "${ROOT_DIR}/logs" "${ROOT_DIR}/build"

printf "\n\n"
echo "============================"
echo "          lab 1"
echo "============================"
bash $ROOT_DIR/scripts/run_lab1.sh

printf "\n\n"
echo "============================"
echo "          lab 2"
echo "============================"
bash $ROOT_DIR/scripts/run_lab2.sh

printf "\n\n"
echo "============================"
echo "          lab 3"
echo "============================"
bash $ROOT_DIR/scripts/run_lab3.sh
