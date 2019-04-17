'''Parameters defining the sweep of benchmarks to run'''
import glob
import os

NUM_NODES = [32, 64, 128, 256, 512, 1024]
RPN = [16, 64]
TRIALS = [1, 2, 3]
COMMON_PARAMS = {
    "cpu_affinity": "depth",
    "threads_per_rank": 1,
    "threads_per_core": 1
}

HERE = os.path.dirname(os.path.abspath(__file__))
BENCH_PATH = os.path.join(HERE, 'mpi4py', 'demo')
BENCH_PATTERN = os.path.join(BENCH_PATH, 'osu_*.py')
BENCHMARK_SCRIPTS = glob.glob(BENCH_PATTERN)
