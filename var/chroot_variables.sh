		# MISC VAR
		bold=$(tput bold)  # (!important)
		normal=$(tput sgr0)  # (!important)
		# these funtions dont belong in a variable file but want to get done quick now 27.8.22
		NOTICE_START () {
			echo "${bold} ${FUNCNAME[1]} ... START ... ${normal}"
		}
		NOTICE_START
		NOTICE_END () {
			echo "${bold}${FUNCNAME[1]}  ... END ... ${normal}"
		}

		# CHROOT ENV
		SOURCE_CHROOT () {
		NOTICE_START
			env-update
			source /etc/profile
			export PS1="(chroot) $PS1"
		NOTICE_END
		}
		SOURCE_CHROOT  # (must run before CHROOT VARIABLES??)

		# CHROOT VARIABLES

		## DRIVES & PARTITIONS
		HDD1=/dev/sda # GENTOO
		# GRUB_PART=/dev/sda1 # bios grub
		BOOT_PART=/dev/sda2 # boot # unencrypted unless required changes are made - see CRYPTSETUP_BOOT 
		MAIN_PART=/dev/sda3 # mainfs - lukscrypt cryptsetup container with LVM env inside

		## SWAP 
		### SWAPFILE  # useful during install on low ram VM's (use KVM to avoid erros; ex firefox avx2 err.)
		SWAPFILE=swapfile1
		SWAPFD=/swapdir # swap-file directory path
		SWAPSIZE=50G  # swap file size with unit APPEND | G = gigabytes
		### SWAP PARTITION
		# SWAP0=swap0  # LVM swap NAME for sorting of swap partitions.
		# SWAP_SIZE="1GB"  # (inside LVM MAIN_PART)
		# SWAP_FS=linux-swap # swapfs

		## FILESYSTEMS  # (note!: FSTOOLS ; FSTAB) (note!: nopt a duplicate - match these above)
		FILESYSTEM_BOOT=ext2  # BOOT
		FILESYSTEM_MAIN=ext4  # GENTOO

		## LVM
		PV_MAIN=pv0crypt  # LVM PV physical volume
		VG_MAIN=vg0crypt  # LVM VG volume group
		LV_MAIN=lv0crypt  # LVM LV logical volume

		# BASE
		### INITSYSTEM
		SYSINITVAR=OPENRC  # OPENRC (!default); SYSTEMD (!todo)

		# STATIC CUSTOM  # lets make some variables to avoid repeats.
		LANG_MAIN_LOWER="en"
		LANG_MAIN_UPPER="US"
		LANG_SECOND_LOWER="de"
		LANG_SECOND_UPPER="DE"

		## MAKE.CONF PRESET
		PRESET_CC=gcc  # gcc (!default); the preset compiler
		# https://wiki.gentoo.org/wiki/ACCEPT_KEYWORDS
		PRESET_ACCEPT_KEYWORDS="amd64 ~amd64" # ~amd64"  # "amd64" = stable  If the user wants to be able to install and work with ebuilds that are not considered production-ready yet, they can add the same architecture but with the ~
		# CHOST # https://wiki.gentoo.org/wiki/CHOST
		PRESET_CHOST_ARCH="x86_64"
		PRESET_CHOST_VENDOR="pc"
		PRESET_CHOST_OS="linux"
		PRESET_CHOST_LIBC="gnu"
 		# https://wiki.gentoo.org/wiki/CHOST https://wiki.gentoo.org/wiki/GCC_optimization
		PRESET_CPU_FLAGS_X86="$(if [[ $(lscpu | grep Flags:) =~ "ssse3" ]]; then echo "$(lscpu | grep Flags: | sed -e 's/^\w*\ *//' | sed 's/: //g' ) sse3 sse4a "; fi)"  # workaround to insert sse3 and sse4a - intentianal, no idea if requ - testing…
		PRESET_MARCH=znver1  # default "native"; see "safe_cflags" & may dep kern settings; proc arch specific https://wiki.gentoo.org/wiki/Ryzen znver1 = Zen 1; znver2 = Zen2  # https://wiki.gentoo.org/wiki/Safe_CFLAGS#Finding_the_CPU (!NOTE: fetch before PRESET_CFLAGS, see MAKEFILE)
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
		PRESET_USEFLAG="X a52 aac aalib acl acpi apng apparmor audit alsa bash-completion boost branding bzip2 \
				cpudetection cjk crypt cryptsetup cxx dbus elogind ffmpeg git gtk gtk+ gtk3 gzip \
				hardened initramfs int64 lzma lzo mount opengl pulseaudio jack policykit postproc secure-delete \
				sqlite threads udev udisks unicode zip \
				-consolekit -cups -bluetooth -libnotify -modemmanager -mysql -apache -apache2 -dropbear -redis \
				-systemd -mssql -postgres -ppp -telnet"
		# mount sandbox missing?
		# noman, srsly?
		# sandbox maybe?
		# userpriv and sandbox?
		PRESET_FEATURES="sandbox binpkg-docompress binpkg-dostrip candy cgroup binpkg-logs collision-protect \
				compress-build-logs downgrade-backup fail-clean fixlafiles force-mirror ipc-sandbox merge-sync \
				network-sandbox noman parallel-fetch parallel-install pid-sandbox userpriv usersandbox"

		# https://www.gentoo.org/downloads/mirrors/
		PRESET_GENTOMIRRORS="https://mirror.eu.oneandone.net/linux/distributions/gentoo/gentoo/ \
					https://ftp.snt.utwente.nl/pub/os/linux/gentoo/ https://mirror.isoc.org.il/pub/gentoo/ \
					https://mirrors.lug.mtu.edu/gentoo/ https://mirror.csclub.uwaterloo.ca/gentoo-distfiles/ \
					https://ftp.jaist.ac.jp/pub/Linux/Gentoo/"

		PRESET_MAKE="-j$(expr $(nproc) "*" 1) --quiet "
		PRESET_EMERGE_LOAD=30
		PRESET_EMERGE_DEFAULT_OPTS="--quiet --complete-graph --verbose --update --deep --newuse --jobs $PRESET_EMERGE_JOBS --load-average $PRESET_EMERGE_LOAD"
		PRESET_PORTDIR="/var/db/repos/gentoo"
		PRESET_DISTDIR="/var/cache/distfiles"
		PRESET_PKGDIR="/var/cache/binpkgs"
		PRESET_PORTAGE_TMPDIR="/var/tmp"
		PRESET_PORTAGE_LOGDIR="/var/log/portage"
		PRESET_PORTAGE_ELOG_CLASSES="log warn error"
		PRESET_PORTAGE_ELOG_SYSTEM="save"
		PRESET_LINGUAS="$LANG_MAIN_LOWER $LANG_MAIN_LOWER-$LANG_MAIN_UPPER $LANG_SECOND_LOWER $LANG_SECOND_LOWER-$LANG_SECOND_UPPER"
		PRESET_L10N="$LANG_MAIN_LOWER $LANG_MAIN_LOWER-$LANG_MAIN_UPPER $LANG_SECOND_LOWER $LANG_SECOND_LOWER-$LANG_SECOND_UPPER"
		PRESET_LC_MESSAGES="C"
		# PRESET_CURL_SSL="$SSLD_CONF"

		# ESELECT PROFILE  # https://wiki.gentoo.org/wiki/Profile_(Portage)
		ESELECT_PROFILE=1
		# AS OF 29.10.2020 | AMD64/17.1 (stable) ; 2. 17.1 selinux; 3. hardened; 4. hardnened + selinux; 5. desktop, 6. desk + gnome; 7. 6+ systemd; 8. desk + plasma ; 9. 8 + systemd; 10 dev; 11. no multilib; ;12. 11+ hardened; 13 12+selkinux; 14 systemd 

		# LOCALES
		# LOCALES / LANG MAIN 
		PRESET_LOCALE_A=$LANG_MAIN_LOWER\_$LANG_MAIN_UPPER # lang set 1 # set ISO-8859-1 & UTF-8 locales in  /etc/locale.gen 
		PRESET_LOCALE_B=$LANG_SECOND_LOWER\_$LANG_SECOND_UPPER # lang set 2 # "

		# LOCALES LANG KEYMAPS MAIN
		KEYMAP="de" # set common (!channgeme)
		CONSOLEFONT="default8x16" # https://wiki.gentoo.org/wiki/Fonts

		## LOCALES TIME / DATE MAIN
		SYSDATE_MAN=071604551969  # hack time :)
		SYSCLOCK_SET=AUTO  # USE AUTO (!default) / MANUAL -- MANUAL="NO TIMESYNCED SERVICE"
		SYSCLOCK_MAN="1969-07-16 04:55:42"  # hack time :)
		SYSTIMEZONE_SET="UTC"  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Timezone # https://wiki.gentoo.org/wiki/System_time#Time_zone

		# CORE
		### KERNEL
		KERNDEPLOY="MANUAL"  # (!default); AUTO (genkernel)
		KERNVERS=5.3-rc4  # for MANUAL setup
		KERNSOURCES=EMERGE  # EMERGE (!default) ; TORVALDS (git repository)
		KERNCONFD="PASTE" # PASTE  # DEFCONFIG

		### INITRAMFS
		GENINITRAMFS=DRACUT  # DRACUT (!default); GENKERNEL
		
		# GENKERNEL
		GENKERNEL_CMD="--luks --lvm --no-zfs all"
		# DRACUT
		## DRACUT_CONF
		# just removed gensplash "ERR dracut: dracut module 'gensplash' cannot be found or installed."
		DRACUT_CONF_MODULES="i18n kernel-modules rootfs-block udev-rules usrmount base fs-lib shutdown crypt crypt-gpg lvm debug dm"
		DRACUT_CONF_HOSTONLY="yes"
		DRACUT_CONF_LVMCONF="yes"
		DRACUT_CONFD_ADD_DRACUT_MODULES="usrmount"
		##INITRAMFSVAR="--lvm --mdadm"

		### BOOT
		BOOTLOADER=GRUB2  # GRUB2 (!default)
		BOOTSYSINITVAR=BIOS  # BIOS (!default) / UEFI (!prototype)

		## SYSAPP
		### CRON
		CRON=CRONIE  # CRONIE (!default), DCRON, ANACRON ..... see on your own

		# FSTOOLS -- (note!: this is not activating kernel settings yet - solely for FSTOOLS) # (note!: kernel configuration for filesystems not automated yet)
		FSTOOLS_EXT=YES
		FSTOOLS_XFS=NO
		FSTOOLS_REISER=NO
		FSTOOLS_JFS=NO
		FSTOOLS_VFAT=NO
		FSTOOLS_BTRFS=NO

		## LOG
		SYSLOG=SYSLOGNG          

		# SYSAPP_ YES / NO
		SYSAPP_DMCRYPT=YES
		SYSAPP_LVM2=YES
		SYSAPP_SUDO=YES
		SYSAPP_PCIUTILS=YES
		SYSAPP_MULTIPATH=YES
		SYSAPP_GNUPG=NO
		SYSAPP_OSPROBER=YES
		SYSAPP_SYSLOG=NO
		SYSAPP_CRON=NO
		SYSAPP_FILEINDEXING=NO

		## NETWORK - https://en.wikipedia.org/wiki/Public_recursive_name_server
		HOSTNAME=gentoo  # (!changeme) define hostname
		DOMAIN=gentoo  # (!changeme) define domain
		NETWORK_NET=DHCPD  # DHCPD or STATIC, config static on your own in the network section.	
		NETIFACE_MAIN=enp0s3  # eth0
		NETWMGR=NETWORKMANAGER  # NETIFRC; DHCPD; NETWORKMANAGER

		# DNS
		# NAMESERVER1_IPV4=1.1.1.1  # (!changeme) 1.1.1.1 ns1 cloudflare ipv4
		# NAMESERVER1_IPV6=2606:4700:4700::1111  # (!changeme) ipv6 ns1 2606:4700:4700::1111 cloudflare ipv6
		# NAMESERVER2_IPV4=1.0.0.1  # (!changeme) 1.0.0.1 ns2 cloudflare ipv4
		# NAMESERVER2_IPV6=2606:4700:4700::1001  # (!changeme) ipv6 ns2 2606:4700:4700::1001 cloudflare ipv6

		# VIRTUALIZATION
		SYSVARD=GUEST  # host is GUEST & HOST ... for virtualbization setup

		# DISPLAY / SCREEN
		DISPLAYSERV=X11  # see options
		DISPLAYMGR_YESNO=W_D_MGR  # W_D_MGR (WITH display manager) / SOLO (without display manager)
		DISPLAYMGR=LXDM  # CDM; GDM; LIGHTDM; LXDM (!default - other env untested / todo); QINGY; SSDM; SLIM; WDM; XDM  # sample, check the section for valid setups,
		DESKTOPENV=XFCE  # XFCE (!default - other env untested / todo); BUDGIE; CINNAMON; FVWM; GNOME; KDE; LXDE; LXQT; LUMINA; MATE; PANTHEON; RAZORQT; TDE; # sample, check the section for valid setups,

		# X11
		## X11 KEYBOARD
		X11_KEYBOARD_XKB_VARIANT="altgr-intl,abnt2"
		X11_KEYBOARD_XKB_OPTIONS="grp:shift_toggle,grp_led:scroll"
		X11_KEYBOARD_MATCHISKEYBOARD="on"

		# GRAPHIC UNIT
		#GPU_SET=amdgpu  # (!changeme) amdgpu, radeon # (!todo)

		# USERAPP
		USERAPP_GIT=NO  # (!todo)
		USERAPP_FIREFOX=YES
		USERAPP_CHROMIUM=NO  # (!NOTE !todo !bug ..)
		USERAPP_MIDORI=NO  # (!NOTE: some unmask thing .. ruby?)  # https://astian.org/en/midori-browser/

		## USER
		SYSUSERNAME=admini  # (!changeme) wheel group member - name of the login sysadmin user
		USERGROUPS="wheel,plugdev,power,video"  # (!NOTE: virtualbox groups set if guest / host system is set)

		# SET USEFLAGS (!NOTE: names follow a pattern which must be kept for functions to read it ... "USERFLADS_"emerge_ name"  : "-" is replaced with "_" and lower converted to uppercase letters)
		USEFLAGS_LINUX_FIRMWARE="initramfs redistributable unknown-license"
		USEFLAGS_CRYPTSETUP="udev"
		USEFLAGS_DRACUT="device-mapper"  # if systemd - systemd useflag required?
		USEFLAGS_GENKERNEL="cryptsetup"
		
		USEFLAGS_PULSEAUDIO=""
		USEFLAGS_XORG_SERVER="xvfb"
		USEFLAGS_XFCE4_META="gtk3 gcr"
		USEFLAGS_NETWORKMANAGER="dhcpcd -modemmanager -ppp"
		
		USEFLAGS_GRUB2="fonts"
		
		USEFLAGS_VIRTUALBOX_GUEST_ADDITIONS="X"

		# WEBBROWSER 
		USEFLAGS_FIREFOX="bindist eme-free geckodriver hwaccel jack -system-libvpx -system-icu"  # system-av1 system-harfbuzz system-icu system-jpeg system-libevent system-libvpx system-webp hwaccel jack lto pgo screencast wifi
		USEFLAGS_CHROMIUM="official -cups -hangouts -kerberos -screencast -pic"  # hangouts proprietary-codecs system-ffmpeg system-icu # https://wiki.gentoo.org/wiki/Chromium
		USEFLAGS_MIDORI=""