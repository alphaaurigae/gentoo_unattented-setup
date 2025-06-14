# Variables defined in: var/1_PRE_main.sh && var/var_main.sh unless noted otherwise behind the var line / func

# (!NOTE: LVM on luks "CRYPT --> BOOT/LVM2 --> OS" ...
CRYPTSETUP() { # https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS && https://blog.stigok.com/2018/05/03/lvm-in-luks-with-encrypted-boot-partition-and-suspend-to-disk.html
	NOTICE_START
	IF_CRYPSETUP() {
		NOTICE_START
		RUN_CRYPTSETUP() {
			NOTICE_START
			MODPROBE_CRYPT() {
				NOTICE_START
				local modules=(dm-mod dm-crypt sha256 aes aes_generic xts)
				local fail=0

				lsmod
				modprobe -a "${modules[@]}" || fail=1
				for m in "${modules[@]}"; do
					if ! lsmod | grep -q "^$m"; then
						printf "%s%s%s%s\n" "${BOLD}${MAGENTA}" "WARNING:" "${RESET}" " modprobe - Module not loaded: $m"
						fail=1
					fi
				done

				if [ "$fail" -eq 0 ]; then
					printf "%s%s%s%s\n" "${BOLD}${GREEN}" "SUCCESS:" "${RESET}" " modprobe - All modules loaded successfully."
				else
					printf "%s%s%s%s\n" "${BOLD}${MAGENTA}" "WARNING:" "${RESET}" " modprobe - One or more modules failed to load."
				fi
				lsmod

				return $fail

				NOTICE_END
			}
			LUKS_CRYPTSETUP() {
				NOTICE_START

				printf '%s\n' "${BOLD}Enter the $PV_MAIN password${RESET}"

				CRYPTSETUP_ARGS=(
					-v luksFormat
					--type luks2
					--pbkdf pbkdf2
					--pbkdf-force-iterations 500000
					--hash sha256
					--cipher aes-xts-plain64
					--key-size 512
					--align-payload=8192
					--sector-size=512
					"$MAIN_PART"
					--debug
				)
				printf '%s\n' "${BOLD}cryptsetup arguments set: ${CRYPTSETUP_ARGS[*]}${RESET}"
				cryptsetup "${CRYPTSETUP_ARGS[@]}"

				cryptsetup open $MAIN_PART $PV_MAIN
				NOTICE_END
			}
			DEBUG_LUKS() {
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
			printf "%s%s%s%s\n" "${BOLD}${GREEN}" "Cryptsetup is set to YES:" "${RESET}" " in the script variables --> CRYPTSETUP"
			RUN_CRYPTSETUP
		else
			printf "%s%s%s%s\n" "${BOLD}${WHITE}" "Cryptsetup is NOT set to YES:" "${RESET}" " in the script variables --> SKIPPING CRYPTSETUP!"
		fi
		NOTICE_END
	}
	IF_CRYPSETUP
	NOTICE_END
}
