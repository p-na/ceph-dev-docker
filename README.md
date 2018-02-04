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

### Start Ceph

Within your docker container, run the following code.

    $ start

### Running the container with all dependencies installed

    # docker run --rm -it -v ~/ceph-local:/ceph -h ceph-dev --net host ceph-dev

### Test ceph development environment

    $ ceph -s

### Stop ceph development environment

    $ stop

### Backup the Container

At a certain point, it might make sense to create an image out of the current
container to preserve the current state of the container.  To do this, you will
need to commit your container to an image.

    $ docker commit <CONTAINER_ID> <NEW_IMAGE_NAME>

E.g.

    $ docker commit 7dbf64f71d4d ceph-dev-build

You can find the container ID by issuing `docker ps` (if it's running) or by
issuing `docker ps -a`.  Both commands do only work outside of the container.
The latter will will list all containers, including those which have been
stopped.

