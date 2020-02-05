#!/usr/bin/env bash

[[ -z "${1}" ]] && NAME=dnsmasq || NAME="${1}"
docker run --name "${NAME}" --restart=unless-stopped --net=host --cap-add=NET_ADMIN "${NAME}" &
