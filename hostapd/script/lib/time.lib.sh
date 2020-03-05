#!/usr/bin/env bash

# Detect if library is already loaded
[ ${JIFI_LIB+x} ]		|| declare -A JIFI_LIB
[ ${JIFI_LIB[$BASH_SOURCE]} ]	|| JIFI_LIB[$BASH_SOURCE]=true

# Query functions
function generate_timestamp() { echo $(date +$"%Y%m%d-%H%M%S-%3N-%z"); }

# Do nothing when executed directly
function main() { :; }

# Prevent direct execution
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then main $@; fi
