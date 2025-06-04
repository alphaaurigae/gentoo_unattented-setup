		. /gentoo_unattented-setup/var/var_main.sh

		# CHROOT ENV
		SOURCE_CHROOT () {  # function may not belong in vars but lazy to sort this in functions and possibly debug again ...
		NOTICE_START
			env-update
			source /etc/profile
			export PS1="(chroot) $PS1"
		NOTICE_END
		}
		SOURCE_CHROOT  # (must run before CHROOT VARIABLES??)

		# BASE
		### INITSYSTEM
		SYSINITVAR="OPENRC"  # OPENRC (!default); SYSTEMD (!todo) # used script wide to choose install routine for based on initsystem


		
		# ESELECT PROFILE  # https://wiki.gentoo.org/wiki/Profile_(Portage)
		ESELECT_PROFILE="41"  # used in run.sh and gentoo_unattented-setup/src/CHROOT/BASE/ESELECT_PROFILE.sh
		# AS OF 17.09.2022 | AMD64/17.1 (stable)

		## LOCALES TIME / DATE MAIN
		SYSDATE_MAN="071604551969"  # hack time :)  # use in gentoo_unattented-setup/src/CHROOT/BASE/SYSTEMTIME.sh
		SYSCLOCK_SET="AUTO"  # USE AUTO (!default) / MANUAL -- MANUAL="NO TIMESYNCED SERVICE"   # use in gentoo_unattented-setup/src/CHROOT/BASE/SYSTEMTIME.sh
		SYSCLOCK_MAN="1969-07-16 04:55:42"  # hack time :)   # use in gentoo_unattented-setup/src/CHROOT/BASE/SYSTEMTIME.sh
		SYSTIMEZONE_SET="UTC"  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Timezone # https://wiki.gentoo.org/wiki/System_time#Time_zone   # use in gentoo_unattented-setup/src/CHROOT/BASE/SYSTEMTIME.sh



		# CORE
		### KERNEL
		INSTALLKERNEL="true" # true/false to use installkernel https://wiki.gentoo.org/wiki/Installkernel
		KERNDEPLOY="MANUAL"  # (!default); AUTO (genkernel)  # use in gentoo_unattented-setup/src/CHROOT/CORE/KERNEL.sh
		KERNVERS="5.3-rc4"  # for MANUAL setup  # use in gentoo_unattented-setup/src/CHROOT/CORE/KERNEL.sh
		KERNSOURCES="EMERGE"  # EMERGE (!default) ; TORVALDS (git repository)  # use in gentoo_unattented-setup/src/CHROOT/CORE/KERNEL.sh
		KERNCONFD="PASTE" # PASTE  # DEFCONFIG  # use in gentoo_unattented-setup/src/CHROOT/CORE/KERNEL.sh

		### INITRAMFS
		GENINITRAMFS="DRACUT"  # DRACUT (!default); GENKERNEL  # use in gentoo_unattented-setup/src/CHROOT/CORE/INITRAM.sh
		
		# GENKERNEL
		GENKERNEL_CMD="--luks --lvm --no-zfs all"  # use in gentoo_unattented-setup/src/CHROOT/CORE/INITRAM.sh
		# DRACUT
		## DRACUT_CONF
		# just removed gensplash "ERR dracut: dracut module 'gensplash' cannot be found or installed."
		# <key>+=" <values> ": <values> should have surrounding white spaces!
		DRACUT_CONF_MODULES_LVM=" i18n kernel-modules rootfs-block udev-rules usrmount base fs-lib shutdown lvm debug dm "  # for LVM on /dev/sd**  (CRYPSETUP="NO" /var/var_main )  # use in  gentoo_unattented-setup/src/CHROOT/CORE/INITRAM.sh
		DRACUT_CONF_MODULES_CRYPTSETUP=" i18n kernel-modules rootfs-block udev-rules usrmount base fs-lib shutdown crypt crypt-gpg lvm debug dm "  # for LVM on cryptsetup /dev/sd** (CRYPSETUP="YES" /var/var_main )  # use in  gentoo_unattented-setup/src/CHROOT/CORE/INITRAM.sh
		DRACUT_CONF_HOSTONLY="yes"  # use in  gentoo_unattented-setup/src/CHROOT/CORE/INITRAM.sh
		DRACUT_CONF_LVMCONF="yes"  # use in  gentoo_unattented-setup/src/CHROOT/CORE/INITRAM.sh
		#DRACUT_CONFD_ADD_DRACUT_MODULES="usrmount"  # use in  gentoo_unattented-setup/src/CHROOT/CORE/INITRAM.sh
		##INITRAMFSVAR="--lvm --mdadm"  # was used in gentoo_unattented-setup/src/CHROOT/CORE/INITRAM.sh, not defined atm

		### BOOT
		BOOTLOADER="GRUB2"  # GRUB2 (!default)  # used in /gentoo_unattented-setup/src/CHROOT/CORE/SYSBOOT.sh
		GRUB_PRELOAD_MODULES_CRYPTSETUP="cryptodisk luks luks2 lvm ext2 part_msdos part_gpt gcry_*"
		GRUB_PRELOAD_MODULES_DEFAULT="cryptodisk luks luks2 lvm ext2 part_msdos part_gpt gcry_*"
		# BIOS / UEFI defined in var_main.sh as its needed for partitioning too.

		## SYSAPP
		### CRON
		CRON="CRONIE"  # CRONIE (!default), DCRON, ANACRON ..... see on your own  # used in /gentoo_unattented-setup/src/CHROOT/CORE/SYSPROCESS.sh

		# FSTOOLS -- (note!: this is not activating kernel settings yet - solely for FSTOOLS) # (note!: kernel configuration for filesystems not automated yet)
		# placeholder? check later
		FSTOOLS_EXT="YES"
		FSTOOLS_XFS="NO"
		FSTOOLS_REISER="NO"
		FSTOOLS_JFS="NO"
		FSTOOLS_VFAT="NO"
		FSTOOLS_BTRFS="NO"

		## LOG
		SYSLOG="SYSLOGNG"   # used in gentoo_unattented-setup/src/CHROOT/CORE/APPADMIN.sh      

		# SYSAPP_ YES / NO
		SYSAPP_DMCRYPT="YES" # use in gentoo_unattented-setup/var/chroot_variables.sh && gentoo_unattented-setup/src/CHROOT/BASE/MAKECONF.sh
		SYSAPP_LVM2="YES"  # must be set to YES, required with all setups for now - lvm on root and lvm on cryptsetup
		SYSAPP_SUDO="YES"
		SYSAPP_PCIUTILS="YES"
		SYSAPP_MULTIPATH="YES"
		SYSAPP_GNUPG="NO"
		SYSAPP_OSPROBER="YES"
		SYSAPP_SYSLOG="NO"
		SYSAPP_CRON="NO"
		SYSAPP_FILEINDEXING="NO"

		## NETWORK - https://en.wikipedia.org/wiki/Public_recursive_name_server  # use in gentoo_unattented-setup/src/CHROOT/CORE/NETWORK.sh
		HOSTNAME="gentoo"  # (!changeme) define hostname 
		DOMAIN="gentoo"  # (!changeme) define domain  
		NETWORK_NET="DHCPD"  # DHCPD or STATIC, config static on your own in the network section. 
		NETIFACE_MAIN="enp0s3"  # eth0  
		NETWMGR="NETWORKMANAGER"  # NETIFRC; DHCPD; NETWORKMANAGER  

		# DNS
		# NAMESERVER1_IPV4=1.1.1.1  # (!changeme) 1.1.1.1 ns1 cloudflare ipv4
		# NAMESERVER1_IPV6=2606:4700:4700::1111  # (!changeme) ipv6 ns1 2606:4700:4700::1111 cloudflare ipv6
		# NAMESERVER2_IPV4=1.0.0.1  # (!changeme) 1.0.0.1 ns2 cloudflare ipv4
		# NAMESERVER2_IPV6=2606:4700:4700::1001  # (!changeme) ipv6 ns2 2606:4700:4700::1001 cloudflare ipv6

		# VIRTUALIZATION
		SYSVARD="GUEST"  # host is GUEST & HOST ... for virtualbization setup  # used in gentoo_unattented-setup/src/CHROOT/CORE/APPEMULATION.sh

		# DISPLAY / SCREEN  # use in gentoo_unattented-setup/src/CHROOT/SCREENDSP/WINDOWSYS.sh
		DISPLAYSERV="X11"  # see options
		DISPLAYMGR_YESNO="W_D_MGR"  # W_D_MGR (WITH display manager) / SOLO (without display manager)
		DISPLAYMGR="LXDM"  # CDM; GDM; LIGHTDM; LXDM (!default - other env untested / todo); QINGY; SSDM; SLIM; WDM; XDM  # sample, check the section for valid setups,
		DESKTOPENV="XFCE"  # XFCE (!default - other env untested / todo); BUDGIE; CINNAMON; FVWM; GNOME; KDE; LXDE; LXQT; LUMINA; MATE; PANTHEON; RAZORQT; TDE; # sample, check the section for valid setups,

		# X11
		## X11 KEYBOARD  # use in gentoo_unattented-setup/src/CHROOT/SCREENDSP/WINDOWSYS.sh
		X11_KEYBOARD_XKB_VARIANT="altgr-intl,abnt2"
		X11_KEYBOARD_XKB_OPTIONS="grp:shift_toggle,grp_led:scroll"
		X11_KEYBOARD_MATCHISKEYBOARD="on"

		# GRAPHIC UNIT  # use in gentoo_unattented-setup/src/CHROOT/CORE/GPU.sh
		#GPU_SET=amdgpu  # (!changeme) amdgpu, radeon # (!todo)

		# USERAPP
		USERAPP_GIT="NO"  # (!todo)
		USERAPP_FIREFOX="YES"
		USERAPP_CHROMIUM="NO"  # (!NOTE !todo !bug ..)
		USERAPP_MIDORI="NO"  # (!NOTE: some unmask thing .. ruby?)  # https://astian.org/en/midori-browser/

		## USER
		SYSUSERNAME="admini"  # (!changeme) wheel group member - name of the login sysadmin user  # use in gentoo_unattented-setup/src/CHROOT/USERS/ADMIN.sh && /gentoo_unattented-setup/src/CHROOT/SCREENDSP/DESKTOP_ENV.sh
		USERGROUPS="wheel plugdev power video"  # (!NOTE: virtualbox groups set if guest / host system is set)  # use in gentoo_unattented-setup/src/CHROOT/USERS/ADMIN.sh
		
		# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		# USEFLAGS # used with gentoo_unattented-setup/func/func_chroot_main.sh to set the useflags with emegred packages in gentoo_unattented-setup/src/CHROOT/*
		

		# SET USEFLAGS (!NOTE: names follow a pattern which must be kept for functions to read it ... "USERFLADS_"emerge_ name"  : "-" is replaced with "_" and lower converted to uppercase letters)
		USEFLAGS_INSTALLKERNEL="dracut grub"  # https://wiki.gentoo.org/wiki/Installkernel

		USEFLAGS_LINUX_FIRMWARE="initramfs redistributable unknown-license"  # https://packages.gentoo.org/packages/sys-kernel/linux-firmware https://wiki.gentoo.org/wiki/Linux_firmware

		#CRYPTSETUP
		USEFLAGS_CRYPTSETUP="udev argon2 "  # udev global enough? https://packages.gentoo.org/packages/sys-fs/cryptsetup

		# INITRAM
		USEFLAGS_DRACUT="device-mapper"  # devicemapper dated?  https://wiki.gentoo.org/wiki/Dracut https://packages.gentoo.org/packages/sys-kernel/dracut

		# KERNEL
		USEFLAGS_GENKERNEL="cryptsetup"
		
		#AUDIO
		# USEFLAGS_ALSA=""  # https://packages.gentoo.org/packages/media-sound/alsa-utils  https://wiki.gentoo.org/wiki/ALSA
		USEFLAGS_PULSEAUDIO=""  # https://packages.gentoo.org/packages/media-sound/pulseaudio https://wiki.gentoo.org/wiki/PulseAudio

		# SCREENDSP
		USEFLAGS_XORG_SERVER="xvfb"  # https://packages.gentoo.org/packages/x11-base/xorg-server https://wiki.gentoo.org/wiki/Xorg 
		USEFLAGS_XFCE4_META="gtk3 gcr"  # https://packages.gentoo.org/packages/xfce-base/xfce4-meta https://wiki.gentoo.org/wiki/Xfce

		# NETWORK
		USEFLAGS_NETWORKMANAGER="dhcpcd -modemmanager -ppp"  # https://packages.gentoo.org/packages/net-misc/networkmanager https://wiki.gentoo.org/wiki/NetworkManager
		
		# BOOTLOADER
		USEFLAGS_GRUB2="fonts device-mapper mount nls "  # https://packages.gentoo.org/packages/sys-boot/grub https://wiki.gentoo.org/wiki/GRUB2
		
		# VIRTUALBOX
		USEFLAGS_VIRTUALBOX_GUEST_ADDITIONS="X"  # https://packages.gentoo.org/packages/app-emulation/virtualbox-guest-additions

		# WEBBROWSER 
		USEFLAGS_FIREFOX="bindist eme-free geckodriver hwaccel jack -system-libvpx -system-icu"  # https://packages.gentoo.org/packages/www-client/firefox
		USEFLAGS_CHROMIUM="official -cups -hangouts -kerberos -screencast -pic"  # https://packages.gentoo.org/packages/www-client/chromium # https://wiki.gentoo.org/wiki/Chromium
		USEFLAGS_MIDORI=""