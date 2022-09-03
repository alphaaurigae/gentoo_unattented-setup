#!/bin/bash

rsync --recursive --dry-run -v  gentoo_unattented-setup/ root@192.168.178.168:gentoo_unattended-setup

