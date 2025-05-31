	COPY_CONFIGS () {
	NOTICE_START

		EBUILD () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Gentoo_ebuild_repository
		NOTICE_START
			local SRC="$CHROOTX/usr/share/portage/config/repos.conf"
			local DST="$CHROOTX/etc/portage/repos.conf/gentoo.conf"

			mkdir --parents "$CHROOTX/etc/portage/repos.conf"
			cp "$SRC" "$DST" && VERIFY_COPY "$SRC" "$DST"



			#cp $CHROOTX/usr/share/portage/config/repos.conf $CHROOTX/etc/portage/repos.conf/gentoo.conf  # copy the Gentoo repository configuration file provided by Portage to the (newly created) repos.conf directory.

			# cat $CHROOTX/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
		NOTICE_END
		}                                      
		RESOLVCONF () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Copy_DNS_info
		NOTICE_START
			local SRC="/etc/resolv.conf"
			local DST="$CHROOTX/etc/resolv.conf"

			cp --dereference "$SRC" "$DST" && VERIFY_COPY "$SRC" "$DST"

			# cp --dereference /etc/resolv.conf $CHROOTX/etc/
		NOTICE_END
		}
		EBUILD
		RESOLVCONF
	NOTICE_END
	}