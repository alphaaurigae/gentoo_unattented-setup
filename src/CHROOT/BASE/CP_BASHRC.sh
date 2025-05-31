CP_BASHRC () {  # (!NOTE: custom .bashrc) (!changeme)
NOTICE_START
	local SRC="/gentoo_unattented-setup/configs/default/.bashrc.sh"
	local DST="/etc/skel/.bashrc"
	cp "$SRC" "$DST" && VERIFY_COPY "$SRC" "$DST"
	cat "$DST"
NOTICE_END
}