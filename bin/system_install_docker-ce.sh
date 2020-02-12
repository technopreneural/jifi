#!/bin/bash

DEBIAN_FRONTEND=noninteractive

sudo apt-get update

sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

#sudo apt-key fingerprint 0EBFCD88

echo 'deb https://download.docker.com/linux/debian buster stable' |
sudo tee /etc/apt/sources.list.d/docker.list

sudo apt-get update

sudo apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker pi
