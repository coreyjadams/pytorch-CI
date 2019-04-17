!/bin/bash

export RELEASE_PATH=$RELEASE_ROOT/$(date +%Y/%m/%d/%H_%M)
mkdir -p $RELEASE_PATH
cp -r $BUILD_ROOT/env $RELEASE_PATH
# module load cray-python/3.6.1.1
# module load balsam

# balsam init $RELEASE_PATH/bench-db
# source balsamactivate $RELEASE_PATH/bench-db
# balsam server --add-user msalim
# python add_benchmarks.py
# balsam ls
# balsam submit-launch -n 128 -q default -t 120 -A datascience --job-mode=mpi