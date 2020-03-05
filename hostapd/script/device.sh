#!/usr/bin/env bash

# Include libraries
. lib/path.lib.sh
. lib/time.lib.sh

# Command search path
[ $(in_path path_to_main) ]	|| add_to_path path_to_main

# Files & paths
[ ${DATA_PATH+x} ]	|| DATA_PATH=$(realpath $(path_to_main)/../data)
[ ${DEV_PATH+x} ]	|| DEV_PATH=$DATA_PATH/devices

# Query functions
function list() {
case $1 in
banned		);;
blocked		);;
rejected	);;
timedout	);;
active		);;
inactive	);;
all		);;
esac
}

# Command functions
function add() { :; }

# Main function (process commands)
function main() {
case $1 in
list		) list		$2;;
add		) add		$2;;
block		) block		$2;;
unblock		) block		$2;;
register	) register	$2;;
unregister	) unregister	$2;;
esac
}

# Prevent direct execution
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then main $@; fi
