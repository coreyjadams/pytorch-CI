#!/bin/bash -x

# Set up envirnoment:
module load $BASE_PYTHON
module swap PrgEnv-intel PrgEnv-gnu
module load java
export JAVA_VERSION=1.8

. $BUILD_ROOT/env/bin/activate
export ENVIRON_BASE=$(dirname $(dirname $(which python)))
which python
python --version

git clone https://github.com/pytorch/pytorch.git
cd pytorch
git checkout v1.0.1

git status

cd -

echo "Current files:"
ls
ls pytorch




