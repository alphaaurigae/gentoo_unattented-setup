USERAPP_GIT() { # (note: already setup through use flag make.conf?)
	NOTICE_START
	APPAPP_EMERGE="dev-vcs/git"
	PACKAGE_USE
	EMERGE_USERAPP_DEF
	NOTICE_END
}
