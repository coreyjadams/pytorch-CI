#!/bin/bash -x

BUILD_ROOT=$(cat BUILD_ROOT.path)
echo "BUILD_ROOT is ${BUILD_ROOT}"

# Activate the virtual env:
. $BUILD_ROOT/env/bin/activate
export ENVIRON_BASE=$(dirname $(dirname $(which python)))
which python
python --version

cd pytorch

#------------------------------------------------------------------------------
# This is for building pytorch on Theta, contact me if you find any issue
# This script must be ran by qsub command so that it will be configured with AVX-512
#  --
# Huihuo Zheng @ ALCF
# huihuo.zheng@anl.gov
# --
# Aug 17, 2018
#------------------------------------------------------------------------------
unset LD_LIBRARY_PATH
#**** get the package, run the following command on loggin node
# git clone https://github.com/pytorch/pytorch.git
# git submodule update --init
#****
#rm -rf build
# Set up envirnoment:
module load $BASE_PYTHON
module load intelpython35/2017.0.035
module load gcc/7.3.0
module swap PrgEnv-intel PrgEnv-gnu
#  This is the build command:
aprun -n 1 -cc none -j 0 -e CFLAGS='-mtune=knl -march=knl -pipe' \
-e CRAYPE_LINK_TYPE=dynamic -e CC=$(which gcc) -e CXX=$(which g++) \
-e MPICH_CC=$(which cc) -e MPICH_CXX=$(which CC) -b python setup.py build >& ${BUILD_ROOT}/${COBALT_JOBID}_torch_build.out

cat ${BUILD_ROOT}/${COBALT_JOBID}_torch_build.out

#aprun -n 1 -cc none -j 0 -e CFLAGS='-mtune=knl -march=knl -pipe' -e CRAYPE_LINK_TYPE=dynamic -e CC=$(which gcc) -e CXX=$(which g++) -e MPICH_CC=$(which cc) -e MPICH_CXX=$(which CC) -b python setup.py install --prefix=/soft/datascience/pytorch

aprun -n 1 -cc none -j 0 -e CFLAGS='-mtune=knl -march=knl -pipe' \
-e CRAYPE_LINK_TYPE=dynamic -e CC=$(which gcc) -e CXX=$(which g++) \
-e MPICH_CC=$(which cc) -e MPICH_CXX=$(which CC) -b \
python setup.py install --prefix=$PLACE_YOU_WANT_TO_INSTALL >& ${BUILD_ROOT}/${COBALT_JOBID}_torch_install.out

cat ${BUILD_ROOT}/${COBALT_JOBID}_torch_install.out


echo "Torch install script completed"


touch ${BUILD_ROOT}/${COBALT_JOBID}.finished
