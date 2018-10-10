#!/bin/bash

find bin -type f -exec docker cp {} ceph-dev-tumbleweed:/usr/local/bin/ \;
