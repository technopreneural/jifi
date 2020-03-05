#!/usr/bin/env bash

# Detect if library is already loaded
[ ${JIFI_LIB+x} ]		|| declare -A JIFI_LIB
[ ${JIFI_LIB[$BASH_SOURCE]} ]	|| JIFI_LIB[$BASH_SOURCE]=true

# Query functions
function path_to_main() { echo $(realpath $(dirname $0)); }

function in_path() { [[ ":$PATH:" == *":$1:"* ]] && return 0 || return 1; }

# Command functions
function add_to_path() { in_path $1 || PATH=$PATH:$1; }

function remove_from_path() { TMP=${PATH//:$1/} && [[ $PATH == $TMP ]] && PATH=${PATH//$1:/} || PATH=$TMP; }

# Do nothing when executed directly
function main() { :; }

# Prevent direct execution
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then main $@; fi
