	ROOT () {  # (! default)
	NOTICE_START
		echo "${bold}enter new root password${normal}"
		until passwd
		do
		  echo "${bold}enter new root password${normal}"
		done
	NOTICE_END
	}