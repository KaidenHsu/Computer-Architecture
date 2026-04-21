#!/usr/bin/env bash
set -euo pipefail

# get script directory instead of current directory
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

GEM5_BIN=/opt/gem5/build/RISCV/gem5.opt
GEMM_BIN="${ROOT_DIR}/gemm.riscv"
PARSE_STATS="${ROOT_DIR}/parse_stats.py"
OUT_ROOT="${ROOT_DIR}/results/"

# ensure the simulator command can be run
[[ ! -x "$GEM5_BIN" ]] && {
    echo "gem5 binary not found or not executable: $GEM5_BIN" >&2
    exit 1
}

make

# ensure the program exists
[[ ! -f "$GEMM_BIN" ]] && {
    echo "GEMM binary not found: ${GEMM_BIN}" >&2
    exit 1
}

mkdir -p "$OUT_ROOT"

run_case() {
    local cpu_label=$1
    local script_name=$2
    local n=$3

    local run_dir="${OUT_ROOT}/unrolled2_${cpu_label}_N${n}/"
    local tmp_report_file="${ROOT_DIR}/unrolled2_${cpu_label}_N${n}.txt"
    local report_file="${run_dir}/unrolled2_${cpu_label}_N${n}.txt"

    local gem5_cmd parse_cmd

    rm -rf "${ROOT_DIR}/m5out" "$run_dir"
    mkdir -p "$OUT_ROOT"

    gem5_cmd="$GEM5_BIN ${ROOT_DIR}/$script_name --binary $GEMM_BIN --n ${n} --mode unrolled2"
    parse_cmd="python3 $PARSE_STATS ${run_dir}/stats.txt"

	echo "============================"
	echo "CPU = $cpu_label, N = $n"
	echo "============================"

    {
        # gem5
        printf '$ %s \n' "$gem5_cmd"
        (cd "$ROOT_DIR" && bash -lc "$gem5_cmd")
        mv "${ROOT_DIR}/m5out" "$run_dir"
        echo ""

        # parser
        printf '$ %s \n' "$parse_cmd"
        bash -lc "$parse_cmd"
    } | tee "$tmp_report_file"

    mv "$tmp_report_file" "$report_file"

    printf "\n\n"
}

# timing CPU
for n in 64 128 256; do
    run_case timing run_timing.py "$n"
done

# minor CPU
for n in 64 128 256; do
    run_case minor run_minor.py "$n"
done
