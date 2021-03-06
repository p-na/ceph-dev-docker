# ceph-dev-docker

## Features

- Ceph compile dependencies are build into the Docker image
- Persistent history across new containers
- Simultaneous multi-container support for Ceph containers
- Useful globally callable tools (shell scripts, aliases, etc)
  - `reloadm` - Reloads the dashboard manager module
  - `start` - Starts the cluster
  - `stop` - Stops the cluster
  - `auto-reloadm` - Automatically relodas the dashboard mgr module on
    changes
  - `fe-run` - Serves and automatically rebuilds the frontend on
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

#### Create a `.env` configuration file:

```
CEPH_IMAGE=pnaw/ceph-dev:tumbleweed
CEPH_REPO_1=/home/user/src/ceph-1
# CEPH_REPO_2=/home/user/src/ceph-2
# CEPH_REPO_3=/home/user/src/ceph-3
# CEPH_REPO_4=/home/user/src/ceph-4
```

#### Create `proxy.conf.json` file

```
cp ~/src/ceph-1/src/pybind/mgr/dashboard/frontend/proxy.conf.json.sample \
    ~/src/ceph-1/src/pybind/mgr/dashboard/frontend/proxy.conf.json
```

Adapt both ports in the file to match port 5000. The `start` and `fe-run`
commands depend on the proxy.

The configured repository can be copied to `ceph-{2,3,4}` and used without any
further configuration.

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

Enjoy the dashboard on static ports:

| Container | Dashboard w/SSL | Dashboard w/o SSL | FE Proxy w/o SSL | Dashboards' QA | RGW  |
| --------- | --------------- | ----------------- | ---------------- | -------------- | ---- |
| ceph-1    | 4001            | 8081              | 4201             | 4011           | 4101 |
| ceph-2    | 4002            | 8082              | 4202             | 4012           | 4102 |
| ceph-3    | 4003            | 8083              | 4203             | 4013           | 4103 |
| ceph-4    | 4004            | 8084              | 4204             | 4014           | 4104 |

## Troubleshooting

### Monitoring

#### Grafana fails to load dashboards successfully for both, Ceph Dashboard and Grafan itself

To successfully enable Grafana to talk to Prometheus and the Dashboard to talk
to Grafana, `/etc/hosts` needs to be extended to point to localhost for `grafan`
and `prometheus` respectively.

## Tips and Tricks

### Run backend tests n times

Sometimes, the backend tests behave rather unpredictable with regards to the
reproducibility of a problem. This snippet explains how to run multiple tests in
a row and store the output in log files with timestamps.

```
for i in $(seq 0 10); do docker-compose up -d ceph-1 && docker-compose exec ceph-1 test-be 2>&1 | tee /tmp/backend-test-$(date +%F_%H_%M_%S).log; done
```
