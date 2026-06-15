#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=/work
GEM5=${GEM5:-/opt/gem5/build/RISCV/gem5.opt}
SEPY=${SEPY:-/opt/gem5/configs/deprecated/example/se.py}
OUT=${OUT:-m5out}
ITERS=${ITERS:-250000}
ROOT_DIR=/work

mkdir -p "$OUT" logs

for mode in direct indirect; do
  outdir="$OUT/lab3_default_${mode}"
  "$GEM5" -d "$outdir" "$SEPY" --cpu-type=O3CPU --caches --l1i_size=32kB \
    --l1d_size=32kB --cmd="$ROOT_DIR"/build/lab3_targets.riscv --options="$mode $ITERS"
done

echo "== Lab 3 summary =="  | tee $ROOT_DIR/logs/lab3.log
for mode in direct indirect; do
  echo "-- predictor=default mode=$mode"  | tee -a $ROOT_DIR/logs/lab3.log
  python3 "${ROOT_DIR}/scripts/parse_stats.py" "$OUT/lab3_default_${mode}/stats.txt" | tee -a $ROOT_DIR/logs/lab3.log
  echo
done
