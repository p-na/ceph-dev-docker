#!/bin/bash

cd /ceph
git clone https://github.com/openattic/ceph .
./install-deps.sh

if [ ! -d /ceph/build ]; then
    ./do_cmake.sh -DWITH_PYTHON3=ON -DWITH_TESTS=OFF
fi
cd /ceph/build
make -j$(nproc)

pip2 install -r /ceph/src/pybind/mgr/dashboard_v2/requirements.txt
pip3 install -r /ceph/src/pybind/mgr/dashboard_v2/requirements.txt
