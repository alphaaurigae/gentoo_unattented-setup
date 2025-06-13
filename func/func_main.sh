# Print function names
NOTICE_START() {
	printf '%s\n' "${BOLD} ${FUNCNAME[1]} ... START ... ${RESET}"
}
NOTICE_END() {
	printf '%s\n' "${BOLD}${FUNCNAME[1]}  ... END ... ${RESET}"
}

BOLD=$(tput bold)
RESET=$(tput sgr0)
# Regular colors
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)

# Bright colors
BRIGHT_BLACK=$(tput setaf 8)
BRIGHT_RED=$(tput setaf 9)
BRIGHT_GREEN=$(tput setaf 10)
BRIGHT_YELLOW=$(tput setaf 11)
BRIGHT_BLUE=$(tput setaf 12)
BRIGHT_MAGENTA=$(tput setaf 13)
BRIGHT_CYAN=$(tput setaf 14)
BRIGHT_WHITE=$(tput setaf 15)

VERIFY_COPY() {
	NOTICE_START
	local SRC="$1"
	local DST="$2"
	local SRC_HASH=$(sha256sum <"$SRC") &&
		local DST_HASH=$(sha256sum <"$DST") &&
		[ "$SRC_HASH" = "$DST_HASH" ] &&
		printf "%s%s%s\n" "${BOLD}${GREEN}" "Copied and verified:" "${RESET} $SRC -> $DST" || printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " Copy failed or mismatch: $SRC -> $DST"
	NOTICE_END
}

CP_CHROOT() {
	NOTICE_START
	# Since the chroot script can't be run outside of chroot...
	# IMPORTANT: The following commands are executed BEFORE the above INNERSCRIPT (BELOW chroot $CHROOTX /bin/bash ./chroot_run.sh).
	# If a file needs to be made available in the INNERSCRIPT, copy it before (chroot $CHROOTX /bin/bash ./chroot_run.sh) within this CHROOT function!
	rm -rf $CHROOTX/gentoo_unattented-setup
	ls -la /root
	printf '%s\n' "$CHROOTX"
	cp -R /root/gentoo_unattented-setup $CHROOTX/gentoo_unattented-setup
	ls -la $CHROOTX

	NOTICE_END
}
CHROOT_INNER() { # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment
	NOTICE_START
	printf '%s\n' "$INNER_SCRIPT" >$CHROOTX/chroot_main.sh
	chmod +x $CHROOTX/chroot_main.sh
	chroot $CHROOTX /bin/bash ./chroot_main.sh
	NOTICE_END
}

verify_or_exit() {
	description="$1"
	shift
	echo ">> Running: $*" >&2
	if "$@"; then
		printf "%s%s%s\n" "${BOLD}${GREEN}" "CHECK OK:" "${RESET} $description"
	else
		printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " $description check failed!"
		exit 1
	fi
}
