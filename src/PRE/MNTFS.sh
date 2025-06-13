# Variables defined in: var/1_PRE_main.sh && var/var_main.sh unless noted otherwise behind the var line / func

MNTFS() {
	NOTICE_START
	MOUNT_BASESYS() {
		NOTICE_START
		verify_or_exit "mount proc" mount --types proc /proc "$CHROOTX/proc"
		verify_or_exit "mount --rbind sys" mount --rbind /sys "$CHROOTX/sys"
		verify_or_exit "mount --make-rslave sys" mount --make-rslave "$CHROOTX/sys"
		verify_or_exit "mount --rbind dev" mount --rbind /dev "$CHROOTX/dev"
		verify_or_exit "mount --make-rslave dev" mount --make-rslave "$CHROOTX/dev"
		verify_or_exit "mount --bind run" mount --bind /run "$CHROOTX/run"
		verify_or_exit "mount --make-slave run" mount --make-slave "$CHROOTX/run"

		declare -A mount_src=(
			[proc]="/proc"
			[sys]="/sys"
			[dev]="/dev"
			[run]="/run"
		)

		for mnt in proc sys dev run; do
			mounted_src=$(findmnt -n -o SOURCE --target "$CHROOTX/$mnt")
			mounted_target=$(findmnt -n -o TARGET --target "$CHROOTX/$mnt")
			expected_src=${mount_src[$mnt]}
			if [ -n "$mounted_src" ] && [ "$mounted_target" = "$CHROOTX/$mnt" ]; then
				printf "%s%s%s%s%s%s%s\n" "${BOLD}${GREEN}" "MOUNT OK:" "${RESET}" " [$mnt] $expected_src → $mounted_target (mounted fs: $mounted_src)"
			else
				printf "%s%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " mount $mnt missing or incorrect!"
				exit 1
			fi
		done
		NOTICE_END
	}
	SETMODE_DEVSHM() {
		NOTICE_START
		chmod 1777 "$CHROOTX/dev/shm"
		verify_or_exit "chmod 1777 on $CHROOTX/dev/shm" [ "$(stat -c "%a" "$CHROOTX/dev/shm")" = "1777" ]
		NOTICE_END
	}
	MOUNT_BASESYS
	SETMODE_DEVSHM
	NOTICE_END
}
