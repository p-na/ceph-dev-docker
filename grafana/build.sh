#!/bin/bash

sudo chmod -R o+rwx data/
docker build -t pse/grafana .
