# variables defined in: var/1_PRE_main.sh && var/var_main.sh unless noted otherwise behind the var line / func

LVMSETUP() {
	#  LVM = "PV (Physical volume)-> VG (Volume group) > LV (Logical volume) inside of the luks crypt container ...
	LVMONLUKS() {
		NOTICE_START
		LVM_PV() {
			NOTICE_START
			pvcreate /dev/mapper/$PV_MAIN
			pvdisplay
			NOTICE_END
		}
		LVM_VG() {
			NOTICE_START
			vgcreate $VG_MAIN /dev/mapper/$PV_MAIN
			vgdisplay
			NOTICE_END
		}
		LVM_LV() {
			NOTICE_START
			# lvcreate -L $SWAP_SIZE -n $SWAP0 $VG_MAIN
			lvcreate -l 98%FREE -n $LV_MAIN $VG_MAIN
			lvdisplay
			NOTICE_END
		}
		MAKEFS_LVM() {
			NOTICE_START
			mkfs.ext4 /dev/$VG_MAIN/$LV_MAIN
			# mkswap /dev/$VG_MAIN/$SWAP0 # swap ...
			NOTICE_END
		}
		MOUNT_LVM_LV() { # (!NOTE: mount the LVM for CHROOT.)
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
	LVM_ROOT() {
		NOTICE_START

		printf '%s\n' "DEBUG: MAIN_PART='$MAIN_PART' VG_MAIN='$VG_MAIN' LV_MAIN='$LV_MAIN' CHROOTX='$CHROOTX' BOOT_PART='$BOOT_PART'"
		run_cmd() {
			printf "%s%s%s\n" "${BOLD}${WHITE}" "RUNNING:" "${RESET}" " $*"
			printf '%s\n' "RUNNING: $*"
			"$@"
			local status=$?
			printf '%s\n' "EXIT STATUS: $status"
			[[ $status -eq 0 ]] || {
				printf "%s%s%s\n" "${BOLD}${RED}" "ERROR:" "${RESET}" " Command failed: $*"
				exit $status
			}
		}
		LVM_PV() {
			NOTICE_START
			run_cmd pvcreate $MAIN_PART
			run_cmd pvdisplay
			NOTICE_END
		}
		LVM_VG() {
			NOTICE_START
			run_cmd vgcreate $VG_MAIN $MAIN_PART
			run_cmd vgdisplay
			NOTICE_END
		}
		LVM_LV() {
			NOTICE_START
			# lvcreate -L $SWAP_SIZE -n $SWAP0 $VG_MAIN
			run_cmd lvcreate -l 98%FREE -n $LV_MAIN $VG_MAIN
			run_cmd lvdisplay
			NOTICE_END
		}
		MAKEFS_LVM() {
			NOTICE_START
			run_cmd mkfs.ext4 /dev/$VG_MAIN/$LV_MAIN
			# mkswap /dev/$VG_MAIN/$SWAP0 # swap ...
			NOTICE_END
		}
		MOUNT_LVM_LV() { # (!NOTE: mount the LVM for CHROOT.)
			NOTICE_START
			mkdir -p $CHROOTX
			run_cmd mount /dev/mapper/$VG_MAIN-$LV_MAIN $CHROOTX
			# swapon /dev/$VG_MAIN/$SWAP0
			mkdir $CHROOTX/boot
			run_cmd mount $BOOT_PART $CHROOTX/boot
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
	RUN_LVMSET() {
		NOTICE_START
		if [ $CRYPTSETUP = "YES" ]; then
			printf "%s%s%s\n" "${BOLD}${GREEN}" "Cryptsetup is set to YES:" "${RESET}" " in the script variables --> LVM ON LUKS!"
			LVMONLUKS
		else
			printf "%s%s%s\n" "${BOLD}${WHITE}" "Cryptsetup is NOT set to YES:" "${RESET}" " in the script variables --> LVM ON ROOT!"
			LVM_ROOT
		fi
		NOTICE_END
	}
	RUN_LVMSET
	NOTICE_END
}
