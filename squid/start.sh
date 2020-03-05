#!/usr/bin/env bash

[[ -z "${1}" ]] && NAME=squid || NAME="${1}"
docker run --name "${NAME}" --restart=unless-stopped -p 3128:3128/tcp squid &
