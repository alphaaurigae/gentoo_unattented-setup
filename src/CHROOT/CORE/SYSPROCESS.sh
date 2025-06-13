SYSPROCESS() {
	NOTICE_START
	CRON() {
		NOTICE_START
		# (!todo) . /var/app/cron.sh
		## CRON - https://wiki.gentoo.org/wiki/Cron#Which_cron_is_right_for_the_job.3F
		# BCRON # http://untroubled.org/bcron
		BCRON_CRON_SYSTEMD=placeholder
		BCRON_CRON_OPENRC=placeholder
		BCRON_CRON_EMERGE=sys-process/bcron
		# FCRON # http://www.linuxfromscratch.org/blfs/view/systemd/general/fcron.html
		FCRON_CRON_SYSTEMD=fcron
		FCRON_CRON_OPENRC=fcron
		FCRON_CRON_EMERGE=sys-process/fcron
		# DCRON # http://www.linuxfromscratch.org/hints/downloads/files/dcron.txt
		DCRON_CRON_SYSTEMD=razor-session
		DCRON_CRON_OPENRC=razor-session
		DCRON_CRON_EMERGE=sys-process/dcron
		# CRONIE
		CRONIE_CRON_SYSTEMD=cronie
		CRONIE_CRON_OPENRC=cronie
		CRONIE_CRON_EMERGE=sys-process/cronie
		# VIXICRON
		VIXICRON_CRON_SYSTEMD=vixi
		VIXICRON_CRON_OPENRC=vixi
		VIXICRON_CRON_EMERGE=sys-process/vixie-cron

		SETVAR_CRON() {
			NOTICE_START
			for i in $CRON; do
				CRON_SYSTEMD=$i\_CRON_SYSTEMD
				CRON_OPENRC=$i\_CRON_OPENRC
				CRON_EMERGE=$i\_CRON_EMERGE
			done
			NOTICE_END
		}
		CONFIG_CRON() {
			NOTICE_START
			crontab /etc/crontab
			NOTICE_END
		}
		SETVAR_CRON
		APPAPP_EMERGE="${!CRON_EMERGE}"
		AUTOSTART_NAME_OPENRC="${!CRON_OPENRC}"
		AUTOSTART_NAME_OPENRC="${!CRON_SYSTEMD}"
		printf '%s\n' "$APPAPP_EMERGE"
		EMERGE_USERAPP_DEF
		CONFIG_CRON
		AUTOSTART_DEFAULT_$SYSINITVAR
		NOTICE_END
	}
	TOP() {
		NOTICE_START
		HTOP() {
			NOTICE_START
			APPAPP_EMERGE="sys-process/htop "
			EMERGE_USERAPP_DEF
			NOTICE_END
		}
		IOTOP() {
			NOTICE_START
			APPAPP_EMERGE="sys-process/iotop "
			EMERGE_USERAPP_DEF
			NOTICE_END
		}
		HTOP
		IOTOP
		NOTICE_END
	}
	CRON
	TOP
	NOTICE_END
}
