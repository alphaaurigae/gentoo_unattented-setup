INIT() {
	NOTICE_START

	CHRONYD() {
		
		chronyd -q 'server time.cloudflare.com iburst'
	}

	SNTP() {
		sntp -s time.cloudflare.com
	}

	verify_or_exit "time sync (chronyd || sntp)" bash -c '
		chronyd -q "server time.cloudflare.com iburst" ||
		sntp -s time.cloudflare.com
	'

	NOTICE_END
}
