	COPY_CONFIGS () {
	NOTICE_START
		EBUILD () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Gentoo_ebuild_repository
		NOTICE_START
			mkdir --parents $CHROOTX/etc/portage/repos.conf
			cp $CHROOTX/usr/share/portage/config/repos.conf $CHROOTX/etc/portage/repos.conf/gentoo.conf  # copy the Gentoo repository configuration file provided by Portage to the (newly created) repos.conf directory.
			# cat $CHROOTX/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
		NOTICE_END
		}                                      
		RESOLVCONF () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Copy_DNS_info
		NOTICE_START
			cp --dereference /etc/resolv.conf $CHROOTX/etc/
		NOTICE_END
		}
		EBUILD
		RESOLVCONF
	NOTICE_END
	}