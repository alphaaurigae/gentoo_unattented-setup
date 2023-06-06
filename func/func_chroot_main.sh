# variables defined in gentoo_unattented-setup/var/var_main.sh  && /home/a/Desktop/gentoo_unattented-setup/var/chroot_variables.sh
# func chroot main
# APPAPP_EMERGE variable defined in src/CHROOT scripts per application to emerge the application and set keywords and package useflags to avoid typing repeat. ex  linux-firmware APPAPP_EMERGE="sys-kernel/linux-firmware " 
# only openrc things implemented yet, systemd is placeholder or mockup,

EMERGE_USERAPP_DEF () {
NOTICE_START
	echo "emerging $APPAPP_EMERGE "
	emerge $APPAPP_EMERGE
NOTICE_END
}
EMERGE_USERAPP_RD1 () {
NOTICE_START
	echo "emerging ${!APPAPP_EMERGE}"
	emerge ${!APPAPP_EMERGE}  # (note!: for redirected var.)
NOTICE_END
}
NOTICE_PLACEHOLDER () {
NOTICE_START
	echo "nothing todo here"
NOTICE_END
}
ENVUD () {
NOTICE_START
	env-update
	source /etc/profile
NOTICE_END
}
ACC_KEYWORDS_USERAPP () {  # package use keywords defined in unattented-setup/var/chroot_variables.sh $PRESET_ACCEPT_KEYWORDS
NOTICE_START
	touch /etc/portage/package.accept_keywords/common
	sed -ie "s#$APPAPP_EMERGE $PRESET_ACCEPT_KEYWORDS##g" /etc/portage/package.accept_keywords/common
	echo "$APPAPP_EMERGE $PRESET_ACCEPT_KEYWORDS" >> /etc/portage/package.accept_keywords/common
NOTICE_END
}
# probably should be in variable file but want to get done quick..
APPAPP_NAME_SIMPLE="$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}')"  # get the name of the app (!NOTE: fetch EMERGE_USERAPP_DEF --> remove slash --> show second coloumn = name
PORTAGE_USE_DIR="/etc/portage/package.use"
######
PACKAGE_USE () {  # package use variables in gentoo_unattented-setup/var/chroot_variables.sh
NOTICE_START
	SETVAR_PACKAGE_USE () {
	NOTICE_START
		x=$(echo 'USEFLAGS_')
		x+=$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}' | sed -e 's/-/_/g'  | sed -e 's/://g' | tr [:lower:] [:upper:])
		combined=${!x}
		echo "${!x}"
		o=$(echo $PORTAGE_USE_DIR)
		o+=$(echo $APPAPP_NAME_SIMPLE)

		m="$( printf '%s\n' "$APPAPP_EMERGE " )"
		m+="$(echo " ")"
		m+=${!x}
	NOTICE_END
	}
	SETVAR_PACKAGE_USE
	printf '%s\n' "$m"  > /etc/portage/package.use/$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}')  #  variable only works here and not if forwarded from above.
NOTICE_END
}
AUTOSTART_DEFAULT_OPENRC () {
NOTICE_START
	rc-update add $AUTOSTART_NAME_OPENRC default
NOTICE_END
}
AUTOSTART_DEFAULT_SYSTEMD () { (!todo)
NOTICE_START
	systemctl enable dbus.service 
	systemctl start dbus.service
	systemctl daemon-reload
NOTICE_END
}
AUTOSTART_BOOT_OPENRC () {
NOTICE_START
	rc-service $AUTOSTART_NAME_OPENRC start
	rc-update add $AUTOSTART_NAME_OPENRC boot
	rc-service $AUTOSTART_NAME_OPENRC restart
NOTICE_END
}
AUTOSTART_BOOT_SYSTEMD () {
NOTICE_START
	NOTICE_PLACEHOLDER
	systemctl enable $AUTOSTART_NAME_SYSTEMD
	# systemctl enable $AUTOSTART_BOOT_SYSTEMD@.service # https://www.freedesktop.org/software/systemd/man/systemd-cryptsetup@.service.html
NOTICE_END
}
LICENSE_SET () {
NOTICE_START
	mkdir -p /etc/portage/package.license
	#sed -ie "/$APPAPP_EMERGE @BINARY-REDISTRIBUTABLE/d" /etc/portage/package.license/$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}')
	echo "$APPAPP_EMERGE @BINARY-REDISTRIBUTABLE" > /etc/portage/package.license/$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}')
NOTICE_END
}
EMERGE_ATWORLD_A () {
NOTICE_START
	emerge @world  # this is to update after setting the use flag
NOTICE_END
}
EMERGE_ATWORLD_B () {
NOTICE_START
	emerge --changed-use --deep @world
	emerge --update --deep --newuse @world
NOTICE_END
}
# END # func chroot main