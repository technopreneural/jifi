#!/usr/bin/env bash

# Load essential values
. ../config/CONFIG

# Query functions
function exists() { iw dev | grep -iq "interface $1"; }

function has_mac() { iw dev | sed -n "/[iI]nterface ap0/,/txpower/ p;" | grep addr | [ `wc -l` -gt 0 ]; }

function has_ip() { ip addr show $1 | grep -q 'inet $2'; }

# Command functions
function create() { iw phy phy0 interface add $1 type __ap; }

function destroy() { iw dev $1 del; }

function mac_set() { ip link set dev $1 address $2; }

function ip_add() { ip addr add $2 dev $1; }

function ip_del() { ip addr del $2 dev $1; }

function ip_flush() { ip addr flush dev $1; }

# Main function
function main() {
case
exists		) exists	$@;;
has_mac		) has_mac	$@;;
has_ip		) has_ip	$@;;
create		) create	$@;;
destroy		) destroy	$@;;
mac_set		) mac_set	$@;;
ip_add		) ip_add	$@;;
ip_del		) ip_del	$@;;
ip_flush	) ip_flush	$@;;
esac
}

# Prevent direct execution
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then main $@; fi
