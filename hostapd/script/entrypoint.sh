#!/usr/bin/env bash

task_runner.sh &
hostapd config/hostapd.conf -d -t -f /home/app/data/log.hostapd
