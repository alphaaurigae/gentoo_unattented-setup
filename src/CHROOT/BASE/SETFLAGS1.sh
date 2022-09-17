	SETFLAGS1 () {  # set custom flags (!NOTE: disabled by default) (!NOTE; was systemd specific, systemd not compete yet 05.11.2020)
	NOTICE_START
		SETFLAGSS1_OPENRC () {
			NOTICE_PLACEHOLDER
		}
		SETFLAGSS1_SYSTEMD () {  #(!todo)
			APPAPP_EMERGE="virtual/libudev "  # ! If your system set provides sys-fs/eudev, virtual/udev and virtual/libudev may be preventing systemd.  https://wiki.gentoo.org/wiki/Systemd
			EMERGE_USERAPP_DEF
			sed -ie '#echo "sys-apps/systemd cryptsetup#d'
			echo /etc/portage/package.use/systemd"sys-apps/systemd cryptsetup" >> /etc/portage/package.use/systemd
		}
		SETFLAGSS1_$SYSINITVAR
	NOTICE_END
	}