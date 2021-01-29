#!/bin/bash

# github.com/alphaaurigae/gentoo_unattended_modular-setup.sh

# [REDME.md]
##############################################################################################################################################################################################
  [!PASTE_DEF_CONFIG: "VARIABLES_1" "configs/variables_1.sh" - copy paste here your config here ]
############################################################################################################################################################################################################################################################################################################################################################################################
# STATIC VARIABLE
bold=$(tput bold) # staticvar bold text
normal=$(tput sgr0) # # staticvar reverse to normal text
# STATIC FUNCTIONS - left the START / END notices in for a moment ... ( !note: remove?)
NOTICE_START () {  # echo function name
	echo "${bold} ${FUNCNAME[1]} ... START ... ${normal}"
}
NOTICE_END () {
	echo "${bold}${FUNCNAME[1]}  ... END ... ${normal}"
}
# STATIC FUNCTIONS - END
PRE () {  # PREPARE CHROOT
	INIT () {  # (!NOTE:: in this section the script starts off with everything that has to be done prior to the setup action.)
		TIMEUPD () {  # TIME ... update the system time ... (!important) # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Setting_the_date_and_time
			ntpd -q -g
		}
		MODPROBE () {  # load kernel modules for the chroot install process, for luks we def need the dm-crypt ...
			modprobe -a dm-mod dm-crypt sha256 aes aes_generic xts
		}
		TIMEUPD
		MODPROBE
	}
	PARTITIONING () { # (!todo /var/tmp partition in ramfs)
		PARTED () {  # (!NOTE: partitioning for LVM on LUKS cryptsetup)
			# https://wiki.archlinux.org/index.php/GNU_Parted
			sgdisk --zap-all /dev/sda
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
	#  (!NOTE: lvm on luks! Lets put EVERYTHING IN THE LUKS CONTAINER, to put the LVM INSIDE and the installation inside of the LVM "CRYPT --> BOOT/LVM2 --> OS" ... )
	#  (!NOTE: for the main disk $MAIN_PART - you will be prompted for passohrase)
	CRYPTSETUP () {  # https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS && https://blog.stigok.com/2018/05/03/lvm-in-luks-with-encrypted-boot-partition-and-suspend-to-disk.html
		echo "${bold}enter the $PV_MAIN password${normal}"
		cryptsetup -v luksFormat --type luks2 $MAIN_PART --debug
		cryptsetup open $MAIN_PART $PV_MAIN
	}
	#  LVM = "PV (Physical volume)-> VG (Volume group) > LV (Logical volume) inside of the luks crypt container ...             
	LVMONLUKS () {  # (!NOTE: LVM2 in the luks container on $MAIN_PART)
		LVM_PV () {  # (!NOTE: physical volume $PV_MAIN) only for the $MAIN_PART)
			pvcreate /dev/mapper/$PV_MAIN
		}
		LVM_VG () {  # (!NOTE: volume group $VG_MAIN only on the $VG_MAIN)
			vgcreate $VG_MAIN /dev/mapper/$PV_MAIN
		}
		LVM_LV () {  # (!NOTE: volume group $LV_MAIN on $PV_MAIN)
			# lvcreate -L $SWAP_SIZE -n $SWAP0 $VG_MAIN
			lvcreate -l 98%FREE -n $LV_MAIN $VG_MAIN
		}
		MAKEFS_LVM () {  # (!NOTE: filesystems $LV_MAIN)
			mkfs.ext4 /dev/$VG_MAIN/$LV_MAIN # logical volume for OS inst.
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
				LIST="$STAGE3_FILEPATH.tar.xz
					$STAGE3_FILEPATH.tar.xz.CONTENTS.gz
					$STAGE3_FILEPATH.tar.xz.DIGESTS
					$STAGE3_FILEPATH.tar.xz.DIGESTS.asc"
			}
			FETCH_STAGE3_FETCH () {
				for i in $LIST; do
					echo "${bold}FETCH $i ....${normal}"
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
		STAGE3_VERIFY () {  # (!todo) (!important) # "hope this works" -
			SET_VAR_STAGE3_VERIFY (){
				STAGE3_FILENAME="$(cd $CHROOTX/ && ls stage3-* | awk '{ print $1 }' | awk 'FNR == 1 {print}' | sed -r 's/\.tar\.xz//g' )" # | rev | cut -d'/' -f-1 | rev
			}
			RECEIVE_GPGKEYS () { # which key is actually needed? for i in 
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
				if gpg  --verify "$CHROOTX/$STAGE3_FILENAME.tar.xz.DIGESTS.asc" ; then 
					echo 'gpg  --verify "$CHROOTX/$STAGE3_FILENAME.tar.xz.DIGESTS.asc" - OK'
									
					if grep -A 1 -i sha512 $CHROOTX/$STAGE3_FILENAME.tar.xz.DIGESTS.asc; then  # With the cryptographic signature validated, next verify the checksum to make sure the downloaded ISO file is not corrupted. The .DIGESTS.asc file contains multiple hashing algorithms, so one of the methods to validate the right one is to first look at the checksum registered in the .DIGESTS.asc file. For instance, to get the SHA512 checksum:  In the above output, two SHA512 checksums are shown - one for the install-amd64-minimal-20141204.iso file and one for its accompanying .CONTENTS file. Only the first checksum is of interest, as it needs to be compared with the calculated SHA512 checksum which can be generated as follows: 
						echo 'grep -A 1 -i sha512 $CHROOTX/$STAGE3_FILENAME.tar.xz.DIGESTS.asc - OK'
						echo 'STAGE3_UNPACK ....'
						tar xvJpf $CHROOTX/"$STAGE3_FILENAME.tar.xz" --xattrs-include='*.*' --numeric-owner -C $CHROOTX
					fi
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
			mount --types proc /proc $CHROOTX/proc
			mount --rbind /sys $CHROOTX/sys
			mount --make-rslave $CHROOTX/sys
			mount --rbind /dev $CHROOTX/dev
			mount --make-rslave $CHROOTX/dev
		}	 
		SETMODE_DEVSHM () {
			chmod 1777 /dev/shm  # (!todo) (note: Chmod 1777 (chmod a+rwx,ug+s,+t,u-s,g-s) sets permissions so that, (U)ser / owner can read, can write and can execute. (G)roup can read, can write and can execute. (O)thers can read, can write and can execute)
		}
		MOUNT_BASESYS
		SETMODE_DEVSHM
	# REMOUNT 
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
CHROOT () {	#  4.0 CHROOT  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment 
	INNER_SCRIPT=$(cat << 'INNERSCRIPT'
		[ !PASTE_CHROOT - paste the src/CHROOT_PASTE-TO-RUN.sh content here. This is the script for the chroot. ]
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
INNERSCRIPT
)
	echo "$INNER_SCRIPT" > $CHROOTX/chroot_run.sh
	chmod +x $CHROOTX/chroot_run.sh
	chroot $CHROOTX /bin/bash ./chroot_run.sh

}

DEBUG () { 
	rc update -v show
}

####  RUN ALL ## (!changeme)
#PRE
CHROOT

#DEBUG