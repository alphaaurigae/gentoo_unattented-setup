# variables defined in: gentoo_unattented-setup/var/1_PRE_main.sh && gentoo_unattented-setup/var/var_main.sh unless noted otherwise behind the var line / func

	#  (!NOTE: lvm on luks "CRYPT --> BOOT/LVM2 --> OS" ... 
	#  (!NOTE: for the main disk $MAIN_PART - you will be prompted for passohrase)
	CRYPTSETUP () {  # https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS && https://blog.stigok.com/2018/05/03/lvm-in-luks-with-encrypted-boot-partition-and-suspend-to-disk.html
	NOTICE_START
		IF_CRYPSETUP () {
		NOTICE_START
			RUN_CRYPTSETUP () {
			NOTICE_START
				MODPROBE_CRYPT () {
				NOTICE_START
					local modules=(dm-mod dm-crypt sha256 aes aes_generic xts)
					local fail=0

					lsmod
					modprobe -a "${modules[@]}" || fail=1
					for m in "${modules[@]}"; do
						if ! lsmod | grep -q "^$m"; then
							echo "Module not loaded: $m"
							fail=1
						fi
					done

					if [ "$fail" -eq 0 ]; then
						echo "All modules loaded successfully."
					else
						echo "One or more modules failed to load."
					fi
					lsmod

					return $fail

					#lsmod
					#modprobe -a dm-mod dm-crypt sha256 aes aes_generic xts  # load kernel modules for the chroot install process, for luks we def need the dm-crypt ...
					#lsmod
				NOTICE_END
				}
				LUKS_CRYPTSETUP	() {
				NOTICE_START
					echo "${bold}Enter the $PV_MAIN password${normal}"
					# cryptsetup -v luksFormat --type luks2 --pbkdf argon2id --pbkdf-memory 4096 --pbkdf-parallel 2 --pbkdf-force-iterations 4 $MAIN_PART --debug ## did not work apparently - not sure tough

					# cryptsetup -v luksFormat --type luks2 --pbkdf pbkdf2 --cipher aes-xts-plain64 --key-size 512 --hash sha512 $MAIN_PART --debug  ## not tested
					# cryptsetup -v luksFormat --type luks2 --pbkdf pbkdf2 --pbkdf-force-iterations 1000000 --pbkdf-hash sha512 $MAIN_PART --debug  ## not tested
					# cryptsetup -v luksFormat --type luks2 --pbkdf pbkdf2 --pbkdf-force-iterations 1000000 --hash sha512 --cipher aes-xts-plain64 --key-size 512 $MAIN_PART --debug

					# cryptsetup -v luksFormat --type luks2 --pbkdf pbkdf2 --pbkdf-force-iterations 1000000 --hash sha512 --cipher aes-xts-plain64 --key-size 512 --align-payload=8192 --sector-size=512 $MAIN_PART --debug ##test next
					##cryptsetup -v luksFormat --type luks2 --pbkdf pbkdf2 --pbkdf-force-iterations 500000 --hash sha512 --cipher aes-xts-plain64 --key-size 256 --align-payload=8192 --sector-size=512 $MAIN_PART --debug # suppsed failsafe
					# If still fails: Lower --pbkdf-force-iterations (e.g., 500000) to reduce header size Use default cipher/key size (omit --cipher and --key-size)
					#cryptsetup -v luksFormat --type luks2 --pbkdf pbkdf2 --hash sha256 $MAIN_PART --debug # simulate legacy 2023
					cryptsetup -v luksFormat --type luks2 --pbkdf pbkdf2 --pbkdf-force-iterations 500000 --hash sha256 --cipher aes-xts-plain64 --key-size 512 --align-payload=8192 --sector-size=512 $MAIN_PART --debug
					#cryptsetup -v luksFormat --type luks2 $MAIN_PART --debug
					cryptsetup open $MAIN_PART $PV_MAIN
				NOTICE_END
				}
				DEBUG_LUKS () {
				NOTICE_START
					cryptsetup luksDump $MAIN_PART | grep PBKDF
					cryptsetup luksUUID $MAIN_PART

				NOTICE_END
				}
				MODPROBE_CRYPT
				LUKS_CRYPTSETUP
				DEBUG_LUKS
			NOTICE_END
			}
			if [ $CRYPTSETUP = "YES" ]; then
				echo "Cryptsetup is set to YES in the script variables --> PRECEEDING WITH CRYPTSETUP!"
				RUN_CRYPTSETUP
			else
				echo "Cryptsetup is NOT set to YES --> SKIPPING CRYPTSETUP!"
			fi
		NOTICE_END
		}
		IF_CRYPSETUP
	NOTICE_END
	}