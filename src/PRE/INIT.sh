INIT() {
	NOTICE_START

	CHRONYD() {
		chronyd -q "server $NTP_SERVER_PRE iburst" || { printf "%s\n" "${BOLD}${RED}ERROR:${RESET} Chronyd SYNC failed" >&2; exit 1; }

	}

	#SNTP() {
	#	sntp -s $NTP_SERVER_PRE || { printf "%s\n" "${BOLD}${RED}ERROR:${RESET} sntp SYNC failed" >&2; exit 1; }
	#}
	CHRONYD

	NOTICE_END
}