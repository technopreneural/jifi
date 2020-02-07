#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PATH="$DIR:$PATH"

function main() {
echo "Removing ${1} from list of connected stations"
sed -i "/${1}/d" "$DIR/../data/sta.connected"
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "${@}"
fi
