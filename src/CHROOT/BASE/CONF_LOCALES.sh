CONF_LOCALES() { # https://wiki.gentoo.org/wiki/Localization/Guide
	CONF_LOCALEGEN() {
		NOTICE_START
		cat <<-EOF >/etc/locale.gen
			$PRESET_LOCALE_A ISO-8859-1
			$PRESET_LOCALE_A.UTF-8 UTF-8
			$PRESET_LOCALE_B ISO-8859-1
			$PRESET_LOCALE_B.UTF-8 UTF-8
		EOF
		cat /etc/locale.gen
		NOTICE_END
	}
	GEN_LOCALE() {
		NOTICE_START
		locale-gen
		NOTICE_END
	}
	SYS_LOCALE() { # (!todo)
		NOTICE_START
		SYSLOCALE="$PRESET_LOCALE_A.UTF-8"
		SYSTEMLOCALE_OPENRC() { # https://wiki.gentoo.org/wiki/Localization/Guide#OpenRC
			cat <<-EOF >/etc/env.d/02locale
				LANG="$SYSLOCALE"
				LC_COLLATE="C" # Define alphabetical ordering of strings. This affects e.g. output of sorted directory listings.
				# LC_CTYPE=$PRESET_LOCALE_A.UTF-8 # (!NOTE: not tested yet)
			EOF
			cat /etc/env.d/02locale
			env-update && source /etc/profile || printf "env-update failed\n"
			NOTICE_END
		}
		SYSTEMLOCALE_SYSTEMD() { # https://wiki.gentoo.org/wiki/Localization/Guide#systemd
			localectl set-locale LANG=$SYSLOCALE
			localectl | grep "System Locale"
			NOTICE_END
		}
		SYSTEMLOCALE_$SYSINITVAR
		NOTICE_END
	}
	CONF_LOCALEGEN
	GEN_LOCALE
	SYS_LOCALE
	NOTICE_END
}
