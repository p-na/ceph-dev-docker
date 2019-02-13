# ceph-dev-docker

## Features

- Ceph compile dependencies are build into the Docker image
- Persistent history across new containers
- Simultaneous multi-container support for Ceph containers
- Useful globally callable tools (shell scripts, aliases, etc)
    - `reloadm`      - Reloads the dashboard manager module
    - `start`        - Starts the cluster
    - `stop`         - Stops the cluster
    - `auto-reloadm` - Automatically relodas the dashboard mgr module on
                       changes
    - `fe-run`       - Serves and automatically rebuilds the frontend on
                       changes
- PyCharm remote debugging support

## Quick Start

### Prerequisites

```
# Clone Ceph repository
git clone git@github.com:ceph/ceph.git ~/src/ceph-1
# Clone Ceph-Dev-Docker repository
git clone https://github.com/p-na/ceph-dev-docker ~/src/ceph-dev-docker
# Build Image
cd ~/src/ceph-dev-docker
docker build -t pnaw/ceph-dev-docker .
```

Create a `.env` configuration file:

```
CEPH_IMAGE=pnaw/ceph-dev:tumbleweed
CEPH_REPO_1=/home/user/src/ceph-1
# CEPH_REPO_2=/home/user/src/ceph-2
# CEPH_REPO_3=/home/user/src/ceph-3
# CEPH_REPO_4=/home/user/src/ceph-4
```

### Start Container 

```
docker-compose up -d ceph-1
```

### Compile Ceph

```
cd ~/src/ceph-dev-docker

docker-compose exec ceph-1 setup-ceph
# or
# docker-compose exec ceph-1 setup-ceph <amount_of_cores>
```

### Start Ceph

```
start
```
