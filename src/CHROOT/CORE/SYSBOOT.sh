	SYSBOOT () {
	NOTICE_START
		SYSBOOT_OSPROBER () {
		NOTICE_START
			APPAPP_EMERGE="sys-boot/os-prober "
			EMERGE_USERAPP_DEF
		NOTICE_END
		}
		BOOTLOAD () {  # BOOTINITVAR=BIOS/UEFI (UEFI NOT FULLY IMPLEMENTED SCRIPTWIDE)
		NOTICE_START
			SETUP_GRUB2 () {  # https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt
			NOTICE_START
				LOAD_GRUB2 () {
				NOTICE_START
					PRE_GRUB2 () {
					NOTICE_START
						etc-update --automode -3
						APPAPP_EMERGE="sys-boot/grub:2 "
						ACC_KEYWORDS_USERAPP
						PACKAGE_USE
						EMERGE_ATWORLD_A
						EMERGE_USERAPP_DEF
					NOTICE_END
					}
					GRUB2_BIOS () {
					NOTICE_START
						PRE_GRUB2BIOS () {
						NOTICE_START
							sed -i '/GRUB_PLATFORMS=/d' /etc/portage/make.conf
							printf '%s\n' 'GRUB_PLATFORMS="pc"' >> /etc/portage/make.conf
							EMERGE_ATWORLD_A
						NOTICE_END
						}
						PRE_GRUB2BIOS
						grub-install --recheck --modules="${GRUB_PRELOAD_MODULES}" --target=i386-pc $HDD1
						ls /boot/grub/i386-pc/
						printf '%s\n' "grub-probe --target=fs /boot"
						grub-probe --target=fs /boot
						grub-install --version
					NOTICE_END
					}
					GRUB2_UEFI () {
					NOTICE_START
						PRE_GRUB2UEFI () {
						NOTICE_START
							sed -i '/GRUB_PLATFORMS=/d' /etc/portage/make.conf
							sed -i '/GRUB_PLATFORMS="efi-64/d' /etc/portage/make.conf
							printf '%s\n' 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
							EMERGE_ATWORLD_A
						NOTICE_END
						}
						PRE_GRUB2UEFI
						grub-install --target=x86_64-efi --efi-directory=/boot

						## (!NOTE: optional)# mount -o remount,rw /sys/firmware/efi/efivars  
						# If grub_install returns an error like Could not prepare Boot variable: Read-only file system, it may be necessary to remount the efivars special mount as read-write in order to succeed:
						## (!NOTE: optional)# grub-install --target=x86_64-efi --efi-directory=/boot --removable  
						# Some motherboard manufacturers seem to only support the /efi/boot/ directory location for the .EFI file in the EFI System Partition (ESP). 
					NOTICE_END
					}
					PRE_GRUB2
					GRUB2_$BOOTINITVAR
				NOTICE_END
				}
				CONFIG_GRUB2 () { # ( !note: config is edited partially after pasting, to be fully integrated in variables. )
				NOTICE_START
					CONFGRUB2_MAIN () {
					NOTICE_START
						etc-update --automode -3
						local SRC="/gentoo_unattented-setup/configs/default/grub.sh"
						local DST="/etc/default/grub"
						cp "$SRC" "$DST" && VERIFY_COPY "$SRC" "$DST"
						printf '%s\n' "may ignore complaining cp"
					NOTICE_END
					}
					CONFGRUB2_OPENRC () {  # https://wiki.gentoo.org/wiki/GRUB2
					NOTICE_START

						# If the root file system is contained in a logical volume of a fully encrypted LVM, 
						# the device mapper for it will be in the general form of root=/dev/volumegroup/logicalvolume. 
						# https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration

						# (!NOTE: etc/crypttab not required under default openrc, "luks on lvm", GPT, bios - setup)
						# Warning: If you are using /etc/crypttab or /etc/crypttab.initramfs together with luks.* or rd.luks.* parameters, 
						# only those devices specified on the kernel command line will be activated and you will see Not creating device 'devicename' because it was not specified on the kernel command line.. 
						# To activate all devices in /etc/crypttab do not specify any luks.* parameters and use rd.luks.*. 
						# To activate all devices in /etc/crypttab.initramfs do not specify any luks.* or rd.luks.* parameters.

						local GRUB_CMDLINE
						local GRUB_PRELOAD

						if [ "$CRYPTSETUP" = "YES" ]; then
							GRUB_CMDLINE="raid=noautodetect cryptdevice=PARTUUID=$(blkid -s PARTUUID -o value "$MAIN_PART"):$PV_MAIN root=UUID=$(blkid -s UUID -o value /dev/"$VG_MAIN"/"$LV_MAIN") rootfstype=ext4 dolvm"
							GRUB_PRELOAD="${GRUB_PRELOAD_MODULES_CRYPTSETUP}"
						else
							GRUB_CMDLINE="raid=noautodetect root=UUID=$(blkid -s UUID -o value /dev/"$VG_MAIN"/"$LV_MAIN") rootfstype=ext4 dolvm"
							GRUB_PRELOAD="${GRUB_PRELOAD_MODULES_DEFAULT}"
						fi


						sed -i '/^GRUB_CMDLINE_LINUX=/d' /etc/default/grub
						sed -i '/^GRUB_PRELOAD_MODULES=/d' /etc/default/grub

						printf '%s\n' \
						"GRUB_CMDLINE_LINUX=\"${GRUB_CMDLINE}\"" \
						"GRUB_PRELOAD_MODULES=\"${GRUB_PRELOAD}\"" >> /etc/default/grub
					NOTICE_END
					}
					CONFGRUB_SYSTEMD () {  # https://wiki.gentoo.org/wiki/GRUB2
					NOTICE_START
						sed -i '/GRUB_CMDLINE_LINUX=/d' /etc/default/grub
						cat <<- EOF >> /etc/default/grub
						
						GRUB_CMDLINE_LINUX="rd.luks.name=$(blkid -o value -s UUID $MAIN_PART)=$PV_MAIN root=UUID=$(blkid -s UUID -o value /dev/$VG_MAIN/$LV_MAIN) rootfstype=ext4 dolvm " #real_init=/lib/systemd/systemd
						
						EOF

						# MOCKUP, NEED TESTING!
						# If the root file system is contained in a logical volume of a fully encrypted LVM, the device mapper for it will be in the general form of root=/dev/volumegroup/logicalvolume. 
						# https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration

						# rd.luks.name= is honored only by initial RAM disk (initrd) while luks.name= is honored by both the main system and the initrd. https://www.freedesktop.org/software/systemd/man/systemd-cryptsetup-generator.html
						
					NOTICE_END
					}
					CONFGRUB2_MAIN
					CONFGRUB2_$SYSINITVAR
				NOTICE_END
				}
				UPDATE_GRUB2 () {
				NOTICE_START
					grub-mkconfig -o /boot/grub/grub.cfg
				NOTICE_END
				}
				DEBUG_GRUB2() {
				NOTICE_START
					grep -A3 'menuentry' /boot/grub/grub.cfg
					grep linux /boot/grub/grub.cfg
				NOTICE_END
				}
				LOAD_GRUB2
				CONFIG_GRUB2
				UPDATE_GRUB2
				DEBUG_GRUB2
			NOTICE_END
			}
			SETUP_LILO () {
			NOTICE_START
				APPAPP_EMERGE="sys-boot/lilo "
				CONF_LILO () {  # https://wiki.gentoo.org/wiki/LILO # https://github.com/a2o/lilo/blob/master/sample/lilo.example.conf
				NOTICE_START
					local SRC="/gentoo_unattented-setup/configs/optional/lilo.conf"
					local DST="/etc/lilo.conf"
					cp "$SRC" "$DST" && VERIFY_COPY "$SRC" "$DST"
				NOTICE_END
				}
				EMERGE_USERAPP_DEF
				CONF_LILO
			NOTICE_END
			}
			SETUP_$BOOTLOADER
		NOTICE_END
		}   
		SYSBOOT_OSPROBER
		BOOTLOAD
	NOTICE_END
	}