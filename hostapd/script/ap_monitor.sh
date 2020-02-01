#!/usr/bin/env bash

function main() {
	case "${2}" in
	"AP-STA-CONNECTED")
		;&
	"AP-STA-DISCONNECTED")
		;&
	"WPS-PIN-NEEDED")
		echo "${@}"
		;&
	*)
	esac
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
