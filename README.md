# ceph-dev-docker

Ceph development environment using Docker and vstart on SUSE Tumbleweed.

## Features

- Ceph compile dependencies are build into the Docker image

    No need to run `install-deps.sh` in the container anymore!

- Persistent shell history across new containers

    The history is stored in a docker volume. As the whole $HOME directory of
    the user is being used as a volume, other debug data can also be
    persistently stored and is automatically shared across all running
    containers.

- Simultaneous multi-container support

    This fork currently supports up to four different local Ceph repositories
    to be used simultaneously. Run your tests in one container while you
    develop in another one.

    The ports are allocated automatically to:

        - ceph-1:5000 -> localhost:4201
        - ceph-2:5000 -> localhost:4202
        - ceph-3:5000 -> localhost:4203
        - ceph-4:5000 -> localhost:4204

    For this to work you'll need to have `fe-run` running.  If you use `start`
    to spin up the cluster, `fe-run` is automatically started in the
    background as a tmux window.

- Useful globally callable tools (shell scripts, aliases, etc)

    - `reloadm`      Reloads the dashboard manager module
    - `start`        Starts the (vstart) Ceph cluster. After using `start`, a
                     tmux session is opened in the background. It launches
                     `auto-reloadm` and `fe-run` in separate windows. `start`
                     also compresses the `mgr.?.log` files to an archive in
                     the build dir on start automatically.
    - `stop`         Stops the cluster
    - `auto-reloadm` Automatically relodas the dashboard mgr module on
                     backend changes
    - `fe-run`       Serves the frontend using HTTP and automatically rebuilds
                     the frontend on changes
    - `traceback`    Greps the manager log file for tracebacks and prints them
                     nicely formatted and colorized.
    - `cdm`          Jumps to the module directory
                         (/ceph/src/pybind/mgr/dashboard)
    - `cdf`          Jumps to the frontend directory
                         (/ceph/src/pybind/mgr/dashboard/frontend)
    - `grep-mgr-log` Greps the mgr logfile(s).
    - `api-request`  A Python script that quickly requests the dashboards
                     backend and formats the output nicely.

                     ```
                     user@ceph-2 /ceph/build/out (master*) $ api-request.py get osd/1/safe-to-destroy
                     GET to https://ceph-2:5000/api/osd/1/safe-to-destroy without payload data returned status code 404                                                                                            
                     Response:
                     Details: The path '/api/osd/1/safe-to-destroy' was not found.
                     Status: 404 Not Found
                     Traceback: Traceback (most recent call last):
                       File "/usr/lib/python3.7/site-packages/cherrypy/_cprequest.py", line 670, in respond
                         response.body = self.handler()
                       File "/usr/lib/python3.7/site-packages/cherrypy/lib/encoding.py", line 221, in __call__
                         self.body = self.oldhandler(*args, **kwargs)
                       File "/usr/lib/python3.7/site-packages/cherrypy/_cperror.py", line 415, in __call__
                         raise self
                     cherrypy._cperror.NotFound: (404, "The path '/api/osd/1/safe-to-destroy' was not found.")

                     user@ceph-2 /ceph/build/out (master*) $ api-request.py get osd/1/safe_to_destroy
                     Request timed out after 30 seconds (client-side)
                     user@ceph-2 /ceph/build/out (master*) $ api-request.py get osd/1/safe_to_destroy
                     ```

- PyCharm remote debugging support

    TODO add reasoning

- Automatic archiving of the MGR log when using `start`

    TODO add details

## Default configuration

- tmux

    The default escape character for tmux is <ctrl>+a, not <ctrl>+b, the tmux
    default.

- vim/neovim
    
    TODO 


## How things are done

## Setup

## Warnings

Support for newly added functionality to the dashboard included in the original
repository of Ricardo Marques is not ported in a timely manner but on a
on-demand basis.
