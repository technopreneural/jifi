#!/bin/bash

function disk_save_compressed_sparse_image() {
sudo sh -c "dd bs=4M conv=sparse if=/dev/mmcblk0 | gzip > ${1}" && return 0 || return 1
}

function file_generate_name() {
PREFIX_NAME="backup" && [[ -z "${1}" ]] || PREFIX_NAME="${1}"
BACKUP_DATE="$(date '+%Y%m%d')"
OUTPUT_FILE="${PREFIX_NAME}-${BACKUP_DATE}.img.gz"
echo "${OUTPUT_FILE}"
}

function main() {
disk_save_compressed_sparse_image "$( file_generate_name ${1} )" && return 0 || return 1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "${@}"
fi
