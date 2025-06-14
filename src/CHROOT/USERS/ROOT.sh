ROOT() {
	NOTICE_START
	printf '%s\n' "${BOLD}Enter new root password${RESET}"
	until passwd; do
		printf '%s\n' "${BOLD}Enter new root password${RESET}"
	done
	NOTICE_END
}
