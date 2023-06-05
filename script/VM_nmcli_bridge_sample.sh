#!/bin/bash

SHOW_NET () { # show net setup
	nmcli con show
	nmcli connection show --active 
}

SETUP_BRIDGE () {
	ADD_BRIDGE () {
		nmcli con add ifname $BRIDGE1 type bridge con-name $BRIDGE1 # add a bridge adapter
	}
	ADD_BRSLAVE () {
		nmcli con add type bridge-slave ifname $NIC1 master $BRIDGE1 # create BRIDGE_SLAVE
	}
	ADD_BRIDGE
	ADD_BRSLAVE
}

MOD_BRIDGE () {
	nmcli con mod $BRIDGE1 +ipv4.dns $DNSIPV4_1 +ipv4.dns $DNSIPV4_2
}

REMOVE_DEFWIRE () {
	wired1="Wired connection 1"
	nmcli con down "$(echo $wired1)"
}

START_BRIDGE () {
	nmcli con up $BRIDGE1
}

RELOAD_NET () {

	sudo nmcli connection reload
	sudo systemctl restart NetworkManager.service
}

SHOW_NET
SETUP_BRIDGE
MOD_BRIDGE
brctl show
REMOVE_DEFWIRE
START_BRIDGE
RELOAD_NET