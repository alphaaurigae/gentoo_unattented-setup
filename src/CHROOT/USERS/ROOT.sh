ROOT() {
	NOTICE_START
	printf '%s\n' "${bold}Enter new root password${normal}"
	until passwd; do
		printf '%s\n' "${bold}Enter new root password${normal}"
	done
	NOTICE_END
}
