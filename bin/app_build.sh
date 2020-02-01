#!/usr/bin/env bash

APPDIR="`find ~/ -name jifi`"

cd "${APPDIR}/dnsmasq"
./build.sh

cd "${APPDIR}/hostapd"

cat > "data/auth.wpa_psk" <<EOF
EOF

./build.sh

docker image prune -f

