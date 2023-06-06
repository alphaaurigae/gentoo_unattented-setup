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
		SYSINITVAR="OPENRC"  # OPENRC (!default); SYSTEMD (!todo)

		# STATIC CUSTOM  # lets make some variables to avoid repeats.
		LANG_MAIN_LOWER="en"
		LANG_MAIN_UPPER="US"
		LANG_SECOND_LOWER="de"
		LANG_SECOND_UPPER="DE"
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		## MAKE.CONF PRESET
		PRESET_CC="gcc"  # gcc (!default); the preset compiler
		# https://wiki.gentoo.org/wiki/ACCEPT_KEYWORDS
		PRESET_ACCEPT_KEYWORDS="amd64" # 1/2 # build 8.9.22 "amd64 ~amd64" - build 7.9.22 # ~amd64" # alone not tested yet # all on profile 1 .  
		# 2/2 # "amd64" = stable  If the user wants to be able to install and work with ebuilds that are not considered production-ready yet, they can add the same architecture but with the ~
		# CHOST # https://wiki.gentoo.org/wiki/CHOST
		PRESET_CHOST_ARCH="x86_64"
		PRESET_CHOST_VENDOR="pc"
		PRESET_CHOST_OS="linux"
		PRESET_CHOST_LIBC="gnu"
 		# https://wiki.gentoo.org/wiki/CHOST https://wiki.gentoo.org/wiki/GCC_optimization
		PRESET_CPU_FLAGS_X86="$(if [[ $(lscpu | grep Flags:) =~ "ssse3" ]]; then echo "$(lscpu | grep Flags: | sed -e 's/^\w*\ *//' | sed 's/: //g' ) sse3 sse4a "; fi)"  # 1/2 # workaround to insert sse3 and sse4a -
		# 2/2 intentianal, no idea if requ - testing…
		PRESET_MARCH="native" # "znver1"  # 1/2 default "native"; see "safe_cflags" & may dep kern settings; proc arch specific https://wiki.gentoo.org/wiki/Ryzen znver1 = Zen 1; znver2 = Zen2 
		# 2/2 # https://wiki.gentoo.org/wiki/Safe_CFLAGS#Finding_the_CPU (!NOTE: fetch before PRESET_CFLAGS, see MAKEFILE)
		PRESET_CFLAGS="-march=$PRESET_MARCH -O2 -pipe"  # https://wiki.gentoo.org/wiki/Safe_CFLAGS
		PRESET_CXXFLAGS="${PRESET_CFLAGS}"
		PRESET_FCFLAGS="${PRESET_CFLAGS}"
		PRESET_FFLAGS="${PRESET_CFLAGS}"
		# clone https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#CFLAGS_and_CXXFLAGS
		PRESET_INPUTEVICE="libinput keyboard"
		PRESET_VIDEODRIVER="virtualbox"  # amdgpu, radeonsi, radeon, virtualbox ; (!NOTE: if running in virtualbox and intend to build firefox - run KVM and set to your hardware ... "avx2 error firefox")
		PRESET_LICENCES="*"  # default is: "-* @FREE" Only accept licenses in the FREE license group (i.e. Free Software) (!todo)

		# https://www.gentoo.org/support/use-flags/
		# cjk why?
		# hardened flag but no hardened image, why?
		# SEE CRYPSETUP $SYSAPP_DMCRYPT bwlow for comment on crypsetup
		PRESET_USEFLAG_LVMROOTNOCRYPOPT="X a52 aac aalib acl acpi apng apparmor audit alsa bash-completion boost branding bzip2 \
				cpudetection cjk cxx dbus elogind ffmpeg git gtk gtk3 gzip \
				hardened initramfs int64 lzma lzo mount opengl pulseaudio jack policykit postproc secure-delete \
				sqlite threads udev udisks unicode zip \
				-consolekit -cups -bluetooth -libnotify -modemmanager -mysql -apache -apache2 -dropbear -redis \
				-systemd -mssql -postgres -ppp -telnet"
		PRESET_USEFLAG_CRYPTOPTANDCRYPTSETUP="X a52 aac aalib acl acpi apng apparmor audit alsa bash-completion boost branding bzip2 \
				cpudetection cjk crypt cryptsetup cxx dbus elogind ffmpeg git gtk gtk3 gzip \
				hardened initramfs int64 lzma lzo mount opengl pulseaudio jack policykit postproc secure-delete \
				sqlite threads udev udisks unicode zip \
				-consolekit -cups -bluetooth -libnotify -modemmanager -mysql -apache -apache2 -dropbear -redis \
				-systemd -mssql -postgres -ppp -telnet"
		# mount sandbox missing?
		# noman, srsly?
		# sandbox maybe?
		# userpriv and sandbox?
		##collision-protect  removed for protect-owned as linux-firmware failed emerging cpio
		PRESET_FEATURES="sandbox binpkg-docompress binpkg-dostrip candy cgroup binpkg-logs \
				downgrade-backup ebuild-locks fail-clean fixlafiles ipc-sandbox merge-sync \
				network-sandbox noman parallel-fetch parallel-install pid-sandbox userpriv usersandbox "

		# https://www.gentoo.org/downloads/mirrors/
		PRESET_GENTOMIRRORS="http://gentoo-mirror.flux.utah.edu"

		PRESET_MAKE="-j$(expr $(nproc) "*" 1) --quiet "
		PRESET_EMERGE_LOAD="30"
		PRESET_EMERGE_DEFAULT_OPTS="--quiet --complete-graph --verbose --update --deep --newuse --jobs $PRESET_EMERGE_JOBS --load-average $PRESET_EMERGE_LOAD"
		PRESET_PORTDIR="/var/db/repos/gentoo"
		PRESET_DISTDIR="/var/cache/distfiles"
		PRESET_PKGDIR="/var/cache/binpkgs"
		PRESET_PORTAGE_TMPDIR="/var/tmp"
		PRESET_PORTAGE_LOGDIR="/var/log/portage"
		PRESET_PORTAGE_ELOG_CLASSES="log warn error"
		PRESET_PORTAGE_ELOG_SYSTEM="echo save"
		PRESET_LINGUAS="$LANG_MAIN_LOWER $LANG_MAIN_LOWER-$LANG_MAIN_UPPER $LANG_SECOND_LOWER $LANG_SECOND_LOWER-$LANG_SECOND_UPPER"
		PRESET_L10N="$LANG_MAIN_LOWER $LANG_MAIN_LOWER-$LANG_MAIN_UPPER $LANG_SECOND_LOWER $LANG_SECOND_LOWER-$LANG_SECOND_UPPER"
		PRESET_LC_MESSAGES="C"
		# PRESET_CURL_SSL="$SSLD_CONF"
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
		# ESELECT PROFILE  # https://wiki.gentoo.org/wiki/Profile_(Portage)
		ESELECT_PROFILE="3"
		# AS OF 17.09.2022 | AMD64/17.1 (stable)

		# LOCALES
		# LOCALES / LANG MAIN 
		PRESET_LOCALE_A=$LANG_MAIN_LOWER\_$LANG_MAIN_UPPER # lang set 1 # set ISO-8859-1 & UTF-8 locales in  /etc/locale.gen 
		PRESET_LOCALE_B=$LANG_SECOND_LOWER\_$LANG_SECOND_UPPER # lang set 2 # "

		# LOCALES LANG KEYMAPS MAIN
		KEYMAP="de" # set common (!channgeme)
		CONSOLEFONT="default8x16" # https://wiki.gentoo.org/wiki/Fonts

		## LOCALES TIME / DATE MAIN
		SYSDATE_MAN="071604551969"  # hack time :)
		SYSCLOCK_SET="AUTO"  # USE AUTO (!default) / MANUAL -- MANUAL="NO TIMESYNCED SERVICE"
		SYSCLOCK_MAN="1969-07-16 04:55:42"  # hack time :)
		SYSTIMEZONE_SET="UTC"  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Timezone # https://wiki.gentoo.org/wiki/System_time#Time_zone

		# CORE
		### KERNEL
		KERNDEPLOY="MANUAL"  # (!default); AUTO (genkernel)
		KERNVERS="5.3-rc4"  # for MANUAL setup
		KERNSOURCES="EMERGE"  # EMERGE (!default) ; TORVALDS (git repository)
		KERNCONFD="PASTE" # PASTE  # DEFCONFIG

		### INITRAMFS
		GENINITRAMFS="DRACUT"  # DRACUT (!default); GENKERNEL
		
		# GENKERNEL
		GENKERNEL_CMD="--luks --lvm --no-zfs all"
		# DRACUT
		## DRACUT_CONF
		# just removed gensplash "ERR dracut: dracut module 'gensplash' cannot be found or installed."
		DRACUT_CONF_MODULES_LVM="i18n kernel-modules rootfs-block udev-rules usrmount base fs-lib shutdown lvm debug dm"  # for LVM on /dev/sd**  (CRYPSETUP="NO" /var/var_main )
		DRACUT_CONF_MODULES_CRYPTSETUP="i18n kernel-modules rootfs-block udev-rules usrmount base fs-lib shutdown crypt crypt-gpg lvm debug dm"  # for LVM on cryptsetup /dev/sd** (CRYPSETUP="YES" /var/var_main )
		DRACUT_CONF_HOSTONLY="yes"
		DRACUT_CONF_LVMCONF="yes"
		#DRACUT_CONFD_ADD_DRACUT_MODULES="usrmount"
		##INITRAMFSVAR="--lvm --mdadm"

		### BOOT
		BOOTLOADER="GRUB2"  # GRUB2 (!default)
		BOOTSYSINITVAR="BIOS"  # BIOS (!default) / UEFI (!prototype)

		## SYSAPP
		### CRON
		CRON="CRONIE"  # CRONIE (!default), DCRON, ANACRON ..... see on your own

		# FSTOOLS -- (note!: this is not activating kernel settings yet - solely for FSTOOLS) # (note!: kernel configuration for filesystems not automated yet)
		FSTOOLS_EXT="YES"
		FSTOOLS_XFS="NO"
		FSTOOLS_REISER="NO"
		FSTOOLS_JFS="NO"
		FSTOOLS_VFAT="NO"
		FSTOOLS_BTRFS="NO"

		## LOG
		SYSLOG="SYSLOGNG"          

		# SYSAPP_ YES / NO
		SYSAPP_DMCRYPT="YES" #
		SYSAPP_LVM2="YES"  # must be set to YES, required with all setups for now - lvm on root and lvm on cryptsetup
		SYSAPP_SUDO="YES"
		SYSAPP_PCIUTILS="YES"
		SYSAPP_MULTIPATH="YES"
		SYSAPP_GNUPG="NO"
		SYSAPP_OSPROBER="YES"
		SYSAPP_SYSLOG="NO"
		SYSAPP_CRON="NO"
		SYSAPP_FILEINDEXING="NO"

		## NETWORK - https://en.wikipedia.org/wiki/Public_recursive_name_server
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
		SYSVARD="GUEST"  # host is GUEST & HOST ... for virtualbization setup

		# DISPLAY / SCREEN
		DISPLAYSERV="X11"  # see options
		DISPLAYMGR_YESNO="W_D_MGR"  # W_D_MGR (WITH display manager) / SOLO (without display manager)
		DISPLAYMGR="LXDM"  # CDM; GDM; LIGHTDM; LXDM (!default - other env untested / todo); QINGY; SSDM; SLIM; WDM; XDM  # sample, check the section for valid setups,
		DESKTOPENV="XFCE"  # XFCE (!default - other env untested / todo); BUDGIE; CINNAMON; FVWM; GNOME; KDE; LXDE; LXQT; LUMINA; MATE; PANTHEON; RAZORQT; TDE; # sample, check the section for valid setups,

		# X11
		## X11 KEYBOARD
		X11_KEYBOARD_XKB_VARIANT="altgr-intl,abnt2"
		X11_KEYBOARD_XKB_OPTIONS="grp:shift_toggle,grp_led:scroll"
		X11_KEYBOARD_MATCHISKEYBOARD="on"

		# GRAPHIC UNIT
		#GPU_SET=amdgpu  # (!changeme) amdgpu, radeon # (!todo)

		# USERAPP
		USERAPP_GIT="NO"  # (!todo)
		USERAPP_FIREFOX="YES"
		USERAPP_CHROMIUM="NO"  # (!NOTE !todo !bug ..)
		USERAPP_MIDORI="NO"  # (!NOTE: some unmask thing .. ruby?)  # https://astian.org/en/midori-browser/

		## USER
		SYSUSERNAME="admini"  # (!changeme) wheel group member - name of the login sysadmin user
		USERGROUPS="wheel,plugdev,power,video"  # (!NOTE: virtualbox groups set if guest / host system is set)
		
		# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		# USEFLAGS # used with gentoo_unattented-setup/func/func_chroot_main.sh to set the useflags with emegred packages in gentoo_unattented-setup/src/CHROOT/*
		
		# SET USEFLAGS (!NOTE: names follow a pattern which must be kept for functions to read it ... "USERFLADS_"emerge_ name"  : "-" is replaced with "_" and lower converted to uppercase letters)
		USEFLAGS_LINUX_FIRMWARE="initramfs redistributable unknown-license"  # https://packages.gentoo.org/packages/sys-kernel/linux-firmware https://wiki.gentoo.org/wiki/Linux_firmware

		#CRYPTSETUP
		USEFLAGS_CRYPTSETUP="udev"  # udev global enough? https://packages.gentoo.org/packages/sys-fs/cryptsetup

		# INITRAM
		USEFLAGS_DRACUT="device-mapper"  # devicemapper dated?  https://wiki.gentoo.org/wiki/Dracut https://packages.gentoo.org/packages/sys-kernel/dracut

		# KERNEL
		USEFLAGS_GENKERNEL="cryptsetup"
		
		#AUDIO
		#USEFLAGS_ALSA=""  ## https://packages.gentoo.org/packages/media-sound/alsa-utils  https://wiki.gentoo.org/wiki/ALSA
		USEFLAGS_PULSEAUDIO=""  # https://packages.gentoo.org/packages/media-sound/pulseaudio https://wiki.gentoo.org/wiki/PulseAudio

		# SCREENDSP
		USEFLAGS_XORG_SERVER="xvfb"  # https://packages.gentoo.org/packages/x11-base/xorg-server https://wiki.gentoo.org/wiki/Xorg 
		USEFLAGS_XFCE4_META="gtk3 gcr"  # https://packages.gentoo.org/packages/xfce-base/xfce4-meta https://wiki.gentoo.org/wiki/Xfce

		# NETWORK
		USEFLAGS_NETWORKMANAGER="dhcpcd -modemmanager -ppp"  # https://packages.gentoo.org/packages/net-misc/networkmanager https://wiki.gentoo.org/wiki/NetworkManager
		
		# BOOTLOADER
		USEFLAGS_GRUB2="fonts"  # https://packages.gentoo.org/packages/sys-boot/grub https://wiki.gentoo.org/wiki/GRUB2
		
		# VIRTUALBOX
		USEFLAGS_VIRTUALBOX_GUEST_ADDITIONS="X"  # https://packages.gentoo.org/packages/app-emulation/virtualbox-guest-additions

		# WEBBROWSER 
		USEFLAGS_FIREFOX="bindist eme-free geckodriver hwaccel jack -system-libvpx -system-icu"  # https://packages.gentoo.org/packages/www-client/firefox
		USEFLAGS_CHROMIUM="official -cups -hangouts -kerberos -screencast -pic"  # https://packages.gentoo.org/packages/www-client/chromium # https://wiki.gentoo.org/wiki/Chromium
		USEFLAGS_MIDORI=""