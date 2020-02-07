#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PATH="$DIR:$PATH"

function main() {
for i in $(device_connected.sh); do
echo $i
done
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
main "${@}"
fi
