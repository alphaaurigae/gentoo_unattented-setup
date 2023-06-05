#!/bin/bash

GENTOO_UNATTENDED_SETUP_GITREPODIR="$WORKPATH_MAIN/gentoo_unattented-setup"

VMIPV4="192.168.178.97"
rsync -av --recursive --dry-run  $GENTOO_UNATTENDED_SETUP_GITREPODIR root@$VMIPV4:/root/

rsync -av --recursive --dry-run  $GENTOO_UNATTENDED_SETUP_GITREPODIR root@$VMIPV4:/root/
