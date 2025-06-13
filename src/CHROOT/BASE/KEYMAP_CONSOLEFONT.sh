KEYMAP_CONSOLEFONT() { # https://wiki.gentoo.org/wiki/Keyboard_layout_switching  ## (note:: theres a second place where keymaps are set, which is:"X11 KEYS SET = WINDOWSYS --> X11")
	NOTICE_START
	KEYMAP_CONSOLEFONT_OPENRC() {
		NOTICE_START
		KEYMAP_OPENRC() { # (!changeme in var)
			NOTICE_START
			AUTOSTART_NAME_OPENRC="keymaps"
			sed -ie 's/keymap="us"/keymap="$KEYMAP"/g' /etc/conf.d/keymaps
			sed -ie 's/keymap="de"/keymap="$KEYMAP"/g' /etc/conf.d/keymaps
			sed -ie "s/\$KEYMAP/$KEYMAP/g" /etc/conf.d/keymaps
			AUTOSTART_BOOT_OPENRC
			rc-update add keymaps boot
			NOTICE_END
		}
		CONSOLEFONT_OPENRC() {
			NOTICE_START
			AUTOSTART_NAME_OPENRC="consolefont"
			sed -ie 's/consolefont="default8x16"/consolefont="$CONSOLEFONT"/g' /etc/conf.d/consolefont
			sed -ie "s/\$CONSOLEFONT/$CONSOLEFONT/g" /etc/conf.d/consolefont # note: consolefont file also contains "conoletranslation=" ;  "unicodemap=" - not set here - disabled by default.
			AUTOSTART_BOOT_OPENRC
			NOTICE_END
		}
		etc-update --automode -3
		KEYMAP_OPENRC
		CONSOLEFONT_OPENRC
		NOTICE_END
	}
	KEYMAP_CONSOLEFONT_SYSTEMD() { # https://wiki.archlinux.org/index.php/Keyboard_configuration_in_console
		NOTICE_START
		AUTOSTART_NAME_SYSTEMD="placeholder"
		VCONSOLE_KEYMAP=$KEYMAP-latin1 # (!changeme) console keymap systemd
		VCONSOLE_FONT="$CONSOLEFONT"   # (!changeme)
		cat <<-EOF >/etc/vconsole.conf
			KEYMAP=$VCONSOLE_KEYMAP
			FONT=$VCONSOLE_FONT
		EOF
		NOTICE_END
	}
	ENVUD
	KEYMAP_CONSOLEFONT_$SYSINITVAR
	NOTICE_END
}
