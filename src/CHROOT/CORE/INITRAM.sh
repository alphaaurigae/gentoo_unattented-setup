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
							add_dracutmodules+="$DRACUT_CONF_MODULES_CRYPTSETUP"
							EOF
							cat /etc/dracut.conf
						else
							echo "dracut lvm"
							cat <<- EOF > /etc/dracut.conf

							#i18n_install_all="yes"
							i18n_vars="/etc/conf.d/keymaps:keymap-KEYMAP,extended_keymaps-EXT_KEYMAPS /etc/conf.d/consolefont:consolefont-FONT,consoletranslation-FONT_MAP /etc/rc.conf:unicode-UNICODE"

							hostonly="$DRACUT_CONF_HOSTONLY"
							lvmconf="$DRACUT_CONF_LVMCONF"
							add_dracutmodules+="$DRACUT_CONF_MODULES_LVM"
							EOF
							cat /etc/dracut.conf
						fi
					NOTICE_END
					}
					#DRACUT_USERMOUNTCONF
					DRACUT_DRACUTCONF
				NOTICE_END
				}
				DRACUT_INIT () {
					NOTICE_START

					echo "$(readlink -f /usr/src/linux)" # test debug
					echo "$(make -sC /usr/src/linux kernelrelease)"
					#FETCH_KERNEL_VERSION="$(basename -- "$(readlink -f /usr/src/linux)")"
					FETCH_KERNEL_VERSION="$(make -sC /usr/src/linux kernelrelease)"
					[ -n "$FETCH_KERNEL_VERSION" ] || { echo "Failed to determine kernel version";  }

					INITRAMFS_PATH="/boot/initramfs-${FETCH_KERNEL_VERSION}.img"
					[ -d /boot ] || { echo "/boot not mounted or missing"; }
					[ -d "/lib/modules/${FETCH_KERNEL_VERSION}" ] || { echo "Missing modules for $FETCH_KERNEL_VERSION";  }

					dracut --force "$INITRAMFS_PATH" "$FETCH_KERNEL_VERSION" --kmoddir "/lib/modules/${FETCH_KERNEL_VERSION}"

				# dracut --list-modules # test
					NOTICE_END
				}
				PACKAGE_USE
				EMERGE_USERAPP_DEF
				CONFIG_DRACUT
				#DRACUT_INIT

				dracut --force '' $(ls /lib/modules) # replaced by DRACUT_INIT because upstream behavioral changes on dracut.
				# older versions of dracut accepted an empty string '' as a valid placeholder for the output path and would default to /boot/initramfs-<version>.img. 
				# This was implicit behavior, undocumented, and not reliable going forward.
				# In newer dracut versions (especially >=255+ on systemd-based distros), passing '' is no longer treated as "use default"
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