#!/usr/bin/env bash
set -euo pipefail

# get script directory instead of current directory
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

GEM5=${GEM5:-/opt/gem5/build/RISCV/gem5.opt}

make -C "${ROOT_DIR}"

for cpu in timing minor; do
    for n in 64 128 256; do
        for mode in baseline tiled_cpu accel_tiny accel_medium accel_large hybrid; do
            RAW_DIR="$ROOT_DIR/results/raw/${cpu}_${n}_${mode}"
            mkdir -p "${RAW_DIR}"

            STATS_DIR="${ROOT_DIR}/results/stats"
            mkdir -p "${STATS_DIR}"
            STATS_FILE="${ROOT_DIR}/results/stats/${cpu}_${n}_${mode}.txt"

            printf "\n\n"
            echo "===================================================="
            echo "          cpu=${cpu} N=${n} mode=${mode}"
            echo "===================================================="

            {
                printf '$ %s -d %q %q --binary %q --n %q --mode %q\n\n' \
                    "${GEM5}" "${RAW_DIR}" "scripts/run_${cpu}.py" \
                    "gemm_accel.riscv" "${n}" "${mode}"

                "${GEM5}" -d "${RAW_DIR}" "scripts/run_${cpu}.py" \
                    --binary gemm_accel.riscv --n "${n}" --mode "${mode}"
            } | tee "${RAW_DIR}/command.log" "${STATS_FILE}"

            printf "\n"

            python3 scripts/extract_stats.py "${RAW_DIR}/stats.txt" | tee -a "${STATS_FILE}"
        done
    done
done
