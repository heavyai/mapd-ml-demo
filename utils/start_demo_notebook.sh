#!/usr/bin/env bash
set -e

cd /mapd-ml/notebooks
source activate $MAPD_ML
jupyter notebook --allow-root --ip=*
