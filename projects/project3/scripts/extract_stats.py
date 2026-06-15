#!/usr/bin/env python3
import argparse
from pathlib import Path

DEFAULT_PATTERNS = [
    "simTicks",
    "simInsts",
    "numCycles",
    "committedInsts",
    "dcache",
    "l1d",
    "overallHits",
    "overallMisses",
    "overallMissRate",
    "demandHits",
    "demandMisses",
]

parser = argparse.ArgumentParser()
parser.add_argument("stats", type=Path, help="Path to gem5 stats.txt")
parser.add_argument("--patterns", nargs="*", default=DEFAULT_PATTERNS)
args = parser.parse_args()

patterns = [p.lower() for p in args.patterns]
seen = set()
with args.stats.open("r", errors="ignore") as f:
    for line in f:
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        stat_name = stripped.split()[0]
        lower = stat_name.lower()
        if any(pat in lower for pat in patterns):
            if stat_name not in seen:
                print(stripped)
                seen.add(stat_name)
