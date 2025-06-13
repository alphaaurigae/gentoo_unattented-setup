ESELECT_PROFILE() {
	NOTICE_START
	eselect profile list
	eselect profile set $ESELECT_PROFILE
	eselect profile show
	NOTICE_END
}
