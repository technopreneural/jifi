#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PATH="$DIR:$PATH"

AUTH_FILE="$DIR/../data/auth.wpa_psk"
WPS_LOG="$DIR/../data/wps.log"

function remove_duplicates() {
DEVICE="${3}"; PSK=$( sed "/${DEVICE}/h; \$!d; x" "$AUTH_FILE" ); echo "+${PSK}" >> "${WPS_LOG}"
sed -i '/^\s*$/d;/'"${DEVICE}"'/{/'"${PSK}"'/!d}' "${AUTH_FILE}" && echo "Removing stale keys..."
}

function main() {
[ `grep "${3}" "$AUTH_FILE" | wc -l` -gt 1 ] && echo "Stale keys detected..." && remove_duplicates "${@}"
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
main "${@}"
fi
