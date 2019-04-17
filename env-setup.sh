#!/bin/bash -x
                
module load $BASE_PYTHON
module swap PrgEnv-intel $PROGRAMMING_ENV
rm -rf $BUILD_ROOT
rm -rf ./bazel
rm -rf ./tensorflow
mkdir -p $BUILD_ROOT
export PYTHONUSERBASE=$BUILD_ROOT/.pip/theta/cray-python
pip install --user virtualenv
$PYTHONUSERBASE/bin/virtualenv  --system-site-packages --no-wheel $BUILD_ROOT/env
which python
python --version
