#!/bin/bash

# https://github.com/pi-hole/docker-pi-hole/blob/master/README.md

function default_mode() {
docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp \
    -p 67:67/udp \
    -p 80:80 \
    -p 443:443 \
    -e TZ="Asia/Manila" \
    -v "$(pwd)/etc-pihole/:/etc/pihole/" \
    -v "$(pwd)/etc-dnsmasq.d/:/etc/dnsmasq.d/" \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=unless-stopped \
    pihole/pihole:latest
}

function host_mode() {
DataPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/data"
ServerIP=$(hostname -I | cut -d ' ' -f 1)
#echo $ServerIP; exit 0;
docker run -d \
    --net=host \
    --cap-add=NET_ADMIN \
    --name pihole \
    -e TZ="Asia/Manila" \
    -e ServerIP=192.168.1.6 \
    -v "${DataPath}/etc-pihole/:/etc/pihole/" \
    -v "${DataPath}/etc-dnsmasq.d/:/etc/dnsmasq.d/" \
    --dns=1.1.1.1 \
    --restart=unless-stopped \
    # Manually invoke s6-init
    -it --entrypoint=bash \
    pihole/pihole:latest
}

host_mode
#default_mode

printf 'Starting up pihole container '
for i in $(seq 1 20); do
    if [ "$(docker inspect -f "{{.State.Health.Status}}" pihole)" == "healthy" ] ; then
        printf ' OK'
        echo -e "\n$(docker logs pihole 2> /dev/null | grep 'password:') for your pi-hole: https://${IP}/admin/"
        exit 0
    else
        sleep 3
        printf '.'
    fi

    if [ $i -eq 20 ] ; then
        echo -e "\nTimed out waiting for Pi-hole start, consult check your container logs for more info (\`docker logs pihole\`)"
        exit 1
    fi
done;
