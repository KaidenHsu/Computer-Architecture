#!/usr/bin/env python3
import sys
from pathlib import Path

keys = [
    'simTicks', 'simInsts', 'board.processor.cores.core.numCycles',
    'board.cache_hierarchy.l1dcaches.overallMisses::total',
    'board.cache_hierarchy.l1dcaches.overallHits::total',
    'board.cache_hierarchy.l1icaches.overallMisses::total',
]

if len(sys.argv) < 2:
    print('usage: extract_stats.py <stats.txt>')
    sys.exit(1)

text = Path(sys.argv[1]).read_text(errors='ignore').splitlines()
for k in keys:
    for line in text:
        if line.startswith(k + ' ') or line.startswith(k + '\t'):
            print(line)
            break
