APP() {
	NOTICE_START
	APP_PORTAGE() {
		SYSAPP_CPUID2CPUFLAGS() {
			NOTICE_START
			APPAPP_EMERGE="app-portage/cpuid2cpuflags "
			EMERGE_USERAPP_DEF
			NOTICE_END
		}
		SYSAPP_CPUID2CPUFLAGS
	}
	APP_CRYPT() {
		NOTICE_START
		SYSAPP_GNUPG() {
			NOTICE_START
			# SETVAR_GNUPG
			APPAPP_EMERGE="app/crypt/gnupg "
			EMERGE_USERAPP_DEF
			gpg --full-gen-key
			NOTICE_END
		}
		SYSAPP_GNUPG
		NOTICE_END
	}
	APP_PORTAGE
	APP_CRYPT
	NOTICE_END
}
