#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PATH="$DIR:$PATH"

function main() {
echo "Adding ${1} to list of registered stations"
echo "${1}" >> "$DIR/../data/sta.registered"
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "${@}"
fi
