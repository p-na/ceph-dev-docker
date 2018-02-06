#!/bin/bash

cd /ceph
git clone https://github.com/openattic/ceph .
./install-deps.sh

if [ ! -d /ceph/build ]; then
    ./do_cmake.sh $@
fi
cd /ceph/build
make -j$(nproc)

pip install -r /ceph/src/pybind/mgr/dashboard_v2/requirements.txt
