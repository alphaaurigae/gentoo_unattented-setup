INITRAM() {
	NOTICE_START
	INITRAMFS() { # https://wiki.gentoo.org/wiki/Initramfs
		NOTICE_START
		INITRFS_GENKERNEL() {
			NOTICE_START
			# genkernel --config=/etc/genkernel.conf initramfs
			genkernel $GENKERNEL_CMD
			NOTICE_END
		}
		INITRFS_DRACUT() { # https://wiki.gentoo.org/wiki/Dracut
			NOTICE_START
			APPAPP_EMERGE="sys-kernel/dracut"
			CONFIG_DRACUT() {
				NOTICE_START
				#					DRACUT_USERMOUNTCONF () { # separate /usr
				#					NOTICE_START
				#						cat <<-EOF > /etc/dracut.conf.d/usrmount.conf
				#						add_dracutmodules+=" usrmount "
				#						EOF
				#
				#						cat /etc/dracut.conf.d/usrmount.conf
				#					NOTICE_END
				#					}
				DRACUT_DRACUTCONF() {
					NOTICE_START
					# <key>+=" <values> ": <values> should have surrounding white spaces! Sourced variables are sanitized, keep spaces add_e.g dracutmodules+=" ${MOD} "
					local HOSTONLY="${DRACUT_CONF_HOSTONLY}"
					local LVMCONF="${DRACUT_CONF_LVMCONF}"
					local MOD

					if [ "$CRYPTSETUP" = "YES" ]; then
						MOD="$(printf '%s\n' "$DRACUT_CONF_MODULES_CRYPTSETUP" | xargs)"
					else
						MOD="$(printf '%s\n' "$DRACUT_CONF_MODULES_LVM" | xargs)"
					fi

					cat <<-EOF >/etc/dracut.conf
						#i18n_install_all="yes"
						i18n_vars="/etc/conf.d/keymaps:keymap-KEYMAP,extended_keymaps-EXT_KEYMAPS /etc/conf.d/consolefont:consolefont-FONT,consoletranslation-FONT_MAP /etc/rc.conf:unicode-UNICODE"

						hostonly="${HOSTONLY}"
						lvmconf="${LVMCONF}"
						add_dracutmodules+=" ${MOD} "
					EOF

					chmod 600 /etc/dracut.conf || printf '%s\n' "Failed chmod /etc/dracut.conf"
					cat /etc/dracut.conf
					NOTICE_END
				}

				#DRACUT_USERMOUNTCONF
				DRACUT_DRACUTCONF
				NOTICE_END
			}
			DRACUT_INIT() {
				NOTICE_START

				local KERNEL_BUILD_DIR="/usr/src/linux"
				local FETCH_KERNEL_VERSION="$(make -sC "$KERNEL_BUILD_DIR" kernelrelease)"
				printf '%s\n' "$(readlink -f "$KERNEL_BUILD_DIR")"
				printf '%s\n' "$FETCH_KERNEL_VERSION"

				[ -n "$FETCH_KERNEL_VERSION" ] || { printf '%s\n' "Failed to determine kernel version"; }
				[ -d "/boot" ] || { printf '%s\n' "/boot not mounted or missing"; }
				[ -d "/lib/modules/${FETCH_KERNEL_VERSION}" ] || { printf '%s\n' "Missing modules for ${FETCH_KERNEL_VERSION}"; }
				DEBUG_DRACUT() {
					NOTICE_START
					local INITRAMFS_PATH="/boot/initramfs-${FETCH_KERNEL_VERSION}.img"
					local INITRAMFS_LINK="/boot/initramfs.img"
					ls -lh "$INITRAMFS_PATH"
					readlink "$INITRAMFS_LINK"
					dracut --list-modules
					ls -lh /boot/vmlinuz-*
					ls -lh /boot/initrd.img-*
					ls -l /boot/initramfs-*
					file /boot/initramfs-*
					ls -l /boot
					#lsinitrd /boot/initramfs-<version> | grep -E 'cryptsetup|luks|dm-crypt'
					NOTICE_END
				}

				if $INSTALLKERNEL; then
					printf '%s\n' "installkernel set to TRUE"
					#dracut --force '' $(ls /lib/modules)
					#dracut --force --kver "${FETCH_KERNEL_VERSION}"
					dracut --force "/boot/initramfs-${FETCH_KERNEL_VERSION}.img" "$FETCH_KERNEL_VERSION"
					DEBUG_DRACUT
				else

					local INITRAMFS_PATH="/boot/initramfs-${FETCH_KERNEL_VERSION}.img"
					local INITRAMFS_LINK="/boot/initramfs.img"

					dracut --force "$INITRAMFS_PATH" "$FETCH_KERNEL_VERSION" \
						--kmoddir "/lib/modules/${FETCH_KERNEL_VERSION}" || { printf '%s\n' "dracut failed"; }

					[ -f "$INITRAMFS_PATH" ] || { printf '%s\n' "Dracut did not create initramfs"; }

					ln -sf "$INITRAMFS_PATH" "$INITRAMFS_LINK" || printf '%s\n' "symlink creation failed"

					DEBUG_DRACUT
				fi
				NOTICE_END
			}

			PACKAGE_USE
			EMERGE_USERAPP_DEF
			CONFIG_DRACUT
			DRACUT_INIT

			NOTICE_END
		}
		INITRFS_$GENINITRAMFS # config / build
		etc-update --automode -3
		NOTICE_END
	}
	if [ "$CONFIGBUILDKERN" != "AUTO" ]; then
		INITRAMFS
	else
		printf '%s\n' 'CONFIGBUILDKERN AUTO DETECTED, skipping initramfs'
	fi
	NOTICE_END
}
