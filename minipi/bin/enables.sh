#!/usr/bin/env bash

apt-rdepends ${@} | sed '/.*Depends: /d' | sort | uniq
