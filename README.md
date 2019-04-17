# Tensorflow: CI & Performance Measurement on Theta

This repository is a modifed version of the one Misha Salim created for mpi4py: https://github.com/balsam-alcf/mpi4py-CI.git

This repository contains automation code based on Jenkins and Balsam infrastructure for building, deploying, and measuring performance of mpi4py on Theta. The Jenkins pipeline consists of the following stages:

1. Virtualenv setup: an environment based on cray-python 3.6 is first created for the build and test activities
2. Bazel download & build from source
3. Tensorflow checkout & build from source
4. Sanity check: quick single-node tensorflow test to ensure build was successful and a session can run
5. Deploy (i.e. copy build to permanent location) & launch performance measurement job (NOT IMPLEMENTED)

## Jenkinsfile: pipeline definition

The Jenkinsfile uses a declarative syntax to define the stages above.  We are essentially orchestrating a series of shell scripts in this case. [Jenkins Pipeline](`https://jenkins.io/doc/book/pipeline/getting-started/`) is a flexible automation language which can embed Groovy scripts for more complex workflows.


## Build scripts
The Theta build process is split into three shell scripts:

- [env-setup.sh](https://github.com/balsam-alcf/mpi4py-CI/blob/master/env-setup.sh)
- [build-cython.sh](https://github.com/balsam-alcf/mpi4py-CI/blob/master/build-cython.sh)
- [build-mpi4py.sh](https://github.com/balsam-alcf/mpi4py-CI/blob/master/build-mpi4py.sh)

## Sanity check

The script job [testMPI4Py.sh](https://github.com/balsam-alcf/mpi4py-CI/blob/master/testMPI4Py.sh) is submitted to Cobalt as a quick single-node debug job.  This job runs the `printRank.py` script to ensure that MPI is initialized correctly in this Python environment running on Theta compute nodes.

Since there is no "queue runner" on Theta, we write some extra logic in the Pipeline to submit the job and poll on its completion. When the job is completed, we leverage `grep -q` return code behavior to test whether `printRank.py` produced the correct output. If not, the Pipeline fails at this stage.

## Deploy & Benchmark
Given a successful build, the [deploy-benchmark.sh](https://github.com/balsam-alcf/mpi4py-CI/blob/master/deploy-benchmark.sh) script copies the fresh environment from the ephemeral `BUILD_ROOT` directory to a more permanent location pre-configured in the Jenkinsfile (`RELEASE_ROOT`).

Finally, we dispatch the benchmark suite with Balsam.  This executes asychronously; that is, the Pipeline will exit succesfully upon *submitting* the benchmark job, and it's up to us to go check on results after the benchmarks actually run on Theta (this could be much later, depending on how busy Theta is).

A new Balsam database is initialized in `RELEASE_ROOT` and populated with a suite of OSU MPI benchmark tasks.  These actually come for free, bundled with the `mpi4py` source distribution (`mpi4py/demo/osu_*.py`). We leverage Balsam to define a big parameter sweep (multiple trials, nodes, ranks-per-node, etc...) and let the ensemble execute automatically.
An analysis job can be added as a final "summary" stage to organize the ensemble data into a friendly, human-readable format. Ideally, we would go as far as to generate a PDF with graphical results and have the full set of performance results mailed to us automatically.
