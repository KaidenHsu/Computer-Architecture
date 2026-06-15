import argparse
import os

from gem5.components.boards.simple_board import SimpleBoard
from gem5.components.cachehierarchies.classic.private_l1_cache_hierarchy import (
    PrivateL1CacheHierarchy,
)
from gem5.components.memory.single_channel import SingleChannelDDR3_1600
from gem5.components.processors.cpu_types import CPUTypes
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.isas import ISA
from gem5.resources.resource import BinaryResource
from gem5.simulate.simulator import Simulator


def must_exist(path: str) -> str:
    abs_path = os.path.abspath(path)
    if not os.path.isfile(abs_path):
        raise FileNotFoundError(f"Binary not found: {abs_path}")
    return abs_path


parser = argparse.ArgumentParser()
parser.add_argument("--binary", type=str, default="./gemm.riscv")
parser.add_argument("--n", type=str, default="128")
parser.add_argument("--mode", type=str, default="baseline")
parser.add_argument("--l1i_size", type=str, default="32KiB")
parser.add_argument("--l1d_size", type=str, default="32KiB")
args = parser.parse_args()

binary_path = must_exist(args.binary)

cache_hierarchy = PrivateL1CacheHierarchy(
    l1i_size=args.l1i_size,
    l1d_size=args.l1d_size,
)

memory = SingleChannelDDR3_1600(size="1GiB")
processor = SimpleProcessor(
    cpu_type=CPUTypes.TIMING,
    isa=ISA.RISCV,
    num_cores=1,
)

board = SimpleBoard(
    clk_freq="2GHz",
    processor=processor,
    memory=memory,
    cache_hierarchy=cache_hierarchy,
)

board.set_se_binary_workload(
    binary=BinaryResource(local_path=binary_path),
    arguments=[args.n, args.mode],
)

simulator = Simulator(board=board)
simulator.run()
