#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PATH="$PATH:$DIR"

function main() {
case "${2}" in
"AP-STA-CONNECTED")
	device_connect.sh "${3}"
	;;
"AP-STA-DISCONNECTED")
	device_disconnect.sh "${3}"
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
	echo "Registration was successful"
	device_enable.sh "${@}"
	;;
*)
	;;
esac
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "${@}"
fi
