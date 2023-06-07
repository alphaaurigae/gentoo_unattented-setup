	INITRAM () {
	NOTICE_START
		INITRAMFS () {  # https://wiki.gentoo.org/wiki/Initramfs
		NOTICE_START
			INITRFS_GENKERNEL () {
			NOTICE_START
				# genkernel --config=/etc/genkernel.conf initramfs
				genkernel $GENKERNEL_CMD
			NOTICE_END
			}
			INITRFS_DRACUT () {  # https://wiki.gentoo.org/wiki/Dracut
			NOTICE_START
				APPAPP_EMERGE="sys-kernel/dracut"
				CONFIG_DRACUT () {
				NOTICE_START
#					DRACUT_USERMOUNTCONF () {
#					NOTICE_START
#						cat << EOF > /etc/dracut.conf.d/usrmount.conf
#						add_dracutmodules+="$DRACUT_CONFD_ADD_DRACUT_MODULES"  # Dracut modules to add to the default
#EOF
#						cat /etc/dracut.conf.d/usrmount.conf
#					NOTICE_END
#					}
					DRACUT_DRACUTCONF () {
					NOTICE_START
						if [ $CRYPTSETUP = "YES" ]; then
							echo "dracut cryptsetup"
							cat <<- EOF > /etc/dracut.conf

							#i18n_install_all="yes"
							i18n_vars="/etc/conf.d/keymaps:keymap-KEYMAP,extended_keymaps-EXT_KEYMAPS /etc/conf.d/consolefont:consolefont-FONT,consoletranslation-FONT_MAP /etc/rc.conf:unicode-UNICODE"

							hostonly="$DRACUT_CONF_HOSTONLY"
							lvmconf="$DRACUT_CONF_LVMCONF"
							dracutmodules+="$DRACUT_CONF_MODULES_CRYPTSETUP"
							EOF
							cat /etc/dracut.conf
						else
							echo "dracut lvm"
							cat <<- EOF > /etc/dracut.conf

							#i18n_install_all="yes"
							i18n_vars="/etc/conf.d/keymaps:keymap-KEYMAP,extended_keymaps-EXT_KEYMAPS /etc/conf.d/consolefont:consolefont-FONT,consoletranslation-FONT_MAP /etc/rc.conf:unicode-UNICODE"

							hostonly="$DRACUT_CONF_HOSTONLY"
							lvmconf="$DRACUT_CONF_LVMCONF"
							dracutmodules+="$DRACUT_CONF_MODULES_LVM"
							EOF
							cat /etc/dracut.conf
						fi
					NOTICE_END
					}
					#DRACUT_USERMOUNTCONF
					DRACUT_DRACUTCONF
				NOTICE_END
				}
				PACKAGE_USE
				EMERGE_USERAPP_DEF
				CONFIG_DRACUT
				dracut --force '' $(ls /lib/modules)
			NOTICE_END
			}
			INITRFS_$GENINITRAMFS  # config / build
			etc-update --automode -3
		NOTICE_END
		}
		if [ "$CONFIGBUILDKERN" != "AUTO" ]; then # pass 07.09.22 no err
			INITRAMFS
		else
			echo 'CONFIGBUILDKERN AUTO DETECTED, skipping initramfs'
		fi
	NOTICE_END
	}