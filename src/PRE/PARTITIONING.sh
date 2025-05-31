# variables defined in: gentoo_unattented-setup/var/1_PRE_main.sh && gentoo_unattented-setup/var/var_main.sh unless noted otherwise behind the var line / func

PARTITIONING_MAIN  () {
	PARTITIONING_BIOS () {
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

	PARTITIONING_UEFI () {
	NOTICE_START
		PARTED () {  # EFI + LVM on LUKS
		NOTICE_START
			sgdisk --zap-all $HDD1
			parted -s $HDD1 mklabel gpt
			parted -s $HDD1 mkpart primary fat32 1MiB "$GRUB_SIZE"
			parted -s $HDD1 name 1 efi
			parted -s $HDD1 set 1 esp on
			parted -s $HDD1 set 1 boot on
			parted -s $HDD1 mkpart primary $FILESYSTEM_BOOT "$BOOT_SIZE"
			parted -s $HDD1 name 2 boot
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
			mkfs.fat -F32 $EFI_PART
			mkfs.$FILESYSTEM_BOOT $BOOT_PART
		NOTICE_END
		}
		PARTED
		PTABLES
		MAKEFS_BOOT
	NOTICE_END
	}
PARTITIONING_$BOOTINITVAR
}