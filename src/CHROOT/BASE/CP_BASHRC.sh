CP_BASHRC () {  # (!NOTE: custom .bashrc) (!changeme)
	NOTICE_START
		cp /gentoo_unattented-setup/configs/default/.bashrc.sh /etc/skel/.bashrc
		cat /etc/skel/.bashrc
	NOTICE_END
	}