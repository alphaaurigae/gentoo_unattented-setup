SYSTEMTIME() { # https://wiki.gentoo.org/wiki/System_time

	SET_TIMEZONE() {
		printf '%s\n' "$SYSTIMEZONE_SET" >/etc/timezone
		case "${SYSINITVAR,,}" in
			openrc)
				emerge --config sys-libs/timezone-data
				;;
			systemd)
				timedatectl set-timezone "$SYSTIMEZONE_SET"
				;;
		esac
	}

	NETMISC_OPENNTPD() {
		APPAPP_EMERGE="net-misc/openntpd "
		AUTOSTART_NAME_OPENRC="openntpd"
		AUTOSTART_NAME_SYSTEMD="openntpd"
		PACKAGE_USE
		ACC_KEYWORDS_USERAPP
		EMERGE_USERAPP_DEF
		AUTOSTART_DEFAULT_${SYSINITVAR}
	}

	NETMISC_CHRONY() {
		APPAPP_EMERGE="net-misc/chrony "
		AUTOSTART_NAME_OPENRC="chronyd"
		AUTOSTART_NAME_SYSTEMD="chronyd"
		PACKAGE_USE
		ACC_KEYWORDS_USERAPP
		EMERGE_USERAPP_DEF
		AUTOSTART_DEFAULT_${SYSINITVAR}
	}

	NETMISC_NTPD() {
		APPAPP_EMERGE="net-misc/ntp "
		AUTOSTART_NAME_OPENRC="ntpd"
		AUTOSTART_NAME_SYSTEMD="ntpd"
		PACKAGE_USE
		ACC_KEYWORDS_USERAPP
		EMERGE_USERAPP_DEF
		AUTOSTART_DEFAULT_${SYSINITVAR}
	}

	SET_SYSTEMCLOCK() {

		case "$SYSINITVAR" in
			OPENRC)
				case "$SYSCLOCK_SET" in
					MANUAL)
						date "$SYSDATE_MAN_OPENRC"
						;;
					AUTO)
						case "$NTP_PROVIDER" in
							openntpd) NETMISC_OPENNTPD ;;
							chronyd) NETMISC_CHRONY ;;
							ntpd) NETMISC_NTPD ;;
						esac
						;;
				esac
				;;
			SYSTEMD)
				case "$SYSCLOCK_SET" in
					MANUAL)
						timedatectl set-time "$SYSDATE_MAN_SYSTEMD"
						;;
					AUTO)
						case "$NTP_PROVIDER" in
							systemd-timesyncd)
								systemctl enable systemd-timesyncd
								systemctl start systemd-timesyncd
								systemctl daemon-reexec
								;;
							openntpd) NETMISC_OPENNTPD ;;
							chronyd) NETMISC_CHRONY ;;
							ntpd) NETMISC_NTPD ;;
						esac
						;;
				esac
				;;
		esac
	}

	SET_HWCLOCK() {
		[ -z "$SET_RTC" ] && printf '%s\n' "WARN: SET_RTC is unset"
		hwclock --systohc
		case "$SYSINITVAR" in
			OPENRC)
				rc-update delete hwclock boot
				cat /etc/conf.d/hwclock
				{
					printf '%s\n' 'clock_hctosys="YES"'
					printf '%s\n' 'clock_systohc="YES"'
					printf '%s\n' "clock=\"$SET_RTC\""
				} >/etc/conf.d/hwclock
				rc-service hwclock restart
				rc-update add hwclock boot
				;;
			SYSTEMD)
				timedatectl set-local-rtc $([ "$SET_RTC" = "local" ] && printf 1 || printf 0)
				;;
		esac
	}

	SET_TIMEZONE
	SET_SYSTEMCLOCK
	SET_HWCLOCK
}
