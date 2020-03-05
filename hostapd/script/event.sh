#!/usr/bin/env bash

# Include libraries
. lib/path.lib.sh

# Process hostapd events
function main() {
echo $@
case $1 in
"AP-STA-CONNECTED"	) echo $2 connected;;
#session.sh start	$1;;
"AP-STA-DISCONNECTED"	) echo $2 disconnected;;
#session.sh stop	$1;;
esac
}

if [ "${BASH_SOURCE[0]}" == "${0}" ]; then main $@; fi
