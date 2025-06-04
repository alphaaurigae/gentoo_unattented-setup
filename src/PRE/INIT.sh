	INIT () {  # (!NOTE:: in this section the script starts off with everything that has to be done prior to the setup action.)
	NOTICE_START
                # NTPD () {
                #         # depr
                #         emerge --ask net-misc/ntp  # overload
		#         ntpd -q -g   # TIME ... update the system time ... (!important) # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Setting_the_date_and_time
                #         ntpd -q -g 2>&1 | tee /var/log/ntpd-sync.log
                #}
        CHRONYD() {
                if chronyd -q 'server pool.ntp.org iburst' >/dev/null 2>&1; then
                        printf '%s\n' "chronyd: ok"
                        return 0
                else
                        printf '%s\n' "chronyd: fail"
                        return 1
                fi
                }

        SNTP() {
                if sntp -s pool.ntp.org >/dev/null 2>&1; then
                        printf '%s\n' "sntp: ok"
                        return 0
                else
                        printf '%s\n' "sntp: fail"
                        return 1
                fi
                }
                CHRONYD
                # SNTP
	NOTICE_END
	}