#!/usr/bin/env bash

# Load essential values
. ../config/CONFIG
. $PROCESS_DATA

# Query functions
function get() { sed -n '/$1/p' | cut -d '=' -f 2; }

# Command functions
function save() { grep -q "$1=" $PROCESS_DATA && sed -i "/$1/ s/=.*/=$2/" || echo $1=$2 >> $PROCESS_DATA; }

function kill() { kill -9 $(pid_get $1); }

# Main function
function main() {
case
get	) get	$@;;
save	) save	$@;;
kill	) kill	$@;;
esac
}

# Prevent direct execution
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then main $@; fi
