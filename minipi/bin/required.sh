#!/usr/bin/env bash

dpkg-query -Wf '${Package;-40}${Priority}\n' | grep -E "required" | sed 's/[ ]*required$//'
