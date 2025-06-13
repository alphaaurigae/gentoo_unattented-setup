WINDOWSYS() {
	NOTICE_START
	X11() { # (! default) # https://wiki.gentoo.org/wiki/Xorg/Guide
		NOTICE_START
		EMERGE_XORG() {
			NOTICE_START
			APPAPP_EMERGE="x11-libs/gdk-pixbuf "
			EMERGE_USERAPP_DEF
			APPAPP_EMERGE="x11-base/xorg-server "
			PACKAGE_USE
			EMERGE_USERAPP_DEF
			ENVUD
			NOTICE_END
		}
		CONF_XORG() {
			NOTICE_START
			CONF_X11_KEYBOARD() {
				NOTICE_START
				# changed from Option "XkbLayout" "LANG_MAIN_LOWER,$LANG_SECOND_LOWER" - to have the corect keyboard layout after boot in the desktop environment (testing) 04.09.2022
				touch /usr/share/X11/xorg.conf.d/10-keyboard.conf
				cat <<-EOF >/usr/share/X11/xorg.conf.d/10-keyboard.conf
					Section "InputClass"
					    Identifier "keyboard-all"

					    Option "XkbLayout" "$KEYMAP"
					    Option "XkbVariant" "$X11_XKBVARIANT"
					    Option "XkbOptions" "$X11_KEYBOARD_XKB_OPTIONS"
					    MatchIsKeyboard "$X11_KEYBOARD_MATCHISKEYBOARD"
					EndSection
				EOF
				NOTICE_END
			}
			CONF_X11_KEYBOARD
			NOTICE_END
		}
		EMERGE_XORG
		CONF_XORG
		ENVUD
		NOTICE_END
	}
	$DISPLAYSERV
	NOTICE_END
}
