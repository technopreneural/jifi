#!/usr/bin/env bash

# Load essential values
. ../config/CONFIG

# Internal functions
function task_list_exec() { for i in $TASK_LIST; do eval $i; done; }

# Main function
function main() { while true; do task_list_exec(); sleep $TASK_INTERVAL; done; }

# Prevent direct execution
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then main $@; fi
