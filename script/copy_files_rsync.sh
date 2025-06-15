#!/bin/bash

GENTOO_UNATTENDED_SETUP_GITREPODIR="$WORKPATH_MAIN/gentoo_unattented-setup"

VMIPV4="192.168.178.52"

VMIPV4_LIST=(
	192.168.178.39
)

BOLD=$(tput bold)
RESET=$(tput sgr0)
# Regular colors
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)

# Bright colors
BRIGHT_BLACK=$(tput setaf 8)
BRIGHT_RED=$(tput setaf 9)
BRIGHT_GREEN=$(tput setaf 10)
BRIGHT_YELLOW=$(tput setaf 11)
BRIGHT_BLUE=$(tput setaf 12)
BRIGHT_MAGENTA=$(tput setaf 13)
BRIGHT_CYAN=$(tput setaf 14)
BRIGHT_WHITE=$(tput setaf 15)

RSYNC_REPO_TO_VBOX() {
	local ip="$1"

	printf "%s%s%s\n" "${BOLD}${GREEN}" "$ip" "${RESET}"

	SSH_KEY_CHECK=$(ssh -o BatchMode=yes -o StrictHostKeyChecking=yes -o ConnectTimeout=5 root@"$ip" exit 2>&1)

	if printf '%s\n' "$SSH_KEY_CHECK" | grep -qE 'WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED|Offending key|Host key verification failed'; then
		ssh-keygen -R "$ip"
	fi

	# Remove ssh connectivity test to allow password prompt during rsync
	rsync -av --recursive "$GENTOO_UNATTENDED_SETUP_GITREPODIR" root@"$ip":/root/ || \
		printf "%srsync to %s failed.%s\n" "${BOLD}${YELLOW}" "$ip" "${RESET}"
}

for ip in "${VMIPV4_LIST[@]}"; do
	RSYNC_REPO_TO_VBOX "$ip"
done