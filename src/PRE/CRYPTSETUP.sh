# variables defined in: gentoo_unattented-setup/var/1_PRE_main.sh && gentoo_unattented-setup/var/var_main.sh unless noted otherwise behind the var line / func

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