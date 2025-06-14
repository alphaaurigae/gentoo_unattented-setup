# Variables defined in: g1_PRE_main.sh && var/var_main.sh unless noted otherwise behind the var line / func

PARTITIONING_MAIN() {
	CLEANUP_DISK() {
		NOTICE_START
		run_cmd() {
			printf '%s\n' "RUNNING: $*"
			"$@"
			local status=$?
			printf '%s\n' "EXIT STATUS: $status"
			[[ $status -eq 0 ]] || printf '%s\n' "ERROR: Command failed: $* (exit status: $status)"
		}
		swapoff -a || true

		umount -f $CHROOTX/boot || true
		umount -f $CHROOTX || true
		umount -f $BOOT_PART || true
		umount -f /dev/mapper/$VG_MAIN-$LV_MAIN || true

		lvchange -an $VG_MAIN || true
		vgchange -an $VG_MAIN || true

		if [ -e /dev/mapper/$VG_MAIN-$LV_MAIN ]; then
			run_cmd wipefs -a /dev/mapper/$VG_MAIN-$LV_MAIN
		fi

		vgremove -ff $VG_MAIN || true
		pvremove -ff /dev/mapper/$PV_MAIN || true
		pvremove -ff $MAIN_PART || true

		cryptsetup luksClose $PV_MAIN || true

		dmsetup remove_all || true
		kpartx -d $HDD1 || true

		run_cmd wipefs -a $BOOT_PART
		run_cmd wipefs -a $MAIN_PART
		run_cmd wipefs -a $HDD1
		run_cmd sgdisk --zap-all $HDD1
		run_cmd dd if=/dev/zero of=$HDD1 bs=1M count=100 status=progress
		blkdiscard $HDD1 || true

		udevadm settle
		sleep 1
		partx -d $HDD1 || true
		partprobe -s $HDD1 || true
		udevadm settle

		NOTICE_END
	}
	PARTITIONING_BIOS() {
		NOTICE_START
		PARTED() { # LVM on LUKS https://wiki.archlinux.org/index.php/GNU_Parted
			NOTICE_START
			sgdisk --zap-all $HDD1
			# parted -s $HDD1 rm 1
			# parted -s $HDD1 rm 2
			# parted -s $HDD1 rm 3
			parted -s $HDD1 mklabel gpt                 # GUID Part-Table
			parted -s $HDD1 mkpart primary "$GRUB_SIZE" # The BIOS boot partition is needed when a GPT partition layout is used with GRUB2 in PC/BIOS mode.
			parted -s $HDD1 name 1 grub                 # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks#GPT
			parted -s $HDD1 set 1 bios_grub on
			parted -s $HDD1 mkpart primary $FILESYSTEM_BOOT "$BOOT_SIZE"
			parted -s $HDD1 name 2 boot
			parted -s $HDD1 set 2 boot on
			parted -s $HDD1 mkpart primary $FILESYSTEM_MAIN "$MAIN_SIZE"
			parted -s $HDD1 name 3 mainfs
			parted -s $HDD1 set 3 lvm on
			NOTICE_END
		}
		PTABLES() {
			NOTICE_START
			partx -u $HDD1
			partprobe $HDD1
			NOTICE_END
		}
		MAKEFS_BOOT() {
			NOTICE_START
			mkfs.$FILESYSTEM_BOOT $BOOT_PART
			NOTICE_END
		}
		PARTED
		PTABLES
		MAKEFS_BOOT
		NOTICE_END
	}

	PARTITIONING_UEFI() {
		NOTICE_START
		PARTED() { # EFI + LVM on LUKS
			NOTICE_START
			sgdisk --zap-all $HDD1
			parted -s $HDD1 mklabel gpt
			parted -s $HDD1 mkpart primary fat32 1MiB "$GRUB_SIZE"
			parted -s $HDD1 name 1 efi
			parted -s $HDD1 set 1 esp on
			parted -s $HDD1 set 1 boot on
			parted -s $HDD1 mkpart primary $FILESYSTEM_BOOT "$BOOT_SIZE"
			parted -s $HDD1 name 2 boot # Noot part not required when booting in EFI/UEFI mode.
			parted -s $HDD1 mkpart primary $FILESYSTEM_MAIN "$MAIN_SIZE"
			parted -s $HDD1 name 3 mainfs
			parted -s $HDD1 set 3 lvm on
			NOTICE_END
		}
		PTABLES() {
			NOTICE_START
			partx -u $HDD1
			partprobe $HDD1
			NOTICE_END
		}
		MAKEFS_BOOT() {
			NOTICE_START
			mkfs.fat -F32 $EFI_PART
			mkfs.$FILESYSTEM_BOOT $BOOT_PART
			NOTICE_END
		}
		PARTED
		PTABLES
		MAKEFS_BOOT
		NOTICE_END
	}
	CLEANUP_DISK
	PARTITIONING_$BOOTINITVAR
}
