ADMIN () {
NOTICE_START 
	ADD_GROUPS () {
	NOTICE_START
	 	for GRP in $USERGROUPS; do
			getent group "$GRP" >/dev/null || groupadd "$GRP"
		done

	NOTICE_END
	}
	ADD_USER () {
	NOTICE_START
		ASK_PASSWD () {
		NOTICE_START
			echo "${bold}Enter new $SYSUSERNAME password${normal}"
			until passwd $SYSUSERNAME
			do
			  echo "${bold}Enter new $SYSUSERNAME password${normal}"
			done
		NOTICE_END
		}
		local USERGROUPS_CSV="${USERGROUPS// /,}"
		if id "$SYSUSERNAME" &>/dev/null; then
			usermod -a -G "$USERGROUPS_CSV" "$SYSUSERNAME" || echo "Failed to modify user groups" >&2
		else
			useradd -m -g users -G "$USERGROUPS_CSV" -s /bin/bash "$SYSUSERNAME" || { echo "Failed to add user" >&2; }
		fi
		ASK_PASSWD
	NOTICE_END
	}
	VIRTADMIN_GROUPS () {
	NOTICE_START
		getent group vboxguest >/dev/null || groupadd vboxguest
		gpasswd -a "$SYSUSERNAME" vboxguest
	NOTICE_END
	}
	ADD_GROUPS
	ADD_USER
	VIRTADMIN_GROUPS
NOTICE_END
}