#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=/work
GEM5=${GEM5:-/opt/gem5/build/RISCV/gem5.opt}
SEPY=${SEPY:-/opt/gem5/configs/deprecated/example/se.py}
OUT=${OUT:-$ROOT_DIR/m5out}
ITERS=${ITERS:-800000}

mkdir -p "$OUT" logs

modes=(loop alt corr)
for mode in "${modes[@]}"; do
  outdir="$OUT/lab1_default_${mode}"
  "$GEM5" -d "$outdir" "$SEPY" --cpu-type=O3CPU --caches --l1i_size=32kB \
    --l1d_size=32kB --cmd="$ROOT_DIR"/build/lab1_branch_patterns.riscv --options="$mode $ITERS"
done

echo "== Lab 1 summary ==" | tee $ROOT_DIR/logs/lab1.log
for mode in "${modes[@]}"; do
  echo "-- predictor=default mode=$mode" | tee -a $ROOT_DIR/logs/lab1.log
  python3 "${ROOT_DIR}/scripts/parse_stats.py" "$OUT/lab1_default_${mode}/stats.txt" | tee -a $ROOT_DIR/logs/lab1.log
  echo
done
