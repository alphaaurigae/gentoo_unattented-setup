#!/bin/bash

# current work branch. at this point the repo is transitioning from singlefile to multifile setup .. not sure to keep both.. anyways this is the latest setup now 27.8.22

# github.com/alphaaurigae/gentoo_unattended_modular-setup.sh

#########################################################################################################################################################################################################################################################################################################################################################################
# VARIABLE && FUNCTONS (options) ##unfinished
#. configs/required/default-testing/1_PRE.sh

. var/1_PRE_main.sh
# for f in func/pre/*; do . $f && echo $f; done  # copy off multifile ahead

PRE () {  # PREPARE CHROOT
	INIT () {  # (!NOTE:: in this section the script starts off with everything that has to be done prior to the setup action.)
		ntpd -q -g   # TIME ... update the system time ... (!important) # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Setting_the_date_and_time
		modprobe -a dm-mod dm-crypt sha256 aes aes_generic xts  # load kernel modules for the chroot install process, for luks we def need the dm-crypt ...
	}
	PARTITIONING () {
		PARTED () {  # LVM on LUKS https://wiki.archlinux.org/index.php/GNU_Parted
			sgdisk --zap-all $HDD1
			# parted -s $HDD1 rm 1
			# parted -s $HDD1 rm 2
			# parted -s $HDD1 rm 3
			parted -s $HDD1 mklabel gpt # GUID Part-Table
			parted -s $HDD1 mkpart primary "$GRUB_SIZE"  # the BIOS boot partition is needed when a GPT partition layout is used with GRUB2 in PC/BIOS mode. It is not required when booting in EFI/UEFI mode. 
			parted -s $HDD1 name 1 grub # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks#GPT
			parted -s $HDD1 set 1 bios_grub on
			parted -s $HDD1 mkpart primary $FILESYSTEM_BOOT "$BOOT_SIZE"
			parted -s $HDD1 name 2 boot
			parted -s $HDD1 set 2 boot on
			parted -s $HDD1 mkpart primary $FILESYSTEM_MAIN "$MAIN_SIZE"
			parted -s $HDD1 name 3 mainfs
			parted -s $HDD1 set 3 lvm on
		}
		PTABLES () {
			partx -u $HDD1
			partprobe $HDD1
		}
		MAKEFS_BOOT () {
			mkfs.$FILESYSTEM_BOOT $BOOT_PART
		}
		PARTED
		PTABLES
		MAKEFS_BOOT
	}
	#  (!NOTE: lvm on luks "CRYPT --> BOOT/LVM2 --> OS" ... 
	#  (!NOTE: for the main disk $MAIN_PART - you will be prompted for passohrase)
	CRYPTSETUP () {  # https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS && https://blog.stigok.com/2018/05/03/lvm-in-luks-with-encrypted-boot-partition-and-suspend-to-disk.html
		echo "${bold}enter the $PV_MAIN password${normal}"
		cryptsetup -v luksFormat --type luks2 $MAIN_PART --debug
		cryptsetup open $MAIN_PART $PV_MAIN
	}
	#  LVM = "PV (Physical volume)-> VG (Volume group) > LV (Logical volume) inside of the luks crypt container ...             
	LVMONLUKS () {
		LVM_PV () {
			pvcreate /dev/mapper/$PV_MAIN
		}
		LVM_VG () {
			vgcreate $VG_MAIN /dev/mapper/$PV_MAIN
		}
		LVM_LV () {
			# lvcreate -L $SWAP_SIZE -n $SWAP0 $VG_MAIN
			lvcreate -l 98%FREE -n $LV_MAIN $VG_MAIN
		}
		MAKEFS_LVM () {
			mkfs.ext4 /dev/$VG_MAIN/$LV_MAIN
			# mkswap /dev/$VG_MAIN/$SWAP0 # swap ...
		}
		MOUNT_LVM_LV () {  # (!NOTE: mount the LVM for CHROOT.)
			mkdir -p $CHROOTX
			mount /dev/mapper/$VG_MAIN-$LV_MAIN $CHROOTX
			# swapon /dev/$VG_MAIN/$SWAP0
			mkdir $CHROOTX/boot
			mount $BOOT_PART $CHROOTX/boot
		}
		LVM_PV
		LVM_VG
		LVM_LV
		MAKEFS_LVM
		MOUNT_LVM_LV
	}
	# STAGE3 TARBALL - HTTPS:// ?
	STAGE3 () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Choosing_a_stage_tarball && # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Unpacking_the_stage_tarball
		STAGE3_FETCH () {
			SET_VAR_STAGE3_FETCH (){
				STAGE3_FILEPATH="$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/$STAGE3DEFAULT.txt | sed '/^#/ d' | awk '{print $1}' | sed -r 's/\.tar\.xz//g' )"
#echo $STAGE3_FILEPATH
				LIST="$STAGE3_FILEPATH.tar.xz
					$STAGE3_FILEPATH.tar.xz.CONTENTS.gz
					$STAGE3_FILEPATH.tar.xz.DIGESTS
					$STAGE3_FILEPATH.tar.xz.asc"
			}
			FETCH_STAGE3_FETCH () {
				for i in $LIST; do
					#echo "${bold}FETCH $i ....${normal}"
echo $GENTOO_RELEASE_URL/$i
					wget -P $CHROOTX/ $GENTOO_RELEASE_URL/"$i"  # stage3.tar.xz (!NOTE: main stage3 archive) # OLD single: wget -P $CHROOTX/ http://distfiles.gentoo.org/releases/amd64/autobuilds/"$STAGE3_FILENAME"  # stage3.tar.xz (!NOTE: main stage3 archive)

					if [ -f "$CHROOTX/$( echo $i| rev | cut -d'/' -f-1 | rev)" ]; then
						echo "$CHROOTX/$(echo "$i" | rev | cut -d'/' -f-1 | rev) found - OK"
					else
						echo "ERROR: $CHROOTX/$(echo "$i" | rev | cut -d'/' -f-1 | rev) not found!"
					fi
				done
			}
			SET_VAR_STAGE3_FETCH
			FETCH_STAGE3_FETCH
		}
		STAGE3_VERIFY () {
			SET_VAR_STAGE3_VERIFY (){
				STAGE3_FILENAME="$(cd $CHROOTX/ && ls stage3-* | awk '{ print $1 }' | awk 'FNR == 1 {print}' | sed -r 's/\.tar\.xz//g' )"  # | rev | cut -d'/' -f-1 | rev
				echo "$STAGE3_FILENAME"
			}
			RECEIVE_GPGKEYS () {  # which key is actually needed? for i in 
				GENTOOKEYS="
					$GENTOO_EBUILD_KEYFINGERPRINT1
					$GENTOO_EBUILD_KEYFINGERPRINT2
					$GENTOO_EBUILD_KEYFINGERPRINT3
					$GENTOO_EBUILD_KEYFINGERPRINT4
				"
				for i in $GENTOOKEYS ; do
					echo "${bold}$i=$i ....${normal}"
					echo "${bold}gpg --keyserver $KEYSERVER --recv-keys $i ....${normal}"
					gpg --keyserver $GPG_KEYSERV --recv-keys "$i"  # Fetch the key https://www.gentoo.org/downloads/signatures/
				done
				# gpg --list-keys
			}
			VERIFY_UNPACK () {
				if gpg  --verify "$CHROOTX/$STAGE3_FILENAME.tar.xz.asc" ; then 
					echo "gpg  --verify $CHROOTX/$STAGE3_FILENAME.tar.xz.asc - OK"
						
					# unfinished https://forums.gentoo.org/viewtopic-t-1044026-start-0.html			
					 grep -A 1 -i sha512 $CHROOTX/$STAGE3_FILENAME.tar.xz.asc  # With the cryptographic signature validated, next verify the checksum to make sure the downloaded ISO file is not corrupted. The .DIGESTS.asc file contains multiple hashing algorithms, so one of the methods to validate the right one is to first look at the checksum registered in the .DIGESTS.asc file. For instance, to get the SHA512 checksum:  In the above output, two SHA512 checksums are shown - one for the install-amd64-minimal-20141204.iso file and one for its accompanying .CONTENTS file. Only the first checksum is of interest, as it needs to be compared with the calculated SHA512 checksum which can be generated as follows: 
						#echo "grep -A 1 -i sha512 $CHROOTX/$STAGE3_FILENAME.tar.xz.asc - OK"
						echo 'STAGE3_UNPACK ....'
						tar xvJpf $CHROOTX/$STAGE3_FILENAME.tar.xz --xattrs-include='*.*' --numeric-owner -C $CHROOTX

				else 
					echo "SIGNATURE ALERT!"
				fi
			}
			SET_VAR_STAGE3_VERIFY
			RECEIVE_GPGKEYS
			VERIFY_UNPACK
		}
		STAGE3_FETCH
		STAGE3_VERIFY
	}
	MNTFS () {
		MOUNT_BASESYS () {  # (!important) # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Mounting_the_necessary_filesystems
					# Warning
					# When using non-Gentoo installation media, this might not be sufficient. 
					# Some distributions make /dev/shm a symbolic link to /run/shm/ which, after the chroot, becomes invalid. Making /dev/shm/ a proper tmpfs mount up front can fix this: 
			mount --types proc /proc $CHROOTX/proc
			mount --rbind /sys $CHROOTX/sys
			mount --make-rslave $CHROOTX/sys
			mount --rbind /dev $CHROOTX/dev
			mount --make-rslave $CHROOTX/dev
			mount --bind /run $CHROOTX/run
			mount --make-slave $CHROOTX/run
		}	 
		SETMODE_DEVSHM () {
			chmod 1777 /dev/shm  # (!todo) (note: Chmod 1777 (chmod a+rwx,ug+s,+t,u-s,g-s) sets permissions so that, (U)ser / owner can read, can write and can execute. (G)roup can read, can write and can execute. (O)thers can read, can write and can execute)
		}
		MOUNT_BASESYS
		SETMODE_DEVSHM
	}
	COPY_CONFIGS () {
		EBUILD () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Gentoo_ebuild_repository
			mkdir --parents $CHROOTX/etc/portage/repos.conf
			cp $CHROOTX/usr/share/portage/config/repos.conf $CHROOTX/etc/portage/repos.conf/gentoo.conf  # copy the Gentoo repository configuration file provided by Portage to the (newly created) repos.conf directory.
			# cat $CHROOTX/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
		}                                      
		RESOLVCONF () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Copy_DNS_info
			cp --dereference /etc/resolv.conf $CHROOTX/etc/
		}
		EBUILD
		RESOLVCONF
	}
	INIT   
	PARTITIONING
	CRYPTSETUP
	LVMONLUKS
	STAGE3
	MNTFS
	COPY_CONFIGS
	# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}
CHROOT () {	# 4.0 CHROOT # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment 
	INNER_SCRIPT=$(cat << 'INNERSCRIPT'
	#https://github.com/alphaaurigae/gentoo_unattented-setup

	#!/bin/bash
			# CHROOT START >>> alphaaurigae/gentoo_unattented-setup | https://github.com/alphaaurigae/gentoo_unattented-setup

			. /chroot_variables.sh
			#. /kern.config.sh
			#. func/chroot_static-functions.sh

	# MISC FUNCTIONS
	EMERGE_USERAPP_DEF () {
		echo "emerging $APPAPP_EMERGE "
		emerge $APPAPP_EMERGE
	}
	EMERGE_USERAPP_RD1 () {
		echo "emerging ${!APPAPP_EMERGE}"
		emerge ${!APPAPP_EMERGE}  # (note!: for redirected var.)
	}
	NOTICE_PLACEHOLDER () {
		echo "nothing todo here"
	}
	ENVUD () {
		env-update
		source /etc/profile
	}
	ACC_KEYWORDS_USERAPP () {
		touch /etc/portage/package.accept_keywords/common
		sed -ie "s#$APPAPP_EMERGE ~amd64##g" /etc/portage/package.accept_keywords/common
		echo "$APPAPP_EMERGE ~amd64" >> /etc/portage/package.accept_keywords/common
	}

	APPAPP_NAME_SIMPLE="$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}')"  # get the name of the app (!NOTE: fetch EMERGE_USERAPP_DEF --> remove slash --> show second coloumn = name
	PORTAGE_USE_DIR="/etc/portage/package.use"

	PACKAGE_USE () {
			SETVAR_PACKAGE_USE () {
				x=$(echo 'USEFLAGS_')
				x+=$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}' | sed -e 's/-/_/g'  | sed -e 's/://g' | tr [:lower:] [:upper:])
				combined=${!x}
				echo "${!x}"
				o=$(echo $PORTAGE_USE_DIR)
				o+=$(echo $APPAPP_NAME_SIMPLE)

				m="$( printf '%s\n' "$APPAPP_EMERGE " )"
				m+="$(echo " ")"
				m+=${!x}
			}
			SETVAR_PACKAGE_USE
			printf '%s\n' "$m"  > /etc/portage/package.use/$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}')  #  variable only works here and not if forwarded from above.
	}
	AUTOSTART_DEFAULT_OPENRC () {
		rc-update add $AUTOSTART_NAME_OPENRC default
	}
	AUTOSTART_DEFAULT_SYSTEMD () { (!todo)
		systemctl enable dbus.service 
		systemctl start dbus.service
		systemctl daemon-reload
	}
	AUTOSTART_BOOT_OPENRC () {
		rc-service $AUTOSTART_NAME_OPENRC start
		rc-update add $AUTOSTART_NAME_OPENRC boot
		rc-service $AUTOSTART_NAME_OPENRC restart
	}
	AUTOSTART_BOOT_SYSTEMD () {
		NOTICE_PLACEHOLDER
		systemctl enable $AUTOSTART_NAME_SYSTEMD
		# systemctl enable $AUTOSTART_BOOT_SYSTEMD@.service # https://www.freedesktop.org/software/systemd/man/systemd-cryptsetup@.service.html
	}
	LICENSE_SET () {
		mkdir -p /etc/portage/package.license
		#sed -ie "/$APPAPP_EMERGE @BINARY-REDISTRIBUTABLE/d" /etc/portage/package.license/$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}')
		echo "$APPAPP_EMERGE @BINARY-REDISTRIBUTABLE" > /etc/portage/package.license/$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}')
	}
	EMERGE_ATWORLD_A () {
		emerge @world  # this is to update after setting the use flag
	}
	EMERGE_ATWORLD_B () {
		emerge --changed-use --deep @world
		emerge --update --deep --newuse @world
	}
	# END MISC FUNCTIONS


			BASE () {
				SWAPFILE () {
					DEBUG_SWAPFILE () {
						swapon -s
						ls -lh $SWAPFD/$SWAPFILE_$SWAPSIZE
					}
					CREATE_FILE () {
						mkdir -p $SWAPFD
						fallocate -l $SWAPSIZE $SWAPFD/$SWAPFILE_$SWAPSIZE
						chmod 600 $SWAPFD/$SWAPFILE_$SWAPSIZE
						mkswap $SWAPFD/$SWAPFILE_$SWAPSIZE
					}
					CREATE_SWAP () {
						swapon  $SWAPFD/$SWAPFILE_$SWAPSIZE
					}
					PERMANENT () {
						echo "$SWAPFD/$SWAPFILE_SWAPSIZE none swap sw 0 0" >> /etc/fstab
						cat /etc/fstab
					}
					CREATE_FILE
					# DEBUG_SWAPFILE
					CREATE_SWAP
					# DEBUG_SWAPFILE
					# PERMANENT
				}
				MAKECONF () {  # /etc/portage/make.conf # https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/USE
					MAKECONF_VARIABLES () {
						cat << EOF > /etc/portage/make.conf
						CC="$PRESET_CC"
						ACCEPT_KEYWORDS="$PRESET_ACCEPT_KEYWORDS"
						CHOST="$PRESET_CHOST_ARCH-$PRESET_CHOST_VENDOR-$PRESET_CHOST_OS-$PRESET_CHOST_LIBC"
						
						# (!NOTE) (!todo - not sure if this is "perfect" yet.. anyways, "it works". 
						CPU_FLAGS_X86="$PRESET_CPU_FLAGS_X86" # workaround to insert sse3 and sse4a - intentianal, no idea if requ - testing…
						# CPU_FLAGS_X86="$(lscpu | grep Flags: | sed -e 's/Flags:               //g')" # lscpu hides sse3 and sse4a which are shown in cpuid.
						CFLAGS="$PRESET_CFLAGS"
						CXXFLAGS="${PRESET_CFLAGS}"
						FCFLAGS="${PRESET_CFLAGS}"
						FFLAGS="${PRESET_CFLAGS}"
						MAKEOPTS="$PRESET_MAKE"
						EMERGE_DEFAULT_OPTS="$PRESET_EMERGE_DEFAULT_OPTS"
						INPUT_DEVICES="$PRESET_INPUTEVICE"
						VIDEO_CARDS="$PRESET_VIDEODRIVER"
						ACCEPT_LICENSE="$PRESET_LICENCES"
						FEATURES="$PRESET_FEATURES"
						USE="$PRESET_USEFLAG"
						GENTOO_MIRRORS="$PRESET_GENTOMIRRORS"
						PORTDIR="$PRESET_PORTDIR"
						DISTDIR="$PRESET_DISTDIR"
						PKGDIR="$PRESET_PKGDIR"
						PORTAGE_TMPDIR="$PRESET_PORTAGE_TMPDIR"
						PORTAGE_LOGDIR="$PRESET_PORTAGE_LOGDIR"
						PORTAGE_ELOG_CLASSES="$PRESET_PORTAGE_ELOG_CLASSES"
						PORTAGE_ELOG_SYSTEM="$PRESET_PORTAGE_ELOG_SYSTEM"
						LINGUAS="$PRESET_LINGUAS"
						L10N="$PRESET_L10N"  # IETF language tags
						LC_MESSAGES="$PRESET_LC_MESSAGES"
						# CURL_SSL="$PRESET_CURL_SSL"
EOF
					}
					MAKECONF_VARIABLES
					EMERGE_ATWORLD_B
				}
				CONF_LOCALES () {  # https://wiki.gentoo.org/wiki/Localization/Guide
					CONF_LOCALEGEN () {
						cat << EOF > /etc/locale.gen
						$PRESET_LOCALE_A ISO-8859-1
						$PRESET_LOCALE_A.UTF-8 UTF-8
						$PRESET_LOCALE_B ISO-8859-1
						$PRESET_LOCALE_B.UTF-8 UTF-8
EOF
					}
					GEN_LOCALE () {
						locale-gen
					}
					SYS_LOCALE () {  # (!todo)
						SYSLOCALE="$PRESET_LOCALE_A.UTF-8"
						SYSTEMLOCALE_OPENRC () {  # https://wiki.gentoo.org/wiki/Localization/Guide#OpenRC
							cat << EOF > /etc/env.d/02locale
							LANG="$SYSLOCALE"
							LC_COLLATE="C" # Define alphabetical ordering of strings. This affects e.g. output of sorted directory listings.
							# LC_CTYPE=$PRESET_LOCALE_A.UTF-8 # (!NOTE: not tested yet)
EOF
						}
						SYSTEMLOCALE_SYSTEMD () {  # https://wiki.gentoo.org/wiki/Localization/Guide#systemd
							localectl set-locale LANG=$SYSLOCALE
							localectl | grep "System Locale"
						}
						SYSTEMLOCALE_$SYSINITVAR
					}
					CONF_LOCALEGEN
					GEN_LOCALE
					SYS_LOCALE
				}

				ESELECT_PROFILE () {
					eselect profile set $ESELECT_PROFILE
				}
				SETFLAGS1 () {  # set custom flags (!NOTE: disabled by default) (!NOTE; was systemd specific, systemd not compete yet 05.11.2020)
					SETFLAGSS1_OPENRC () {
						NOTICE_PLACEHOLDER
					}
					SETFLAGSS1_SYSTEMD () {  #(!todo)
						APPAPP_EMERGE="virtual/libudev "  # ! If your system set provides sys-fs/eudev, virtual/udev and virtual/libudev may be preventing systemd.  https://wiki.gentoo.org/wiki/Systemd
						EMERGE_USERAPP_DEF
						sed -ie '#echo "sys-apps/systemd cryptsetup#d'
						echo /etc/portage/package.use/systemd"sys-apps/systemd cryptsetup" >> /etc/portage/package.use/systemd
					}
					SETFLAGSS1_$SYSINITVAR
				}
				PORTAGE () {  # https://wiki.gentoo.org/wiki/Portage#emerge-webrsync # https://dev.gentoo.org/~zmedico/portage/doc/man/emerge.1.html
					mkdir /usr/portage
					emerge-webrsync
				}
				EMERGE_SYNC () {
					emerge --sync
				}
				MISC1_CHROOT () {
					MISC1CHROOT_OPENRC () {
						NOTICE_PLACEHOLDER
					}
					MISC1CHROOT_SYSTEMD () {
						systemctl preset-all
						systemctl daemon-reload
						ENVUD
					}
					MISC1CHROOT_$SYSINITVAR
				}
				RELOADING_SYS () {
					RELOAD_OPENRC () {
						NOTICE_PLACEHOLDER
					}
					RELOAD_SYSTEMD () {
						systemctl preset-all
						systemctl daemon-reload
						ENVUD
					}
					RELOAD_$SYSINITVAR
				}
				SYSTEMTIME () {  # https://wiki.gentoo.org/wiki/System_time
					SET_TIMEZONE () {
						echo $SYSTIMEZONE_SET > /etc/timezone
						TIMEZONE_OPENRC () {
							echo "$SYSTIMEZONE_SET" > /etc/timezone
							APPAPP_EMERGE=" --config sys-libs/timezone-data "
							EMERGE_USERAPP_DEF
						}
						TIMEZONE_SYSTEMD () {
							timedatectl set-timezone $SYSTIMEZONE_SET
						}
						TIMEZONE_$SYSINITVAR
					}
					SET_SYSTEMCLOCK () {  # https://wiki.gentoo.org/wiki/System_time#System_clock
						SYSTEMCLOCK_OPENRC () {
							OPENRC_SYSCLOCK_MANUAL () {
								OPENRC_SYSTEMCLOCK () {
									date $SYSDATE_MAN
								}
								OPENRC_SYSTEMCLOCK
							}
							OPENRC_OPENNTPD () {
								APPAPP_EMERGE="net-misc/openntpd"
								SYSSTART_OPENNTPD () {
									AUTOSTART_NAME_OPENRC="ntpd"
									AUTOSTART_DEFAULT_OPENRC
								}
								EMERGE_USERAPP_DEF
								SYSSTART_OPENNTPD
							}
							# OPENRC_SYSCLOCK_MANUAL  # (!changeme: only 1 can be set)
							OPENRC_OPENNTPD
						}
						SYSTEMCLOCK_SYSTEMD () {  # https://wiki.gentoo.org/wiki/System_time#Hardware_clock
							SYSTEMD_SYSCLOCK_MANUAL () {
								timedatectl set-time "$SYSCLOCK_MAN"
							}
							SYSTEMD_SYSCLOCK_AUTO () { 
								SYSSTART_TIMESYND () {
									AUTOSTART_NAME_SYSTEMD="systemd-timesyncd"
									AUTOSTART_DEFAULT_SYSTEMD
									# timedatectl set-local-rtc 0 # 0 set UTC
								}
								SYSSTART_TIMESYND
							}
							SYSTEMD_SYSCLOCK_$SYSCLOCK_SET
						}
						SYSTEMCLOCK_$SYSINITVAR
					}
					SET_HWCLOCK () {
						hwclock --systohc
					}
					SET_TIMEZONE  # echos err for systemd if install medium isnt systemd
					SET_SYSTEMCLOCK  # echos err for systemd, if install medium isnt systemd
					SET_HWCLOCK
				}

				KEYMAP_CONSOLEFONT () {  # https://wiki.gentoo.org/wiki/Keyboard_layout_switching  ## (note:: theres a second place where keymaps are set, which is:"X11 KEYS SET = WINDOWSYS --> X11")

					KEYMAP_CONSOLEFONT_OPENRC () {
						KEYMAP_OPENRC () { # (!changeme in var)
							AUTOSTART_NAME_OPENRC="keymaps"
							sed -ie 's/keymap="us"/keymap="$KEYMAP"/g' /etc/conf.d/keymaps
							sed -ie 's/keymap="de"/keymap="$KEYMAP"/g' /etc/conf.d/keymaps
							sed -ie "s/\$KEYMAP/$KEYMAP/g" /etc/conf.d/keymaps
							AUTOSTART_BOOT_OPENRC
							rc-update add keymaps boot
						}
						CONSOLEFONT_OPENRC () {
							AUTOSTART_NAME_OPENRC="consolefont"
							sed -ie 's/consolefont="default8x16"/consolefont="$CONSOLEFONT"/g' /etc/conf.d/consolefont
							sed -ie "s/\$CONSOLEFONT/$CONSOLEFONT/g" /etc/conf.d/consolefont  # note: consolefont file also contains "conoletranslation=" ;  "unicodemap=" - not set here - disabled by default.
							AUTOSTART_BOOT_OPENRC
						}
						etc-update --automode -3
						KEYMAP_OPENRC
						CONSOLEFONT_OPENRC
					}

					KEYMAP_CONSOLEFONT_SYSTEMD () {   # https://wiki.archlinux.org/index.php/Keyboard_configuration_in_console
						AUTOSTART_NAME_SYSTEMD="placeholder"
						VCONSOLE_KEYMAP=$KEYMAP-latin1 # (!changeme) console keymap systemd
						VCONSOLE_FONT="$CONSOLEFONT" # (!changeme)
						cat << EOF > /etc/vconsole.conf
						KEYMAP=$VCONSOLE_KEYMAP
						FONT=$VCONSOLE_FONT
EOF
					}
					
					ENVUD
					KEYMAP_CONSOLEFONT_$SYSINITVAR
				}
				FIRMWARE () {
					LINUX_FIRMWARE () {  # https://wiki.gentoo.org/wiki/Linux_firmware
						APPAPP_EMERGE="sys-kernel/linux-firmware "
						PACKAGE_USE				
						LICENSE_SET
						EMERGE_ATWORLD_A
						EMERGE_USERAPP_DEF
						etc-update --automode -3  # (automode -3 = merge all)
					}
					LINUX_FIRMWARE
				}
				BASHRC () {  # (!NOTE: custom .bashrc) (!todo) (!changeme)
					cp /.bashrc.sh /etc/skel/.bashrc
				}
				#SWAPFILE
				#df -h
# backup vom last stop
				#cat /etc/portage/make.conf
				#MAKECONF
				# cat /etc/portage/make.conf
				#CONF_LOCALES

				 #PORTAGE
				## EMERGE_SYNC  # probably can leave this out if everything already latest ...
				#eselect profile list
				#ESELECT_PROFILE
				# SETFLAGS1
				#EMERGE_ATWORLD_A
				##MISC1_CHROOT
				##RELOADING_SYS
				#SYSTEMTIME
				#KEYMAP_CONSOLEFONT
				#FIRMWARE
				BASHRC
				# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			}
			CORE () {
				FSTAB () {  # https://wiki.gentoo.org/wiki/Fstab
					FSTAB_LVMONLUKS_BIOS () {  # (!default)
						cat << EOF > /etc/fstab
						# ROOT MAIN FS
						/dev/mapper/$VG_MAIN-$LV_MAIN	/	$FILESYSTEM_MAIN	errors=remount-ro	0 1
						# BOOT
						UUID="$(blkid -o value -s UUID $BOOT_PART)"	/boot	$FILESYSTEM_BOOT	rw,relatime	0 2
EOF
					} 
					FSTAB_LVMONLUKS_UEFI () {
						cat << EOF > /etc/fstab
						# ROOT MAIN FS
						/dev/mapper/$VG_MAIN-$LV_MAIN	/	$FILESYSTEM_MAIN	errors=remount-ro	0 1
						# BOOT
						UUID="$(blkid -o value -s UUID $BOOT_PART)"	/boot	$FILESYSTEM_BOOT	rw,relatime	0 2
EOF
					}
					FSTAB_LVMONLUKS_$BOOTSYSINITVAR
				}
				CRYPTTABD () {
					cat << EOF > /etc/crypttab
						# crypt-container
						$PV_MAIN UUID=$(blkid -o value -s UUID $MAIN_PART) none luks,discard
EOF
				}
				SYSAPP () {
					SYSAPP_DMCRYPT () {  # https://wiki.gentoo.org/wiki/Dm-crypt
						APPAPP_EMERGE="sys-fs/cryptsetup "
						AUTOSTART_NAME_OPENRC="dmcrypt"
						AUTOSTART_NAME_SYSTEMD="systemd-cryptsetup"
						PACKAGE_USE
						ACC_KEYWORDS_USERAPP
						EMERGE_ATWORLD_A
						EMERGE_USERAPP_DEF
						etc-update --automode -3  # (automode -3 = merge all)
						AUTOSTART_BOOT_$SYSINITVAR
					} 
					SYSAPP_LVM2 () {  # https://wiki.gentoo.org/wiki/LVM/de
						APPAPP_EMERGE="sys-fs/lvm2"
						AUTOSTART_NAME_OPENRC="lvm"  # (!important: "lvm" instead of "lvm2" as label)
						AUTOSTART_NAME_SYSTEMD="$APPAPP_NAME_SIMPLE-monitor"
						CONFIG_LVM2 () {
							sed -e 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf > /tmp/lvm.conf
							mv /tmp/lvm.conf /etc/lvm/lvm.conf
						}
						EMERGE_USERAPP_DEF
						AUTOSTART_BOOT_$SYSINITVAR
						CONFIG_LVM2
					}
					SYSAPP_SUDO () {  # https://wiki.gentoo.org/wiki/Sudo
						APPAPP_EMERGE="app-admin/sudo "  # (note!: must keep trailing)
						CONFIG_SUDO () {
							cp /etc/sudoers /etc/sudoers_bak
							sed -ie 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
						}
						EMERGE_USERAPP_DEF
						CONFIG_SUDO
					}
					SYSAPP_PCIUTILS () {
						APPAPP_EMERGE="sys-apps/pciutils "
						EMERGE_USERAPP_DEF
					}
					SYSAPP_MULTIPATH () {  # https://wiki.gentoo.org/wiki/Multipath
						APPAPP_EMERGE="sys-fs/multipath-tools "
						EMERGE_USERAPP_DEF
					}
					SYSAPP_GNUPG () {
						APPAPP_EMERGE="app/crypt/gnupg "
						EMERGE_USERAPP_DEF
						gpg --full-gen-key
					}
					SYSAPP_OSPROBER () {
						APPAPP_EMERGE="sys-boot/os-prober "
						EMERGE_USERAPP_DEF
					}
					SYSAPP_SYSLOG () {
						# (!todo) # . /var/app/syslog.sh
						# SYSLOGNG
SYSLOGNG_SYSLOG_SYSTEMD="syslog-ng@default"
SYSLOGNG_SYSLOG_OPENRC="syslog-ng"
SYSLOGNG_SYSLOG_EMERGE="app-admin/syslog-ng "
# SYSKLOGD
SYSKLOGD_SYSLOG_SYSTEMD=rsyslog
SYSKLOGD_SYSLOG_OPENRC=sysklogd
SYSKLOGD_SYSLOG_EMERGE="app-admin/sysklogd "

						SETVAR_SYSLOG () {
						
							if [ "$SYSLOG" == "SYSLOGNG" ]; then
								AUTOSTART_NAME_SYSTEMD=$SYSLOGNG_SYSLOG_SYSTEMD
								AUTOSTART_NAME_OPENRC=$SYSLOGNG_SYSLOG_OPENRC
								SYSLOG_EMERGE=$SYSLOGNG_SYSLOG_EMERGE
							elif [ "$SYSLOG" == "SYSKLOGD" ] 
								then AUTOSTART_NAME_SYSTEMD=$SYSKLOGD_SYSLOG_SYSTEMD
								AUTOSTART_NAME_OPENRC=$SYSKLOGD_SYSLOG_OPENRC
								SYSLOG_EMERGE=$SYSLOGNG_SYSLOG_EMERGE
							else
								echo "${bold}ERROR: Could not detect '$SYSLOG' - debug syslog $SYSLOG ${normal}"
							fi
						
						}
						SETVAR_SYSLOG
						APPAPP_EMERGE="$SYSLOG_EMERGE "
						EMERGE_USERAPP_DEF
						# SYSLOG_$SYSINITVAR  # (note!: autostart TODO)
						LOGROTATE () {
							APPAPP_EMERGE="app-admin/logrotate "
							CONFIG_LOGROTATE_OPENRC () {
								NOTICE_PLACEHOLDER
							}
							CONFIG_LOGROTATE_SYSTEMD () {
								systemd-tmpfiles --create /usr/lib/tmpfiles.d/logrotate.conf
							}
							EMERGE_USERAPP_DEF
							CONFIG_LOGROTATE_$SYSINITVAR
						}
						LOGROTATE
					}
					SYSAPP_CRON () {
						# (!todo) . /var/app/cron.sh
## CRON - https://wiki.gentoo.org/wiki/Cron#Which_cron_is_right_for_the_job.3F
# BCRON # http://untroubled.org/bcron
BCRON_CRON_SYSTEMD=placeholder
BCRON_CRON_OPENRC=placeholder
BCRON_CRON_EMERGE=sys-process/bcron
# FCRON # http://www.linuxfromscratch.org/blfs/view/systemd/general/fcron.html
FCRON_CRON_SYSTEMD=fcron
FCRON_CRON_OPENRC=fcron
FCRON_CRON_EMERGE=sys-process/fcron
# DCRON # http://www.linuxfromscratch.org/hints/downloads/files/dcron.txt
DCRON_CRON_SYSTEMD=razor-session
DCRON_CRON_OPENRC=razor-session
DCRON_CRON_EMERGE=sys-process/dcron
# CRONIE
CRONIE_CRON_SYSTEMD=cronie
CRONIE_CRON_OPENRC=cronie
CRONIE_CRON_EMERGE=sys-process/cronie
# VIXICRON
VIXICRON_CRON_SYSTEMD=vixi
VIXICRON_CRON_OPENRC=vixi
VIXICRON_CRON_EMERGE=sys-process/vixie-cron

						SETVAR_CRON () {
							for i in $CRON
							do
								CRON_SYSTEMD=$i\_CRON_SYSTEMD
								CRON_OPENRC=$i\_CRON_OPENRC
								CRON_EMERGE=$i\_CRON_EMERGE
							done
						}
						CONFIG_CRON () {
							crontab /etc/crontab	
						}
						SETVAR_CRON
						APPAPP_EMERGE="${!CRON_EMERGE}"
						AUTOSTART_NAME_OPENRC="${!CRON_OPENRC}"
						AUTOSTART_NAME_OPENRC="${!CRON_SYSTEMD}"
						echo $APPAPP_EMERGE
						EMERGE_USERAPP_DEF
						CONFIG_CRON
						AUTOSTART_DEFAULT_$SYSINITVAR
					}
					SYSAPP_FILEINDEXING () {
						APPAPP_EMERGE="sys-apps/mlocate "
						EMERGE_USERAPP_DEF
					}
				SYSAPP_DMCRYPT
					RUN_ALL_YES () {
						for i in ${!SYSAPP_*}
						do
							$i
						done
					}
					RUN_ALL_YES
				}
				# (note!: kernel configuration for filesystems not automated yet)
				I_FSTOOLS () {  # (! e2fsprogs # Ext2, 3, and 4) # optional, add to variables at time.
					## (note!: this is a little workaround to make sure FS support is installed.  This is missing a routine to avoid double emerges as of 16 01 2021)
						## FSTOOLS
						FST_EMERGE_EXT=sys-fs/e2fsprogs
						FST_EMERGE_XFS=sys-fs/xfsprogs
						FST_EMERGE_REISER=sys-fs/reiserfsprogs
						FST_EMERGE_JFS=sys-fs/jfsutils
						FST_EMERGE_VFAT=sys-fs/dosfstools # (FAT32, ...) 
						FST_EMERGE_BTRFS=sys-fs/btrfs-progs
						MAIN () {
							ALL_YES () {
								for i in  ${!FSTOOLS_*}
								do
									if [ $(printf '%s\n' "${!i}") == "YES" ]; then
										APPAPP_EMERGE=$(printf '%s\n' "$i" | sed -e s'/FSTOOLS_/FST_EMERGE_/g')
										EMERGE_USERAPP_RD1
									else 
										APPAPP_EMERGE=$(printf '%s\n' "$i" | sed -e s'/FSTOOLS_/FST_EMERGE_/g' )
										MATCHFS="$(printf '%s\n' "$i" | sed -e s'/FSTOOLS_/FST_EMERGE_/g' )"
										LDGFSE="$(printf '%s\n' "${!MATCHFS}" |   sed -e 's/-progs//g' | sed -e 's/progs//g' | sed -e 's#sys-fs/##g')"
										printf '%s\n' "$APPAPP_EMERGE  is set to NO, test for boot fs ..."
										for i in  ${!FILESYSTEM_*}
										do
											if [ "${!i}" == "$LDGFSE" ]; then
												echo "system / boot FS ${!i} = $LDGFSE pattern in search string for fstools repo variables $i "
												echo "emerging ${!APPAPP_EMERGE}"
												#EMERGE_USERAPP_RD1
											else
												#printf '%s\n' "${!MATCHFS}"
												#printf '%s\n' "${!i}"
												echo "system / boot FS ${!i} != $LDGFSE pattern in search string for fstools repo variables $i "
											fi
										done
									fi
								done
							}
							FILTER_YES () {
								for i in ${!FILESYSTEM_*}
								do
									if [[ "${!i}" == "msdos" || "${!FILESYSTEM_*}" == "vfat" || "${!FILESYSTEM_*}" == "fat" ]]; then
										echo "${!i} IS BINGO dos fs"
										APPAPP_EMERGE="$(printf '%s\n' "$FST_EMERGE_VFAT")"
										echo "emerging ${!APPAPP_EMERGE}"
										EMERGE_USERAPP_DEF
									else
										#printf '%s\n' "${!MATCHFS}"
										#printf '%s\n' "${!i}"
										echo "${!i} is not dos fs"
									fi
									if [[ "${!i}" == *"ext"* ]]; then
										echo "${!i} IS BINGO ext fs"
										APPAPP_EMERGE="$(printf '%s\n' "$FST_EMERGE_EXT")"
										echo "emerging $APPAPP_EMERGE "
										EMERGE_USERAPP_DEF
									else
										#printf '%s\n' "${!MATCHFS}"
										#printf '%s\n' "${!i}"
										echo "${!i} is not ext fs"
									fi
								done
							}
							ALL_YES
							FILTER_YES
						}
						MAIN
					}
				BOOTLOAD () {  # BOOTSYSINITVAR=BIOS/UEFI
					SETUP_GRUB2 () {  # (!NOTE:  https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt) 
						LOAD_GRUB2 () {
							PRE_GRUB2 () {
								etc-update --automode -3
								APPAPP_EMERGE="sys-boot/grub:2 "
								ACC_KEYWORDS_USERAPP
								PACKAGE_USE
								EMERGE_ATWORLD_A
								EMERGE_USERAPP_DEF
							}
							GRUB2_BIOS () {
								PRE_GRUB2BIOS () {
									sed -ie '/GRUB_PLATFORMS=/d' /etc/portage/make.conf
									echo 'GRUB_PLATFORMS="pc"' >> /etc/portage/make.conf
									EMERGE_ATWORLD_A
								}
								PRE_GRUB2BIOS
								grub-install --recheck --target=i386-pc $HDD1
							}
							GRUB2_UEFI () {
								PRE_GRUB2UEFI () {
									sed -ie '/GRUB_PLATFORMS=/d' /etc/portage/make.conf
									sed -ie '/GRUB_PLATFORMS="efi-64/d' /etc/portage/make.conf
									echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
									EMERGE_ATWORLD_A
								}
								PRE_GRUB2UEFI
								grub-install --target=x86_64-efi --efi-directory=/boot
								## (!NOTE: optional)# mount -o remount,rw /sys/firmware/efi/efivars  # If grub_install returns an error like Could not prepare Boot variable: Read-only file system, it may be necessary to remount the efivars special mount as read-write in order to succeed:
								## (!NOTE: optional)# grub-install --target=x86_64-efi --efi-directory=/boot --removable  # Some motherboard manufacturers seem to only support the /efi/boot/ directory location for the .EFI file in the EFI System Partition (ESP). 
							}
							PRE_GRUB2
							GRUB2_$BOOTSYSINITVAR
						}
						CONFIG_GRUB2_DMCRYPT () { # ( !note: config is edited partially after pasting, to be fully integrated in variables. )
						
							CONFGRUBDMCRYPT_MAIN () {
								etc-update --automode -3
								cp  /configs/default/grub /etc/default/grub
								echo "may ignore complaining cp"
							}
							CONFGRUBDMCRYPT_OPENRC () {  # https://wiki.gentoo.org/wiki/GRUB2
							
								sed -ie '/GRUB_CMDLINE_LINUX=/d' /etc/default/grub
								cat << EOF >> /etc/default/grub
								# If the root file system is contained in a logical volume of a fully encrypted LVM, the device mapper for it will be in the general form of root=/dev/volumegroup/logicalvolume. https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration
								GRUB_CMDLINE_LINUX="raid=noautodetect cryptdevice=PARTUUID=$(blkid -s PARTUUID -o value $MAIN_PART):$PV_MAIN root=UUID=$(blkid -s UUID -o value /dev/$VG_MAIN/$LV_MAIN) rootfstype=ext4 dolvm"
								# (!NOTE: etc/crypttab not required under default openrc, "luks on lvm", GPT, bios - setup) # Warning: If you are using /etc/crypttab or /etc/crypttab.initramfs together with luks.* or rd.luks.* parameters, only those devices specified on the kernel command line will be activated and you will see Not creating device 'devicename' because it was not specified on the kernel command line.. To activate all devices in /etc/crypttab do not specify any luks.* parameters and use rd.luks.*. To activate all devices in /etc/crypttab.initramfs do not specify any luks.* or rd.luks.* parameters.
EOF
							}
							CONFGRUBDMCRYPT_SYSTEMD () {  # https://wiki.gentoo.org/wiki/GRUB2
							
								sed -ie '/GRUB_CMDLINE_LINUX=/d' /etc/default/grub
								cat << EOF >> /etc/default/grub
								# If the root file system is contained in a logical volume of a fully encrypted LVM, the device mapper for it will be in the general form of root=/dev/volumegroup/logicalvolume. https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration
								GRUB_CMDLINE_LINUX="rd.luks.name=$(blkid -o value -s UUID $MAIN_PART)=$PV_MAIN root=UUID=$(blkid -s UUID -o value /dev/$VG_MAIN/$LV_MAIN) rootfstype=ext4 dolvm " #real_init=/lib/systemd/systemd
								# rd.luks.name= is honored only by initial RAM disk (initrd) while luks.name= is honored by both the main system and the initrd. https://www.freedesktop.org/software/systemd/man/systemd-cryptsetup-generator.html
EOF
							}
							CONFGRUBDMCRYPT_MAIN
							CONFGRUBDMCRYPT_$SYSINITVAR
						}
						UPDATE_GRUB () {
							grub-mkconfig -o /boot/grub/grub.cfg
						}
						LOAD_GRUB2
						CONFIG_GRUB2_DMCRYPT
						UPDATE_GRUB
					}
					SETUP_LILO () {
						APPAPP_EMERGE="sys-boot/lilo "
						CONF_LILO () {  # https://wiki.gentoo.org/wiki/LILO # https://github.com/a2o/lilo/blob/master/sample/lilo.example.conf
							cp /configs/optional/lilo.conf /etc/lilo.conf
						}
						EMERGE_USERAPP_DEF
						CONF_LILO
					}
					SETUP_$BOOTLOADER
				}                        
				KERNEL () {  # https://wiki.gentoo.org/wiki/Kernel
					KERN_LOAD () {
						KERN_EMERGE () {
							APPAPP_EMERGE="sys-kernel/gentoo-sources "
							ACC_KEYWORDS_USERAPP
							EMERGE_ATWORLD_A
							EMERGE_USERAPP_DEF
						}
						KERN_TORVALDS () {
							rm -rf /usr/src/linux
							git clone https://github.com/torvalds/linux /usr/src/linux
							cd /usr/src/linux
							git fetch
							git fetch --tags
							git checkout v$KERNVERS  # get desired branch / tag
						}
						KERN_$KERNSOURCES
					}
					KERN_DEPLOY () {
						KERN_MANUAL () {
							KERN_CONF () {
								KERNCONF_PASTE () {  # paste own config here ( ~ this should go to auto)
									mv /usr/src/$(ls /usr/src) /usr/src/linux			
									mv /usr/src/linux/.config /usr/src/linux/.oldconfig 
									echo "ignore err"
									touch /usr/src/linux/.config
									cp /kern.config /usr/src/$(ls /usr/src)/.config  # stripped version infos for refetch # ls function to get the dirname quick - probably not the best hack but want to get done here now.
								}
								KERNCONF_DEFCONFIG () {
									cd /usr/src/linux
									make clean
									make proper
									make -j $(nproc) defconfig
								}
								KERNCONF_MENUCONFIG () {
									cd /usr/src/linux
									make clean
									make proper
									make -j $(nproc) menuconfig
								}
								KERNCONF_ALLYESCONFIG () {  # New config where all options are accepted with yes
									cd /usr/src/linux
									make clean
									make proper
									make -j $(nproc) allyesconfig
								}
								KERNCONF_OLDCONFIG () {  # (!testing) (!todo)
									cd /usr/src/linux
									make clean
									make proper
									make -j $(nproc) oldconfig
								}
								if [ "$KERNCONFD" != "DEFCONFIG" ]; then
									KERNCONF_PASTE
									KERNCONF_$KERNCONFD
								else
									KERNCONF_DEFCONFIG
								fi
							}
							KERN_BUILD () {  # (!incomplete (works but) modules setup *smart)
								cd /usr/src/linux  # enter build directory (required?)
								make -j$(nproc) dep
								make -j$(nproc) -o /usr/src/linux/.config # build kernel based on .config file
								make -j$(nproc) -o /usr/src/linux/.config modules # build modules based on .config file
								make -j$(nproc) bzImage
								sudo make install  # install the kernel
								sudo make modules_install  # install the modules
							}
							lsmod  # active modules by install medium.
							KERN_CONF  # kernel configure set
							KERN_BUILD  # kernel build set
							grub-mkconfig -o /boot/grub/grub.cfg  # update grub in case its already installed ....
						}
						KERN_AUTO () {  # (!changeme) switch to auto (option variables top) # switch to auto configuration (option variables top)
							GENKERNEL_NEXT () {  # # (!incomplete)
								CONF_GENKERNEL () {  # (!incomplete)
									touch /etc/genkernel.conf
									cat << 'EOF' > /etc/genkernel.conf
									# [!PASTE_OPTIONAL_CONFIG: config/other_optional/genkernel.conf - not yet intgreated in variables and fully tested, ]
EOF
								}
								RUN_GENKERNEL () {
									# genkernel --config=/etc/genkernel.conf all
									genkernel --luks --lvm --no-zfs all
									rub-mkconfig -o /boot/grub/grub.cfg  # update grub in case its already installed ....
								}
								APPAPP_EMERGE="sys-kernel/genkernel-next"
								PACKAGE_USE
								ACC_KEYWORDS_USERAPP
								EMERGE_ATWORLD_A
								EMERGE_USERAPP_DEF
								# CONF_GENKERNEL
								RUN_GENKERNEL
							}
							GENKERNEL_NEXT
						}
						KERN_$KERNDEPLOY
						cd /
					}
					KERNEL_HEADERS () {
						emerge --ask sys-kernel/linux-headers
					}
					KERN_LOAD  # load kernel source (download, copy ; etc ....)
					KERN_DEPLOY  # config / build
					KERNEL_HEADERS
				}
				INITRAMFS () {  # https://wiki.gentoo.org/wiki/Initramfs
					INITRFS_GENKERNEL () {
						# genkernel --config=/etc/genkernel.conf initramfs
						genkernel $GENKERNEL_CMD
					}
					INITRFS_DRACUT () {  # https://wiki.gentoo.org/wiki/Dracut
						APPAPP_EMERGE="sys-kernel/dracut"
						CONFIG_DRACUT () {
							DRACUT_USERMOUNTCONF () {
								cat << EOF > /etc/dracut.conf.d/usrmount.conf
								add_dracutmodules+="$DRACUT_CONFD_ADD_DRACUT_MODULES" # Dracut modules to add to the default
EOF
								cat /etc/dracut.conf.d/usrmount.conf
							}
							DRACUT_DRACUTCONF () {
								cat << EOF > /etc/dracut.conf
# i18n
#i18n_vars="/etc/sysconfig/keyboard:KEYTABLE-KEYMAP /etc/sysconfig/i18n:SYSFONT-FONT,FONTACM-FONT_MAP,FONT_UNIMAP"
#i18n_default_font="eurlatgr"
								#i18n_vars="/etc/conf.d/keymaps:KEYMAP,EXTENDED_KEYMAPS-EXT_KEYMAPS /etc/conf.d/consolefont:CONSOLEFONT-FONT,CONSOLETRANSLATION-FONT_MAP /etc/rc.conf:UNICODE"
								#i18n_install_all="yes"
								i18n_vars="/etc/conf.d/keymaps:keymap-KEYMAP,extended_keymaps-EXT_KEYMAPS /etc/conf.d/consolefont:consolefont-FONT,consoletranslation-FONT_MAP /etc/rc.conf:unicode-UNICODE"

								hostonly="$DRACUT_CONF_HOSTONLY"
								lvmconf="$DRACUT_CONF_LVMCONF"
								dracutmodules+="$DRACUT_CONF_MODULES"
EOF
								cat /etc/dracut.conf
							}
							DRACUT_USERMOUNTCONF
							DRACUT_DRACUTCONF
						}
						PACKAGE_USE
						EMERGE_USERAPP_DEF
						CONFIG_DRACUT
						dracut --force '' $(ls /lib/modules)
					}
					INITRFS_$GENINITRAMFS  # config / build
					etc-update --automode -3
				}



				MODPROBE_CHROOT () {
					modprobe -a dm-mod dm-crypt sha256 aes aes_generic xts
				}
				VIRTUALIZATION () {
					SYS_HOST () {
						NOTICE_PLACEHOLDER
					}
					SYS_GUEST () {
						GUE_VIRTUALBOX () {
						# which kernel variables set the dependencies?
							APPAPP_EMERGE="app-emulation/virtualbox-guest-additions"
							AUTOSTART_NAME_OPENRC="virtualbox-guest-additions"
							PACKAGE_USE
							EMERGE_ATWORLD_B
							EMERGE_USERAPP_DEF
							AUTOSTART_DEFAULT_OPENRC
							VBoxClient-all
							rc-update add dbus boot
						}
						GUE_VIRTUALBOX
					}
					SYS_$SYSVARD
				}
				AUDIO () {  # (!todo)
					SOUND_API () {
						LIBSNDFILE () {
							USE="minimal" emerge -q media-libs/libsndfile
						}
						ALSA () {  # https://wiki.gentoo.org/wiki/ALSA
							USEFLAGS_
							APPAPP_EMERGE="media-sound/alsa-utils"
							AUTOSTART_NAME_OPENRC="alsasound"
							AUTOSTART_NAME_SYSTEMD="alsa-restore"
							EMERGE_ATWORLD_B
							EMERGE_USERAPP_DEF
							APPAPP_EMERGE="media-plugins/alsa-plugins "
							# USE="ffmpeg" emerge -q media-plugins/alsa-plugins
							EMERGE_USERAPP_DEF
							AUTOSTART_DEFAULT_$SYSINITVAR
						}
						LIBSNDFILE
						ALSA
					}
					SOUND_SERVER () {
						JACK () {
							APPAPP_EMERGE="media-sound/jack2 "
							PACKAGE_USE
							EMERGE_USERAPP_DEF
							ENVUD 
						}

						PULSEAUDIO () {
							APPAPP_EMERGE="media-sound/pulseaudio "
							PACKAGE_USE
							EMERGE_USERAPP_DEF
							ENVUD 
						}
						JACK
						PULSEAUDIO
					}
					SOUND_MIXER () {
						PAVUCONTROL () {
							APPAPP_EMERGE="media-sound/pavucontrol "
							EMERGE_USERAPP_DEF
						}
						PAVUCONTROL
					}
					SOUND_API
					SOUND_SERVER
					SOUND_MIXER
				}
			#	GPU () {  # (!todo)
			#		SET_NONE () {
			#			NOTICE_PLACEHOLDER
			#		
			#		}
			#		SET_NVIDIA () {  # (!todo)
			#			NOTICE_PLACEHOLDER
			#		} 
			#		SET_AMD () {  # (!todo)
			#			RADEON () {  # (!todo)
			#				APPAPP_EMERGE=" "
			#				EMERGE_USERAPP_DEF
			#			}
			#			AMDGPUDEF () {  # (!todo)
			#				APPAPP_EMERGE=" "
			#				EMERGE_USERAPP_DEF
			#				# radeon-ucode
			#			}
			#			AMDGPUPRO () {  # (!todo)
			#				APPAPP_EMERGE="dev-libs/amdgpu-pro-opencl "
			#				EMERGE_USERAPP_DEF
			#			}
			#			# RADEON
			#			# AMDGPUDEF
			#			AMDGPUPRO
			#		}
			#		$GPU_SET
			#	}
				NETWORK_MAIN () {  # (!todo)
					HOSTSFILE () {  # (! default)
						echo "$HOSTNAME" > /etc/hostname
						echo "127.0.0.1	localhost
						::1		localhost
						127.0.1.1	$HOSTNAME.$DOMAIN	$HOSTNAME" > /etc/hosts
						cat /etc/hosts
					}
					NETWORK_MGMT () {
						GENTOO_DEFAULT () {
							NETIFRC () {  # (! default)
								APPAPP_EMERGE="net-misc/netifrc "
								VAR_EMERGE=" --noreplace net-misc/netifrc " 
								AUTOSTART_NAME_OPENRC="net.$NETIFACE_MAIN "
								AUTOSTART_NAME_SYSTEMD="net@$NETIFACE_MAIN"
								CONF_NETIFRC () {
									cat << EOF > /etc/conf.d/net  # Please read /usr/share/doc/netifrc-*/net.example.bz2 for a list of all available options. DHCP client man page if specific DHCP options need to be set.
									config_$NETIFACE_MAIN="dhcp"
EOF
									cat /etc/conf.d/net
								}
								EMERGE_USERAPP_DEF
								CONF_NETIFRC
								AUTOSTART_DEFAULT_$SYSINITVAR
							}
							NETIFRC
						}
						OPENRC_DEFAULT () {
							NOTICE_PLACEHOLDER
						}
						SYSTEMD_DEFAULT () {
							NETWORKD () {  # https://wiki.archlinux.org/index.php/Systemd-networkd
								systemctl enable systemd-networkd.service
								REPLACE_RESOLVECONF () {  # (! default)
									ln -snf /run/systemd/resolved.conf /etc/resolv.conf
									systemctl enable systemd-resolved.service
								}
								WIRED_DHCPD () {  # (! default)
									cat << 'EOF' > /etc/systemd/network/20-wired.network
									[ Match ]
									Name=enp0s3
									[ Network ]
									DHCP=ipv4
EOF
								}
								WIRED_STATIC () {
									cat << 'EOF' > /etc/systemd/network/20-wired.network
									[ Match ]
									Name=enp0s3
									[ Network ]
									Address=10.1.10.9/24
									Gateway=10.1.10.1
									DNS=10.1.10.1
									# DNS=8.8.8.8
EOF
								}
								REPLACE_RESOLVECONF
								WIRED_$NETWORK_NET
							}
							NETWORKD
						}
						DHCCLIENT () {
							DHCPCD () {  # https://wiki.gentoo.org/wiki/Dhcpcd
								APPAPP_EMERGE="net-misc/dhcpcd "
								AUTOSTART_NAME_OPENRC="dhcpcd"
								AUTOSTART_NAME_SYSTEMD="dhcpcd"
								EMERGE_USERAPP_DEF
								AUTOSTART_DEFAULT_$SYSINITVAR
							}
							DHCPCD
						}
						NETWORKMANAGER () {
							EMERGE_NETWORKMANAGER () {
								APPAPP_EMERGE="net-misc/networkmanager "
								AUTOSTART_NAME_OPENRC="NetworkManager"
								AUTOSTART_NAME_SYSTEMD="NetworkManager"
								PACKAGE_USE
								ACC_KEYWORDS_USERAPP
								EMERGE_ATWORLD_A
								EMERGE_USERAPP_DEF
								AUTOSTART_DEFAULT_$SYSINITVAR
							}
							EMERGE_NETWORKMANAGER
							AUTOSTART_DEFAULT_$SYSINITVAR
						}
						DHCCLIENT
						$NETWMGR
					}
					HOSTSFILE
					NETWORK_MGMT
				}
				#FSTAB
				## CRYPTTABD  # (!info: not required for the default lvm on luks gpt bios grub - setup)
				#SYSAPP  # (!NOTE !todo !bug : virtualbox) other issues?  # notice during setup  unsupporeted locale setting
				#I_FSTOOLS # notice during setup  unsupporeted locale setting
				BOOTLOAD
				#KERNEL
				if [ "$CONFIGBUILDKERN" != "AUTO" ]; then
					INITRAMFS
				else
					echo 'CONFIGBUILDKERN AUTO DETECTED, skipping initramfs'
				fi
				##MODPROBE_CHROOT  # (!info: not required for the default lvm on luks gpt bios grub - setup)
				#VIRTUALIZATION  # (!info !bug !todo : worked previously with virtualbox set as gpu in make.conf, curiously.)
				#AUDIO # circular dependencies err "minimal, pulse3audio"
				##GPU # (!note: incomplete)
				#NETWORK_MAIN
				# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			
			}
			SCREENDSP () {  # note: replace visual header with "screen and desktop"
				WINDOWSYS () {
					X11 () {  # (! default) # https://wiki.gentoo.org/wiki/Xorg/Guide
						EMERGE_XORG () {
							APPAPP_EMERGE="x11-libs/gdk-pixbuf "
							EMERGE_USERAPP_DEF
							APPAPP_EMERGE="x11-base/xorg-server "
							PACKAGE_USE
							EMERGE_USERAPP_DEF
							ENVUD 
						}
						CONF_XORG () {
							CONF_X11_KEYBOARD () {
								# changed from Option "XkbLayout" "LANG_MAIN_LOWER,$LANG_SECOND_LOWER" - to have the corect keyboard layout after boot in the desktop environment (testing) 04.09.2022
								touch /usr/share/X11/xorg.conf.d/10-keyboard.conf
								cat << EOF > /usr/share/X11/xorg.conf.d/10-keyboard.conf
								Section "InputClass"
								    Identifier "keyboard-all"
								
								    Option "XkbLayout" "$KEYMAP"
								    Option "XkbVariant" "$X11_XKBVARIANT"
								    Option "XkbOptions" "$X11_KEYBOARD_XKB_OPTIONS"
								    MatchIsKeyboard "$X11_KEYBOARD_MATCHISKEYBOARD"
								EndSection
EOF
							}
							CONF_X11_KEYBOARD
						}
						EMERGE_XORG
						CONF_XORG
						ENVUD
					}
					$DISPLAYSERV
				}
				DESKTOP_ENV () {  # https://wiki.gentoo.org/wiki/Desktop_environment
					#. /var/app/desk-env.sh
#  BUDGIE - https://wiki.gentoo.org/wiki/Budgie
BUDGIE_DSTENV_XEC=budgie_dpmexec
BUDGIE_DSTENV_STARTX=budgie
BUDGIE_DSTENV_EMERGE=budgie
#  CINNAMON - https://wiki.gentoo.org/wiki/Cinnamon
CINNAMON_DSTENV_XEC=gnome-session-cinnamon
CINNAMON_DSTENV_STARTX=cinnamon-session
CINNAMON_DSTENV_EMERGE=gnome-extra/cinnamon
#  DDE "Deepin Desktop Environment" - https://wiki.gentoo.org/wiki/DDE
DDE_DSTENV_XEC=DDE
DDE_DSTENV_STARTX=DDE
DDE_DSTENV_EMERGE=DDE
#  FVWM-Crystal - FVWM-Crystal
FVWMCRYSTAL_DSTENV_XEC=fvwm-crystal
FVWMCRYSTAL_DSTENV_STARTX=fvwm-crystal
FVWMCRYSTAL_DSTENV_EMERGE=x11-themes/fvwm-crystal
#  GNOME - https://wiki.gentoo.org/wiki/GNOME
GNOME_DSTENV_XEC=gnome-session
GNOME_DSTENV_STARTX=GNOME
GNOME_DSTENV_EMERGE=gnome-base/gnome
#  KDE - FVWM-Crystal
KDE_DSTENV_XEC=kde-plasma/startkde
KDE_DSTENV_STARTX=startkde
KDE_DSTENV_EMERGE=kde-plasma/plasma-meta
#  LXDE - https://wiki.gentoo.org/wiki/LXDE
LXDE_DSTENV_XEC=startlxde
LXDE_DSTENV_STARTX=startlxde
LXDE_DSTENV_EMERGE=lxde-base/lxde-meta
#  LXQT - FVWM-Crystal
LXQT_DSTENV_XEC=startlxqt
LXQT_DSTENV_STARTX=startlxqt
LXQT_DSTENV_EMERGE=lxqt-base/lxqt-meta
#  LUMINA - https://wiki.gentoo.org/wiki/Lumina
LUMINA_DSTENV_XEC=start-lumina-desktop
LUMINA_DSTENV_STARTX=start-lumina-desktop
LUMINA_DSTENV_EMERGE=x11-wm/lumina
#  MATE - https://wiki.gentoo.org/wiki/MATE
MATE_DSTENV_XEC=mate-session
MATE_DSTENV_STARTX=mate-session
MATE_DSTENV_EMERGE=mate-base/mate
#  PANTHEON - https://wiki.gentoo.org/wiki/Pantheon
PANTHEON_DSTENV_XEC=PANTHEON
PANTHEON_DSTENV_STARTX=PANTHEON
PANTHEON_DSTENV_EMERGE=PANTHEON
#  RAZORQT - FVWM-Crystal
RAZORQT_DSTENV_XEC=razor-session
RAZORQT_DSTENV_STARTX=razor-session
RAZORQT_DSTENV_EMERGE=RAZORQT
#  TDE - https://wiki.gentoo.org/wiki/Trinity_Desktop_Environment
TDE_DSTENV_XEC=tde-session
TDE_DSTENV_STARTX=tde-session
TDE_DSTENV_EMERGE=trinity-base/tdebase-meta
#  XFCE - https://wiki.gentoo.org/wiki/Xfce
XFCE_DSTENV_XEC=xfce4-session
XFCE_DSTENV_STARTX=startxfce4
XFCE_DSTENV_EMERGE=xfce-base/xfce4-meta
					SETVAR_DSKTENV () {
						for i in $DESKTOPENV ; do
							DSTENV_XEC=$DESKTOPENV\_DSTENV_XEC
							DSTENV_STARTX=$DESKTOPENV\_DSTENV_STARTX
							DSTENV_EMERGE=$DESKTOPENV\_DSTENV_EMERGE
						done
					}
					ADDREPO_DSTENV () {
						if [ "$DESKTOPENV" == "PANTHEON" ]; then
							layman -a elementary
							eselect repository enable elementary
							emerge --sync elementary 
						else
							NOTICE_PLACEHOLDER
						fi
					}
					EMERGE_DSTENV () {
						# emerge --ask gnome-extra/nm-applet
						if [ "$DESKTOPENV" == "DDM" ]; then
							GIT () {
								APPAPP_EMERGE="dev-vcs/git "
								EMERGE_USERAPP_DEF
							}
							ESELECT () {
								APPAPP_EMERGE="app-eselect/eselect-repository "
								EMERGE_USERAPP_DEF
							}
							DEEPIN_GIT () {
								MAIN () {
								eselect repository add deepin git https://github.com/zhtengw/deepin-overlay.git
								APPAPP_EMERGE="deepin "
								EMERGE_USERAPP_DEF
								}
								PLUGIN () {
								mkdir -pv /etc/portage/package.use
								sed -ie '#dde-base/dde-meta multimedia#d' /etc/portage/package.use/deepin
								echo "dde-base/dde-meta multimedia" >> /etc/portage/package.use/deepin
								APPAPP_EMERGE="dde-base/dde-meta "
								EMERGE_USERAPP_DEF
								}
								MAIN
								PLUGIN
							}
							GIT
							ESELECT
							DEEPIN_GIT
						elif [ "$DESKTOPENV" == "PANTHEON" ]; then
							PANTHEON_MAIN () {
								APPAPP_EMERGE="pantheon-base/pantheon-shell "
								EMERGE_USERAPP_DEF
							
							}
							PANTHEON_ADDON () {
								APPAPP_EMERGE="media-video/audience x11-terms/pantheon-terminal "
								EMERGE_USERAPP_DEF
							}
							PANTHEON_MAIN
							PANTHEON_ADDON
						elif [ "$DESKTOPENV" == "XFCE" ]; then
							MISC_XFCE () {
								XFCEADDON () {
									emerge xfce-base/xfce4-session
									emerge xfce-base/xfce4-settings
									emerge xfce-base/xfwm4
									emerge xfce-base/xfce4-panel
									# emerge xfce-extra/xfce4-notifyd
									# emerge xfce-extra/xfce4-mount-plugin  #(!bug) failed to emerge
									emerge xfce-base/thunar
									emerge x11-terms/xfce4-terminal
									emerge app-editors/mousepad
									#emerge --ask media-sound/tudor-volumed
									#emerge XFCE-pulseaudio-plugin
									# emerge xfce-extra/xfce4-mixer  # not found 17.11.19
									emerge xfce-extra/xfce4-alsa-plugin
									# emerge xfce-extra/thunar-volman
								}
								APPAPP_EMERGE="xfce-base/xfce4-meta "
								PACKAGE_USE
								EMERGE_ATWORLD_B
								EMERGE_USERAPP_DEF
								XFCEADDON
							}
							MISC_XFCE
						else
							emerge $DSTENV_EMERGE
						fi
						ENVUD
					}
					MAIN_DESKTPENV_OPENRC () {
						AUTOSTART_NAME_OPENRC="dbus"
						AUTOSTART_DEFAULT_OPENRC
						AUTOSTART_NAME_OPENRC="xdm"
						AUTOSTART_DEFAULT_OPENRC
						AUTOSTART_NAME_OPENRC="elogind"  # elogind The systemd project's "logind", extracted to a standalone package https://github.com/elogind/elogind
						AUTOSTART_BOOT_OPENRC
					}
					MAIN_DESKTPENV_SYSTEMD () {
						AUTOSTART_NAME_SYSTEMD="dbus"
						AUTOSTART_DEFAULT_SYSTEMD
						AUTOSTART_NAME_SYSTEMD="systemd-logind"
						AUTOSTART_DEFAULT_SYSTEMD
						ENVUD
					}
					DESKTENV_SOLO () {
						DESKTENV_STARTX () {
							if [ "$DESKTOPENV" == "LUMINA" ]; then
								cat << 'EOF' > ~/.xinitrc 
								[[ -f ~/.Xresources ]]
								xrdb -merge -I/home/$SYSUSERNAME ~/.Xresources
								exec start-lumina-desktop
EOF
							else
								cat << 'EOF' > ~/.xinitrc 
								exec $DSTENV_STARTX
EOF
							fi
						}
						DESKTENV_AUTOSTART_OPENRC () {
							if [ "$DESKTOPENV" == "CINNAMON" ]; then
								cp /etc/xdg/autostart/nm-applet.desktop /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
								echo 'X-GNOME-Autostart-enabled=false' >> /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
								chown $SYSUSERNAME:$SYSUSERNAME /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
							else
								NOTICE_PLACEHOLDER
							fi
						}
						DESKTENV_AUTOSTART_SYSTEMD () {
							NOTICE_PLACEHOLDER
						}
						DESKTENV_STARTX
						DESKTENV_AUTOSTART_$SYSINITVAR
					}
					W_D_MGR () {  # Display_manager https://wiki.gentoo.org/wiki/Display_manager
						#. /var/app/display-mgr.sh
#  CDM - The Console Display Manager https://wiki.gentoo.org/wiki/CDM -- https://github.com/evertiro/cdm
CDM_DSPMGR_SYSTEMD=cdm.service
CDM_DSPMGR_OPENRC=cdm
CDM_APPAPP_EMERGE=x11-misc/cdm
#  GDM - https://wiki.gentoo.org/wiki/GNOME/gdm
GDM_DSPMGR_SYSTEMD=cdm.service
GDM_DSPMGR_OPENRC=gdm
GDM_APPAPP_EMERGE=gnome-base/gdm                                     
#  LIGHTDM - https://wiki.gentoo.org/wiki/LightDM
LIGHTDM_DSPMGR_SYSTEMD=lightdm.service
LIGHTDM_DSPMGR_OPENRC=lightdm
LIGHTDM_APPAPP_EMERGE=x11-misc/lightdm                       
#  LXDM - https://wiki.gentoo.org/wiki/LXDE (always links to lxde by time of this writing)					
LXDM_DSPMGR_SYSTEMD=lxdm.service
LXDM_DSPMGR_OPENRC=lxdm # (startlxde ?)
LXDM_APPAPP_EMERGE=lxde-base/lxdm
#  QINGY - https://wiki.gentoo.org/wiki/ QINGY
QINGY_DSPMGR_SYSTEMD=qingy.service
QINGY_DSPMGR_OPENRC=qingy
QINGY_APPAPP_EMERGE=placeholder
#  SSDM - https://wiki.gentoo.org/wiki/SSDM
SSDM_DSPMGR_SYSTEMD=sddm.service
SSDM_DSPMGR_OPENRC=sddm
SSDM_APPAPP_EMERGE=x11-misc/sddm                      
#  SLIM - https://wiki.gentoo.org/wiki/SLiM
SLIM_DSPMGR_SYSTEMD=slim.service
SLIM_DSPMGR_OPENRC=slim
SLIM_APPAPP_EMERGE=x11-misc/slim                                            
#  WDM - https://wiki.gentoo.org/wiki/WDM
WDM_DSPMGR_SYSTEMD=wdm.service
WDM_DSPMGR_OPENRC=wdm
WDM_APPAPP_EMERGE=x11-misc/wdm                 
#  XDM - https://packages.gentoo.org/packages/x11-apps/xdm
XDM_DSPMGR_SYSTEMD=xdm.service
XDM_DSPMGR_OPENRC=xdm
XDM_APPAPP_EMERGE=x11-apps/xdm

						SETVAR_DSPMGR () {
							for i in $DISPLAYMGR
							do
								DSTENV_XEC=$DESKTOPENV\_DSTENV_XEC
								DSTENV_STARTX=$DESKTOPENV\_DSTENV_STARTX
								DSPMGR_AS=$i\_DSPMGR_$SYSINITVAR
								DSPMGR_XEC=$i\_DSPMGR_XEC
								DSPMGR_STARTX=$i\_DSPMGR_STARTX
								APPAPP_EMERGE=$i\_APPAPP_EMERGE
							done
						}
						DSPMGR_OPENRC () {
	
							sed -ie "s#llxdm#xdm#g" /etc/conf.d/display-manager
							sed -ie "s#lxdm#xdm#g" /etc/conf.d/display-manager
							sed -ie "s#xdm#${!DSPMGR_AS}#g" /etc/conf.d/display-manager
							 cat /etc/conf.d/display-manager 
							cat << EOF > ~/.xinitrc 
							exec ${!DSTENV_STARTX}
EOF
							cat ~/.xinitrc 
							rc-update add dbus default
							rc-update add ${!DSPMGR_AS} default
						}
						DSPMGR_SYSTEMD () {
							systemctl enable $DSPMGR_SYSTEMD
						}
						CONFIGURE_DSPMGR () {
							if [ "$DISPLAYMGR" == "LXDM" ]; then 
							printf '%s\n' " ${!DSPMGR_AS}"
								sed -ie "s;^# session=/usr/bin/startlxde;session=/usr/bin/${!DSTENV_STARTX};g" /etc/lxdm/lxdm.conf
							elif [ "$DISPLAYMGR" == "LIGHTDM" ]; then 
								cat << 'EOF' > /usr/share/lightdm/lightdm.conf.d/50-xfce-greeter.conf
								[SeatDefaults]
								greeter-session=unity-greeter
								user-session=xfce
EOF
							else
								NOTICE_PLACEHOLDER
							fi
						}
						SETVAR_DSPMGR
						EMERGE_USERAPP_RD1
						DSPMGR_$SYSINITVAR
						CONFIGURE_DSPMGR
					}
					SETVAR_DSKTENV  # set the variables
					ADDREPO_DSTENV
					EMERGE_DSTENV
					MAIN_DESKTPENV_$SYSINITVAR
					$DISPLAYMGR_YESNO
				}
				WINDOWSYS
				DESKTOP_ENV
				# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			}
			USERAPP () {  # (!todo)
				USERAPP_GIT () {  # (note: already setup through use flag make.conf?)
					APPAPP_EMERGE="dev-vcs/git"
					PACKAGE_USE
					EMERGE_USERAPP_DEF
				}
				WEBBROWSER () {
					USERAPP_FIREFOX () {
						APPAPP_EMERGE="www-client/firefox"
						PACKAGE_USE
						ACC_KEYWORDS_USERAPP
						EMERGE_USERAPP_DEF
					}
					USERAPP_CHROMIUM () {  # (!todo)
						APPAPP_EMERGE="www-client/chromium"
						PACKAGE_USE
						EMERGE_USERAPP_DEF
						etc-update --automode -3
					}
					USERAPP_MIDORI () {  # (!todo)
						APPAPP_EMERGE="www-client/midori"
						PACKAGE_USE
						EMERGE_USERAPP_DEF
					}
					RUN_ALLYES () {
						for i in  ${!USERAPP_*}
						do
							if [ $(printf '%s\n' "${!i}") == "YES" ]; then
								$i
							else 
								printf '%s\n' "$i is set to ${!i}, test for boot fs ..." 
							fi
						done
					}
					RUN_ALLYES
				}
				# GIT
				WEBBROWSER


			}
			USERS () {
				ROOT () {  # (! default)
					echo "${bold}enter new root password${normal}"
					until passwd
					do
					  echo "${bold}enter new root password${normal}"
					done
				}
				ADMIN () {  # (!NOTE: default) - ok 
					ADD_GROUPS () {
					  # for group user sets in var do groupadd -- changeme
						groupadd plugdev
						groupadd power
						groupadd adm
						groupadd audio
					}
					ADD_USER () {
						ASK_PASSWD () {
							echo "${bold}enter new $SYSUSERNAME password${normal}"
							until passwd $SYSUSERNAME
							do
							  echo "${bold}enter new $SYSUSERNAME password${normal}"
							done
						}
						useradd -m -g users -G $USERGROUPS -s /bin/bash $SYSUSERNAME
						ASK_PASSWD
					}
					VIRTADMIN () {
						groupadd vboxguest
						gpasswd -a $SYSUSERNAME vboxguest
					}
					ADD_GROUPS
					ADD_USER
					VIRTADMIN
				}
				ROOT
				ADMIN
			} 
			FINISH () {  # tidy up installation files - ok
			
				rm -f /stage3-*.tar.*
				echo "${bold}Script finished all operations - END${normal}"
			
			} 
			## (RUN ENTIRE SCRIPT) (!changeme)

BASE
#CORE
#SCREENDSP
#USERAPP
#USERS
#FINISH
echo "end chroot"
INNERSCRIPT
)

	# since the chroot script cant be run outside of chroot the script and possibly sourced functions and variables scripts need to be copied accordingly.
	# for the onefile setup this is simply done by echoing the 'INNERSCRIPT" ... if the setup is split in multiple files for readability, every file or alt the gentoo script repo needs to be copied to make all functions and variables available.
	# only variables outside the chroot innerscript for now 27.8.22
	# IMPORTANT blow commands are executed BEFORE the above INNERSCRIPT! (BELOW chroot $CHROOTX /bin/bash ./chroot_run.sh). if a file needs to be made available in the INNERSCRIPT, copy it before ( chroot $CHROOTX /bin/bash ./chroot_run.sh ) below in this CHROOT function!!!

	# cp src/chroot_main.sh $CHROOTX/chroot.sh # old kept as sample
	#mkdir $CHROOTX/gentoo_unattented_setup_chroot
	cp var/chroot_variables.sh $CHROOTX/chroot_variables.sh # sourced on top of the INNERSCRIPT
	cp configs/required/kern.config.sh $CHROOTX/kern.config # linux kernel config! this could also be pasted in the INNERSCRIPT above but for readability this should be outside, else this file is bblow up for xxxxx lines.
	cp configs/default/.bashrc.sh $CHROOTX/.bashrc.sh
	# cp -R configs/default $CHROOTX/configs/default  # old kept as sample
	# cp -R configs/optional $CHROOTX/configs/optional # old kept as sample
	# cp -R func $CHROOTX/func  # old kept as sample

	echo "$INNER_SCRIPT" > $CHROOTX/chroot_run.sh
	chmod +x $CHROOTX/chroot_run.sh
	chroot $CHROOTX /bin/bash ./chroot_run.sh
}

DEBUG () { 
	rc update -v show
}

####  RUN ALL ## (!changeme)
#PRE # TESTING 26_8_22
CHROOT

#DEBUG
