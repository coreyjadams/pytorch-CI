'''Populate Balsam DB with benchmark suite'''

from itertools import product
import os
from benchmark_config import (
    NUM_NODES,
    RPN,
    TRIALS,
    COMMON_PARAMS,
    BENCHMARK_SCRIPTS,
)
from balsam.core.models import BalsamJob, ApplicationDefinition


RELEASE_PATH = os.environ['RELEASE_PATH']
PYTHON = os.path.join(RELEASE_PATH, 'env', 'bin', 'python')

for script_path in BENCHMARK_SCRIPTS:
    executable = ' '.join((PYTHON, script_path))
    app_name = script_path[script_path.find('osu_') + 4:-3]
    app, created = ApplicationDefinition.objects.get_or_create(
        name=app_name,
        defaults=dict(
            executable=executable,
        )
    )
    for (num_nodes, rpn, trial) in product(NUM_NODES, RPN, TRIALS):
        job = BalsamJob(
            name=f"{num_nodes}nodes.{rpn}rpn.{trial}",
            workflow=f"{app_name}",
            application=app_name,
            num_nodes=num_nodes,
            ranks_per_node=rpn,
            **COMMON_PARAMS,
        )
        job.save()
