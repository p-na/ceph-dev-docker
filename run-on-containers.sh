#!/usr/bin/env bash
#

function usage() {
    echo "Runs a command on different versions of container images"
    echo
    echo "Usage"
    echo
    echo -e "\t$0 -h|--help|-v|--verbose|-i <image>|--image <image> [--] arg..."
    echo
    echo "Examples"
    echo
    echo -e "\t➜  ./run-on-containers.sh -i grafana/grafana:7.5.1 -i grafana/grafana:7.3.1 -- id"
    echo -e "\tuid=472(grafana) gid=0(root) groups=0(root)"
    echo -e "\tuid=472(grafana) gid=0(root) groups=0(root)"
    echo
    echo -e "\t➜  ./run-on-containers.sh -i grafana/grafana:7.5.1 -i grafana/grafana:7.3.1 -- id"
    echo -e "\tuid=472(grafana) gid=0(root) groups=0(root)"
    echo -e "\tuid=472(grafana) gid=0(root) groups=0(root)"
    echo
    echo -e "\t➜  ./run-on-containers.sh -i grafana/grafana:7.5.1 -i grafana/grafana:7.3.1 -- ls             "
    echo -e "\tLICENSE"
    echo -e "\tNOTICE.md"
    echo -e "\tREADME.md"
    echo -e "\tVERSION"
    echo -e "\tbin"
    echo -e "\tconf"
    echo -e "\tplugins-bundled"
    echo -e "\tpublic"
    echo -e "\tscripts"
    echo
    echo -e "\tLICENSE"
    echo -e "\tNOTICE.md"
    echo -e "\tREADME.md"
    echo -e "\tVERSION"
    echo -e "\tbin"
    echo -e "\tconf"
    echo -e "\tplugins-bundled"
    echo -e "\tpublic"
    echo -e "\tscripts"
    echo
    echo -e "\t➜  ./run-on-containers.sh -i grafana/grafana:7.5.1 -i grafana/grafana:7.3.1 -- id"
    echo -e "\tuid=472(grafana) gid=0(root) groups=0(root)"
    echo -e "\tuid=472(grafana) gid=0(root) groups=0(root)"
    echo
    echo -e "\t➜  ./run-on-containers.sh -i grafana/grafana:7.5.1 -i grafana/grafana:7.3.1 -v -- id"
    echo -e "\tgrafana/grafana:7.5.1: uid=472(grafana) gid=0(root) groups=0(root)"
    echo -e "\tgrafana/grafana:7.3.1: uid=472(grafana) gid=0(root) groups=0(root)"
    echo
    echo -e "\t➜  ./run-on-containers.sh -i grafana/grafana:7.5.1 -i grafana/grafana:7.3.1 -v -- ls /etc/grafana"
    echo -e "\tgrafana/grafana:7.5.1:"
    echo
    echo -e "\tgrafana.ini"
    echo -e "\tldap.toml"
    echo -e "\tprovisioning"
    echo
    echo -e "\tgrafana/grafana:7.3.1:"
    echo
    echo -e "\tgrafana.ini"
    echo -e "\tldap.toml"
    echo -e "\tprovisioning"
    echo
    echo -e "\t➜  ./run-on-containers.sh -i grafana/grafana:7.5.1 -i grafana/grafana:7.3.1 -- ls /etc/grafana "
    echo -e "\tgrafana.ini"
    echo -e "\tldap.toml"
    echo -e "\tprovisioning"
    echo
    echo -e "\tgrafana.ini"
    echo -e "\tldap.toml"
    echo -e "\tprovisioning"
    echo
}

VERBOSE=${VERBOSE:-0}
ENGINE=${ENGINE:-docker}
CONTAINER_IMAGES=""

args=$(getopt -o 'vhi:' --long 'verbose,help,image:' -- "$@") || exit
eval "set -- $args"

while true; do
    case $1 in
    -v | --verbose)
        ((VERBOSE++))
        shift
        ;;
    -i | --image)
        CONTAINER_IMAGES="$CONTAINER_IMAGES $2"
        shift 2
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    --)
        shift
        break
        ;;
    *) exit 1 ;;
    esac
done

if [ -z "$CONTAINER_IMAGES" ]; then
    echo >&2 "No container images specified to run commands on"
    echo >&2 "Please, add least add one container image using \"-i <image_path>\""
    exit 1
fi

if [ "$#" -eq 0 ]; then
    echo >&2 "No command specified to run on containers"
    echo >&2 "Please, at least specify one command to run on containers"
    exit 1
fi

if [ "$VERBOSE" -gt 1 ]; then
    echo "CONTAINER_IMAGES: $CONTAINER_IMAGES"
fi

entrypoint=$1
shift

if [ "$VERBOSE" -gt 1 ]; then
    echo "ENGINE: $ENGINE"
    echo "entrypoint: $entrypoint"
    echo "args: $@"
    echo
fi

for image in $CONTAINER_IMAGES; do
    if [[ "$ENGINE" != "docker" && "$ENGINE" != "podman" ]]; then
        echo >&2 "Unknown container engine: $ENGINE"
        exit 1
    fi

    cmd="$ENGINE run --rm --entrypoint $entrypoint $image $@"
    result=$($cmd)
    lines=$(echo "$result" | wc -l)

    if [ "$VERBOSE" -eq 0 ]; then
        echo "$result"
        if [ "$lines" -gt 1 ]; then
            echo
        fi
    else
        if [ "$lines" -eq 1 ]; then
            echo "$image: $result"
        else
            echo "$image:"
            echo
            echo "$result"
            echo
        fi
    fi
done
