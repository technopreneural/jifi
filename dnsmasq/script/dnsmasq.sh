#!/usr/bin/env bash
dnsmasq --test -C config/dnsmasq.conf
dnsmasq -d -C config/dnsmasq.conf
