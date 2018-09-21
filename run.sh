#! /usr/bin/env bash

# Defaults
DEV_ENV_NO="one"
DISTRO="tumbleweed"
SHELL_TO_USE="zsh"

if [ ! -z "$1" ]; then
	DEV_ENV_NO="$1"
fi
if [ ! -z "$2" ]; then
	DISTRO="$2"
fi
if [ ! -z "$3" ]; then
	SHELL_TO_USE="$3"
fi
HOME_DIR=~/tmp/ceph-$DEV_ENV_NO-home
if [ ! -d $HOME_DIR ]; then
	mkdir -p $HOME_DIR
fi

if [ ! -d ~/tmp ]; then
	mkdir -p ~/tmp
fi


if [ ! -d $HOME_DIR/.ccache ]; then
	mkdir $HOME_DIR/.ccache
fi
cp ccache.conf $HOME_DIR/.ccache/

cp aliases $HOME_DIR/.aliases
cp zshrc $HOME_DIR/.zshrc
cp bashrc $HOME_DIR/.bashrc
cp funcs $HOME_DIR/.funcs
cp pdbrc $HOME_DIR/.pdbrc

if [ "$DEV_ENV_NO" = "one" ]; then
	docker run -it --rm \
		-v $HOME_DIR:/home/user \
		-v ~/src/ceph:/ceph \
		--network=host \
		--name=ceph-dev-$DISTRO \
		--hostname=ceph-dev-$DISTRO \
		--add-host=ceph-dev-$DISTRO:127.0.0.1 \
		ceph-dev:$DISTRO $SHELL_TO_USE
elif [ "$DEV_ENV_NO" = "two" ]; then
	docker run -it --rm \
		-v $HOME_DIR:/home/user \
		-v ~/src/ceph-two:/ceph \
		-e CEPH_PORT=9000 \
		-e CEPH_RGW_PORT=8001 \
		--network=host \
		--name=ceph-dev-${DISTRO}-two \
		--hostname=ceph-dev-${DISTRO}-two \
		--add-host=ceph-dev-${DISTRO}-two:127.0.0.1 \
		ceph-dev:${DISTRO} $SHELL_TO_USE
fi
