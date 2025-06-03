#!/bin/bash

GENTOO_UNATTENDED_SETUP_GITREPODIR="$WORKPATH_MAIN/gentoo_unattented-setup"

VMIPV4="192.168.178.61"


RSYNC_REPO_TO_VBOX () {
	printf '%q\n' "$VMIPV4"
	SSH_KEY_CHECK=$(ssh -o BatchMode=yes -o StrictHostKeyChecking=yes -o ConnectTimeout=5 root@"$VMIPV4" exit 2>&1)

	if echo "$SSH_KEY_CHECK" | grep -qE 'WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED|Offending key|Host key verification failed'; then
	ssh-keygen -R "$VMIPV4"
	fi

	#rsync -av --recursive --dry-run  $GENTOO_UNATTENDED_SETUP_GITREPODIR root@$VMIPV4:/root/
	rsync -av --recursive "$GENTOO_UNATTENDED_SETUP_GITREPODIR" root@"$VMIPV4":/root/
}

RSYNC_REPO_TO_VBOX

