	SYSCONFIG_CORE () {
	NOTICE_START
		FSTAB () {  # https://wiki.gentoo.org/wiki/Fstab
		NOTICE_START
			FSTAB_LVMONLUKS_BIOS () {  # (!default)
			NOTICE_START
				cat <<- EOF > /etc/fstab
				# ROOT MAIN FS
				/dev/mapper/$VG_MAIN-$LV_MAIN	/	$FILESYSTEM_MAIN	errors=remount-ro	0 1
				# BOOT
				UUID="$(blkid -o value -s UUID $BOOT_PART)"	/boot	$FILESYSTEM_BOOT	rw,relatime	0 2
				EOF
cat /etc/fstab
			NOTICE_END
			} 
			FSTAB_LVMONLUKS_UEFI () {
			NOTICE_START
				cat <<- EOF > /etc/fstab
				# ROOT MAIN FS
				/dev/mapper/$VG_MAIN-$LV_MAIN	/	$FILESYSTEM_MAIN	errors=remount-ro	0 1
				# BOOT
				UUID="$(blkid -o value -s UUID $BOOT_PART)"	/boot	$FILESYSTEM_BOOT	rw,relatime	0 2
				EOF
			NOTICE_END
			}
			FSTAB_LVMONLUKS_$BOOTINITVAR
		NOTICE_END
		}
		CRYPTTABD () {
		NOTICE_START
			cat <<- EOF > /etc/crypttab
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