#!/usr/bin/env python3
import re
import sys
from pathlib import Path

KEYS = {
    "sim_insts": "simInsts",
    "sim_seconds": "simSeconds",
    "host_seconds": "hostSeconds",
    "num_cycles": "system.cpu.numCycles",
    "ipc": "system.cpu.ipc",
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

def main():
    if len(sys.argv) != 2:
        print("Usage: parse_stats.py <stats.txt>")
        sys.exit(1)
    vals = parse_stats(Path(sys.argv[1]))
    for k in KEYS:
        print(f"{k:16s} {vals.get(k, 'N/A')}")

if __name__ == "__main__":
    main()
