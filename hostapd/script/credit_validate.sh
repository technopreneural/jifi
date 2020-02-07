#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PATH="$DIR:$PATH"
CHECK_INTERVAL=6
TARGET="$DIR/../data/testfile"

function main() {
while true; do
credit_update
credit_validate
sleep "${CHECK_INTERVAL}"
done
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
main "${@}"
fi
