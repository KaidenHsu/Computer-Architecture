#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=/work
GEM5=${GEM5:-/opt/gem5/build/RISCV/gem5.opt}
SEPY=${SEPY:-/opt/gem5/configs/deprecated/example/se.py}
OUT=${OUT:-m5out}

mkdir -p "$ROOT_DIR/$OUT"

"$GEM5" -d "$ROOT_DIR/$OUT/lab1_indep" "$SEPY" --cpu-type=O3CPU --caches --l1i_size=32kB --l1d_size=32kB \
    --cmd="$ROOT_DIR/build/lab1_ilp.riscv" --options="indep 500000"
"$GEM5" -d "$ROOT_DIR/$OUT/lab1_chain" "$SEPY" --cpu-type=O3CPU --caches --l1i_size=32kB --l1d_size=32kB \
    --cmd="$ROOT_DIR/build/lab1_ilp.riscv" --options="chain 500000"

echo "== Independent ==" | tee "$ROOT_DIR/logs/lab1.log"
python3 "$ROOT_DIR/scripts/parse_stats.py" "$ROOT_DIR/$OUT/lab1_indep/stats.txt" | tee -a "$ROOT_DIR/logs/lab1.log"

echo | tee -a "$ROOT_DIR/logs/lab1.log"
echo "== Chain =="  | tee -a "$ROOT_DIR/logs/lab1.log"
python3 "$ROOT_DIR/scripts/parse_stats.py" "$ROOT_DIR/$OUT/lab1_chain/stats.txt"  | tee -a "$ROOT_DIR/logs/lab1.log"
