#!/usr/bin/env python3
import re
from pathlib import Path
import glob
import argparse


def read_stats(stats_path):
    stats = {}
    with open(stats_path, "r", errors="ignore") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split()
            key = parts[0]
            if len(parts) >= 2:
                val = parts[1]
            else:
                val = ""
            stats[key] = val
    return stats


def read_out(out_path):
    info = {}
    if not out_path.exists():
        return info
    with out_path.open("r", errors="ignore") as f:
        for line in f:
            line = line.strip()
            if line.startswith("N="):
                info["N"] = line.split("=", 1)[1]
            elif line.startswith("mode="):
                info["mode"] = line.split("=", 1)[1]
            elif line.startswith("checksum="):
                info["checksum"] = line.split("=", 1)[1]
            elif line.startswith("correct="):
                info["correct"] = line.split("=", 1)[1]
    return info


def fmt_int_with_commas(s):
    try:
        if "." in s:
            # float-looking but request was for integers; keep as-is
            return s
        v = int(float(s))
        return format(v, ",")
    except Exception:
        return s


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", type=Path, default=Path("result.txt"))
    args = parser.parse_args()

    stats_files = sorted(glob.glob("outputs/*/*_stats.txt"))
    rows = []
    main_rows = []
    sensitivity_rows = []

    cpu_map = {"timing": "TimingSimpleCPU", "minor": "MinorCPU", "sensitivity": "TimingSimpleCPU"}

    for sfile in stats_files:
        spath = Path(sfile)
        parent = spath.parent.name
        cpu = cpu_map.get(parent, parent)

        name = spath.name
        if name.endswith("_stats.txt"):
            base = name[: -len("_stats.txt")]
        else:
            base = spath.stem

        out_path = spath.parent / (base + ".out")

        stats = read_stats(spath)
        info = read_out(out_path)

        # Fields to extract
        # derive N and version (mode) from filename if not in .out
        N = info.get("N") or (re.search(r"N(\d+)", base) and re.search(r"N(\d+)", base).group(1)) or "NA"
        # mode/version: prefer info from .out, otherwise parse from filename suffix after first underscore
        version = info.get("mode")
        if not version:
            m = re.match(r"^[^_]+_(.+)$", base)
            version = m.group(1) if m else "NA"
        # extract cache size from filename (e.g., 16KiB, 32KiB, 64KiB)
        # main runs always use 32; sensitivity runs use the filename suffix
        if parent == "sensitivity":
            cache_match = re.search(r"(\d+)KiB", base)
            l1d_cache = cache_match.group(1) if cache_match else "32"
        else:
            l1d_cache = "32"
        checksum = info.get("checksum", "NA")
        correct = info.get("correct", "NA")

        simTicks = stats.get("simTicks", "NA")
        simInsts = stats.get("simInsts", "NA")
        overallMissRate = stats.get("board.cache_hierarchy.l1dcaches.overallMissRate::total", "NA")
        overallMissLatency = stats.get("board.cache_hierarchy.l1dcaches.overallMissLatency::total", "NA")

        simTicks_f = fmt_int_with_commas(simTicks)
        simInsts_f = fmt_int_with_commas(simInsts)
        overallMissLatency_f = fmt_int_with_commas(overallMissLatency)

        row = {
            "N": str(N),
            "version": version,
            "l1-d$": l1d_cache,
            "CPU": cpu,
            "checksum": checksum,
            "correct": correct,
            "simTicks": simTicks_f,
            "simInsts": simInsts_f,
            "overallMissRate::total": overallMissRate,
            "overallMissLatency::total": overallMissLatency_f,
        }
        
        if parent == "sensitivity":
            sensitivity_rows.append(row)
        else:
            main_rows.append(row)
    
    # Split main_rows into baseline and optimization rows
    baseline_rows = [r for r in main_rows if r.get("version") == "baseline"]
    optimization_rows = [r for r in main_rows if r.get("version") in ("transpose_b", "ikj_stream")]

    # Columns and alignment
    headers = ["N", "version", "l1-d$", "CPU", "checksum", "correct", "simTicks", "simInsts", "overallMissRate::total", "overallMissLatency::total"]
    # Define alignment for each column: True = right-align, False = left-align
    right_align = {"N", "version", "l1-d$", "simTicks", "simInsts", "checksum", "correct", "overallMissRate::total", "overallMissLatency::total"}
    
    # compute widths from all rows
    all_rows = baseline_rows + optimization_rows + sensitivity_rows
    widths = {h: len(h) for h in headers}
    for r in all_rows:
        for h in headers:
            widths[h] = max(widths[h], len(str(r.get(h, ""))))

    # Helper function to build table lines
    def build_table(rows_to_use, include_header=True):
        table_lines = []
        if include_header:
            # header (always right-aligned)
            hdr_parts = []
            for h in headers:
                hdr_parts.append(h.rjust(widths[h]))
            table_lines.append("  ".join(hdr_parts))
            # blank line after header
            table_lines.append("")
        
        # sort rows
        order_map = {"baseline": 0, "transpose_b": 1, "ikj_stream": 2}
        
        def sort_key_main(r):
            ver = r.get("version", "")
            o = order_map.get(ver, 99)
            try:
                n = int(r.get("N", "0"))
            except Exception:
                n = 10**9
            return (o, n)
        
        def sort_key_sensitivity(r):
            ver = r.get("version", "")
            o = order_map.get(ver, 99)
            try:
                cache = int(r.get("l1-d$", "32"))
            except Exception:
                cache = 0
            return (o, cache)
        
        if rows_to_use == baseline_rows or rows_to_use == optimization_rows:
            rows_sorted = sorted(rows_to_use, key=sort_key_main)
        else:
            rows_sorted = sorted(rows_to_use, key=sort_key_sensitivity)
        
        prev_ver = None
        for r in rows_sorted:
            ver = r.get("version")
            if prev_ver is not None and ver != prev_ver:
                # add blank line between different versions
                table_lines.append("")
            parts = []
            for h in headers:
                val = str(r.get(h, ""))
                if h in right_align:
                    parts.append(val.rjust(widths[h]))
                else:
                    parts.append(val.ljust(widths[h]))
            table_lines.append("  ".join(parts))
            prev_ver = ver
        
        return table_lines

    # Build lines
    lines = []
    # Add Baseline Run header at the top
    lines.append("# Baseline Run")
    lines.append("")
    # Baseline table
    lines.extend(build_table(baseline_rows, include_header=True))
    
    # Optimization table if it exists
    if optimization_rows:
        lines.append("")
        lines.append("# Memory System-aware Optimizations")
        lines.append("")
        lines.extend(build_table(optimization_rows, include_header=True))
    
    # Sensitivity table if it exists
    if sensitivity_rows:
        lines.append("")
        lines.append("# Sensitivity")
        lines.append("")
        lines.extend(build_table(sensitivity_rows, include_header=True))

    out_path = args.out
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with out_path.open("w") as f:
        f.write("\n".join(lines) + "\n")

    # also write under outputs/result.txt for convenience
    out2 = Path("outputs") / (out_path.name)
    with out2.open("w") as f:
        f.write("\n".join(lines) + "\n")


if __name__ == "__main__":
    main()
