#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PATH="$PATH:$DIR"

function station_connect() {
session_start "${1}"
}

function station_disconnect() {
session_stop "${1}"
}

function station_enable() {
device_enable "${1}"
}

function station_disable() {
device_disable "${1}"
}

function main() {
case "${2}" in
"AP-STA-CONNECTED")
	station_connect "${3}"
	;;
"AP-STA-DISCONNECTED")
	station_disconnect "${3}"
	;;
"WPS-PBC-ACTIVE")
	# WPS Push Button enabled...
	;;
"WPS-PBC-DISABLE")
	# WPS Push Button disabled...
	;;
"WPS-PIN-NEEDED")
	;;
"WPS-REG-SUCCESS")
	device_enable "${3}"
	;;
*)
	;;
esac
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "${@}"
fi
