#!/usr/bin/env bash
set -euo pipefail

GEM5=${GEM5:-/opt/gem5/build/RISCV/gem5.opt}
BIN=${BIN:-./src/gemm.riscv}

make -C src/
mkdir -p outputs/timing outputs/minor outputs/sensitivity m5out_runs

# Task 1 & 4: measure and verify baseline and memory-aware versions
for N in 64 128 256; do
  for MODE in baseline transpose_b ikj_stream; do
    echo "Running TimingSimpleCPU N=${N} MODE=${MODE}"
    ${GEM5} --outdir=m5out_runs/timing_N${N}_${MODE} run_timing.py --binary ${BIN} --n ${N} --mode ${MODE} \
      | tee outputs/timing/N${N}_${MODE}.out
    ./scripts/extract_stats.py m5out_runs/timing_N${N}_${MODE}/stats.txt > outputs/timing/N${N}_${MODE}_stats.txt

    echo "Running MinorCPU N=${N} MODE=${MODE}"
    ${GEM5} --outdir=m5out_runs/minor_N${N}_${MODE} scripts/run_minor.py --binary ${BIN} --n ${N} --mode ${MODE} \
      | tee outputs/minor/N${N}_${MODE}.out
    ./scripts/extract_stats.py m5out_runs/minor_N${N}_${MODE}/stats.txt > outputs/minor/N${N}_${MODE}_stats.txt
  done
done

# Task 5: $ size sensitivity study
for L1D in 16KiB 32KiB 64KiB; do
  for MODE in baseline transpose_b; do
    echo "Running sensitivity TimingSimpleCPU N=128 MODE=${MODE} L1D=${L1D}"
    ${GEM5} --outdir=m5out_runs/sens_N128_${MODE}_${L1D} scripts/run_timing.py --binary ${BIN} --n 128 --mode ${MODE} --l1d_size ${L1D} \
      | tee outputs/sensitivity/N128_${MODE}_${L1D}.out
    ./scripts/extract_stats.py m5out_runs/sens_N128_${MODE}_${L1D}/stats.txt > outputs/sensitivity/N128_${MODE}_${L1D}_stats.txt
  done
done

# Extract stats for my report
if [ -f scripts/my_report_stats.py ]; then
  python3 scripts/my_report_stats.py
fi
