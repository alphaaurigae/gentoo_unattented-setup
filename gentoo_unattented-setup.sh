#!/bin/bash


# 0.0 INFO
#
# Welcome, this is an aweosme script, may not works here and there as expected but its awesome, so how about helping me with this?! Bug reports, suggestions, commits welcome - documentation isnt this awesome but i try :)
#
# Since you already know that this is intentended as one file gentoo setup this is going to be easy as eating a delicious dinner!
#
# Lets start with the index, i wrote it to help organize the whole thing in logical sections and remain flexible to integrate deployment variables.
# THERE ARE 2 PLACES FOR VARIABLES: # 0.4 && # 3.1 - see index.

BANNER () { # 0.1 BANNER
	echo "${bold}
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	+     ____ _____ _   _ _____ ___   ___    _     ___ _   _ _   ___  __   +
	+    / ___| ____| \ | |_   _/ _ \ / _ \  | |   |_ _| \ | | | | \ \/ /   +
	+   | |  _|  _| |  \| | | || | | | | | | | |    | ||  \| | | | |\  /    +
	+   | |_| | |___| |\  | | || |_| | |_| | | |___ | || |\  | |_| |/  \    +
	+    \____|_____|_| \_| |_| \___/ \___/  |_____|___|_| \_|\___//_/\_\   +
	+   									+
	+   modular, "mostly unattended"					+
	+   STATUS: dev PROTOTYPE 						+
	+   									+
	+   https://github.com/alphaaurigae			        	+
	+								        +
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	${normal}"
}

## Deployment Instructions:
# - short, simply run the script with your settings (considered all bugs have been solved (will be printed on top)
# 1. Deploy virtualbox gentoo minimal
# 2. wget -O awesome.sh https://....
# 3. tr -d '\015' < awesome.sh > deploy-gentoo.sh # convert to unix file format in case the host deploys it differently.
# > Depending on variables set there will be prompted for luks & root + user passwords and for verification of those - dont mess this steps up, there is no feature to as for repeat entry yet!!!
# > Depending on variables set kernel may requires semi manual configuration.
# > Depending on variables set all kinds of bad things can happen which may lead to a failure of the entire installation - thats a true pity if you waited a couple of hours. For this reason its highly suggested to not runthe script all at once unless you know the STACK will work together, running the bottom script functions one by one may help debugging.

## Other INFO:
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation

# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#  ___ _   _ ____  _______  __
# |_ _| \ | |  _ \| ____\ \/ /
#  | ||  \| | | | |  _|  \  / 
#  | || |\  | |_| | |___ /  \ 
# |___|_| \_|____/|_____/_/\_\
#                             
# the index somewhat dated but may helps ... work in progress!
# script index and default application / setting notes in (...).
# DEFAULT SETTING NOTES in (!...).
# SYSTEMD is defaul script wide
# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
# 0.0 INFO 
# 0.1 BANNER
# 0.2 Deployment Instructions
# 0.3 INDEX
# 0.4 VARIABLES MAIN (Note!: there are 2 places to edit variables - 
	# (0.4 VARIABLES MAIN (variables for everything EXCEPT the chroot script))
	# && # (3.1 VARIABLES CHROOT (variables only for the chroot script))
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 1.0 DEPLOY_BASESYS (in this section the script starts off with everything that has to be done prior to the setup action.
	# 1.1 TIMEUPD # ... update the system time ... !important
	# 1.2 MODPROBE # ... load kernel modules for the chroot install process ...
	# 1.3 PARTITIONING (!partitioning for LVM on LUKS cryptsetup)
		# 1.4 PARTED
		# 1.4 PTABLES
		# 1.4 MAKEFS_BOOT
	# 1.4 CRYPTSETUP ((!luks) for the main disk $MAIN_PART - you will be prompted for passohrase)
	# 1.5 LVMONLUKS ((!LVM2) in the luks container on $MAIN_PART) - WORKS
		# 1.5.1 LVM_PV ((!physical volume $PV_MAIN) only for the $MAIN_PART)
		# 1.5.2 LVM_VG ((!volume group $VG_MAIN) only on the $VG_MAIN)
		# 1.5.3 LVM_LV ((!volume group $LV_MAIN) only on the $PV_MAIN for the OS installation as root)
		# 1.5.4 MAKEFS_LVM (filesystem on the created LVM logical volume $LV_MAIN)
		# 1.5.5 MOUNT_LVM_LV (mount to proceed with gentoo setup)
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# 2.0 PREPARE_CHROOT
	# 2.1 DL_STAGE (! AMD64_DEFAULT (http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-)) 
	# 2.2 EBUILD
	# 2.3 RESOLVCONF
	# 2.4 BASHRC
	# 2.5 MNTFS
		# 2.5.1 MOUNT_BASESYS
		# 2.5.2 SETMODE_DEVSHM
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 3.0 CHROOT
	# 3.1 VARIABLES CHROOT
	# 3.2 BASE SYSTEM
		# 3.2.1 CONFIG_PORTAGE (! emerge-webrsync)
		# 3.2.2 INSTALL_PCIUTILS (! default)
		# 3.2.3 INSTALL_MULTIPATH (! default)
		# 3.2.4 INSTALL_GNUPG
		# 3.2.5 EMERGE_SYNC (! emerge --sync)
		# 3.2.6 CHOOSE_PROFILE (! eselect profile set 29 # 17.1 systemd (maybe find a smarter way)) 
		# 3.2.7 WORLDSET
		# 3.2.8 MAKECONF (! too complex to list here)
			# 3.2.8.1 MAKECONF_VARIABLES
			# https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/USE
			# systemd
			# LVM2
			# X11
			# grub
			# sudo
			# audio
			# video
			# SSL
			# CPU FLAGS
			# encryption
			# compressions
			# NO KDE
		# 3.2.9 SYSTEMTIME
			# 3.2.9.1 SET_TIMEZONE (! $SYSTIMEZONE_SET)
				# 3.2.9.1.1 TIMEZONE_OPENRC 
				# 3.2.9.1.2 TIMEZONE_SYSTEMD 
			# 3.2.9.2 SYSTEMCLOCK (! systemd-timesyncd)
				# 3.2.9.2.1 OPENRC_SYSTEMCLOCK
					# 3.2.9.2.1.1 OPENRC_SYSCLOCK_MANUAL
						# 3.2.9.2.1.1.1 OPENRC_SYSTEMCLOCK
				# 3.2.9.2.2 OPENRC_OPENNTPD
					# 3.2.9.2.2.1 EMERGE_OPENTPD
					# 3.2.9.2.2.2 SYSSTART_OPENNTPD
			# 3.2.9.3 HWCLOCK (! UTC hardcoded, no variable)
				# 3.2.9.3.1 HWCLOCK_OPENRC
				# 3.2.9.3.2 HWCLOCK_SYSTEMD
		# 3.2.10 CONF_LOCALES
			# 3.2.10.1 CONF_LOCALEGEN
			# 3.2.10.2 GEN_LOCALE
			# 3.2.10.3 SYS_LOCALE
			# 3.2.10.4 RELOAD_LOCALE_ENV
		# 3.2.11 INITSYSTEM (! systemd)
			# 3.2.11.1 INITSYS_OPENRC
				# 3.2.11.1.1 CONFIG_OPENRC
				# 3.2.11.1.2 RCCONF
			# 3.2.12.2 INITSYS_SYSTEMD
				# 3.2.12.2.1 REMOVE_UDEV
				# 3.2.12.2.2 REMOVE_OPENRC
				# 3.2.12.2.3 EMERGE_SYSTEMDANDDEPS
				# 3.2.12.2.4 ETCMTAB
		# 3.2.12 FIRMWARE
	# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	# 3.2 INST_SYSAPP
		# 3.3.1 INSTALL_CRYPTSETUP
			# 3.3.1.1 SYSSTART_CRYPTSETUP_OPENRC
			# 3.3.1.2 SYSSTART_CRYPTSETUP_SYSTEMD
		# 3.3.2 INSTALL_LVM2
			# 3.3.2.1 SYSSTART_LVM2
				# 3.3.2.1.1 BOOT_START_LVM2_OPENRC
				# 3.3.2.1.2 BOOT_START_LVM2_SYSTEMD
			# 3.3.2.2 CONFIG_LVM2
				# 3.3.2.2.1 LVM_CONF
		# 3.3.3 INSTALL_SUDO
		# 3.3.4 INST_LOGGER
			# 3.3.4.1 LOGROTATION (! LOGROTATE)
				# 3.3.4.1.1 LOGROTATE
			# 3.3.4.2 SYSLOG (! SYSLOGNG)
				# 3.3.4.2.1 SYSLOGNG
					# 3.3.4.2.1.1 SYSSTART_SYSLOGNG
						# 3.3.4.2.1.1.1 SYSLOGNG_OPENRC
						# 3.3.4.2.1.1.2 SYSLOGNG_SYSTEMD
				# 3.3.4.2.2 SYSKLOGD
					# 3.3.4.2.2.1 SYSSTART_SYSKLOGD
						# 3.3.4.2.2.1.1 SYSKLOGD_OPENRC
						# 3.3.4.2.2.1.2 SYSKLOGD_SYSTEMD
		# 3.3.5 INST_CRON (! CRONIE)
			# 3.3.5.1 CRON_CRONIE
				# 2.5.1.1 CRONIE_OPENRC
				# 2.5.1.2 CRONIE_SYSTEMD
			# 3.3.5.2 CRON_DCRON
				# 2.5.2.1 DCRON_OPENRC
				# 2.5.2.2 DCRON_SYSTEMD
			# 3.3.5.3 CRON_ANACRON
				# 2.5.3.1 ANACRON_OPENRC
				# 2.5.3.2 ANACRON_SYSTEMD
			# 3.3.5.4 CRON_FCRON
				# 2.5.4.1 FCRON_OPENRC
				# 2.5.4.2 FCRON_SYSTEMD
			# 3.3.5.5 CRON_BCRON
				# 2.5.5.1 BCRON_OPENRC
				# 2.5.5.2 BCRON_SYSTEMD
			# 3.3.5.6 CRON_VIXICRON
				# 3.3.5.6.1 VIXICRON_OPENRC
				# 3.3.5.6.2 VIXICRON_SYSTEMD
		# 3.3.6 FILEINDEXING (! mlocate)
			# 3.3.6.1 mlocate
		# 3.3.7 FSTOOLS # (! e2fsprogs # Ext2, 3, and 4) # optional, add to variables at time.
			# 3.3.7.1 e2fsps drogs
			# 3.3.7.2 xfsprogs
			# 3.3.7.3 reiserfsprogs
			# 3.3.7.4 jfsutils
			# 3.3.7.5 dosfstools
			# 3.3.7.6 btrfs-progs
		# 3.3.8 INSTALL_GIT (! default)
	# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	# 3.4.0 BUILD_KERNEL (by default genkernel is used for simplicity)
		# 3.4.1 KERNEL_SOURCE (! KERN_SOURCES_EMERGE (gentoo sources))
			# 3.4.1.1 KERN_SOURCES_EMERGE
			# 3.1.2 KERN_SOURCES_TORVALDS
		# 3.4.2 CONFIGURE_KERNEL (! CONFKERN_AUTO >> GENKERNEL)
			# 3.4.2.1 CONFKERN_MANUAL ( ! NOT DEFAULT)
				# 3.4.2.1.1 CNFG_KERN_PASTE
				# 3.4.2.1.2 MKERNBUILD
			# 3.4.2.2 CONFKERN_AUTO
				# 3.4.2.2.1 GENKERNEL
					# 3.4.2.2.1.1 CKA_OPENRC
						# 3.4.2.2.1.1.1 CONFGENKERNEL_OPENRC
						# 3.4.2.2.1.1.2 RUNGENKERNEL_OPENRC
					# 3.4.2.2.1.2 CKA_SYSTEMD
						# 3.4.2.2.1.2.1 CONFGENKERNEL_SYSTEMD
						# 3.4.2.2.1.2.2 RUNGENKERNEL_SYSTEMD
	# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	# 3.5.0 INITRAMFS (! GENKERNEL instead)
		# 3.5.1 DRACUT
	# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	# 3.6.0 FSTAB (! FSTAB_LVMONLUKS_BIOS - no switch yet)
		# 3.6.1.1 FSTAB_LVMONLUKS_BIOS
		# 3.6.2.2 FASTAB_LVMONLUKS_UEFI
	# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	# 3.7 KEYMAPS (! $VCONSOLE_KEYMAP && $VCONSOLE_FONT)
		# 3.7.1 KEYMAPS_SYSTEMD
			# 3.7.1.1 VCONSOLE_CONF
	# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	# 3.8 NETWORKING (! GENTOONET; HOSTSFILE; SYSTEMD_NETWORKD)
		# 3.8.1 GENTOONET
		# 3.8.2 HOSTSFILE
		# 3.8.3 SYSTEMD_NETWORKD (! default $NETWORK_NET) 
			# 3.8.3.1 REPLACE_RESOLVECONF
			# 3.8.3.2 WIRED_DHCPD (! DHCP is default)
			# 3.8.3.3 WIRED_STATIC (static config here)
		# 3.8.4 INST_DHCP (! since DHCP is default this must be installed, for default systemd)
			# 3.8.4.1 EMERGE_DHCPD
			# 3.8.4.2 SYSSTART_DHCPD_OPENRC
			# 3.8.4.3 SYSSTART_DHCPD_SYSTEMD
	# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	# 3.9.0 BOOTLOAD (! BIOS is default)
		# 3.9.1 GRUB2_SETUP
			# 3.9.1.1 GRUB2_OPENRC
				# 3.9.1.1.1 GRUB2_BIOS_OPENRC
				# 3.9.1.1.2 GRUB2_UEFI_OPENRC
				# 3.9.1.1.3 CONF_GRUB2_OPENRC
			# 3.9.1.2 GRUB2_SYSTEMD (! default as systemd script wide)
				# 3.9.1.2.1 GRUB2_BIOS_SYSTEMD
				# 3.9.1.2.2 GRUB2_UEFI_SYSTEMD
				# 3.9.1.2.3 CONF_GRUB2_SYSTEMD
	# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	# 3.10.0 DISPLAYVIDEO
		# 3.10.1 SETUP_GPU # no default set
			# 3.10.1.1 NVIDIA # no config yet, no nvda card here rn.
			# 3.10.1.2 AMD
		# 3.10.2 WINDOWSYS (! X11)
			# 3.10.2.1 X11
		# 3.10.3 DISPLAYMGR (! LXDM)
			# 3.10.3.1 LIGHTDM
			# 3.10.3.2 LXDM (default)
				# 3.10.3.2.1 EMERGE_LXDM
				# 3.10.3.2.2 AUTOSTART_LXDM
					# 3.10.3.2.2.1 LXDM_OPENRC
					# 3.10.3.2.2.2 LXDM_SYSTEMD
				# 3.10.3.2.3 CONFIGURE_LXDM
		# 3.10.4 DESKTOP_ENV
			# 3.10.4.1 XFCE4 (! EMERGE_XFCE4;W_DISPLAYMGR; XFCE4_MISC)
				# 3.10.4.1.1 EMERGE_XFCE4
					# 3.10.4.1.1.1 eselect profile set default/linux/amd64/17.0/desktop
					# 3.10.4.1.1.2 app-text/poppler -qt5 # app-text/poppler have +qt5 by default
					# 3.10.4.1.1.3 emerge $EMERGE_VAR xfce-base/xfce4-meta xfce-extra/xfce4-notifyd
					# 3.10.4.1.1.4 emerge $EMERGE_VAR --deselect=y xfce-extra/xfce4-notifyd
					# 3.10.4.1.1.5 emerge $EMERGE_VAR xfce-base/xfwm4 xfce-base/xfce4-panel
				# 3.10.4.1.2 W_DISPLAYMGR
					# 3.10.4.1.2.1 XFCE4_LXDM
				# 3.10.4.1.3 WO_DISPLAYMGR
					# 3.10.4.1.3.1 XFCE_STARTX_OPENRC
				# 3.10.4.1.4 XFCE4_MISC
					# - xfce4-mount-plugin
					# - xfce-base/thunar
					# - x11-terms/xfce4-terminal
					# - app-editors/mousepad
					# - xfce4-pulseaudio-plugin
					# - xfce-extra/xfce4-mixer 
					# - xfce-extra/xfce4-alsa-plugin
					# - xfce-extra/thunar-volman
	# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	# 3.11.0 AUDIO
		# pavu placehold
	# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	# 3.12.0 USER
		# - sysadmin
		# - root
	# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	# 3.13.0 EXIT_CHROOT
		# - tidy up , leavechroot

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 4.0 RUN ALL
	# - run all the things
# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#  ____   ____ ____  ___ ____ _____    ___  ____ _____ ___ ___  _   _ ____  
# / ___| / ___|  _ \|_ _|  _ \_   _|  / _ \|  _ \_   _|_ _/ _ \| \ | / ___| 
# \___ \| |   | |_) || || |_) || |   | | | | |_) || |  | | | | |  \| \___ \ 
#  ___) | |___|  _ < | ||  __/ | |   | |_| |  __/ | |  | | |_| | |\  |___) |
# |____/ \____|_| \_\___|_|    |_|    \___/|_|    |_| |___\___/|_| \_|____/ 
#                                                                          
# Edit the variables, not the script ..... where possible ^^
# 1.0 VARIABLES

	## DRIVES & PARTITIONS
	HDD1=/dev/sda # OS DRIVE - the drive you want to install gentoo to.
	## GRUB_PART=/dev/sda1 # bios grub
	BOOT_PART=/dev/sda2 # boot # unencrypted unless required changes are made - see CRYPTSETUP_BOOT 
	MAIN_PART=/dev/sda3 # mainfs - lukscrypt cryptsetup container with LVM env inside

	## SWAP - DISABLED -- SEE VAR & LVM SECTION TO ENABLE!
	# SWAP0=swap0 # LVM swap NAME for sorting of swap partitions.
	# SWAP_SIZE="1GB"  # (INSIDE LVM MAIN_PART - mainhdd only has boot & fainfs
	# SWAP_FS=linux-swap # swapfs, couldnt have guessed it

	## FILESYSTEMS # !FSTOOLS
	BOOT_FS=ext2 # boot filesystem
	MAIN_FS=ext4 # main filesystem for the OS

	## LVM
	PV_MAIN=pv0_main # LVM PV physical volume
	VG_MAIN=vg0_main # LVM VG volume group
	LV_MAIN=lv0_main # LVM LV logical volume

	## PARTITION SIZE
	GRUB_SIZE="1M 150M" # (!changeme) bios grub sector start/end M for megabytes, G for gigabytes
	BOOT_SIZE="150M 1G" # (!changeme) boot sector start/end
	MAIN_SIZE="1G 100%" # (!changeme) primary partition start/end

	## PROFILE # default during dev of the script is systemd but prep openrc.	
	STAGE3DEFAULT=AMD64_SYSTEMD # (!changeme) AMD64_DEFAULT (default)

	CHROOTX=/mnt/gentoo # chroot directory, installer will create this recursively

	## BASHRC - see section

	## MAKEFILE
	PRESET_INPUTEVICE="libinput keyboard"
	PRESET_VIDEODRIVER='amdgpu radeonsi radeon'
	PRESET_LICENCES="-* @FREE" # Only accept licenses in the FREE license group (i.e. Free Software)
	PRESET_USEFLAG='X a52 aac aalib acl acpi adns alsa apparmor atm audit bash-completion berkdb bidi blas boost branding bzip2 \
			cairo cdda caps cpudetection cjk cracklib crypt cryptsetup css curl cvs cxx dbi dbus debug device-mapper dns-over-tls dga elfutils \
			efiemu emacs encode exif expat fam ffmpeg filecaps flac fonts fortran ftp geoip gcrypt gd gif git gtk gnuefi gnutls gnuplot \
			hardened highlight gzip ipv6 initramfs int64 introspection idn jack jpeg jemalloc kernel kms lame latex ldap libcaca libressl lm_sensors \
			lua lzma lzo lz4 m17n-lib matroska memcached mhash modules mount nettle numa mp3 mp4 mpeg mtp nls ocaml opengl openssl opus osc oss \
			pcre perl png policykit posix pulseaudio python raw readline resolvconf qt5 recode ruby sound seccomp sasl sockets sox \
			socks5 ssl sssd static-libs sqllite sqlite3 svg systemd sysv-utils szip symlink tcl tcpd themes thin truetype threads tiff udev \
			udisks unicode utils xkb xvid zip zlib \
			-kde -cups -bluetooth -libnotify -mysql -apache -apache2 -dropbear -redis -mssql -postgres -telnet'
	PRESET_FEATURES="sandbox binpkg-docompress binpkg-dostrip binpkg-dostrip candy cgroup clean-logs collision-protect \
			compress-build-logs downgrade-backup fail-clean fixlafiles force-mirror ipc-sandbox merge-sync \
			network-sandbox noman parallel-fetch parallel-install pid-sandbox userpriv usersandbox"
	PRESET_GENTOMIRRORS="https://ftp.snt.utwente.nl/pub/os/linux/gentoo/ https://mirror.isoc.org.il/pub/gentoo/ \
				https://mirrors.lug.mtu.edu/gentoo/ https://mirror.csclub.uwaterloo.ca/gentoo-distfiles/ \
				https://ftp.jaist.ac.jp/pub/Linux/Gentoo/"

	## MISC STATIC
	bold=$(tput bold) # staticvar bold text
	normal=$(tput sgr0) # # staticvar reverse to normal text

	# 	
	#  .----------------.  .-----------------. .----------------.  .----------------. 
	# | .--------------. || .--------------. || .--------------. || .--------------. |
	# | |     _____    | || | ____  _____  | || |     _____    | || |  _________   | |
	# | |    |_   _|   | || ||_   \|_   _| | || |    |_   _|   | || | |  _   _  |  | |
	# | |      | |     | || |  |   \ | |   | || |      | |     | || | |_/ | | \_|  | |
	# | |      | |     | || |  | |\ \| |   | || |      | |     | || |     | |      | |
	# | |     _| |_    | || | _| |_\   |_  | || |     _| |_    | || |    _| |_     | |
	# | |    |_____|   | || ||_____|\____| | || |    |_____|   | || |   |_____|    | |
	# | |              | || |              | || |              | || |              | |
	# | '--------------' || '--------------' || '--------------' || '--------------' |
	#  '----------------'  '----------------'  '----------------'  '----------------' 
	#
	INIT () { # 2.0                    
		# TIME ... update the system time ... !important
		TIMEUPD () { # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Setting_the_date_and_time
			ntpd -q -g
		}                                                
		# MODPROBE ... load kernel modules for the chroot isntall process, for luks we def need the dm-crypt ...
		MODPROBE () {
			modprobe -a dm-mod dm_crypt # sha256
		}
		# PARTITIONING .... glad you asked! ill take a coffee, ahh scew it, make it a triple espresso!                                                                  
		PARTITIONING () {
			PARTED () {
				# https://wiki.archlinux.org/index.php/GNU_Parted
				## for virtualbox uefi go here: https://wiki.archlinux.org/index.php/VirtualBox#Installation_steps_for_Arch_Linux_guests
				sgdisk --zap-all /dev/sda
				# parted -s $HDD1 rm 1
				# parted -s $HDD1 rm 2
				# parted -s $HDD1 rm 3
				parted -s $HDD1 mklabel gpt # create GUID Partition Table
				# ///////////////////////////
				parted -s $HDD1 mkpart primary "$GRUB_SIZE" # the BIOS boot partition is needed when a GPT partition layout is used with GRUB2 in PC/BIOS mode. It is not required when booting in EFI/UEFI mode. 
				parted -s $HDD1 name 1 grub # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks#GPT
				parted -s $HDD1 set 1 bios_grub on
				# ///////////////////////////
				parted -s $HDD1 mkpart primary $BOOT_FS "$BOOT_SIZE" #
				parted -s $HDD1 name 2 boot
				parted -s $HDD1 set 2 boot on
				# ///////////////////////////
				parted -s $HDD1 mkpart primary $MAIN_FS "$MAIN_SIZE" # Use the remaining partition scheme is entirely
				parted -s $HDD1 name 3 mainfs
				parted -s $HDD1 set 3 lvm on
			}
			PTABLES () {
				partx -u $HDD1
				partprobe $HDD1
			}
			MAKEFS_BOOT () {
				mkfs.$BOOT_FS $BOOT_PART
			}
			PARTED && echo "${bold}PARTED - END, proceeding to PTABLES ....${normal}"
			PTABLES && echo "${bold}PTABLES - END, proceeding to MAKEFS_BOOT ....${normal}"
			MAKEFS_BOOT && echo "${bold}PTABLES - END ....${normal}"
		}
		# ...  lvm on luks! Lets put EVERYTHING IN THE LUKS CONTAINER, to put the LVM INSIDE and the installation inside of the LVM "CRYPT --> BOOT/LVM2 --> OS" ... 
		CRYPTSETUP () { # https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS && https://blog.stigok.com/2018/05/03/lvm-in-luks-with-encrypted-boot-partition-and-suspend-to-disk.html
			echo "${bold}enter the $PV_MAIN password${normal}"
			cryptsetup -v luksFormat --type luks2 $MAIN_PART --debug
			cryptsetup open $MAIN_PART $PV_MAIN
		}
		# LVM = "PV (Physical volume)-> VG (Volume group) > LV (Logical volume) inside of the luks crypt container ...             
		LVMONLUKS () {
			LVM_PV () { # Create physical volume for OS inst.
				pvcreate /dev/mapper/$PV_MAIN
			}
			LVM_VG () { # Create volume group volume for OS inst.
				vgcreate $VG_MAIN /dev/mapper/$PV_MAIN
			}
			LVM_LV () { # Create logical volume for OS inst.
				# lvcreate -L $SWAP_SIZE -n $SWAP0 $VG_MAIN
				lvcreate -l 98%FREE -n $LV_MAIN $VG_MAIN
			}
			MAKEFS_LVM () { # deploy filesystems for OS inst.
				mkfs.ext4 /dev/$VG_MAIN/$LV_MAIN # logical volume for OS inst.
				# mkswap /dev/$VG_MAIN/$SWAP0 # swap ...
			}
			MOUNT_LVM_LV () { # mount the LVM for OS inst as CHROOT.
				mkdir -p $CHROOTX
				mount /dev/mapper/$VG_MAIN-$LV_MAIN $CHROOTX
				# swapon /dev/$VG_MAIN/$SWAP0
				mkdir $CHROOTX/boot
				mount $BOOT_PART $CHROOTX/boot
			}
			LVM_PV		&& echo "${bold}LVM_PV - END, proceeding to LVM_VG ....${normal}"
			LVM_VG		&& echo "${bold}LVM_VG - END, proceeding to LVM_LV ....${normal}"
			LVM_LV		&& echo "${bold}LVM_LV - END, proceeding to MAKEFS_LVM ....${normal}"
			MAKEFS_LVM	&& echo "${bold}MAKEFS_LVM - END, proceeding to MOUNT_LVM_LV ....${normal}"
			MOUNT_LVM_LV	&& echo "${bold}MOUNT_LVM_LV - END ....${normal}"
			
		}
		TIMEUPD 			&& echo "${bold}UPDATE_TIME - END ....${normal}"
		MODPROBE 			&& echo "${bold}MODPROBE - END ....${normal}"
		PARTITIONING 			&& echo "${bold}PARTED - END ....${normal}"
		CRYPTSETUP 			&& echo "${bold}CRYPTSETUP_MAIN - END ....${normal}"
		LVMONLUKS 			&& echo "${bold}LVMONLUKS - END, proceeding to PREPARE_CHROOT ....${normal}"
	}
	#
	#  .----------------.  .----------------.  .----------------. 
	# | .--------------. || .--------------. || .--------------. |
	# | |   ______     | || |  _______     | || |  _________   | |
	# | |  |_   __ \   | || | |_   __ \    | || | |_   ___  |  | |
	# | |    | |__) |  | || |   | |__) |   | || |   | |_  \_|  | |
	# | |    |  ___/   | || |   |  __ /    | || |   |  _|  _   | |
	# | |   _| |_      | || |  _| |  \ \_  | || |  _| |___/ |  | |
	# | |  |_____|     | || | |____| |___| | || | |_________|  | |
	# | |              | || |              | || |              | |
	# | '--------------' || '--------------' || '--------------' |
	#  '----------------'  '----------------'  '----------------' 
	#
	PRE () { # 3.0 PREPARE CHROOT
		# STAGE3 TARBALL - HTTPS:// ?
		DL_STAGE () { # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Choosing_a_stage_tarball && # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Unpacking_the_stage_tarball
			STAGE3_DEFAULT_AMD64_STATIC () {
				wget -O $CHROOTX/stage3.tar.xz http://distfiles.gentoo.org/releases/amd64/autobuilds/20190804T214502Z/stage3-amd64-20190804T214502Z.tar.xz
				tar xvJpf $CHROOTX/stage3.tar.xz --xattrs-include='*.*' --numeric-owner -C $CHROOTX 
				# verification missing
			}
			STAGE3_LATEST_AMD64_DEFAULT () {
				wget -O $CHROOTX/stage3.tar.xz http://distfiles.gentoo.org/releases/amd64/autobuilds/"$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64.txt | sed '/^#/ d' | awk '{print $1}')"
				tar xvJpf $CHROOTX/stage3.tar.xz --xattrs-include='*.*' --numeric-owner -C $CHROOTX 
			}

			STAGE3_LATEST_AMD64_SYSTEMD () {
				wget -O $CHROOTX/stage3.tar.bz2 http://distfiles.gentoo.org/releases/amd64/autobuilds/"$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64-systemd.txt | sed '/^#/ d' | awk '{print $1}')"
				tar xvfj $CHROOTX/stage3.tar.bz2 --xattrs-include='*.*' --numeric-owner -C $CHROOTX 
			}
			STAGE3_LATEST_AMD64_NOMULTILIB () {
				wget -O $CHROOTX/stage3.tar.xz http://distfiles.gentoo.org/releases/amd64/autobuilds/"$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64-nomultilib.txt | sed '/^#/ d' | awk '{print $1}')"
				tar xvJpf $CHROOTX/stage3.tar.xz --xattrs-include='*.*' --numeric-owner -C $CHROOTX 
			}
			STAGE3_LATEST_AMD64_HARDENED_DEFAULT () {
				wget -O $CHROOTX/stage3.tar.xz http://distfiles.gentoo.org/releases/amd64/autobuilds/"$(curl -s https://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64-hardened.txt | sed '/^#/ d' | awk '{print $1}')"
				tar xvJpf $CHROOTX/stage3.tar.xz --xattrs-include='*.*' --numeric-owner -C $CHROOTX 
			}
			STAGE3_LATEST_AMD64_HARDENED_SELINUX_DEFAULT () {
				wget -O $CHROOTX/stage3.tar.xz http://distfiles.gentoo.org/releases/amd64/autobuilds/"$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64-hardened-selinux.txt | sed '/^#/ d' | awk '{print $1}')"
				tar xvJpf $CHROOTX/stage3.tar.xz --xattrs-include='*.*' --numeric-owner -C $CHROOTX 
			}
			STAGE3_LATEST_AMD64_HARDENED_SELINUX_NOMULTILIB () {
				wget -O $CHROOTX/stage3.tar.xz http://distfiles.gentoo.org/releases/amd64/autobuilds/"$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64-hardened-selinux+nomultilib.txt | sed '/^#/ d' | awk '{print $1}')"
				tar xvJpf $CHROOTX/stage3.tar.xz --xattrs-include='*.*' --numeric-owner -C $CHROOTX 
			}
			STAGE3_LATEST_AMD64_HARDENED_NOMULTILIB () {
				wget -O $CHROOTX/stage3.tar.xz http://distfiles.gentoo.org/releases/amd64/autobuilds/"$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64-hardened+nomultilib.txt | sed '/^#/ d' | awk '{print $1}')"
				tar xvJpf $CHROOTX/stage3.tar.xz --xattrs-include='*.*' --numeric-owner -C $CHROOTX 
			}
			STAGE3_LATEST_$STAGE3DEFAULT
		}                                 
		# EBUILD ... Gentoo ebuild repository ...
		EBUILD () { # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Gentoo_ebuild_repository
			mkdir --parents $CHROOTX/etc/portage/repos.conf
			cp $CHROOTX/usr/share/portage/config/repos.conf $CHROOTX/etc/portage/repos.conf/gentoo.conf # copy the Gentoo repository configuration file provided by Portage to the (newly created) repos.conf directory.
			# cat $CHROOTX/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
		}
		# RESOLVCONF DNS ... copy resolv.conf (DNS info) ...                                          
		RESOLVCONF () { # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Copy_DNS_info
			cp --dereference /etc/resolv.conf $CHROOTX/etc/
		}
		# .BASHRC (!changeme)	
		BASHRC () {
			cat << 'EOF' > $CHROOTX/etc/skel/.bashrc_tmp                   
			#  .bash.rc by alphaaurigae 11.08.19
			# ~/.bashrc: executed by bash(1) for non-login shells.
			# Examples: /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
			[[ $- != *i* ]] && return # If not running interactively, don't do anything
			shopt -s histappend # append to the history file.
			HISTSIZE=1000 # max bash history lines.
			HISTFILESIZE=2000 # max bash history filesize in bytes.
			shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
			case "$TERM" in # set a fancy prompt (non-color, unless we know we "want" color)
			    xterm-color|*-256color) color_prompt=yes;;
			esac
			force_color_prompt=yes
			if [ -n "$force_color_prompt" ]; then
			    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
				color_prompt=yes
			    else
				color_prompt=
			    fi
			fi
			if [ "$color_prompt" = yes ]; then
			# PS1='${arch_chroot:+($arch_chroot)}\[\033[01;32m\]\u@\h\[\036[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ' # default
			PS1='${gentoo_chroot:+($debian_chroot)}\[\033[0;35m\][\[\033[0;32m\]\u\[\033[0;37m\]@\[\033[0;36m\]\h\[\033[0;37m\]:\[\033[0;37m\]\w\[\033[0;35m\]]\[\033[0;37m\]\$\[\033[01;38;5;220m\] ' # mod
			else
			    PS1='${gentoo_chroot:+($gentoo_chroot)}\u@\h:\w\$ '
			fi
			unset color_prompt force_color_prompt
			case "$TERM" in # If this is an xterm set the title to user@host:dir
			xterm*|rxvt*)
			    PS1="\[\e]0;${arch_chroot:+($)}\u@\h: \w\a\]$PS1"
			    ;;
			*)
			    ;;
			esac
			# aliases for the bash shell.
			alias ls='ls --color=auto'
			alias dir='dir --color=auto'
			alias grep='grep --color=auto'
			alias fgrep='fgrep --color=auto'
			alias egrep='egrep --color=auto'
			alias ll='ls -alF'
			alias la='ls -A'
			alias l='ls -CF'
			export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01' # colored GCC warnings and errors
			if [ -f ~/.bash_aliases ]; then # ~/.bash_aliases, instead of adding them here directly.
			    . ~/.bash_aliases
			fi
EOF
		}                                
		MNTFS () {
			MOUNT_BASESYS () { # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Mounting_the_necessary_filesystems
				mount --types proc /proc $CHROOTX/proc
				mount --rbind /sys $CHROOTX/sys
				mount --make-rslave $CHROOTX/sys
				mount --rbind /dev $CHROOTX/dev
				mount --make-rslave $CHROOTX/dev
			}	 
			SETMODE_DEVSHM () {	
				chmod 1777 /dev/shm
			}   
			# # (!changeme)
			MAKECONF () { # https://wiki.gentoo.org/wiki//etc/portage/make.conf
				PRESET_MAKE="-j$(nproc) --quiet"
				MAKECONF_VARIABLES () {
					#cp /etc/portage/make.conf /etc/portage/make.Aconf_backup_$(date +%F_%R)
					cat << EOF > /etc/portage/make.conf
					COMMON_CPUFLAGS="$(lscpu | grep Flags: | sed -e 's/Flags:               //g')"
					COMMON_FLAGS="-march=native -O2 -pipe" # set
					CPU_FLAGS_X86="$(lscpu | grep Flags: | sed -e 's/Flags:               //g')"
					CFLAGS="-march=native -O2 -pipe" # clone
					CXXFLAGS="-march=native -O2 -pipe" # clone https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#CFLAGS_and_CXXFLAGS
					FCFLAGS="-march=native -O2 -pipe"
					FFLAGS="-march=native -O2 -pipe"
					MAKEOPTS="$PRESET_MAKE"
					INPUT_DEVICES="$PRESET_INPUTEVICE"
					VIDEO_CARDS="$PRESET_VIDEODRIVER"
					ACCEPT_LICENSE="$PRESET_LICENCES"
					FEATURES="$PRESET_FEATURES"
					USE="$(lscpu | grep Flags: | sed -e 's/Flags:               //g') $PRESET_USEFLAG"
					# https://www.gentoo.org/downloads/mirrors/
					GENTOO_MIRRORS="$PRESET_GENTOMIRRORS"
					# RSYNC MIRRORS https://www.gentoo.org/support/rsync-mirrors
					PORTDIR="/var/db/repos/gentoo"
					DISTDIR="var/cache/distfiles"
					PKGDIR="/var/cache/binpkgs"
					LC_MESSAGE=C
					CURL_SSL="openssl"
EOF
				}			                         
				MAKECONF_VARIABLES
				# emerge $EMERGE_VAR --changed-use @world
			}
			MOUNT_BASESYS && echo "${bold}MOUNT_BASESYS - END, proceeding to SETMODE_DEVSHM ....${normal}"
			SETMODE_DEVSHM && echo "${bold}SETMODE_DEVSHM - END ...${normal}"
			MAKECONF echo "${bold}MAKECONF done${normal}"
		}
		DL_STAGE			&& echo "${bold}DL_STAGE - END, proceeding to EBUILD ....${normal}"
		EBUILD				&& echo "${bold}EBUILD - END, proceeding to RESOLVCONF ....${normal}"
		RESOLVCONF			&& echo "${bold}RESOLVCONF - END, proceeding to MNTFS ....${normal}"
		MNTFS				&& echo "${bold}MNTFS - END, proceeding to CHROOT ....${normal}"
	}
#
#  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
# | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
# | |     ______   | || |  ____  ____  | || |  _______     | || |     ____     | || |     ____     | || |  _________   | |
# | |   .' ___  |  | || | |_   ||   _| | || | |_   __ \    | || |   .'    `.   | || |   .'    `.   | || | |  _   _  |  | |
# | |  / .'   \_|  | || |   | |__| |   | || |   | |__) |   | || |  /  .--.  \  | || |  /  .--.  \  | || | |_/ | | \_|  | |
# | |  | |         | || |   |  __  |   | || |   |  __ /    | || |  | |    | |  | || |  | |    | |  | || |     | |      | |
# | |  \ `.___.'\  | || |  _| |  | |_  | || |  _| |  \ \_  | || |  \  `--'  /  | || |  \  `--'  /  | || |    _| |_     | |
# | |   `._____.'  | || | |____||____| | || | |____| |___| | || |   `.____.'   | || |   `.____.'   | || |   |_____|    | |
# | |              | || |              | || |              | || |              | || |              | || |              | |
# | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
#  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
# ... Entering the new environment ... 		                                                        /
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment            /
# 4.0 CHROOT
INNER_SCRIPT=$(cat << 'INNERSCRIPT'

INNERSCRIPT
)
RUNCHROOT () {
	echo "$INNER_SCRIPT" > $CHROOTX/chroot_run.sh
	chmod +x $CHROOTX/chroot_run.sh
	chroot $CHROOTX /bin/bash ./chroot_run.sh
}

#### RUN ALL ## (!changeme)
BANNER 		&& echo "${bold}BANNER - END, proceeding to DEPLOY_BASESYS ....${normal}"
INIT 		&& echo "${bold}DEPLOY_BASESYS - END, proceeding to PREPARE_CHROOT ....${normal}"
PRE		&& echo "${bold}PREPARE_CHROOT - END, proceeding to INNER_CHROOT ....${normal}"
CHROOT		&& echo "${bold}RUNCHROOT - END${normal}"
echo "${bold}Script finished all operations - END${normal}"




