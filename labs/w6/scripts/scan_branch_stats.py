#!/usr/bin/env python3
import sys
from pathlib import Path

TOKENS = [
    "branchPred", "mispred", "mispredict", "BTB", "RAS",
    "indirect", "lookups", "predicted", "squash", "squashed"
]

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: scan_branch_stats.py <stats.txt>")
        sys.exit(1)
    path = Path(sys.argv[1])
    for line in path.read_text(errors="ignore").splitlines():
        if any(tok in line for tok in TOKENS):
            print(line)
