# ceph-dev-docker

The purpose of this docker image is to help developing the `dashboard_v2` Ceph
MGR module.

Please note that this Docker container uses Zsh by default instead of Bash.

## Usage

### Build Image

    # docker build -t ceph-dev .

### Run the Container

    # docker run -it -v ~/src/ceph-local:/ceph -h ceph-dev --net host ceph-dev

In this case `~/src/ceph-local` is just an empty directory if you just started
to create your development environment.  You may, of course, change the
location of the directory to your liking.

On first run, you may want to clone and build Ceph.  To do this, you just need
to run `setup-ceph`.

    $ setup-ceph

### Backup the work done

At this point it might make sense to create an image out of the current
container to preserve the current state of the container.  To do this, you will
need to commit your container to an image.

    $ docker commit <CONTAINER_ID> <NEW_IMAGE_NAME>

E.g.

    $ docker commit 7dbf64f71d4d ceph-dev-build

You can find the container ID by issuing `docker ps` (if it's running) or by
issuing `docker ps -a` (outside of the container).  The latter will will list
all containers, including those which are stopped.

### Start Ceph

Within your docker container, run the following code.

    $ cd /ceph/build
    $ ../src/vstart.sh -n

You have to start Ceph with the `-n` command line argument, if you're
starting the Cluster for the first time.  There are other switches available
(`-d`, `-x`) which are not necessary for the development of the `dashboard_v2`
module.

# TODO revise

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


