	ADMIN () {  # (!NOTE: default) - ok
	NOTICE_START 
		ADD_GROUPS () {
		NOTICE_START
		 	# for group user sets in var do groupadd -- changeme
			groupadd plugdev
			groupadd power
			groupadd adm
			groupadd audio
		NOTICE_END
		}
		ADD_USER () {
		NOTICE_START
			ASK_PASSWD () {
			NOTICE_START
				echo "${bold}enter new $SYSUSERNAME password${normal}"
				until passwd $SYSUSERNAME
				do
				  echo "${bold}enter new $SYSUSERNAME password${normal}"
				done
			NOTICE_END
			}
			useradd -m -g users -G $USERGROUPS -s /bin/bash $SYSUSERNAME
			ASK_PASSWD
		NOTICE_END
		}
		VIRTADMIN_GROUPS () {
		NOTICE_START
			groupadd vboxguest
			gpasswd -a $SYSUSERNAME vboxguest
		NOTICE_END
		}
		ADD_GROUPS
		ADD_USER
		VIRTADMIN_GROUPS
	NOTICE_END
	}