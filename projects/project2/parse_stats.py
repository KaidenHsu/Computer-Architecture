#!/usr/bin/env python3
import re
import sys
from pathlib import Path

KEYS = {
    "sim_ticks": "simTicks",
    "sim_insts": "simInsts",
}

def parse_stats(path: Path):
    vals = {}
    text = path.read_text(errors="ignore").splitlines()
    for line in text:
        for out_name, stat_name in KEYS.items():
            if line.startswith(stat_name):
                parts = re.split(r"\s+", line.strip())
                if len(parts) >= 2:
                    vals[out_name] = parts[1]
    return vals


def format_with_commas(value: str) -> str:
    try:
        return f"{int(value):,}"
    except (TypeError, ValueError):
        return value

def main():
    if len(sys.argv) != 2:
        print("Usage: parse_stats.py <stats.txt>")
        sys.exit(1)
    vals = parse_stats(Path(sys.argv[1]))
    for k in KEYS:
        value = vals.get(k, "N/A")
        print(f"{k:16s} {format_with_commas(value)}")

if __name__ == "__main__":
    main()
