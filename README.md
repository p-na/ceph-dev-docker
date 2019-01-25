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

