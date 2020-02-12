#!/usr/bin/env bash

#apt-rdepends "${@}" | grep Depends: | sed 's/.*Depends: //;s/ (.*//' | sort | uniq
apt-rdepends "${@}" | sed 's/.*Depends: //;s/ (.*//' | sort | uniq
