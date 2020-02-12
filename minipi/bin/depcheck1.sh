#!/usr/bin/env bash

#apt-cache depends \
#--recurse \
#--no-recommends \
#--no-suggests \
#--no-conflicts \
#--no-breaks \
#--no-replaces \
#--no-enhances \
#"${@}" | sed 's/^.*Depends: *//;s/^[ |]*//;s/^<//;s/>$//' | sort | uniq

apt-rdepends "${@}" | sed 's/.*Depends: //;s/ (.*//' | sort | uniq
