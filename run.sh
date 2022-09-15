#!/bin/bash

# current work branch. at this point the repo is transitioning from singlefile to multifile setup .. not sure to keep both.. anyways this is the latest setup now 27.8.22
# github.com/alphaaurigae/gentoo_unattended_modular-setup.sh

#########################################################################################################################################################################################################################################################################################################################################################################
# VARIABLE && FUNCTONS (options) ##unfinished
#. configs/required/default-testing/1_PRE.sh
. func/func_main.sh
. var/var_main.sh
. var/1_PRE_main.sh
# for f in func/pre/*; do . $f && echo $f; done  # copy off multifile ahead

PRE () {  # PREPARE CHROOT
NOTICE_START
	INIT () {  # (!NOTE:: in this section the script starts off with everything that has to be done prior to the setup action.)
	NOTICE_START
		ntpd -q -g   # TIME ... update the system time ... (!important) # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Setting_the_date_and_time
	NOTICE_END
	}
	PARTITIONING () {
	NOTICE_START
		PARTED () {  # LVM on LUKS https://wiki.archlinux.org/index.php/GNU_Parted
		NOTICE_START
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
		NOTICE_END
		}
		PTABLES () {
		NOTICE_START
			partx -u $HDD1
			partprobe $HDD1
		NOTICE_STOP
		}
		MAKEFS_BOOT () {
		NOTICE_START
			mkfs.$FILESYSTEM_BOOT $BOOT_PART
		NOTICE_STOP
		}
		PARTED
		PTABLES
		MAKEFS_BOOT
	NOTICE_END
	}
	#  (!NOTE: lvm on luks "CRYPT --> BOOT/LVM2 --> OS" ... 
	#  (!NOTE: for the main disk $MAIN_PART - you will be prompted for passohrase)
	CRYPTSETUP () {  # https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS && https://blog.stigok.com/2018/05/03/lvm-in-luks-with-encrypted-boot-partition-and-suspend-to-disk.html
	NOTICE_START
		IF_CRYPSETUP () {
		NOTICE_START
			RUN_CRYPTSETUP () {
			NOTICE_START
				lsmod
				modprobe -a dm-mod dm-crypt sha256 aes aes_generic xts  # load kernel modules for the chroot install process, for luks we def need the dm-crypt ...
				lsmod			
				echo "${bold}enter the $PV_MAIN password${normal}"
				cryptsetup -v luksFormat --type luks2 $MAIN_PART --debug
				cryptsetup open $MAIN_PART $PV_MAIN
			NOTICE_END
			}
			if [ $CRYPTSETUP = "YES" ]; then
				echo "bingo"
				RUN_CRYPTSETUP
			else
				echo "cryptsetup not set to YES ."
			fi
		NOTICE_END
		}
		IF_CRYPSETUP
	NOTICE_END
	}
	LVMSETUP () {
		#  LVM = "PV (Physical volume)-> VG (Volume group) > LV (Logical volume) inside of the luks crypt container ...             
		LVMONLUKS () {
		NOTICE_START
			LVM_PV () {
			NOTICE_START
				pvcreate /dev/mapper/$PV_MAIN
				pvdisplay
			NOTICE_END
			}
			LVM_VG () {
			NOTICE_START
				vgcreate $VG_MAIN /dev/mapper/$PV_MAIN
				vgdisplay
			NOTICE_END
			}
			LVM_LV () {
			NOTICE_START
				# lvcreate -L $SWAP_SIZE -n $SWAP0 $VG_MAIN
				lvcreate -l 98%FREE -n $LV_MAIN $VG_MAIN
				lvdisplay
			NOTICE_END
			}
			MAKEFS_LVM () {
			NOTICE_START
				mkfs.ext4 /dev/$VG_MAIN/$LV_MAIN
				# mkswap /dev/$VG_MAIN/$SWAP0 # swap ...
			NOTICE_END
			}
			MOUNT_LVM_LV () {  # (!NOTE: mount the LVM for CHROOT.)
			NOTICE_START
				mkdir -p $CHROOTX
				mount /dev/mapper/$VG_MAIN-$LV_MAIN $CHROOTX
				# swapon /dev/$VG_MAIN/$SWAP0
				mkdir $CHROOTX/boot
				mount $BOOT_PART $CHROOTX/boot
			NOTICE_END
			}
			LVM_PV
			LVM_VG
			LVM_LV
			MAKEFS_LVM
			MOUNT_LVM_LV
		NOTICE_END
		}
		LVM_ROOT () {
		NOTICE_START
			LVM_PV () {
			NOTICE_START
				pvcreate $MAIN_PART
				pvdisplay
			NOTICE_END
			}
			LVM_VG () {
			NOTICE_START
				vgcreate $VG_MAIN $MAIN_PART
				vgdisplay
			NOTICE_END
			}
			LVM_LV () {
			NOTICE_START
				# lvcreate -L $SWAP_SIZE -n $SWAP0 $VG_MAIN
				lvcreate -l 98%FREE -n $LV_MAIN $VG_MAIN
				lvdisplay
			NOTICE_END
			}
			MAKEFS_LVM () {
			NOTICE_START
				mkfs.ext4 /dev/$VG_MAIN/$LV_MAIN
				# mkswap /dev/$VG_MAIN/$SWAP0 # swap ...
			NOTICE_END
			}
			MOUNT_LVM_LV () {  # (!NOTE: mount the LVM for CHROOT.)
			NOTICE_START
				mkdir -p $CHROOTX
				mount /dev/mapper/$VG_MAIN-$LV_MAIN $CHROOTX
				# swapon /dev/$VG_MAIN/$SWAP0
				mkdir $CHROOTX/boot
				mount $BOOT_PART $CHROOTX/boot
			NOTICE_END
			}
			modprobe -a dm-mod
			lvmdiskscan
			LVM_PV
			LVM_VG
			LVM_LV
			MAKEFS_LVM
			MOUNT_LVM_LV
		NOTICE_END
		}
		RUN_LVMSET () {
		NOTICE_START
			if [ $CRYPTSETUP = "YES" ]; then
				echo "LVMONLUKS"
				LVMONLUKS
			else
				echo "LVM_ROOT"
				LVM_ROOT
			fi
		NOTICE_END
		}
	RUN_LVMSET
	NOTICE_END
	}
	# STAGE3 TARBALL - HTTPS:// ?
	STAGE3 () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Choosing_a_stage_tarball && # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Unpacking_the_stage_tarball
	NOTICE_START
		STAGE3_FETCH () {
		NOTICE_START
			SET_VAR_STAGE3_FETCH (){
			NOTICE_START
				STAGE3_FILEPATH="$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/$STAGE3DEFAULT.txt | sed '/^#/ d' | awk '{print $1}' | sed -r 's/\.tar\.xz//g' )"
				#echo $STAGE3_FILEPATH
				LIST="$STAGE3_FILEPATH.tar.xz
				$STAGE3_FILEPATH.tar.xz.CONTENTS.gz
				$STAGE3_FILEPATH.tar.xz.DIGESTS
				$STAGE3_FILEPATH.tar.xz.asc"
			NOTICE_END
			}
			FETCH_STAGE3_FETCH () {
			NOTICE_START
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
			NOTICE_END
			}
			SET_VAR_STAGE3_FETCH
			FETCH_STAGE3_FETCH
		NOTICE_END
		}
		STAGE3_VERIFY () {
		NOTICE_START
			SET_VAR_STAGE3_VERIFY (){
			NOTICE_START
				STAGE3_FILENAME="$(cd $CHROOTX/ && ls stage3-* | awk '{ print $1 }' | awk 'FNR == 1 {print}' | sed -r 's/\.tar\.xz//g' )"  # | rev | cut -d'/' -f-1 | rev
				echo "$STAGE3_FILENAME"
			NOTICE_END
			}
			RECEIVE_GPGKEYS () {  # which key is actually needed? for i in
			NOTICE_START
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
			NOTICE_END
			}
			VERIFY_UNPACK () {
			NOTICE_START
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
			NOTICE_END
			}
			SET_VAR_STAGE3_VERIFY
			RECEIVE_GPGKEYS
			VERIFY_UNPACK
		NOTICE_END
		}
		STAGE3_FETCH
		STAGE3_VERIFY
	NOTICE_END
	}
	MNTFS () {
	NOTICE_START
		MOUNT_BASESYS () {  # (!important) # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Mounting_the_necessary_filesystems
		NOTICE_START
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
		NOTICE_END
		}	 
		SETMODE_DEVSHM () {
		NOTICE_START
			chmod 1777 /dev/shm  # (!todo) (note: Chmod 1777 (chmod a+rwx,ug+s,+t,u-s,g-s) sets permissions so that, (U)ser / owner can read, can write and can execute. (G)roup can read, can write and can execute. (O)thers can read, can write and can execute)
		NOTICE_END
		}
		MOUNT_BASESYS
		SETMODE_DEVSHM
	NOTICE_END
	}
	COPY_CONFIGS () {
	NOTICE_START
		EBUILD () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Gentoo_ebuild_repository
		NOTICE_START
			mkdir --parents $CHROOTX/etc/portage/repos.conf
			cp $CHROOTX/usr/share/portage/config/repos.conf $CHROOTX/etc/portage/repos.conf/gentoo.conf  # copy the Gentoo repository configuration file provided by Portage to the (newly created) repos.conf directory.
			# cat $CHROOTX/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
		NOTICE_END
		}                                      
		RESOLVCONF () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Copy_DNS_info
		NOTICE_START
			cp --dereference /etc/resolv.conf $CHROOTX/etc/
		NOTICE_END
		}
		EBUILD
		RESOLVCONF
	NOTICE_END
	}
	INIT   
	PARTITIONING
	CRYPTSETUP
	LVMSETUP
	STAGE3
	MNTFS
	COPY_CONFIGS
NOTICE_END
	# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}
CHROOT () {	# 4.0 CHROOT # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment
NOTICE_START
	INNER_SCRIPT=$(cat << 'INNERSCRIPT'
	# https://github.com/alphaaurigae/gentoo_unattented-setup

	#!/bin/bash
	# CHROOT START >>> alphaaurigae/gentoo_unattented-setup | https://github.com/alphaaurigae/gentoo_unattented-setup
	. /func_main.sh
	. /func_chroot_main.sh
	. /var_main.sh
	. /chroot_variables.sh
	#. /kern.config.sh
	#. func/chroot_static-functions.sh

			BASE () {
			NOTICE_START
				SWAPFILE () {
				NOTICE_START
					DEBUG_SWAPFILE () {
					NOTICE_START
						swapon -s
						ls -lh $SWAPFD/$SWAPFILE_$SWAPSIZE
					NOTICE_END
					}
					CREATE_FILE () {
					NOTICE_START
						mkdir -p $SWAPFD
						fallocate -l $SWAPSIZE $SWAPFD/$SWAPFILE_$SWAPSIZE
						chmod 600 $SWAPFD/$SWAPFILE_$SWAPSIZE
						mkswap $SWAPFD/$SWAPFILE_$SWAPSIZE
					NOTICE_END
					}
					CREATE_SWAP () {
					NOTICE_START
						swapon  $SWAPFD/$SWAPFILE_$SWAPSIZE
					NOTICE_END
					}
					PERMANENT_SWAP () {
					NOTICE_START
						echo "$SWAPFD/$SWAPFILE_SWAPSIZE none swap sw 0 0" >> /etc/fstab
						cat /etc/fstab
					NOTICE_END
					}
					CREATE_FILE
					# DEBUG_SWAPFILE
					CREATE_SWAP
					# DEBUG_SWAPFILE
					# PERMANENT_SWAP
				NOTICE_END
				}
				MAKECONF () {  # /etc/portage/make.conf # https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/USE
				NOTICE_START
					MAKECONF_VARIABLES () {
					NOTICE_START
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
						USE="PLACEHOLDER_USEFLAGS"
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
						
						if [ $SYSAPP_DMCRYPT = "YES" ]; then
							echo "SYSAPP_DMCRYPT=YES"
							sed -ie "s/PLACEHOLDER_USEFLAGS/$PRESET_USEFLAG_CRYPTOPTANDCRYPTSETUP/g" /etc/portage/make.conf
						else
							echo "SYSAPP_DMCRYPT=NO"
							sed -ie "s/PLACEHOLDER_USEFLAGS/$PRESET_USEFLAG_LVMROOTNOCRYPOPT/g" /etc/portage/make.conf
						fi
					NOTICE_END
					}

					MAKECONF_VARIABLES
					EMERGE_ATWORLD_B
				NOTICE_END
				}
				CONF_LOCALES () {  # https://wiki.gentoo.org/wiki/Localization/Guide
					CONF_LOCALEGEN () {
					NOTICE_START
						cat << EOF > /etc/locale.gen
						$PRESET_LOCALE_A ISO-8859-1
						$PRESET_LOCALE_A.UTF-8 UTF-8
						$PRESET_LOCALE_B ISO-8859-1
						$PRESET_LOCALE_B.UTF-8 UTF-8
EOF
					NOTICE_END
					}
					GEN_LOCALE () {
					NOTICE_START
						locale-gen
					NOTICE_END
					}
					SYS_LOCALE () {  # (!todo)
					NOTICE_START
						SYSLOCALE="$PRESET_LOCALE_A.UTF-8"
						SYSTEMLOCALE_OPENRC () {  # https://wiki.gentoo.org/wiki/Localization/Guide#OpenRC
							cat << EOF > /etc/env.d/02locale
							LANG="$SYSLOCALE"
							LC_COLLATE="C" # Define alphabetical ordering of strings. This affects e.g. output of sorted directory listings.
							# LC_CTYPE=$PRESET_LOCALE_A.UTF-8 # (!NOTE: not tested yet)
EOF
						NOTICE_END
						}
						SYSTEMLOCALE_SYSTEMD () {  # https://wiki.gentoo.org/wiki/Localization/Guide#systemd
							localectl set-locale LANG=$SYSLOCALE
							localectl | grep "System Locale"
						NOTICE_END
						}
						SYSTEMLOCALE_$SYSINITVAR
					NOTICE_END
					}
					CONF_LOCALEGEN
					GEN_LOCALE
					SYS_LOCALE
				NOTICE_END
				}

				ESELECT_PROFILE () {
				NOTICE_START
					eselect profile set $ESELECT_PROFILE
				NOTICE_END
				}
				SETFLAGS1 () {  # set custom flags (!NOTE: disabled by default) (!NOTE; was systemd specific, systemd not compete yet 05.11.2020)
				NOTICE_START
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
				NOTICE_END
				}
				PORTAGE () {  # https://wiki.gentoo.org/wiki/Portage#emerge-webrsync # https://dev.gentoo.org/~zmedico/portage/doc/man/emerge.1.html
				NOTICE_START
					mkdir /usr/portage
					emerge-webrsync
				NOTICE_END
				}
				EMERGE_SYNC () {
				NOTICE_START
					emerge --sync
				NOTICE_END
				}
				MISC1_CHROOT () {
					MISC1CHROOT_OPENRC () {
					NOTICE_START
						NOTICE_PLACEHOLDER
					NOTICE_END
					}
					MISC1CHROOT_SYSTEMD () {
					NOTICE_START
						systemctl preset-all
						systemctl daemon-reload
						ENVUD
					NOTICE_END
					}
					MISC1CHROOT_$SYSINITVAR
				NOTICE_END
				}
				RELOADING_SYS () {
				NOTICE_START
					RELOAD_OPENRC () {
						NOTICE_PLACEHOLDER
					}
					RELOAD_SYSTEMD () {
					NOTICE_START
						systemctl preset-all
						systemctl daemon-reload
						ENVUD
					NOTICE_END
					}
					RELOAD_$SYSINITVAR
				NOTICE_END
				}
				SYSTEMTIME () {  # https://wiki.gentoo.org/wiki/System_time
				NOTICE_START
					SET_TIMEZONE () {
					NOTICE_START
						echo $SYSTIMEZONE_SET > /etc/timezone
						TIMEZONE_OPENRC () {
						NOTICE_START
							echo "$SYSTIMEZONE_SET" > /etc/timezone
							APPAPP_EMERGE=" --config sys-libs/timezone-data "
							EMERGE_USERAPP_DEF
						NOTICE_END
						}
						TIMEZONE_SYSTEMD () {
						NOTICE_START
							timedatectl set-timezone $SYSTIMEZONE_SET
						NOTICE_END
						}
						TIMEZONE_$SYSINITVAR
					NOTICE_END
					}
					SET_SYSTEMCLOCK () {  # https://wiki.gentoo.org/wiki/System_time#System_clock
					NOTICE_START
						SYSTEMCLOCK_OPENRC () {
						NOTICE_START
							OPENRC_SYSCLOCK_MANUAL () {
							NOTICE_START
								OPENRC_SYSTEMCLOCK () {
								NOTICE_START
									date $SYSDATE_MAN
								NOTICE_END
								}
								OPENRC_SYSTEMCLOCK
							NOTICE_END
							}
							OPENRC_OPENNTPD () {
								APPAPP_EMERGE="net-misc/openntpd"
								SYSSTART_OPENNTPD () {
									AUTOSTART_NAME_OPENRC="ntpd"
									AUTOSTART_DEFAULT_OPENRC
								NOTICE_END
								}
								EMERGE_USERAPP_DEF
								SYSSTART_OPENNTPD
							NOTICE_END
							}
							# OPENRC_SYSCLOCK_MANUAL  # (!changeme: only 1 can be set)
							OPENRC_OPENNTPD
						NOTICE_END
						}
						SYSTEMCLOCK_SYSTEMD () {  # https://wiki.gentoo.org/wiki/System_time#Hardware_clock
						NOTICE_START
							SYSTEMD_SYSCLOCK_MANUAL () {
							NOTICE_START
								timedatectl set-time "$SYSCLOCK_MAN"
							NOTICE_END
							}
							SYSTEMD_SYSCLOCK_AUTO () {
							NOTICE_START
								SYSSTART_TIMESYND () {
								NOTICE_START
									AUTOSTART_NAME_SYSTEMD="systemd-timesyncd"
									AUTOSTART_DEFAULT_SYSTEMD
									# timedatectl set-local-rtc 0 # 0 set UTC
								NOTICE_END
								}
								SYSSTART_TIMESYND
							NOTICE_END
							}
							SYSTEMD_SYSCLOCK_$SYSCLOCK_SET
						NOTICE_END
						}
						SYSTEMCLOCK_$SYSINITVAR
					NOTICE_END
					}
					SET_HWCLOCK () {
					NOTICE_START
						hwclock --systohc
					NOTICE_END
					}
					SET_TIMEZONE  # echos err for systemd if install medium isnt systemd
					SET_SYSTEMCLOCK  # echos err for systemd, if install medium isnt systemd
					SET_HWCLOCK
				NOTICE_END
				}
				KEYMAP_CONSOLEFONT () {  # https://wiki.gentoo.org/wiki/Keyboard_layout_switching  ## (note:: theres a second place where keymaps are set, which is:"X11 KEYS SET = WINDOWSYS --> X11")
				NOTICE_START
					KEYMAP_CONSOLEFONT_OPENRC () {
					NOTICE_START
						KEYMAP_OPENRC () { # (!changeme in var)
						NOTICE_START
							AUTOSTART_NAME_OPENRC="keymaps"
							sed -ie 's/keymap="us"/keymap="$KEYMAP"/g' /etc/conf.d/keymaps
							sed -ie 's/keymap="de"/keymap="$KEYMAP"/g' /etc/conf.d/keymaps
							sed -ie "s/\$KEYMAP/$KEYMAP/g" /etc/conf.d/keymaps
							AUTOSTART_BOOT_OPENRC
							rc-update add keymaps boot
						NOTICE_END
						}
						CONSOLEFONT_OPENRC () {
						NOTICE_START
							AUTOSTART_NAME_OPENRC="consolefont"
							sed -ie 's/consolefont="default8x16"/consolefont="$CONSOLEFONT"/g' /etc/conf.d/consolefont
							sed -ie "s/\$CONSOLEFONT/$CONSOLEFONT/g" /etc/conf.d/consolefont  # note: consolefont file also contains "conoletranslation=" ;  "unicodemap=" - not set here - disabled by default.
							AUTOSTART_BOOT_OPENRC
						NOTICE_END
						}
						etc-update --automode -3
						KEYMAP_OPENRC
						CONSOLEFONT_OPENRC
					NOTICE_END
					}
					KEYMAP_CONSOLEFONT_SYSTEMD () {   # https://wiki.archlinux.org/index.php/Keyboard_configuration_in_console
					NOTICE_START
						AUTOSTART_NAME_SYSTEMD="placeholder"
						VCONSOLE_KEYMAP=$KEYMAP-latin1 # (!changeme) console keymap systemd
						VCONSOLE_FONT="$CONSOLEFONT" # (!changeme)
						cat << EOF > /etc/vconsole.conf
						KEYMAP=$VCONSOLE_KEYMAP
						FONT=$VCONSOLE_FONT
EOF
					NOTICE_END
					}
					ENVUD
					KEYMAP_CONSOLEFONT_$SYSINITVAR
				NOTICE_END
				}
				FIRMWARE () {
				NOTICE_START
					LINUX_FIRMWARE () {  # https://wiki.gentoo.org/wiki/Linux_firmware
					NOTICE_START
						APPAPP_EMERGE="sys-kernel/linux-firmware "
						PACKAGE_USE				
						LICENSE_SET
						EMERGE_ATWORLD_A
						EMERGE_USERAPP_DEF
						etc-update --automode -3  # (automode -3 = merge all)
					NOTICE_END
					}
					LINUX_FIRMWARE
				NOTICE_END
				}
				CP_BASHRC () {  # (!NOTE: custom .bashrc) (!changeme)
				NOTICE_START
					cp /.bashrc.sh /etc/skel/.bashrc
				NOTICE_END
				}
				#SWAPFILE
				#df -h
				#cat /etc/portage/make.conf
				#MAKECONF
				#cat /etc/portage/make.conf
				#CONF_LOCALES
				#PORTAGE
				#EMERGE_SYNC
				#eselect profile list
				#ESELECT_PROFILE
				# SETFLAGS1  # PLACEHOLDER
				#EMERGE_ATWORLD_A
				##MISC1_CHROOT  # PLACEHOLDER
				##RELOADING_SYS  # PLACEHOLDER
				SYSTEMTIME
				KEYMAP_CONSOLEFONT
				FIRMWARE
				CP_BASHRC
				cat /etc/skel/.bashrc
				# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			}
			CORE () {
			NOTICE_START
				SYSCONFIG_CORE () {
				NOTICE_START
					FSTAB () {  # https://wiki.gentoo.org/wiki/Fstab
					NOTICE_START
						FSTAB_LVMONLUKS_BIOS () {  # (!default)
						NOTICE_START
							cat << EOF > /etc/fstab
							# ROOT MAIN FS
							/dev/mapper/$VG_MAIN-$LV_MAIN	/	$FILESYSTEM_MAIN	errors=remount-ro	0 1
							# BOOT
							UUID="$(blkid -o value -s UUID $BOOT_PART)"	/boot	$FILESYSTEM_BOOT	rw,relatime	0 2
EOF
						NOTICE_END
						} 
						FSTAB_LVMONLUKS_UEFI () {
						NOTICE_START
							cat << EOF > /etc/fstab
							# ROOT MAIN FS
							/dev/mapper/$VG_MAIN-$LV_MAIN	/	$FILESYSTEM_MAIN	errors=remount-ro	0 1
							# BOOT
							UUID="$(blkid -o value -s UUID $BOOT_PART)"	/boot	$FILESYSTEM_BOOT	rw,relatime	0 2
EOF
						NOTICE_END
						}
						FSTAB_LVMONLUKS_$BOOTSYSINITVAR
					NOTICE_END
					}
					CRYPTTABD () {
					NOTICE_START
						cat << EOF > /etc/crypttab
							# crypt-container
							$PV_MAIN UUID=$(blkid -o value -s UUID $MAIN_PART) none luks,discard
EOF
					NOTICE_END
					}
					FSTAB
					cat /etc/fstab  # debug  # pass 09.09.22 no err output
					# CRYPTTABD
				NOTICE_END
				}
				SYSFS () {
				NOTICE_START
					SYSFS_DMCRYPT () {  # https://wiki.gentoo.org/wiki/Dm-crypt
					NOTICE_START
						APPAPP_EMERGE="sys-fs/cryptsetup "
						AUTOSTART_NAME_OPENRC="dmcrypt"
						AUTOSTART_NAME_SYSTEMD="systemd-cryptsetup"
						PACKAGE_USE
						ACC_KEYWORDS_USERAPP
						EMERGE_ATWORLD_A
						EMERGE_USERAPP_DEF
						etc-update --automode -3  # (automode -3 = merge all)
						AUTOSTART_BOOT_$SYSINITVAR
					NOTICE_END
					}
					SYSFS_LVM2 () {  # https://wiki.gentoo.org/wiki/LVM/de
					NOTICE_START
						APPAPP_EMERGE="sys-fs/lvm2"
						AUTOSTART_NAME_OPENRC="lvm"  # (!important: "lvm" instead of "lvm2" as label)
						AUTOSTART_NAME_SYSTEMD="$APPAPP_NAME_SIMPLE-monitor"
						CONFIG_LVM2 () {
						NOTICE_START
							sed -e 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf > /tmp/lvm.conf
							mv /tmp/lvm.conf /etc/lvm/lvm.conf
						NOTICE_END
						}
						EMERGE_USERAPP_DEF
						AUTOSTART_BOOT_$SYSINITVAR
						CONFIG_LVM2
					NOTICE_END
					}
					SYSAPP_MULTIPATH () {  # https://wiki.gentoo.org/wiki/Multipath
					NOTICE_START
						APPAPP_EMERGE="sys-fs/multipath-tools "
						EMERGE_USERAPP_DEF
					NOTICE_END
					}
					SYSFS_FSTOOLS () {  # (! e2fsprogs # Ext2, 3, and 4) # optional, add to variables at time.
					NOTICE_START
						## (note!: this is a little workaround to make sure FS support is installed.  This is missing a routine to avoid double emerges as of 16 01 2021)
						## FSTOOLS
						FST_EMERGE_EXT=sys-fs/e2fsprogs
						FST_EMERGE_XFS=sys-fs/xfsprogs
						FST_EMERGE_REISER=sys-fs/reiserfsprogs
						FST_EMERGE_JFS=sys-fs/jfsutils
						FST_EMERGE_VFAT=sys-fs/dosfstools # (FAT32, ...) 
						FST_EMERGE_BTRFS=sys-fs/btrfs-progs
						MAIN () {
						NOTICE_START
							ALL_YES_FSTOOLS () {
							NOTICE_START
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
							NOTICE_END
							}
							FILTER_YES () {
							NOTICE_START
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
							NOTICE_END
							}
							ALL_YES_FSTOOLS
							FILTER_YES
						NOTICE_END
						}
						MAIN
					NOTICE_END
					}
					SYSFS_DMCRYPT
					SYSFS_LVM2
					SYSAPP_MULTIPATH
					SYSFS_FSTOOLS
				NOTICE_END
				}
				APPADMIN () {
				NOTICE_START
					SUDO () {  # https://wiki.gentoo.org/wiki/Sudo
					NOTICE_START
						APPAPP_EMERGE="app-admin/sudo "  # (note!: must keep trailing)
						CONFIG_SUDO () {
						NOTICE_START
							cp /etc/sudoers /etc/sudoers_bak
							sed -ie 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
						NOTICE_END
						}
						EMERGE_USERAPP_DEF
						CONFIG_SUDO
					NOTICE_END
					}
					SYSLOG () {
					NOTICE_START
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
						NOTICE_START
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
						NOTICE_END
						}
						SETVAR_SYSLOG
						APPAPP_EMERGE="$SYSLOG_EMERGE "
						EMERGE_USERAPP_DEF
						# SYSLOG_$SYSINITVAR  # (note!: autostart TODO)
						LOGROTATE () {
						NOTICE_START
							APPAPP_EMERGE="app-admin/logrotate "
							CONFIG_LOGROTATE_OPENRC () {
							NOTICE_START
								NOTICE_PLACEHOLDER
							NOTICE_END
							}
							CONFIG_LOGROTATE_SYSTEMD () {
							NOTICE_START
								systemd-tmpfiles --create /usr/lib/tmpfiles.d/logrotate.conf
							NOTICE_END
							}
							EMERGE_USERAPP_DEF
							CONFIG_LOGROTATE_$SYSINITVAR
						NOTICE_END
						}
						LOGROTATE
					NOTICE_END
					}
					SUDO
					SYSLOG
				NOTICE_END
				}
				SYSAPP () {
				NOTICE_START
					SYSAPPS_PCIUTILS () {
					NOTICE_START
						APPAPP_EMERGE="sys-apps/pciutils "
						EMERGE_USERAPP_DEF
					NOTICE_END
					}
					SYSAPPS_FILEINDEXING () {
					NOTICE_START
						APPAPP_EMERGE="sys-apps/mlocate "
						EMERGE_USERAPP_DEF
					NOTICE_END
					}
					SYSAPPS_PCIUTILS
					SYSAPPS_FILEINDEXING
				NOTICE_END
				}
				APP () {
				NOTICE_START
					APP_CRYPT () {
					NOTICE_START
						SYSAPP_GNUPG () {
						NOTICE_START
							# SETVAR_GNUPG
							APPAPP_EMERGE="app/crypt/gnupg "
							EMERGE_USERAPP_DEF
							gpg --full-gen-key
						NOTICE_END
						}
						SYSAPP_GNUPG
					NOTICE_END
					}
					APP_CRYPT
				NOTICE_END
				}
				SYSPROCESS () {
				NOTICE_START
					CRON () {
					NOTICE_START
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
						NOTICE_START
							for i in $CRON
							do
								CRON_SYSTEMD=$i\_CRON_SYSTEMD
								CRON_OPENRC=$i\_CRON_OPENRC
								CRON_EMERGE=$i\_CRON_EMERGE
							done
						NOTICE_END
						}
						CONFIG_CRON () {
						NOTICE_START
							crontab /etc/crontab
						NOTICE_END
						}
						SETVAR_CRON
						APPAPP_EMERGE="${!CRON_EMERGE}"
						AUTOSTART_NAME_OPENRC="${!CRON_OPENRC}"
						AUTOSTART_NAME_OPENRC="${!CRON_SYSTEMD}"
						echo $APPAPP_EMERGE
						EMERGE_USERAPP_DEF
						CONFIG_CRON
						AUTOSTART_DEFAULT_$SYSINITVAR
					NOTICE_END
					}
					TOP () {
					NOTICE_START
						HTOP () {
						NOTICE_START
							APPAPP_EMERGE="sys-process/htop "
							EMERGE_USERAPP_DEF
						NOTICE_END
						}
						IOTOP () {
						NOTICE_START
							APPAPP_EMERGE="sys-process/iotop "
							EMERGE_USERAPP_DEF
						NOTICE_END
						}
						HTOP
						IOTOP
					NOTICE_END
					}
					CRON
					TOP
				NOTICE_END
				}
###################################################################################################################################################################
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
									echo "ignore err"
									touch /usr/src/linux/.config
									cp /kern.config /usr/src/linux/.config  # stripped version infos for refetch # ls function to get the dirname quick - probably not the best hack but want to get done here now.
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
								DRACUT_USERMOUNTCONF () {
								NOTICE_START
									cat << EOF > /etc/dracut.conf.d/usrmount.conf
									add_dracutmodules+="$DRACUT_CONFD_ADD_DRACUT_MODULES"  # Dracut modules to add to the default
EOF
									cat /etc/dracut.conf.d/usrmount.conf
								NOTICE_END
								}
								DRACUT_DRACUTCONF () {
								NOTICE_START
									if [ $CRYPTSETUP = "YES" ]; then
										echo "bingo"
										cat << EOF > /etc/dracut.conf

										#i18n_install_all="yes"
										i18n_vars="/etc/conf.d/keymaps:keymap-KEYMAP,extended_keymaps-EXT_KEYMAPS /etc/conf.d/consolefont:consolefont-FONT,consoletranslation-FONT_MAP /etc/rc.conf:unicode-UNICODE"

										hostonly="$DRACUT_CONF_HOSTONLY"
										lvmconf="$DRACUT_CONF_LVMCONF"
										dracutmodules+="$DRACUT_CONF_MODULES_CRYPTSETUP"
EOF
										cat /etc/dracut.conf
									else
										cat << EOF > /etc/dracut.conf

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
								DRACUT_USERMOUNTCONF
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
				MODPROBE_CHROOT () {
				NOTICE_START
					modprobe -a dm-mod dm-crypt sha256 aes aes_generic xts
				NOTICE_END
				}
				SYSBOOT () {
				NOTICE_START
					SYSBOOT_OSPROBER () {
					NOTICE_START
						APPAPP_EMERGE="sys-boot/os-prober "
						EMERGE_USERAPP_DEF
					NOTICE_END
					}
					BOOTLOAD () {  # BOOTSYSINITVAR=BIOS/UEFI
					NOTICE_START
						SETUP_GRUB2 () {  # (!NOTE:  https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt)
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
										sed -ie '/GRUB_PLATFORMS=/d' /etc/portage/make.conf
										echo 'GRUB_PLATFORMS="pc"' >> /etc/portage/make.conf
										EMERGE_ATWORLD_A
									NOTICE_END
									}
									PRE_GRUB2BIOS
									grub-install --recheck --target=i386-pc $HDD1
								NOTICE_END
								}
								GRUB2_UEFI () {
								NOTICE_START
									PRE_GRUB2UEFI () {
									NOTICE_START
										sed -ie '/GRUB_PLATFORMS=/d' /etc/portage/make.conf
										sed -ie '/GRUB_PLATFORMS="efi-64/d' /etc/portage/make.conf
										echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
										EMERGE_ATWORLD_A
									NOTICE_END
									}
									PRE_GRUB2UEFI
									grub-install --target=x86_64-efi --efi-directory=/boot
									## (!NOTE: optional)# mount -o remount,rw /sys/firmware/efi/efivars  # If grub_install returns an error like Could not prepare Boot variable: Read-only file system, it may be necessary to remount the efivars special mount as read-write in order to succeed:
									## (!NOTE: optional)# grub-install --target=x86_64-efi --efi-directory=/boot --removable  # Some motherboard manufacturers seem to only support the /efi/boot/ directory location for the .EFI file in the EFI System Partition (ESP). 
								NOTICE_END
								}
								PRE_GRUB2
								GRUB2_$BOOTSYSINITVAR
							NOTICE_END
							}
							CONFIG_GRUB2 () { # ( !note: config is edited partially after pasting, to be fully integrated in variables. )
							NOTICE_START
								CONFGRUB2_MAIN () {
								NOTICE_START
									etc-update --automode -3
									cp  /configs/default/grub /etc/default/grub
									echo "may ignore complaining cp"
								NOTICE_END
								}
								CONFGRUB_OPENRC () {  # https://wiki.gentoo.org/wiki/GRUB2
								NOTICE_START
									sed -ie '/GRUB_CMDLINE_LINUX=/d' /etc/default/grub
									cat << EOF >> /etc/default/grub
									# If the root file system is contained in a logical volume of a fully encrypted LVM, the device mapper for it will be in the general form of root=/dev/volumegroup/logicalvolume. https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration
									GRUB_CMDLINE_LINUX="raid=noautodetect cryptdevice=PARTUUID=$(blkid -s PARTUUID -o value $MAIN_PART):$PV_MAIN root=UUID=$(blkid -s UUID -o value /dev/$VG_MAIN/$LV_MAIN) rootfstype=ext4 dolvm"
									# (!NOTE: etc/crypttab not required under default openrc, "luks on lvm", GPT, bios - setup) # Warning: If you are using /etc/crypttab or /etc/crypttab.initramfs together with luks.* or rd.luks.* parameters, only those devices specified on the kernel command line will be activated and you will see Not creating device 'devicename' because it was not specified on the kernel command line.. To activate all devices in /etc/crypttab do not specify any luks.* parameters and use rd.luks.*. To activate all devices in /etc/crypttab.initramfs do not specify any luks.* or rd.luks.* parameters.
EOF

									if [ $CRYPTSETUP = "YES" ]; then
										sed -ie '/GRUB_CMDLINE_LINUX=/d' /etc/default/grub
										cat << EOF >> /etc/default/grub
										# If the root file system is contained in a logical volume of a fully encrypted LVM, the device mapper for it will be in the general form of root=/dev/volumegroup/logicalvolume. https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration
										GRUB_CMDLINE_LINUX="raid=noautodetect cryptdevice=PARTUUID=$(blkid -s PARTUUID -o value $MAIN_PART):$PV_MAIN root=UUID=$(blkid -s UUID -o value /dev/$VG_MAIN/$LV_MAIN) rootfstype=ext4 dolvm"
										# (!NOTE: etc/crypttab not required under default openrc, "luks on lvm", GPT, bios - setup) # Warning: If you are using /etc/crypttab or /etc/crypttab.initramfs together with luks.* or rd.luks.* parameters, only those devices specified on the kernel command line will be activated and you will see Not creating device 'devicename' because it was not specified on the kernel command line.. To activate all devices in /etc/crypttab do not specify any luks.* parameters and use rd.luks.*. To activate all devices in /etc/crypttab.initramfs do not specify any luks.* or rd.luks.* parameters.
EOF
									else
										sed -ie '/GRUB_CMDLINE_LINUX=/d' /etc/default/grub
										cat << EOF >> /etc/default/grub
										# If the root file system is contained in a logical volume of a fully encrypted LVM, the device mapper for it will be in the general form of root=/dev/volumegroup/logicalvolume. https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration
										GRUB_CMDLINE_LINUX="raid=noautodetect root=UUID=$(blkid -s UUID -o value /dev/$VG_MAIN/$LV_MAIN) rootfstype=ext4 dolvm"
										# (!NOTE: etc/crypttab not required under default openrc, "luks on lvm", GPT, bios - setup) # Warning: If you are using /etc/crypttab or /etc/crypttab.initramfs together with luks.* or rd.luks.* parameters, only those devices specified on the kernel command line will be activated and you will see Not creating device 'devicename' because it was not specified on the kernel command line.. To activate all devices in /etc/crypttab do not specify any luks.* parameters and use rd.luks.*. To activate all devices in /etc/crypttab.initramfs do not specify any luks.* or rd.luks.* parameters.
EOF
									fi
								NOTICE_END
								}
								CONFGRUB_SYSTEMD () {  # https://wiki.gentoo.org/wiki/GRUB2
								NOTICE_START
									sed -ie '/GRUB_CMDLINE_LINUX=/d' /etc/default/grub
									cat << EOF >> /etc/default/grub
									# If the root file system is contained in a logical volume of a fully encrypted LVM, the device mapper for it will be in the general form of root=/dev/volumegroup/logicalvolume. https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration
									GRUB_CMDLINE_LINUX="rd.luks.name=$(blkid -o value -s UUID $MAIN_PART)=$PV_MAIN root=UUID=$(blkid -s UUID -o value /dev/$VG_MAIN/$LV_MAIN) rootfstype=ext4 dolvm " #real_init=/lib/systemd/systemd
									# rd.luks.name= is honored only by initial RAM disk (initrd) while luks.name= is honored by both the main system and the initrd. https://www.freedesktop.org/software/systemd/man/systemd-cryptsetup-generator.html
EOF
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
							LOAD_GRUB2
							CONFIG_GRUB2
							UPDATE_GRUB2
						NOTICE_END
						}
						SETUP_LILO () {
						NOTICE_START
							APPAPP_EMERGE="sys-boot/lilo "
							CONF_LILO () {  # https://wiki.gentoo.org/wiki/LILO # https://github.com/a2o/lilo/blob/master/sample/lilo.example.conf
							NOTICE_START
								cp /configs/optional/lilo.conf /etc/lilo.conf
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
				APPEMULATION () {
				NOTICE_START
					VIRTUALBOX () {
					NOTICE_START
						SYS_HOST () {
						NOTICE_START
							NOTICE_PLACEHOLDER
						NOTICE_END
						}
						SYS_GUEST () {
						NOTICE_START
							GUE_VIRTUALBOX () {
							NOTICE_START
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
						NOTICE_END
						}
						SYS_$SYSVARD
					NOTICE_END
					}
					VIRTUALBOX
				NOTICE_END				
				}
				AUDIO () {  # (!todo)
				NOTICE_START
					SOUND_API () {
					NOTICE_START
						LIBSNDFILE () {
						NOTICE_START
							USE="minimal" emerge -q media-libs/libsndfile
						NOTICE_END
						}
						ALSA () {  # https://wiki.gentoo.org/wiki/ALSA
						NOTICE_START
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
						NOTICE_END
						}
						LIBSNDFILE
						ALSA
					NOTICE_END
					}
					SOUND_SERVER () {
					NOTICE_START
						JACK () {
						NOTICE_START
							APPAPP_EMERGE="media-sound/jack2 "
							PACKAGE_USE
							EMERGE_USERAPP_DEF
							ENVUD
						NOTICE_END
						}
						PULSEAUDIO () {
						NOTICE_START
							APPAPP_EMERGE="media-sound/pulseaudio "
							PACKAGE_USE
							EMERGE_USERAPP_DEF
							ENVUD
						NOTICE_END
						}
						JACK
						PULSEAUDIO
					NOTICE_END
					}
					SOUND_MIXER () {
					NOTICE_START
						PAVUCONTROL () {
						NOTICE_START
							APPAPP_EMERGE="media-sound/pavucontrol "
							EMERGE_USERAPP_DEF
						NOTICE_END
						}
						PAVUCONTROL
					NOTICE_END
					}
					SOUND_API
					SOUND_SERVER
					SOUND_MIXER
				NOTICE_END
				}
			#	GPU () {  # (!todo)
			#	NOTICE_START
			#		SET_NONE () {
			#		NOTICE_START
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
				NETWORK () {  # (!todo)
				NOTICE_START
					NET_SYS () {
					NOTICE_START
						HOSTSFILE () {  # (! default)
							echo "$HOSTNAME" > /etc/hostname
							echo "127.0.0.1	localhost
							::1		localhost
							127.0.1.1	$HOSTNAME.$DOMAIN	$HOSTNAME" > /etc/hosts
							cat /etc/hosts
						}
						HOSTSFILE
					}
					NET_MGMT () {
					NOTICE_START
						GENTOO_DEFAULT () {
						NOTICE_START
							NETIFRC () {  # (! default)
							NOTICE_START
								APPAPP_EMERGE="net-misc/netifrc "
								VAR_EMERGE=" --noreplace net-misc/netifrc " 
								AUTOSTART_NAME_OPENRC="net.$NETIFACE_MAIN "
								AUTOSTART_NAME_SYSTEMD="net@$NETIFACE_MAIN"
								CONF_NETIFRC () {
								NOTICE_START
									cat << EOF > /etc/conf.d/net  # Please read /usr/share/doc/netifrc-*/net.example.bz2 for a list of all available options. DHCP client man page if specific DHCP options need to be set.
									config_$NETIFACE_MAIN="dhcp"
EOF
									cat /etc/conf.d/net
								NOTICE_END
								}
								EMERGE_USERAPP_DEF
								CONF_NETIFRC
								AUTOSTART_DEFAULT_$SYSINITVAR
							NOTICE_END
							}
							NETIFRC
						NOTICE_END
						}
						OPENRC_DEFAULT () {
						NOTICE_START
							NOTICE_PLACEHOLDER
						NOTICE_END
						}
						SYSTEMD_DEFAULT () {
						NOTICE_START
							NETWORKD () {  # https://wiki.archlinux.org/index.php/Systemd-networkd
							NOTICE_START
								systemctl enable systemd-networkd.service
								REPLACE_RESOLVECONF () {  # (! default)
									ln -snf /run/systemd/resolved.conf /etc/resolv.conf
									systemctl enable systemd-resolved.service
								NOTICE_END
								}
								WIRED_DHCPD () {  # (! default)
								NOTICE_START
									cat << 'EOF' > /etc/systemd/network/20-wired.network
									[ Match ]
									Name=enp0s3
									[ Network ]
									DHCP=ipv4
EOF
								NOTICE_END
								}
								WIRED_STATIC () {
								NOTICE_START
									cat << 'EOF' > /etc/systemd/network/20-wired.network
									[ Match ]
									Name=enp0s3
									[ Network ]
									Address=10.1.10.9/24
									Gateway=10.1.10.1
									DNS=10.1.10.1
									# DNS=8.8.8.8
EOF
								NOTICE_END
								}
								REPLACE_RESOLVECONF
								WIRED_$NETWORK_NET
							NOTICE_END
							}
							NETWORKD
						NOTICE_END
						}
						DHCCLIENT () {
						NOTICE_START
							DHCPCD () {  # https://wiki.gentoo.org/wiki/Dhcpcd
							NOTICE_START
								APPAPP_EMERGE="net-misc/dhcpcd "
								AUTOSTART_NAME_OPENRC="dhcpcd"
								AUTOSTART_NAME_SYSTEMD="dhcpcd"
								EMERGE_USERAPP_DEF
								AUTOSTART_DEFAULT_$SYSINITVAR
							NOTICE_END
							}
							DHCPCD
						NOTICE_END
						}
						NETWORKMANAGER () {
						NOTICE_START
							EMERGE_NETWORKMANAGER () {
							NOTICE_START
								APPAPP_EMERGE="net-misc/networkmanager "
								AUTOSTART_NAME_OPENRC="NetworkManager"
								AUTOSTART_NAME_SYSTEMD="NetworkManager"
								PACKAGE_USE
								ACC_KEYWORDS_USERAPP
								EMERGE_ATWORLD_A
								EMERGE_USERAPP_DEF
								AUTOSTART_DEFAULT_$SYSINITVAR
							NOTICE_END
							}
							EMERGE_NETWORKMANAGER
							AUTOSTART_DEFAULT_$SYSINITVAR
						NOTICE_END
						}
						DHCCLIENT
						$NETWMGR
					NOTICE_END
					}
					NET_FIREWALL () {
					NOTICE_START
						#UFW () {  # https://wiki.gentoo.org/wiki/Ufw
						#NOTICE_START
						#	
						#	APPAPP_EMERGE="net-firewall/ufw"
						#	AUTOSTART_NAME_OPENRC="ufw"
						#	AUTOSTART_NAME_SYSTEMD="ufw"
						#	PACKAGE_USE
						#	ACC_KEYWORDS_USERAPP
						#	EMERGE_USERAPP_DEF
						#	AUTOSTART_DEFAULT_$SYSINITVAR							
						#}
						IPTABLES () {  # https://wiki.gentoo.org/wiki/Iptables
						NOTICE_START
							APPAPP_EMERGE="net-firewall/iptables"
							AUTOSTART_NAME_OPENRC="iptables"
							AUTOSTART_NAME_SYSTEMD="iptables"
							PACKAGE_USE
							ACC_KEYWORDS_USERAPP
							EMERGE_USERAPP_DEF
							AUTOSTART_DEFAULT_$SYSINITVAR
						NOTICE_END						
						}
						#UFW
						IPTABLES
					NOTICE_END
					}
					#NET_FTP () {
					#NOTICE_START
					#	CLIENT () {
					#	NOTICE_START
					#		FTP () {
					#		NOTICE_START
					#			APPAPP_EMERGE="net-ftp/ftp"
					#			# PACKAGE_USE
					#			ACC_KEYWORDS_USERAPP
					#			EMERGE_USERAPP_DEF
					#			AUTOSTART_DEFAULT_$SYSINITVAR
					#		NOTICE_END
					#		}
					#		#FILEZILLA () {  (# build fail # dep x11?)
					#		#	APPAPP_EMERGE="net-ftp/filezilla"
					#		#	# PACKAGE_USE
					#		#	ACC_KEYWORDS_USERAPP
					#		#	EMERGE_USERAPP_DEF
					#		#	AUTOSTART_DEFAULT_$SYSINITVAR
					#		#NOTICE_END
					#		#}
					#		FTP
					#		#FILEZILLA
					#	NOTICE_END
					#	}
					#	CLIENT
					#NOTICE_END
					#}
					NET_SYS
					NET_MGMT
					NET_FIREWALL
					##NET_FTP
					NOTICE_END
				}
				#SYSCONFIG_CORE
				#SYSFS
				#APPADMIN
				#SYSAPP
				#APP
				#SYSPROCESS
				#KERNEL
				#INITRAM
				SYSBOOT
				## MODPROBE_CHROOT
				#APPEMULATION
				#AUDIO
				## GPU
				#NETWORK
			NOTICE_END
				# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			}
			SCREENDSP () {  # note: replace visual header with "screen and desktop"
			NOTICE_START
				WINDOWSYS () {
				NOTICE_START
					X11 () {  # (! default) # https://wiki.gentoo.org/wiki/Xorg/Guide
					NOTICE_START
						EMERGE_XORG () {
						NOTICE_START
							APPAPP_EMERGE="x11-libs/gdk-pixbuf "
							EMERGE_USERAPP_DEF
							APPAPP_EMERGE="x11-base/xorg-server "
							PACKAGE_USE
							EMERGE_USERAPP_DEF
							ENVUD
						NOTICE_END
						}
						CONF_XORG () {
						NOTICE_START
							CONF_X11_KEYBOARD () {
							NOTICE_START
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
				DESKTOP_ENV () {  # https://wiki.gentoo.org/wiki/Desktop_environment
				NOTICE_START
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
					NOTICE_START
						for i in $DESKTOPENV ; do
							DSTENV_XEC=$DESKTOPENV\_DSTENV_XEC
							DSTENV_STARTX=$DESKTOPENV\_DSTENV_STARTX
							DSTENV_EMERGE=$DESKTOPENV\_DSTENV_EMERGE
						done
					NOTICE_END
					}
					ADDREPO_DSTENV () {
					NOTICE_START
						if [ "$DESKTOPENV" == "PANTHEON" ]; then
							layman -a elementary
							eselect repository enable elementary
							emerge --sync elementary 
						else
							NOTICE_PLACEHOLDER
						fi
					NOTICE_END
					}
					EMERGE_DSTENV () {
					NOTICE_START
						# emerge --ask gnome-extra/nm-applet
						if [ "$DESKTOPENV" == "DDM" ]; then
							GIT () {
							NOTICE_START
								APPAPP_EMERGE="dev-vcs/git "
								EMERGE_USERAPP_DEF
							NOTICE_END
							}
							ESELECT () {
							NOTICE_START
								APPAPP_EMERGE="app-eselect/eselect-repository "
								EMERGE_USERAPP_DEF
							NOTICE_END
							}
							DEEPIN_GIT () {
							NOTICE_START
								MAIN () {
								NOTICE_START
								eselect repository add deepin git https://github.com/zhtengw/deepin-overlay.git
								APPAPP_EMERGE="deepin "
								EMERGE_USERAPP_DEF
								NOTICE_END
								}
								PLUGIN () {
								NOTICE_START
								mkdir -pv /etc/portage/package.use
								sed -ie '#dde-base/dde-meta multimedia#d' /etc/portage/package.use/deepin
								echo "dde-base/dde-meta multimedia" >> /etc/portage/package.use/deepin
								APPAPP_EMERGE="dde-base/dde-meta "
								EMERGE_USERAPP_DEF
								NOTICE_END
								}
								MAIN
								PLUGIN
							NOTICE_END
							}
							GIT
							ESELECT
							DEEPIN_GIT
						elif [ "$DESKTOPENV" == "PANTHEON" ]; then
							PANTHEON_MAIN () {
							NOTICE_START
								APPAPP_EMERGE="pantheon-base/pantheon-shell "
								EMERGE_USERAPP_DEF
							NOTICE_END
							}
							PANTHEON_ADDON () {
							NOTICE_START
								APPAPP_EMERGE="media-video/audience x11-terms/pantheon-terminal "
								EMERGE_USERAPP_DEF
							NOTICE_END
							}
							PANTHEON_MAIN
							PANTHEON_ADDON
						elif [ "$DESKTOPENV" == "XFCE" ]; then
							MISC_XFCE () {
							NOTICE_START
								XFCEADDON () {
								NOTICE_START
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
								NOTICE_END
								}
								APPAPP_EMERGE="xfce-base/xfce4-meta "
								PACKAGE_USE
								EMERGE_ATWORLD_B
								EMERGE_USERAPP_DEF
								XFCEADDON
							NOTICE_END
							}
							MISC_XFCE
						else
							emerge $DSTENV_EMERGE
						fi
						ENVUD
					NOTICE_END
					}
					MAIN_DESKTPENV_OPENRC () {
					NOTICE_START
						AUTOSTART_NAME_OPENRC="dbus"
						AUTOSTART_DEFAULT_OPENRC
						AUTOSTART_NAME_OPENRC="xdm"
						AUTOSTART_DEFAULT_OPENRC
						AUTOSTART_NAME_OPENRC="elogind"  # elogind The systemd project's "logind", extracted to a standalone package https://github.com/elogind/elogind
						AUTOSTART_BOOT_OPENRC
					NOTICE_END
					}
					MAIN_DESKTPENV_SYSTEMD () {
					NOTICE_START
						AUTOSTART_NAME_SYSTEMD="dbus"
						AUTOSTART_DEFAULT_SYSTEMD
						AUTOSTART_NAME_SYSTEMD="systemd-logind"
						AUTOSTART_DEFAULT_SYSTEMD
						ENVUD
					NOTICE_END
					}
					DESKTENV_SOLO () {
					NOTICE_START
						DESKTENV_STARTX () {
						NOTICE_START
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
						NOTICE_END
						}
						DESKTENV_AUTOSTART_OPENRC () {
						NOTICE_START
							if [ "$DESKTOPENV" == "CINNAMON" ]; then
								cp /etc/xdg/autostart/nm-applet.desktop /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
								echo 'X-GNOME-Autostart-enabled=false' >> /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
								chown $SYSUSERNAME:$SYSUSERNAME /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
							else
								NOTICE_PLACEHOLDER
							fi
						NOTICE_END
						}
						DESKTENV_AUTOSTART_SYSTEMD () {
						NOTICE_START
							NOTICE_PLACEHOLDER
						NOTICE_END
						}
						DESKTENV_STARTX
						DESKTENV_AUTOSTART_$SYSINITVAR
					NOTICE_END
					}
					W_D_MGR () {  # Display_manager https://wiki.gentoo.org/wiki/Display_manager
					NOTICE_START
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
						NOTICE_START
							for i in $DISPLAYMGR
							do
								DSTENV_XEC=$DESKTOPENV\_DSTENV_XEC
								DSTENV_STARTX=$DESKTOPENV\_DSTENV_STARTX
								DSPMGR_AS=$i\_DSPMGR_$SYSINITVAR
								DSPMGR_XEC=$i\_DSPMGR_XEC
								DSPMGR_STARTX=$i\_DSPMGR_STARTX
								APPAPP_EMERGE=$i\_APPAPP_EMERGE
							done
						NOTICE_END
						}
						DSPMGR_OPENRC () {
						NOTICE_START
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
						NOTICE_END
						}
						DSPMGR_SYSTEMD () {
						NOTICE_START
							systemctl enable $DSPMGR_SYSTEMD
						NOTICE_END
						}
						CONFIGURE_DSPMGR () {
						NOTICE_START
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
						NOTICE_END
						}
						SETVAR_DSPMGR
						EMERGE_USERAPP_RD1
						DSPMGR_$SYSINITVAR
						CONFIGURE_DSPMGR
					NOTICE_END
					}
					SETVAR_DSKTENV  # set the variables
					ADDREPO_DSTENV
					EMERGE_DSTENV
					MAIN_DESKTPENV_$SYSINITVAR
					$DISPLAYMGR_YESNO
				NOTICE_END
				}
				WINDOWSYS
				DESKTOP_ENV
			NOTICE_END
				# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			}
			USERAPP () {  # (!todo)
			NOTICE_START
				USERAPP_GIT () {  # (note: already setup through use flag make.conf?)
				NOTICE_START
					APPAPP_EMERGE="dev-vcs/git"
					PACKAGE_USE
					EMERGE_USERAPP_DEF
				NOTICE_END
				}
				WEBBROWSER () {
				NOTICE_START
					USERAPP_FIREFOX () {
					NOTICE_START
						APPAPP_EMERGE="www-client/firefox"
						PACKAGE_USE
						ACC_KEYWORDS_USERAPP
						EMERGE_USERAPP_DEF
					NOTICE_END
					}
					USERAPP_CHROMIUM () {  # (!todo)
					NOTICE_START
						APPAPP_EMERGE="www-client/chromium"
						PACKAGE_USE
						EMERGE_USERAPP_DEF
						etc-update --automode -3
					NOTICE_END
					}
					USERAPP_MIDORI () {  # (!todo)
					NOTICE_START
						APPAPP_EMERGE="www-client/midori"
						PACKAGE_USE
						EMERGE_USERAPP_DEF
					NOTICE_END
					}
					RUN_ALLYES_USERAPP () {
					NOTICE_START
						for i in  ${!USERAPP_*}
						do
							if [ $(printf '%s\n' "${!i}") == "YES" ]; then
								$i
							else 
								printf '%s\n' "$i is set to ${!i}, test for boot fs ..." 
							fi
						done
					NOTICE_END
					}
					RUN_ALLYES_USERAPP
				NOTICE_END
				}
				# GIT
				WEBBROWSER
			NOTICE_END
			}
			USERS () {
			NOTICE_START 
				ROOT () {  # (! default)
				NOTICE_START
					echo "${bold}enter new root password${normal}"
					until passwd
					do
					  echo "${bold}enter new root password${normal}"
					done
				NOTICE_END
				}
				ADMIN () {  # (!NOTE: default) - ok
				NOTICE_START 
					ADD_GROUPS () {
					NOTICE_START
					 	# for group user sets in var do groupadd -- changeme
						groupadd plugdev
						groupadd power
						groupadd adm
						groupadd audio
					NOTICE_END
					}
					ADD_USER () {
					NOTICE_START
						ASK_PASSWD () {
						NOTICE_START
							echo "${bold}enter new $SYSUSERNAME password${normal}"
							until passwd $SYSUSERNAME
							do
							  echo "${bold}enter new $SYSUSERNAME password${normal}"
							done
						NOTICE_END
						}
						useradd -m -g users -G $USERGROUPS -s /bin/bash $SYSUSERNAME
						ASK_PASSWD
					NOTICE_END
					}
					VIRTADMIN_GROUPS () {
					NOTICE_START
						groupadd vboxguest
						gpasswd -a $SYSUSERNAME vboxguest
					NOTICE_END
					}
					ADD_GROUPS
					ADD_USER
					VIRTADMIN_GROUPS
				NOTICE_END
				}
				ROOT
				ADMIN
			NOTICE_END
			} 
			FINISH () {  # tidy up installation files - ok
			NOTICE_START
				rm -f /stage3-*.tar.*
				echo "${bold}Script finished all operations - END${normal}"
			NOTICE_END
			} 
			## (RUN ENTIRE SCRIPT) (!changeme)
	#BASE
	CORE

	#SCREENDSP
	#USERAPP
	#USERS
	#FINISH
NOTICE_END
INNERSCRIPT
)
	CHROOT_INNER () {
	NOTICE_START
		# since the chroot script cant be run outside of chroot the script and possibly sourced functions and variables scripts need to be copied accordingly.
		# for the onefile setup this is simply done by echoing the 'INNERSCRIPT" ... if the setup is split in multiple files for readability, every file or alt the gentoo script repo needs to be copied to make all functions and variables available.
		# only variables outside the chroot innerscript for now 27.8.22
		# IMPORTANT blow commands are executed BEFORE the above INNERSCRIPT! (BELOW chroot $CHROOTX /bin/bash ./chroot_run.sh). if a file needs to be made available in the INNERSCRIPT, copy it before ( chroot $CHROOTX /bin/bash ./chroot_run.sh ) below in this CHROOT function!!!

		# mkdir $CHROOTX/gentoo_unattented_setup_chroot  # may sort copied files to chroot in a directory another time.
		# cp src/chroot_main.sh $CHROOTX/chroot.sh  # replacement for inenrscript chroot
		cp var/chroot_variables.sh $CHROOTX/chroot_variables.sh # sourced on top of the INNERSCRIPT
		cp var/var_main.sh $CHROOTX/var_main.sh # sourced on top of the INNERSCRIPT
		cp func/func_main.sh $CHROOTX/func_main.sh
		cp func/func_chroot_main.sh $CHROOTX/func_chroot_main.sh
		cp configs/required/kern.config.sh $CHROOTX/kern.config # 09.09.22 updated for linux-5.15.59-gentoo on virtualbox # linux kernel config! this could also be pasted in the INNERSCRIPT above but for readability this should be outside, else this file is bblow up for xxxxx lines.
		cp configs/default/.bashrc.sh $CHROOTX/.bashrc.sh
		# cp -R configs/default $CHROOTX/configs/default  # old kept as sample
		# cp -R configs/optional $CHROOTX/configs/optional # old kept as sample
		# cp -R func $CHROOTX/func  # old kept as sample

		echo "$INNER_SCRIPT" > $CHROOTX/chroot_run.sh
		chmod +x $CHROOTX/chroot_run.sh
		chroot $CHROOTX /bin/bash ./chroot_run.sh
	NOTICE_END
	}
	CHROOT_INNER
NOTICE_END
}
DEBUG () {
NOTICE_START
	rc update -v show
NOTICE_END
}
	####  RUN ALL ## (!changeme)
	#PRE  # no ERR 10.09.22 
	CHROOT
	#DEBUG
NOTICE_END
