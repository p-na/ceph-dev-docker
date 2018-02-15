# ceph-dev-docker

The purpose of this docker image is to help developing the `dashboard_v2` Ceph
MGR module and hence contains some very specific adaptations compared to
ricardomarques/ceph-dev-docker.

Please also note that this Docker container uses Zsh by default instead of
Bash.

## Usage

### Build the Docker Image

    $ docker build -t ceph-dev .

### Create and Run the Container

    $ docker run -it -v ~/src/ceph-local:/ceph -h ceph-dev --net host --name ceph-dev ceph-dev

In this case `~/src/ceph-local` is just an empty directory if you just started
to create your development environment.  You may, of course, change the
location of the directory to your liking.

### Build Ceph

On first run, you may want to clone and build Ceph.  To do this, you just need
to run `setup-ceph`.  The command does also work for rebuilding Ceph.

    $ setup-ceph

Ceph will automatically be build with Python2 and Python3 support.

### Start Ceph

Within your docker container, run the following code.

    $ start -n

When you already started Ceph once, you can omit the `-n` flag.  The `-n` flag
creates a new cluster and hence you'll have to re-enable the `dashboard_v2`
module after you've used it.  By default the environment variable `RGW` will be
passed to `start` with the value `1`, which is not the default of `vstart.sh`,
so now you know.

To, lets say, start a new Ceph cluster with three MGR deamons, do:

    $ MGR=3 start -n

### Check the Status of the Ceph Cluster

    $ ceph -s

### Stop the Ceph Development Environment

    $ stop

### Starting and Stopping Containers

    $ docker start ceph-dev

    $ docker stop ceph-dev

Note that the container is started with all the arguments given on its
creation! Docker containers are created using the `docker create` *and* `docker
run` command.

### Backup the Container

At a certain point, it might make sense to create an image out of the current
container to preserve the current state of it.  To do this, you will need to
commit your container to an image.

    $ docker commit <CONTAINER_ID> <NEW_IMAGE_NAME>

For instance:

    $ docker commit 7dbf64f71d4d ceph-dev-build

You can find the container ID by issuing `docker ps` (if it's running) or by
issuing `docker ps -a`.  Both commands do only work outside of the container.
The latter will will list all containers, including those which have been
stopped.

