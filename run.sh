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
		NOTICE_END
		}
		MAKEFS_BOOT () {
		NOTICE_START
			mkfs.$FILESYSTEM_BOOT $BOOT_PART
		NOTICE_END
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
#INNER_SCRIPT=$(cat << 'INNERSCRIPT'
## depreceted, replaced by copy chroot script in CHROOT_INNER function. kept as sample for singlefile setup.
#INNERSCRIPT
#)
	CHROOT_INNER () {
	NOTICE_START
		# since the chroot script cant be run outside of chroot the script and possibly sourced functions and variables scripts need to be copied accordingly.
		# for the onefile setup this is simply done by echoing the 'INNERSCRIPT" ... if the setup is split in multiple files for readability, every file or alt the gentoo script repo needs to be copied to make all functions and variables available.
		# only variables outside the chroot innerscript for now 27.8.22
		# IMPORTANT blow commands are executed BEFORE the above INNERSCRIPT! (BELOW chroot $CHROOTX /bin/bash ./chroot_run.sh). if a file needs to be made available in the INNERSCRIPT, copy it before ( chroot $CHROOTX /bin/bash ./chroot_run.sh ) below in this CHROOT function!!!

		# mkdir $CHROOTX/gentoo_unattented_setup_chroot  # may sort copied files to chroot in a directory another time.
		cp src/chroot_main.sh $CHROOTX/chroot_main.sh  # replacement for inenrscript chroot
		chmod +x $CHROOTX/chroot_main.sh
		cp var/chroot_variables.sh $CHROOTX/chroot_variables.sh # sourced on top of the INNERSCRIPT
		cp var/var_main.sh $CHROOTX/var_main.sh # sourced on top of the INNERSCRIPT
		cp func/func_main.sh $CHROOTX/func_main.sh
		cp func/func_chroot_main.sh $CHROOTX/func_chroot_main.sh
		cp configs/required/kern.config.sh $CHROOTX/kern.config # 09.09.22 updated for linux-5.15.59-gentoo on virtualbox # linux kernel config! this could also be pasted in the INNERSCRIPT above but for readability this should be outside, else this file is bblow up for xxxxx lines.
		cp configs/default/.bashrc.sh $CHROOTX/.bashrc.sh
		# cp -R configs/default $CHROOTX/configs/default  # sample
		# cp -R configs/optional $CHROOTX/configs/optional # sample
		# cp -R func $CHROOTX/func  # old kept as sample

		echo "$INNER_SCRIPT" > $CHROOTX/chroot_run.sh
		chmod +x $CHROOTX/chroot_run.sh
		chroot $CHROOTX /bin/bash ./chroot_main.sh
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
