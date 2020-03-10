#!/usr/bin/env bash

tar czvf hostapd.tar script config data
docker build -f Dockerfile.hostapd -t hostapd .
rm hostapd.tar
docker image prune -f
