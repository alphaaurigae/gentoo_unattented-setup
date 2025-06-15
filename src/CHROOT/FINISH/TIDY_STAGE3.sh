FINISH_CHROOT () {
	TIDY () {	
		printf '%s\n' "${BOLD}Removing setup files /gentoo_unattented-setup && /stage3-*.tar.*${RESET}"
		rm -rf /gentoo_unattented-setup
		rm -f /stage3-*.tar.*
	}

	FINALIZE () {
		EMERGE_WORLDINIT
		printf '%s\n' "${BOLD}Script finished all operations - END${RESET}"
	}
	TIDY
	FINALIZE
}