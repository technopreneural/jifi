#!/usr/bin/env bash

# Include libraries
. lib/path.lib.sh

# Command search path
[ $(in_path path_to_main) ]	|| add_to_path $(path_to_main)

# Load essential values
. ../config/CONFIG

# Internal functions
function iface_init() { iface.sh destroy $1; iface.sh create $1; iface.sh mac_set $1 $2; iface.sh ip_add $1 $3; }

function initialize() {
iface_init $DEVICE $MAC_ADDRESS $IP_ADDRESS
task.sh &; process.sh save TASK $!
hostapd_cli -a event.sh &; process.sh save HOSTAPD_CLI $!
}

function launch() { hostapd config/hostapd.conf -d -t -f /home/app/data/log.hostapd; }

function cleanup() { process.sh kill HOSTAPD_CLI; process.sh kill TASK; iface_destroy $MAC_ADDRESS; }

# Main function (event loop)
function main() { initialize; launch; cleanup; }

# Prevent direct execution
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then main $@; fi
