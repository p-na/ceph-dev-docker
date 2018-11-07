#!/bin/bash

find bin -type f -exec docker cp {} ceph-dev-tumbleweed-1:/usr/local/bin/ \;
