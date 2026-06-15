#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=/work
GEM5=${GEM5:-/opt/gem5/build/RISCV/gem5.opt}
SEPY=${SEPY:-/opt/gem5/configs/deprecated/example/se.py}
OUT=${OUT:-m5out}
ITERS=${ITERS:-500000}

mkdir -p "$OUT" logs

for mode in pred unpred; do
  outdir="$OUT/lab2_default_${mode}"
  "$GEM5" -d "$outdir" "$SEPY" --cpu-type=O3CPU --caches --l1i_size=32kB \
    --l1d_size=32kB --cmd="$ROOT_DIR"/build/lab2_speculation.riscv --options="$mode $ITERS"
done

echo "== Lab 2 summary ==" | tee $ROOT_DIR/logs/lab2.log
for mode in pred unpred; do
  echo "-- predictor=default mode=$mode" | tee -a $ROOT_DIR/logs/lab2.log
  python3 "${ROOT_DIR}/scripts/parse_stats.py" "$OUT/lab2_default_${mode}/stats.txt" | tee -a $ROOT_DIR/logs/lab2.log
  echo
done
