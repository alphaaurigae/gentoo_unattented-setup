ADMIN() {
	NOTICE_START
	ADD_GROUPS() {
		NOTICE_START
		for GRP in $USERGROUPS; do
			getent group "$GRP" >/dev/null || groupadd "$GRP"
		done

		NOTICE_END
	}
	ADD_USER() {
		NOTICE_START
		ASK_PASSWD() {
			NOTICE_START
			printf '%s\n' "${BOLD}Enter new $SYSUSERNAME password${RESET}"
			until passwd $SYSUSERNAME; do
				printf '%s\n' "${BOLD}Enter new $SYSUSERNAME password${RESET}"
			done
			NOTICE_END
		}
		local USERGROUPS_CSV="${USERGROUPS// /,}"
		if id "$SYSUSERNAME" &>/dev/null; then
			usermod -a -G "$USERGROUPS_CSV" "$SYSUSERNAME" || printf '%s\n' "Failed to modify user groups" >&2
		else
			useradd -m -g users -G "$USERGROUPS_CSV" -s /bin/bash "$SYSUSERNAME" || { printf '%s\n' "Failed to add user" >&2; }
		fi
		ASK_PASSWD
		NOTICE_END
	}
	VIRTADMIN_GROUPS() {
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
