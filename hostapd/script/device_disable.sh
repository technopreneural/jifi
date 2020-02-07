#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PATH="$DIR:$PATH"

AUTH_FILE="$DIR/../data/auth.wpa_psk"
WPS_LOG="$DIR/../data/wps.log"

function main() {
DEVICE="${3}"; echo "-${PSK}" >> "${WPS_LOG}"
sed -i "/${3}/d" "${AUTH_FILE}"
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "${@}"
fi
