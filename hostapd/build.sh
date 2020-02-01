#!/usr/bin/env bash

tar czvf hostapd.tar *
docker build -f Dockerfile.hostapd -t hostapd .
rm hostapd.tar
