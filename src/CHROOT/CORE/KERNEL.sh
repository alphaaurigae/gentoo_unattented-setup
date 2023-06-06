	KERNEL () {  # https://wiki.gentoo.org/wiki/Kernel
	NOTICE_START
		KERN_LOAD () {
		NOTICE_START
			KERN_EMERGE () {
			NOTICE_START
				APPAPP_EMERGE="sys-kernel/gentoo-sources"
				ACC_KEYWORDS_USERAPP
				EMERGE_ATWORLD_A
				EMERGE_USERAPP_DEF
				# emerge =sys-kernel/gentoo-sources-4.19.250
				# emerge --search "%@^sys-kernel/.*sources"
				#eselect kernel list
				eselect kernel set 1
			NOTICE_END
			}
			KERN_TORVALDS () {
			NOTICE_START
				rm -rf /usr/src/linux
				git clone https://github.com/torvalds/linux /usr/src/linux
				cd /usr/src/linux
				git fetch
				git fetch --tags
				git checkout v$KERNVERS  # get desired branch / tag
			NOTICE_END
			}
			KERN_$KERNSOURCES
		NOTICE_END
		}
		KERN_DEPLOY () {
		NOTICE_START
			KERN_MANUAL () {
			NOTICE_START
				KERN_CONF () {
				NOTICE_START
					KERNCONF_PASTE () {  # paste own config here ( ~ this should go to auto)
					NOTICE_START
						# mv /usr/src/$(ls /usr/src) /usr/src/linux
						mv /usr/src/linux/.config /usr/src/linux/.oldconfig 
						echo "ignore mv err"
						touch /usr/src/linux/.config
						cp /gentoo_unattented-setup/configs/required/kern.config.sh /usr/src/linux/.config  # stripped version infos for refetch # ls function to get the dirname quick - probably not the best hack but want to get done here now.
					NOTICE_END
					}
					KERNCONF_DEFCONFIG () {
					NOTICE_START
						cd /usr/src/linux
						make clean
						make proper
						make -j $(nproc) defconfig
					NOTICE_END
					}
					KERNCONF_MENUCONFIG_NEW () {
					NOTICE_START
						cd /usr/src/linux
						make clean
						make proper
						make -j $(nproc) menuconfig
					NOTICE_END
					}
					KERNCONF_ALLYESCONFIG () {  # New config where all options are accepted with yes
					NOTICE_START
						cd /usr/src/linux
						make clean
						make proper
						make -j $(nproc) allyesconfig
					NOTICE_END
					}
					KERNCONF_OLDCONFIG () {  # (!testing) (!todo)
					NOTICE_START
						cd /usr/src/linux
						make clean
						make proper
						make -j $(nproc) oldconfig
					NOTICE_END
					}
					if [ "$KERNCONFD" != "DEFCONFIG" ]; then
						# KERNCONF_PASTE
						KERNCONF_$KERNCONFD
					else
						KERNCONF_DEFCONFIG
					fi
				NOTICE_END
				}
				KERN_BUILD () {  # (!incomplete (works but) modules setup *smart)
				NOTICE_START
					cd /usr/src/linux  # enter build directory (required?)
					make -j$(nproc) dep
					make -j$(nproc) -o /usr/src/linux/.config menuconfig # build kernel based on .config file
					make -j$(nproc) -o /usr/src/linux/.config modules # build modules based on .config file
					make -j$(nproc) bzImage
					sudo make install  # install the kernel
					sudo make modules_install  # install the modules
				NOTICE_END
				}
				lsmod  # active modules by install medium.
				KERN_CONF  # kernel configure set
				KERN_BUILD  # kernel build set
				echo "ignore err grub-mkconfig if grub not installed yet"
				grub-mkconfig -o /boot/grub/grub.cfg  # update grub in case its already installed ....
			NOTICE_END
			}
			KERN_AUTO () {  # (!changeme) switch to auto (option variables top) # switch to auto configuration (option variables top)
			NOTICE_START
				GENKERNEL_NEXT () {  # # (!incomplete)
				NOTICE_START
					CONF_GENKERNEL () {  # (!incomplete)
					NOTICE_START
						touch /etc/genkernel.conf
						cat << 'EOF' > /etc/genkernel.conf
						# [!PASTE_OPTIONAL_CONFIG: config/other_optional/genkernel.conf - not yet intgreated in variables and fully tested, ]
EOF
					NOTICE_END
					}
					RUN_GENKERNEL () {
					NOTICE_START
						# genkernel --config=/etc/genkernel.conf all
						genkernel --luks --lvm --no-zfs all
						echo "ignore err grub-mkconfig if grub not installed yet"
						grub-mkconfig -o /boot/grub/grub.cfg  # update grub in case its already installed ....
					NOTICE_END
					}
					APPAPP_EMERGE="sys-kernel/genkernel-next"
					PACKAGE_USE
					ACC_KEYWORDS_USERAPP
					EMERGE_ATWORLD_A
					EMERGE_USERAPP_DEF
					# CONF_GENKERNEL
					RUN_GENKERNEL
				NOTICE_END
				}
				GENKERNEL_NEXT
			NOTICE_END
			}
			KERN_$KERNDEPLOY
			cd /
		NOTICE_END
		}
		KERNEL_HEADERS () {
		NOTICE_START
			emerge --ask sys-kernel/linux-headers
		NOTICE_END
		}
		KERN_LOAD  # load kernel source (download, copy ; etc ....)
		KERN_DEPLOY  # config / build
		KERNEL_HEADERS
	NOTICE_END
	}