# ceph-dev-docker

The purpose of this docker image is to help developing the `dashboard_v2` Ceph
MGR module.

## Usage

### Build Image

    # docker build -t ceph-dev .

### Run the Container

    # docker run -it -v ~/src/ceph-local:/ceph -h ceph-dev --net host ceph-dev

On first run, you may want to clone and build Ceph. To do this, you just need
to run `setup-ceph`.

    $ setup-ceph

# TODO revise

### Create a new docker image with all dependencies installed (use a separate terminal)

     # docker ps
     # docker commit <CONTAINER_ID> ceph-dev-docker-build

### Running the container with all dependencies installed

    # docker run --rm -it -v ~/ceph-local:/ceph -h ceph-dev --net host pna/docker-dev

### Start ceph development environment

     # cd /ceph/build
     # ../src/vstart.sh -d -n -x

### Test ceph development environment

     # cd /ceph/build
     # bin/ceph -s

### Stop ceph development environment

     # cd /ceph/build
     # ../src/stop.sh


