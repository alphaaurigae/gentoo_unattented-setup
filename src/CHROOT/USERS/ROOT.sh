ROOT () {
NOTICE_START
	echo "${bold}Enter new root password${normal}"
	until passwd
	do
	  echo "${bold}Enter new root password${normal}"
	done
NOTICE_END
}