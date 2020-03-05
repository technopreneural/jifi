#!/usr/bin/env bash

# Include libraries
. lib/path.lib.sh
. lib/time.lib.sh

# Command search path
[ $(in_path path_to_main) ]	|| add_to_path $(path_to_main)

# Files & paths
[ ${DATA_PATH+x} ]	|| DATA_PATH=$(realpath $(path_to_main)/../data)
[ ${SESH_PATH+x} ]	|| SESH_PATH=$DATA_PATH/sessions

# Internal functions
function generate_name() { echo $(generate_timestamp).open.$1.session; }

function get_latest_open_session() { $(ls -t $DATA_PATH/*.open.$1.session); }

# External functions
function start() {
if $(device.sh has_credits $1); then
[ ${SESH_PATH+x} ] || mkdir -p $SESH_PATH || system.sh error "cannot create sessions folder"
SESH=$DATA_PATH/$(generate_name $1); touch $SESH && [ -f $SESH ] && echo $SESH >> $DATA_PATH/sessions.all
else
device.sh disconnect $1
fi
}

function end() {
OPEN=$(get_latest_open_session $1); CLOSED=${OPEN//open/$(generate_timestamp)}
mv $OPEN $CLOSED && [ -f $CLOSED ] && sed -i "s/$OPEN/$CLOSED/" $DATA_PATH/sessions.all
}

function list() { echo $(iw dev ap0 station dump | sed -n "/Station/p" | cut -d " " -f 2); }

# Main function (process commands)
function main() {
case $1 in
start	) start $2;;
end	) end   $2;;
list	) list	$2;;
esac
}

# Prevent direct execution
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then main $@; fi
