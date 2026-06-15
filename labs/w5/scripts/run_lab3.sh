#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=/work
GEM5=${GEM5:-/opt/gem5/build/RISCV/gem5.opt}
SEPY=${SEPY:-/opt/gem5/configs/deprecated/example/se.py}
OUT=${OUT:-m5out}

mkdir -p "$ROOT_DIR/$OUT"

for acc in 1 2 4 8; do
  "$GEM5" -d "$ROOT_DIR/$OUT/lab3_acc${acc}" "$SEPY" --cpu-type=O3CPU --caches --l1i_size=32kB \
    --l1d_size=32kB --cmd="$ROOT_DIR/build/lab3_accumulators.riscv" --options="$acc 400000"
done

for acc in 1 2 4 8; do
  echo "== accumulators=${acc} ==" | tee -a "$ROOT_DIR/logs/lab3.log"
  python3 $ROOT_DIR/scripts/parse_stats.py "$ROOT_DIR/$OUT/lab3_acc${acc}/stats.txt"  | tee -a "$ROOT_DIR/logs/lab3.log"
  echo
done
