CP_BASHRC () {  # (!NOTE: custom .bashrc) (!changeme)
	NOTICE_START
		cp /.bashrc.sh /etc/skel/.bashrc
		cat /etc/skel/.bashrc
	NOTICE_END
	}