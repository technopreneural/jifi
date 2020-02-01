#!/bin/bash

DEBIAN_FRONTEND=noninteractive

sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

#sudo apt-key fingerprint 0EBFCD88

ARCH="`uname -m`"

case "${ARCH}" in
"armv7l")
ARCH="[arch=armhf]";;
*)
unset ARCH;;
esac

sudo add-apt-repository \
   'deb "${ARCH}" https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable'

#sudo apt-get update

#sudo apt-get install docker-ce docker-ce-cli containerd.io

#sudo usermod -aG docker pi