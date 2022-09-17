	APPADMIN () {
	NOTICE_START
		SUDO () {  # https://wiki.gentoo.org/wiki/Sudo
		NOTICE_START
			APPAPP_EMERGE="app-admin/sudo "  # (note!: must keep trailing)
			CONFIG_SUDO () {
			NOTICE_START
				cp /etc/sudoers /etc/sudoers_bak
				sed -ie 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
			NOTICE_END
			}
			EMERGE_USERAPP_DEF
			CONFIG_SUDO
		NOTICE_END
		}
		SYSLOG () {
		NOTICE_START
			# (!todo) # . /var/app/syslog.sh
			# SYSLOGNG
			SYSLOGNG_SYSLOG_SYSTEMD="syslog-ng@default"
			SYSLOGNG_SYSLOG_OPENRC="syslog-ng"
			SYSLOGNG_SYSLOG_EMERGE="app-admin/syslog-ng "
			# SYSKLOGD
			SYSKLOGD_SYSLOG_SYSTEMD=rsyslog
			SYSKLOGD_SYSLOG_OPENRC=sysklogd
			SYSKLOGD_SYSLOG_EMERGE="app-admin/sysklogd "
			SETVAR_SYSLOG () {
			NOTICE_START
				if [ "$SYSLOG" == "SYSLOGNG" ]; then
					AUTOSTART_NAME_SYSTEMD=$SYSLOGNG_SYSLOG_SYSTEMD
					AUTOSTART_NAME_OPENRC=$SYSLOGNG_SYSLOG_OPENRC
					SYSLOG_EMERGE=$SYSLOGNG_SYSLOG_EMERGE
				elif [ "$SYSLOG" == "SYSKLOGD" ] 
					then AUTOSTART_NAME_SYSTEMD=$SYSKLOGD_SYSLOG_SYSTEMD
					AUTOSTART_NAME_OPENRC=$SYSKLOGD_SYSLOG_OPENRC
					SYSLOG_EMERGE=$SYSLOGNG_SYSLOG_EMERGE
				else
					echo "${bold}ERROR: Could not detect '$SYSLOG' - debug syslog $SYSLOG ${normal}"
				fi
			NOTICE_END
			}
			SETVAR_SYSLOG
			APPAPP_EMERGE="$SYSLOG_EMERGE "
			EMERGE_USERAPP_DEF
			# SYSLOG_$SYSINITVAR  # (note!: autostart TODO)
			LOGROTATE () {
			NOTICE_START
				APPAPP_EMERGE="app-admin/logrotate "
				CONFIG_LOGROTATE_OPENRC () {
				NOTICE_START
					NOTICE_PLACEHOLDER
				NOTICE_END
				}
				CONFIG_LOGROTATE_SYSTEMD () {
				NOTICE_START
					systemd-tmpfiles --create /usr/lib/tmpfiles.d/logrotate.conf
				NOTICE_END
				}
				EMERGE_USERAPP_DEF
				CONFIG_LOGROTATE_$SYSINITVAR
			NOTICE_END
			}
			LOGROTATE
		NOTICE_END
		}
		SUDO
		SYSLOG
	NOTICE_END
	}