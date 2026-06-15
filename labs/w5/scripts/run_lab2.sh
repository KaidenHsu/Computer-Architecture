#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=/work
GEM5=${GEM5:-/opt/gem5/build/RISCV/gem5.opt}
SEPY=${SEPY:-/opt/gem5/configs/deprecated/example/se.py}
OUT=${OUT:-m5out}

mkdir -p "$ROOT_DIR/$OUT"

"$GEM5" -d "$ROOT_DIR/$OUT/lab2_minor" "$SEPY" --cpu-type=MinorCPU --caches --l1i_size=32kB --l1d_size=32kB \
    --cmd="$ROOT_DIR/build/lab2_ooo.riscv" --options="200000 32768"
"$GEM5" -d "$ROOT_DIR/$OUT/lab2_o3" "$SEPY" --cpu-type=O3CPU --caches --l1i_size=32kB --l1d_size=32kB \
    --cmd="$ROOT_DIR/build/lab2_ooo.riscv" --options="200000 32768"

echo "== MinorCPU ==" | tee "$ROOT_DIR/logs/lab2.log"
python3 "$ROOT_DIR/scripts/parse_stats.py" "$ROOT_DIR/$OUT/lab2_minor/stats.txt" | tee -a "$ROOT_DIR/logs/lab2.log"

echo | tee -a "$ROOT_DIR/logs/lab2.log"
echo "== O3CPU ==" | tee -a "$ROOT_DIR/logs/lab2.log"
python3 "$ROOT_DIR/scripts/parse_stats.py" "$ROOT_DIR/$OUT/lab2_o3/stats.txt" | tee -a "$ROOT_DIR/logs/lab2.log"
