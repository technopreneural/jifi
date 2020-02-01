#!/usr/bin/env bash

docker run --name dnsmasq --restart=unless-stopped --net=host --cap-add=NET_ADMIN dnsmasq &
docker run --name hostapd --restart=unless-stopped --net=host --cap-add=NET_ADMIN --device=/dev/rfkill hostapd &
