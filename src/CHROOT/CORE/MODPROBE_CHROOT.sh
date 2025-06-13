MODPROBE_CHROOT() {
	NOTICE_START
	modprobe -a dm-mod dm-crypt sha256 aes aes_generic xts
	NOTICE_END
}
