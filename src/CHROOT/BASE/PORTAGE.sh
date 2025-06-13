PORTAGE() { # https://wiki.gentoo.org/wiki/Portage#emerge-webrsync # https://dev.gentoo.org/~zmedico/portage/doc/man/emerge.1.html
	NOTICE_START
	mkdir /usr/portage
	emerge-webrsync
	NOTICE_END
}
