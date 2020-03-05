#!/usr/bin/env bash

[[ -z "${1}" ]] && NAME=hostapd || NAME="${1}"
docker run --name "${NAME}" --net=host --cap-add=NET_ADMIN  --device=/dev/rfkill -v -it --entrypoint=bash "${NAME}"
