#!/usr/bin/env bash

tar czvf hostapd.tar *
docker build -f Dockerfile.squid -t squid .
rm hostapd.tar
docker image prune -f
