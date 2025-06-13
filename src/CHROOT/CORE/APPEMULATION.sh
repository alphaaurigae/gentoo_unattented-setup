APPEMULATION() {
	NOTICE_START
	VIRTUALBOX() {
		NOTICE_START
		SYS_HOST() {
			NOTICE_START
			NOTICE_PLACEHOLDER
			NOTICE_END
		}
		SYS_GUEST() {
			NOTICE_START
			GUE_VIRTUALBOX() {
				NOTICE_START
				# which kernel variables set the dependencies?
				APPAPP_EMERGE="app-emulation/virtualbox-guest-additions"
				AUTOSTART_NAME_OPENRC="virtualbox-guest-additions"
				PACKAGE_USE
				EMERGE_ATWORLD_B
				EMERGE_USERAPP_DEF
				AUTOSTART_DEFAULT_OPENRC
				VBoxClient-all
				rc-update add dbus boot
			}
			GUE_VIRTUALBOX
			NOTICE_END
		}
		SYS_$SYSVARD
		NOTICE_END
	}
	VIRTUALBOX
	NOTICE_END
}
