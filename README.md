# Jifi
Jifi is a consumer wifi vendo software generally for the raspberry pi 3B+. 

## Architecture
It makes use of opensource components integrated with custom code. The main components are:
* docker
* hostapd
* dnsmasq
* python

## Folder Structure
There are 4 folders included
* install - contains installation scripts
* configs - contains configuration files (hostapd, dnsmasq, etc.)
* scripts - contains application scripts (station, credits, etc.)
* data    - contains data files (e.g. auth, acl, etc.) 

## Install Folder
* jifi_install.sh - updates raspberry pi and installs essential packages (e.g. docker)
* dockerfiles     - build docker images for hostapd, dnsmasq, and the python app

## Configs Folder
* hostapd.conf - access point configuration
* dnsmasq.conf - dhcp & dns configuration

## Scripts
This folder contains applications scripts that integrate various components and automate actions
* station - registraation (wps_pbc), allow/deny (acl)
* session - start/stop, duration, data usage, subscription mode (duration, time usage, data usage)
* counter - count/identify coins received, calculate transaction amount, record transactions:

## Data
This folder contains the data files shared across the app
* auth.wpa_psk
* acl.allow
* acl.deny
* req.wps_pin
