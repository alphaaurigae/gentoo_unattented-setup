	INIT () {  # (!NOTE:: in this section the script starts off with everything that has to be done prior to the setup action.)
	NOTICE_START
		ntpd -q -g   # TIME ... update the system time ... (!important) # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Setting_the_date_and_time
	NOTICE_END
	}