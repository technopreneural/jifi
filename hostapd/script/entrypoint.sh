#!/usr/bin/env bash

function check_error() {
RESULT=${1} && FAILURE_MESSAGE=${2} && SUCCESS_MESSAGE=${3}
if [ $RESULT -ne 0 ]; then
        echo "${FAILURE_MESSAGE}. Aborting."
        exit $RESULT
else echo "${SUCCESS_MESSAGE}"
fi
}

function interface_exists() {
ip link show ${1} > /dev/null 2>&1; RESULT=$?
if [ $RESULT -ne 0 ]; then echo "Cannot find interface ${1}."; return $RESULT; fi
}

function interface_get_mac() {
if interface_exists ${1}; then echo `ip link show ${1} | grep -v ${1} | sed 's/^ *//;s/ +/ /' | cut -d ' ' -f 2`; fi
}

function interface_get_ip() {
if interface_exists ${1}; then echo `ip addr show ${1} | grep 'inet ' | sed "s/^ \+//;s/  \+/ /g" | cut -d ' ' -f 2`; fi
}

function create_virtual_wireless_interface() {
echo creating interface ${1}...
if interface_exists ${1}; then echo "Interface ${1} already exists."
else
iw phy phy0 interface add ${1} type __ap
check_error $? "Cannot create interface ${1}." "Interface ${1} created successfully."
fi
}

function set_virtual_wireless_interface_mac_address() {
echo setting mac...
if [[ $(interface_get_mac ${1}) == ${2} ]]; then echo "Interface ${1} mac address already set."
else
ip link set dev ${1} address ${2}
check_error $? "Cannot set mac address for interface ${1}." "Interface ${1} mac address set successfully."
fi
}

function set_virtual_wireless_interface_ip_address() {
echo setting ip...
if [[ $(interface_get_ip ${1}) == ${2} ]]; then echo "Interface ${1} ip address already configured."
else
ip addr add ${2} dev ${1}
check_error $? "Cannot set ip address for interface ${1}." "Interface ${1} ip address set successfully."
fi
}

function interface_remove() {
echo "Removing interface ${1}..."
iw dev ${1} del; check_error $? "Cannot remove interface ${1}" "Interface ${1} removed successfully."
}

function task_runner_launch() {
/home/app/script/device_monitor.sh &
TASK_RUNNER=$!
}

function task_runner_shutdown() {
kill -9 $TASK_RUNNER
}

function container_cleanup() {
interface_remove $WIFI_DEV
task_runner_shutdown
}

function container_launch() {
hostapd config/hostapd.conf -d -t -f /home/app/data/log.hostapd
HOSTAPD=$!
}

function container_initialize() {
MAC_ADDR=b2:27:eb:e9:70:7a
IP_ADDR=192.168.2.240/24
WIFI_DEV=ap0

HOSTAPD=hostapd
HOSTAPD_OPT=-d -t -f
HOSTAPD_CFG=/home/app/config/hostapd.conf
HOSTAPD_LOG=/home/app/data/log.hostapd

TASK_RUNNER=/home/app/script/task_runner.sh
TASK_RUNNER_PID=0

create_virtual_wireless_interface $WIFI_DEV
set_virtual_wireless_interface_mac_address ap0 $MAC_ADDR
set_virtual_wireless_interface_ip_address ap0 $IP_ADDR
}

function main() {
container_initialize
container_launch
container_cleanup
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
