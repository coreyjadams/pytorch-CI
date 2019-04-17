#!/bin/bash -x

mpi_launch="aprun"
BUILD_ROOT=$(cat BUILD_ROOT.path)
. $BUILD_ROOT/env/bin/activate
which python
python --version

$mpi_launch -n 1 $BUILD_ROOT/env/bin/python simple_torch.py >& simple_torch.out
status=$?
if [ $status -ne 0 ]; then
    cat simple_torch.out
    exit $status
fi

if grep -q "Success: pytorch session succeeded" simple_torch.out;
then
    echo "Success: pytorch session succeeded."
    touch $COBALT_JOBID.finished
else
    echo "Failed: aprun -n1 gave the following output:"
    cat simple_torch.out
    touch $COBALT_JOBID.finished
    exit 1
fi
