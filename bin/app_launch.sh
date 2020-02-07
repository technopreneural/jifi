#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PATH="$PATH:$DIR"

network_reset_apps.sh
network_setup_interfaces.sh
network_setup_iptables.sh

docker run --name dnsmasq --restart=unless-stopped --net=host --cap-add=NET_ADMIN dnsmasq &
docker run --name hostapd --restart=unless-stopped --net=host --cap-add=NET_ADMIN --device=/dev/rfkill hostapd &
