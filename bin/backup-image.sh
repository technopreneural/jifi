#!/bin/bash

function disk_wipe_empty_space() {
dd if=/dev/zero of=zero.tmp; sleep 1; rm zero.tmp && return 0 || return 1
}

function disk_save_compressed_image() {
sudo dd bs=4M conv=sparse if=/dev/mmcblk0 | gzip > "${TARGET_FILE_NAME}" && return 0 || return 1
}

function file_generate_name() {
PREFIX_NAME="backup" && [[ -z "${1}" ]] || PREFIX_NAME="${1}"
BACKUP_DATE="$(date '+%Y%m%d')"
OUTPUT_FILE="${PREFIX_NAME}-${BACKUP_DATE}.img.gz"
}

function main() {
file_generate_name "${1}" && echo "${OUTPUT_FILE}"
disk_save_compressed_image && return 0 || return 1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
