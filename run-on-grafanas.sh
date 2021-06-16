#!/usr/bin/env bash
#

function usage() {
    echo "Runs a command on different versions of a container"
    echo
    echo "Example"
    echo
    echo "./run-on-grafanas.sh id grafana"
    echo "uid=472(grafana) gid=0(root) groups=0(root),0(root)"
    echo "uid=472(grafana) gid=472(grafana) groups=472(grafana),472(grafana)"
}

VERBOSE=${VERBOSE:-0}
ENGINE=${ENGINE:-docker}
VERSIONS=(
    grafana/grafana:7.5.1
    grafana/grafana:6.7.4
)

args=$(getopt -o ':vh' --long 'verbose,help' -- "$@") || exit
eval "set -- $args"

while true; do
    case $1 in
    -v | --verbose)
        ((VERBOSE++))
        shift
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

if [ "$#" -eq 0 ]; then
    echo >&2 You really need to tell me what to run on those containers
    echo $@
    exit 1
fi

if [ "$VERBOSE" -gt 1 ]; then
    echo "VERSIONS: ${VERSIONS[@]}"
fi

entrypoint=$1
shift

if [ "$VERBOSE" -gt 1 ]; then
    echo "ENGINE: $ENGINE"
    echo "entrypoint: $entrypoint"
    echo "args: $@"
    echo
fi

for version in ${VERSIONS[@]}; do
    if [[ "$ENGINE" != "docker" && "$ENGINE" != "podman" ]]; then
        echo >&2 "Unknown container engine: $ENGINE"
        exit 1
    fi

    cmd="$ENGINE run --rm --entrypoint $entrypoint $version $@"
    if [ "$VERBOSE" -gt 1 ]; then
        echo $cmd
    fi
    if [[ "$VERBOSE" -eq 1 ]]; then
        echo "${version}: $($cmd)"
    else
        $cmd
        if [ "$VERBOSE" -gt 1 ]; then
            echo
        fi
    fi
done
