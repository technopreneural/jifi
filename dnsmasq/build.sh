#!/usr/bin/env bash

tar czvf dnsmasq.tar *
docker build -f Dockerfile.dnsmasq -t dnsmasq .
rm dnsmasq.tar
