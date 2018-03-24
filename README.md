# mapd-ml-demo

Can be run with nvidia-docker-compose. This depends on two containers:

| Name | Use | Dockerfile location |
| --- | --- | --- |
| `mapd-core` | MapD Database | Defaults to Community Edition on Docker Hub `mapd/mapd-ce-cuda` |
| `mapd/ml` | Demo notebooks | Dockerfile in top-level of `mapd-ml-demo` repo |

## Build

### mapd-ml-demo Server

To build the `mapd-ml-demo` container, clone the repo and `cd` into it.

To build the container, run:

    docker build -t mapd/ml .

### Exporting

If you need to move the containers to a new machine, run:

    docker save -o mapd-ce-cuda.tar mapd/mapd-ce-cuda
    docker save -o mapd-ml.tar mapd/ml

    gzip mapd-ce-cuda.tar
    gzip mapd-ml.tar

You will then have files which can be moved to the new machine: `mapd-ce-cuda.tar.gz`, `mapd-ml.tar.gz`. You will also want to grab the `docker-compose.yml` file (but probably not the `nvidia-docker-compose.yml` one).

## Run

### Setup

Uses `nvidia-docker-compose`. First make sure `nvidia-docker` is installed. Then install `nvidia-docker-compose` via pip:

    pip install nvidia-docker-compose

Next, modify the `docker-compose.yml` file to update the path containing the `/mapd-storage` volume. The default is to store this into a `mapd-storage-ml` directory in the current dir. To point elsewhere, change the line:

    volumes
      - ./mapd-storage-ml:/mapd_storage

to, for example:

    volumes
      - /home/wamsi/mapd-storage-ml:/mapd_storage

This needs to be changed for the `mapd-core` service.

Import the containers if on a clean machine:

    docker load -i mapd-ce-cuda.tar.gz
    docker load -i mapd-ml.tar.gz

### Running

If running for the first time, make sure you have [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) installed and run it first. Also, uninstall any previous installations of `nvidia-docker2.deb` and do a fresh install of `nvidia-docker.`

    nvidia-docker run -it nvidia/cuda nvidia-smi


Finally

    nvidia-docker-compose up

Below is a URL for Notebooks:

    http://localhost:8888

Below is a URL for Immerse:

    http://localhost:9092

If you are setting up dockerfile in an AWS instance then the URL would be like:

    http://<Public DNS Name>:9092

You should be able to find the Public DNS name in instances section of aws console. Make sure you allow the TCP/HTTP traffic in `security group -> inbound` settings. Replace default port 80  with Port numbers 9090, 9092, and 8888.
