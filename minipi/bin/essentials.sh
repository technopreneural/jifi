#!/usr/bin/env bash

dpkg-query -Wf '${Package;-40}${Essential}\n' | grep yes | sed 's/[ ]*yes$//'

apt list \
apt \
apt-utils \
apt-rdepends \
cron \
iw \
iproute2 \
dnsutils \
rfkill \
openssh-server \
raspberrypi-archive-keyring \
raspberrypi-bootloader \
raspberrypi-kernel \
raspberrypi-net-mods \
raspberrypi-sys-mods \
raspbian-archive-keyring \
raspi-config \
raspi-copies-and-fills \
raspi-gpio \
raspinfo \
firmware-brcm80211 | \
sed 's/\/.*//;/^ *$/d;/Listing.../d;'

