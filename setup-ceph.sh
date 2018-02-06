#!/bin/bash


cd /ceph
git clone https://github.com/openattic/ceph .
./install-deps.sh

if [ ! -d /ceph/build ]; then
    ./do_cmake.sh
    cd /ceph/build
    make -j$(nproc)
else
    echo "skipping compilation... found /ceph/build"
fi

pip install -r /ceph/src/pybind/mgr/dashboard_v2/requirements.txt
