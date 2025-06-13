INIT() {
	NOTICE_START

	CHRONYD() {
		chronyd -q 'server pool.ntp.org iburst'
	}

	SNTP() {
		sntp -s pool.ntp.org
	}

	verify_or_exit "time sync (chronyd || sntp)" bash -c '
		chronyd -q "server pool.ntp.org iburst" ||
		sntp -s pool.ntp.org
	'

	NOTICE_END
}
