FROM nvidia/cuda:8.0-devel-ubuntu16.04
LABEL maintainer "Wamsi Viswanath [https://www.linkedin.com/in/wamsiv]"

ENV MAPD_ML=mapd_ml_examples

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
            wget \
            build-essential \
            libopenblas-dev \
            bzip2 && \
            apt-get remove --purge -y && \
            apt-get install -y git && \
            rm -rf /var/lib/apt/lists/*

# Install Miniconda
WORKDIR /opt/conda

RUN wget --no-check-certificate https://repo.continuum.io/miniconda/Miniconda3-4.3.21-Linux-x86_64.sh -O /opt/conda/miniconda3.sh
RUN bash /opt/conda/miniconda3.sh -b -p /opt/conda/Miniconda3
ENV PATH=$PATH:/opt/conda/Miniconda3/bin

# Copy files
COPY . /mapd-ml
WORKDIR /mapd-ml

# Create Environment
RUN conda env create -n $MAPD_ML -f /mapd-ml/env/py36_example.yml

# Configure environment
ARG XGBOOST_COMMIT="332b26d"

# Add xgboost
RUN git clone --recursive https://github.com/dmlc/xgboost.git && cd xgboost && git checkout $XGBOOST_COMMIT && \
    make PLUGIN_UPDATER_GPU=ON && \
    cd python-package && \
    /bin/bash -c "source activate mapd_ml_examples && python setup.py install" && \
    cd /mapd-ml && rm -rf xgboost

EXPOSE 8888

CMD bash ./utils/start_demo_notebook.sh
