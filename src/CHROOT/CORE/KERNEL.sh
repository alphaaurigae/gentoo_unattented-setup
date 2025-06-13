KERNEL() { # https://wiki.gentoo.org/wiki/Kernel
	NOTICE_START
	KERN_LOAD() {
		NOTICE_START
		KERN_EMERGE() {
			NOTICE_START
			APPAPP_EMERGE="sys-kernel/gentoo-sources"
			ACC_KEYWORDS_USERAPP
			EMERGE_ATWORLD
			EMERGE_USERAPP_DEF
			eselect kernel set 1
			NOTICE_END
		}
		KERN_TORVALDS() {
			NOTICE_START
			# Needs testing and possibly further integration - PLACEHOLDER
			[ -L /usr/src/linux ] && unlink /usr/src/linux
			[ -d /usr/src/linux ] && rm -rf /usr/src/linux
			git clone https://github.com/torvalds/linux "/usr/src/linux-torvalds-${KERNVERS}"
			ln -sfn "/usr/src/linux-torvalds-${KERNVERS}" /usr/src/linux
			cd /usr/src/linux
			git fetch
			git fetch --tags
			git checkout v"${KERNVERS}"
			NOTICE_END
		}
		KERN_$KERNSOURCES
		NOTICE_END
	}
	INSTALLKERNEL() { # https://wiki.gentoo.org/wiki/Installkernel
		NOTICE_START
		APPAPP_EMERGE="sys-kernel/installkernel"
		ACC_KEYWORDS_USERAPP
		EMERGE_ATWORLD
		EMERGE_USERAPP_DEF
		NOTICE_END
	}
	KERN_DEPLOY() {
		NOTICE_START
		KERN_MANUAL() {
			NOTICE_START
			KERN_CONF() {
				NOTICE_START
				KERNCONF_PASTE() {
					NOTICE_START
					cd /usr/src/linux
					make mrproper

					mv /usr/src/linux/.config /usr/src/linux/.oldconfig
					printf "%s%s%s%s\n" "${BOLD}${YELLOW}" "NOTICE:" "${RESET}" " Ignore the mv error"
					touch /usr/src/linux/.config

					local SRC="/gentoo_unattented-setup/configs/required/kern.config.sh"
					local DST="/usr/src/linux/.config"

					cp "$SRC" "$DST" && VERIFY_COPY "$SRC" "$DST"
					NOTICE_END
				}
				KERNCONF_DEFCONFIG() {
					NOTICE_START
					cd /usr/src/linux
					make mrproper
					make -j $(nproc) defconfig
					NOTICE_END
				}
				KERNCONF_MENUCONFIG_NEW() {
					NOTICE_START
					cd /usr/src/linux
					make mrproper
					make -j $(nproc) menuconfig
					NOTICE_END
				}
				KERNCONF_ALLYESCONFIG() { # New config where all options are accepted with yes
					NOTICE_START
					cd /usr/src/linux
					make mrproper
					make -j $(nproc) allyesconfig
					NOTICE_END
				}
				KERNCONF_OLDCONFIG() { # (!testing) (!todo)
					NOTICE_START
					cd /usr/src/linux
					make mrproper
					make -j $(nproc) oldconfig
					NOTICE_END
				}
				if [ "$KERNCONFD" != "DEFCONFIG" ]; then
					KERNCONF_$KERNCONFD
				else
					KERNCONF_DEFCONFIG
				fi
				NOTICE_END
			}
			KERN_BUILD() { # (!incomplete (works but) modules setup *smart)
				NOTICE_START
				cd /usr/src/linux
				# -o good practice in this context??? Works but ...)
				make -j$(nproc) -o /usr/src/linux/.config menuconfig
				make -j$(nproc) -o /usr/src/linux/.config modules
				make -j$(nproc) bzImage
				make install
				make modules_install

				local FETCH_KERNEL_VERSION="$(make -sC /usr/src/linux kernelrelease)"

				DEBUG_KERNELINST() {
					NOTICE_START

					printf '%s\n' "Verify module installation"
					ls -d /lib/modules/$FETCH_KERNEL_VERSION
					modinfo -k $FETCH_KERNEL_VERSION

					printf '%s\n' "Debug kernel installation"
					[ -f "${BOOTDIR}/vmlinuz-${FETCH_KERNEL_VERSION}" ] || printf "%s%s%s%s\n" "${BOLD}${MAGENTA}" "WARNING:" "${RESET}" " Kernel image missing!"
					[ -f "${BOOTDIR}/System.map-${FETCH_KERNEL_VERSION}" ] || printf "%s%s%s%s\n" "${BOLD}${MAGENTA}" "WARNING:" "${RESET}" " System.map missing!"
					[ -f "${BOOTDIR}/config-${FETCH_KERNEL_VERSION}" ] || printf "%s%s%s%s\n" "${BOLD}${MAGENTA}" "WARNING:" "${RESET}" " Config missing!"

					ls -l /boot/vmlinuz-$FETCH_KERNEL_VERSION
					ls -l /boot/System.map-$FETCH_KERNEL_VERSION
					ls -l /boot/config-$FETCH_KERNEL_VERSION
					readlink /boot/vmlinuz /boot/System.map /boot/config
					file /boot/vmlinuz-$FETCH_KERNEL_VERSION
					ls -lh /boot/vmlinuz-*
					ls -l /boot

					printf '%s\n' "cd boot && ls -a log:"
					cd /boot
					ls -a
					NOTICE_END
				}

				if $INSTALLKERNEL; then
					printf '%s\n' "Installkernel is set to TRUE"
					DEBUG_KERNELINST
				else

					printf '%s\n' "Install kernel manually instead of installkernel set to FALSE --> Installing the kernel manually!"
					local SRC_IMAGE="/usr/src/linux/arch/x86/boot/bzImage"
					local DEST_IMAGE="/boot/vmlinuz-${FETCH_KERNEL_VERSION}"
					local DEST_MAP="/boot/System.map-${FETCH_KERNEL_VERSION}"
					local DEST_CONFIG="/boot/config-${FETCH_KERNEL_VERSION}"

					cp "${SRC_IMAGE}" "${DEST_IMAGE}"
					cp /usr/src/linux/System.map "${DEST_MAP}"
					cp /usr/src/linux/.config "${DEST_CONFIG}"

					#local SRC="/usr/src/linux/arch/x86/boot/bzImage"
					#local DST="/boot/vmlinuz-${FETCH_KERNEL_VERSION}"
					#cp "$SRC" "$DST" && VERIFY_COPY "$SRC" "$DST"

					ln -sf "vmlinuz-${FETCH_KERNEL_VERSION}" /boot/vmlinuz
					ln -sf "System.map-${FETCH_KERNEL_VERSION}" /boot/System.map
					ln -sf "config-${FETCH_KERNEL_VERSION}" /boot/config
					DEBUG_KERNELINST
				fi

				NOTICE_END
			}
			lsmod      # active modules by install medium.
			KERN_CONF  # kernel configure set
			KERN_BUILD # kernel build set
			printf "%s%s%s%s\n" "${BOLD}${YELLOW}" "NOTICE:" "${RESET}" " Ignore err grub-mkconfig if grub is not installed yet!"
			grub-mkconfig -o /boot/grub/grub.cfg # ... Not sure why i left this here. Remove? Test ...
			NOTICE_END
		}
		KERN_AUTO() {
			NOTICE_START
			GENKERNEL_NEXT() { # # (!incomplete)
				NOTICE_START
				CONF_GENKERNEL() { # (!incomplete)
					NOTICE_START
					touch /etc/genkernel.conf
					cat <<-'EOF' >/etc/genkernel.conf
						# [!PASTE_OPTIONAL_CONFIG: config/other_optional/genkernel.conf - not yet intgreated in variables and fully tested, ]
					EOF
					NOTICE_END
				}
				RUN_GENKERNEL() {
					NOTICE_START
					# genkernel --config=/etc/genkernel.conf all
					genkernel --luks --lvm --no-zfs all
					printf "%s%s%s%s\n" "${BOLD}${YELLOW}" "NOTICE:" "${RESET}" " Ignore err grub-mkconfig if grub is not installed yet!"
					grub-mkconfig -o /boot/grub/grub.cfg
					NOTICE_END
				}
				APPAPP_EMERGE="sys-kernel/genkernel-next"
				PACKAGE_USE
				ACC_KEYWORDS_USERAPP
				EMERGE_ATWORLD
				EMERGE_USERAPP_DEF
				# CONF_GENKERNEL
				RUN_GENKERNEL
				NOTICE_END
			}
			GENKERNEL_NEXT
			NOTICE_END
		}
		KERN_$KERNDEPLOY
		cd /  # ... Not sure why i left this here. Remove? Test ...
		NOTICE_END
	}
	KERNEL_HEADERS() {
		NOTICE_START
		emerge --ask sys-kernel/linux-headers
		NOTICE_END
	}
	KERN_LOAD # load kernel source (download, copy ; etc ....)
	if $INSTALLKERNEL; then
		printf '%s\n' "Installkernel is set to TRUE"
		INSTALLKERNEL
	else
		printf '%s\n' "Installkernel is set to FALSE"
	fi
	KERN_DEPLOY
	KERNEL_HEADERS
	NOTICE_END
}
