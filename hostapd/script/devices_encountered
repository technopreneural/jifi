#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PATH="$PATH:$DIR"

function main() {
iw dev ap0 station dump | sed -n "/Station/p" | cut -d " " -f 2
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "${@}"
fi
