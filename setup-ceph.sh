#!/bin/bash

set -ex

cd /ceph
git clone https://github.com/openattic/ceph . | true
./install-deps.sh

cmake_called=False
if [ ! -d /ceph/build ]; then
    # do_cmake.sh enables ccache by default if ccache is available
    ./do_cmake.sh -DWITH_PYTHON3=ON -DWITH_TESTS=OFF
    cmake_called=True
fi
cd /ceph/build
if [ "${cmake_called}" -eq "False" ] ; then
    cmake -DWITH_CCACHE=ON -DWITH_TESTS=OFF -DWITH_PYTHON3=ON ..
fi
make -j$(nproc)

pip2 install -r /ceph/src/pybind/mgr/dashboard_v2/requirements.txt
pip3 install -r /ceph/src/pybind/mgr/dashboard_v2/requirements.txt
