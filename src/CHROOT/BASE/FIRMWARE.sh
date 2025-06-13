FIRMWARE() {
	NOTICE_START
	LINUX_FIRMWARE() { # https://wiki.gentoo.org/wiki/Linux_firmware
		NOTICE_START

		APPAPP_EMERGE="sys-kernel/linux-firmware "
		PACKAGE_USE
		LICENSE_SET
		EMERGE_ATWORLD
		EMERGE_USERAPP_DEF
		etc-update --automode -3 # (automode -3 = merge all)
		NOTICE_END
	}
	LINUX_FIRMWARE
	NOTICE_END
}
