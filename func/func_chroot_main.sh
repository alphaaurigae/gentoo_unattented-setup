# Variables defined in var/var_main.sh  && var/chroot_variables.sh
# APPAPP_EMERGE variable defined in src/CHROOT scripts per application to emerge the application and set keywords and package useflags to avoid typing repeat. ex  linux-firmware APPAPP_EMERGE="sys-kernel/linux-firmware "
# Systemd is placeholder / mockup.

EMERGE_USERAPP_DEF() {
	NOTICE_START
	printf "%s%s%s\n" "${BOLD}${CYAN}" "START:" "${RESET}" " emerging $APPAPP_EMERGE "
	emerge $APPAPP_EMERGE
	NOTICE_END
}
EMERGE_USERAPP_RD1() {
	NOTICE_START
	printf "%s%s%s\n" "${BOLD}${CYAN}" "START:" "${RESET}" " emerging ${!APPAPP_EMERGE}"
	emerge ${!APPAPP_EMERGE} # Note!: For redirected var.)
	NOTICE_END
}
NOTICE_PLACEHOLDER() {
	NOTICE_START
	printf '%s\n' "nothing todo here"
	NOTICE_END
}
ENVUD() {
	NOTICE_START
	env-update
	source /etc/profile
	NOTICE_END
}
ACC_KEYWORDS_USERAPP() { # Package use keywords defined in unattented-setup/var/chroot_variables.sh $PRESET_ACCEPT_KEYWORDS
	NOTICE_START
	touch /etc/portage/package.accept_keywords/common
	sed -ie "s#$APPAPP_EMERGE $PRESET_ACCEPT_KEYWORDS##g" /etc/portage/package.accept_keywords/common
	printf '%s\n' "$APPAPP_EMERGE $PRESET_ACCEPT_KEYWORDS" >>/etc/portage/package.accept_keywords/common
	NOTICE_END
}

APPAPP_NAME_SIMPLE="$(printf '%s\n' "$APPAPP_EMERGE" | sed -e "s#/# #g" | awk '{print $2}')" # Get the name of the app.
PORTAGE_USE_DIR="/etc/portage/package.use"

PACKAGE_USE() { # Package USE variables in var/chroot_variables.sh
	NOTICE_START
	SETVAR_PACKAGE_USE() {
		NOTICE_START
		x=$(printf '%s' 'USEFLAGS_')
		x+=$(printf '%s' "$APPAPP_EMERGE" | sed -e "s#/# #g" | awk '{print $2}' | sed -e 's/-/_/g' | sed -e 's/://g' | tr [:lower:] [:upper:])
		combined=${!x}
		printf '%s\n' "${!x}"
		o=$(printf '%s' "$PORTAGE_USE_DIR")
		o+=$(printf '%s' "$APPAPP_NAME_SIMPLE")

		m="$(printf '%s\n' "$APPAPP_EMERGE ")"
		m+="$(printf '%s\n' " ")"
		m+=${!x}
		NOTICE_END
	}
	SETVAR_PACKAGE_USE
	printf '%s\n' "$m" >/etc/portage/package.use/$(printf '%s\n' "$APPAPP_EMERGE" | sed -e "s#/# #g" | awk '{print $2}')
	NOTICE_END
}
AUTOSTART_DEFAULT_OPENRC() {
	NOTICE_START
	rc-update add "$AUTOSTART_NAME_OPENRC" default
	rc-service $AUTOSTART_NAME_OPENRC start
	rc-service $AUTOSTART_NAME_OPENRC restart
	NOTICE_END
}
AUTOSTART_DEFAULT_SYSTEMD() {
	NOTICE_START
	systemctl enable "$AUTOSTART_NAME_SYSTEMD".service
	systemctl start $AUTOSTART_NAME_SYSTEMD.service
	systemctl daemon-reload
	NOTICE_END
}
AUTOSTART_BOOT_OPENRC() {
	NOTICE_START
	rc-update add $AUTOSTART_NAME_OPENRC boot
	rc-service $AUTOSTART_NAME_OPENRC start
	rc-service $AUTOSTART_NAME_OPENRC restart
	NOTICE_END
}
AUTOSTART_BOOT_SYSTEMD() {
	NOTICE_START
	systemctl enable "$AUTOSTART_NAME_SYSTEMD".service
	systemctl start $AUTOSTART_NAME_SYSTEMD.service
	systemctl daemon-reload
	NOTICE_END
}
LICENSE_SET() {
	NOTICE_START
	mkdir -p /etc/portage/package.license
	# sed -ie "/$APPAPP_EMERGE @BINARY-REDISTRIBUTABLE/d" /etc/portage/package.license/$(printf '%s\n' "$APPAPP_EMERGE" | sed -e "s#/# #g" | awk  '{print $2}')
	printf '%s\n' "$APPAPP_EMERGE @BINARY-REDISTRIBUTABLE" >/etc/portage/package.license/$(printf '%s\n' "$APPAPP_EMERGE" | sed -e "s#/# #g" | awk '{print $2}')
	NOTICE_END
}
EMERGE_ATWORLD() {
	NOTICE_START
	printf "%s%s%s\n" "${BOLD}${CYAN}" "START:" "${RESET}" " emerge --sync"
	emerge --sync
	printf "%s%s%s\n" "${BOLD}${CYAN}" "START:" "${RESET}" " emerge --update --deep --newuse --with-bdeps=y @world"
	emerge --update --deep --newuse --with-bdeps=y @world
	printf "%s%s%s\n" "${BOLD}${CYAN}" "START:" "${RESET}" " emerge --depclean"
	emerge --depclean
	printf "%s%s%s\n" "${BOLD}${CYAN}" "START:" "${RESET}" " emerge @preserved-rebuild"
	emerge @preserved-rebuild
	NOTICE_END
}

