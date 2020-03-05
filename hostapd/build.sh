#!/usr/bin/env bash

tar czvf hostapd.tar --exclude={*.hostapd,*.sh,script2} *
docker build -f Dockerfile.hostapd -t hostapd .
rm hostapd.tar
docker image prune -f
