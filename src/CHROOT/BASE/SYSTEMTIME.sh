	SYSTEMTIME () {  # https://wiki.gentoo.org/wiki/System_time
	NOTICE_START
		SET_TIMEZONE () {
		NOTICE_START
			printf '%s\n' "$SYSTIMEZONE_SET" > /etc/timezone
			TIMEZONE_OPENRC () {
			NOTICE_START
				printf '%s\n' "$SYSTIMEZONE_SET" > /etc/timezone
				APPAPP_EMERGE=" --config sys-libs/timezone-data "
				EMERGE_USERAPP_DEF
			NOTICE_END
			}
			TIMEZONE_SYSTEMD () {
			NOTICE_START
				timedatectl set-timezone $SYSTIMEZONE_SET
			NOTICE_END
			}
			TIMEZONE_$SYSINITVAR
		NOTICE_END
		}
		SET_SYSTEMCLOCK () {  # https://wiki.gentoo.org/wiki/System_time#System_clock
		NOTICE_START
			SYSTEMCLOCK_OPENRC () {
			NOTICE_START
				OPENRC_SYSCLOCK_MANUAL () {
				NOTICE_START
					OPENRC_SYSTEMCLOCK () {
					NOTICE_START
						date $SYSDATE_MAN
					NOTICE_END
					}
					OPENRC_SYSTEMCLOCK
				NOTICE_END
				}
				OPENRC_OPENNTPD () {
					APPAPP_EMERGE="net-misc/openntpd"
					SYSSTART_OPENNTPD () {
						AUTOSTART_NAME_OPENRC="ntpd"
						AUTOSTART_DEFAULT_OPENRC
					NOTICE_END
					}
					EMERGE_USERAPP_DEF
					SYSSTART_OPENNTPD
				NOTICE_END
				}
				# OPENRC_SYSCLOCK_MANUAL  # (!changeme: only 1 can be set)
				OPENRC_OPENNTPD
			NOTICE_END
			}
			SYSTEMCLOCK_SYSTEMD () {  # https://wiki.gentoo.org/wiki/System_time#Hardware_clock
			NOTICE_START
				SYSTEMD_SYSCLOCK_MANUAL () {
				NOTICE_START
					timedatectl set-time "$SYSCLOCK_MAN"
				NOTICE_END
				}
				SYSTEMD_SYSCLOCK_AUTO () {
				NOTICE_START
					SYSSTART_TIMESYND () {
					NOTICE_START
						AUTOSTART_NAME_SYSTEMD="systemd-timesyncd"
						AUTOSTART_DEFAULT_SYSTEMD
						# timedatectl set-local-rtc 0 # 0 set UTC
					NOTICE_END
					}
					SYSSTART_TIMESYND
				NOTICE_END
				}
				SYSTEMD_SYSCLOCK_$SYSCLOCK_SET
			NOTICE_END
			}
			SYSTEMCLOCK_$SYSINITVAR
		NOTICE_END
		}
		SET_HWCLOCK () {
		NOTICE_START
			hwclock --systohc
		NOTICE_END
		}
		SET_TIMEZONE  # err for systemd if install medium isnt systemd
		SET_SYSTEMCLOCK  # err for systemd, if install medium isnt systemd
		SET_HWCLOCK
	NOTICE_END
	}