#!/bin/bash

function disk_wipe_empty_space() {
ZERO_FILE="zero.tmp"
[[ -z "${1}" ]] || ZERO_FILE="${1}/${ZERO_FILE}" && echo "${ZERO_FILE}"
#dd if=/dev/zero of="${ZERO_FILE}"; sleep 1; rm "${ZERO_FILE}" && return 0 || return 1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    disk_wipe_empty_space "$@"
fi
