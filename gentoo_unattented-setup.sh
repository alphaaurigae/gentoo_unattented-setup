#!/bin/bash

# 0.0 INFO 

# Welcome, this is an aweosme script, may not works here and there as expected but its awesome, so how about helping me with this?! Bug reports, suggestions, commits welcome - documentation isnt this awesome but i try :)
#
# Since you already know that this is intentended as one file gentoo setup this is going to be easy as eating a delicious dinner!
#
# Lets start with the index, i wrote it to help organize the whole thing in logical sections and remain flexible to integrate deployment variables.
# THERE ARE 2 PLACES FOR VARIABLES: # 0.4 && # 3.1 - see index.

BANNER () { # 0.1 BANNER
	echo "${bold}
	+ +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	+    ____ _____ _   _ _____ ___   ___    _     ___ _   _ _   ___  __  +
	+   / ___| ____| \ | |_   _/ _ \ / _ \  | |   |_ _| \ | | | | \ \/ /  +
	+  | |  _|  _| |  \| | | || | | | | | | | |    | ||  \| | | | |\  /   +
	+  | |_| | |___| |\  | | || |_| | |_| | | |___ | || |\  | |_| |/  \   +
	+   \____|_____|_| \_| |_| \___/ \___/  |_____|___|_| \_|\___//_/\_\  +
	+								      +
	+  gentoo linux - by default LVM2 on LUKS, BIOS, GPT, SYSTEMD, XFCE   +
	+  Init commit 12.06.2019 					      +
	+  Script by https://github.com/alphaaurigae			      +
	+								      +
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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
		# 3.2.9 SYSTEMTIME
			# 3.2.9.1 SET_TIMEZONE (! $SYSTIMEZONE_SET)
				# 3.2.9.1.1 TIMEZONE_OPENRC 
				# 3.2.9.1.2 TIMEZONE_SYSTEMCTL 
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

	# DRIVES & PARTITIONS
	HDD1=/dev/sda # OS DRIVE - the drive you want to install gentoo to.
	# GRUB_PART=/dev/sda1 # bios grub
	BOOT_PART=/dev/sda2 # boot # unencrypted unless required changes are made - see CRYPTSETUP_BOOT 
	MAIN_PART=/dev/sda3 # mainfs - lukscrypt cryptsetup container with LVM env inside

	# - SWAP IS DISABLED -- SEE VAR & LVM SECTION TO ENABLE!
	# SWAP0=swap0 # LVM swap NAME for sorting of swap partitions.
	# SWAP_SIZE="1GB"  # (INSIDE LVM MAIN_PART - mainhdd only has boot & fainfs
	# SWAP_FS=linux-swap # swapfs, couldnt have guessed it

	BOOT_FS=ext2 # boot filesystem
	MAIN_FS=ext4 # main filesystem for the OS

	# LVM
	PV_MAIN=pv0_main # LVM PV physical volume
	VG_MAIN=vg0_main # LVM VG volume group
	LV_MAIN=lv0_main # LVM LV logical volume

	# PARTITION SIZE
	GRUB_SIZE="1M 150M" # bios grub sector start/end M for megabytes, G for gigabytes
	BOOT_SIZE="150M 1G" # boot sector start/end
	MAIN_SIZE="1G 100%" # primary partition start/end

	CHROOTX=/mnt/gentoo # chroot directory, installer will create this recursively

	# REGION=Europe # disabled for $SYSTEMTIMEZONE # # ls -la /usd/share/zoneinfo/$REGION/$CITY
	# CITY=Berlin
	VCONSOLE_KEYMAP=de-latin1 # console keymap
	VCONSOLE_FONT=eurlatgr
	LOCALE_GEN_a1="en_US ISO-8859-1"
	LOCALE_GEN_a2="en_US.UTF-8 UTF-8"
	LOCALE_GEN_b1="de_DE ISO-8859-1"
	LOCALE_GEN_b2="de_DE.UTF-8 UTF-8"
	LOCALE_CONF="en_US.UTF-8"
	X11KEYMAP="de" # keymap for desktop environment 
	HOSTNAME=p1p1 # define hostname
	DOMAIN=p1p1 # define domain
	SYSTIMEZONE=utc # utc or localtime # ls -la /usd/share/zoneinfo

	# NETWORK # https://en.wikipedia.org/wiki/Public_recursive_name_server
	NAMESERVER1_IPV4=1.1.1.1 # cloudflare ipv4
	NAMESERVER1_IPV6=2606:4700:4700::1111 # cloudflare ipv6
	NAMESERVER2_IPV4=1.0.0.1 # cloudflare ipv4
	NAMESERVER2_IPV6=2606:4700:4700::1001 # cloudflare ipv6


	DISPLAYSERV=XORG # see options
	DESKTOPENV=XFCE4 # see options
	DISPLAYMGR=LXDM # see options

	SYSUSERNAME=gentoo # name of the login user

	INITRAMFSVAR="--lvm --mdadm"

	GPU_DRIVER=amdgpu # amdgpu, radeon
	# VARIABLES END

	# MISC STATIC
	bold=$(tput bold) # staticvar bold text
	normal=$(tput sgr0) # # staticvar reverse to normal text

	EMERGE_VAR="--quiet --complete-graph --verbose " # !Must keep trailing space!

	STAGE3DEFAULT=AMD64_DEFAULT # AMD64_DEFAULT (default)
#######################################################################################################################
#  ___ _   _ ____ _____  _    _     _       ____ _____  _    ____ _____   _____  _    ____  ____    _    _     _      #
# |_ _| \ | / ___|_   _|/ \  | |   | |     / ___|_   _|/ \  / ___| ____| |_   _|/ \  |  _ \| __ )  / \  | |   | |     #
#  | ||  \| \___ \ | | / _ \ | |   | |     \___ \ | | / _ \| |  _|  _|     | | / _ \ | |_) |  _ \ / _ \ | |   | |     #
#  | || |\  |___) || |/ ___ \| |___| |___   ___) || |/ ___ \ |_| | |___    | |/ ___ \|  _ <| |_) / ___ \| |___| |___  #
# |___|_| \_|____/ |_/_/   \_\_____|_____| |____/ |_/_/   \_\____|_____|   |_/_/   \_\_| \_\____/_/   \_\_____|_____| #
#														      #
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage                                                      #
#######################################################################################################################
	DEPLOY_BASESYS () { # 2.0
		#  _____ ___ __  __ _____ 
		# |_   _|_ _|  \/  | ____|
		#   | |  | || |\/| |  _|  
		#   | |  | || |  | | |___ 
		#   |_| |___|_|  |_|_____|
		#                        
		# ... update the system time ... !important
		TIMEUPD () { # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Setting_the_date_and_time
			ntpd -q -g
		}
		#  __  __  ___  ____  ____  ____   ___  ____  _____ 
		# |  \/  |/ _ \|  _ \|  _ \|  _ \ / _ \| __ )| ____|
		# | |\/| | | | | | | | |_) | |_) | | | |  _ \|  _|  
		# | |  | | |_| | |_| |  __/|  _ <| |_| | |_) | |___ 
		# |_|  |_|\___/|____/|_|   |_| \_\\___/|____/|_____|
		#                                                  
		# ... load kernel modules for the chroot isntall process, for luks we def need the dm-crypt ...
		MODPROBE () {
			modprobe -a dm-mod dm_crypt # sha256
		}
		#  ____   _    ____ _____ ___ _____ ___ ___  _   _ ___ _   _  ____ 
		# |  _ \ / \  |  _ \_   _|_ _|_   _|_ _/ _ \| \ | |_ _| \ | |/ ___|
		# | |_) / _ \ | |_) || |  | |  | |  | | | | |  \| || ||  \| | |  _ 
		# |  __/ ___ \|  _ < | |  | |  | |  | | |_| | |\  || || |\  | |_| |
		# |_| /_/   \_\_| \_\|_| |___| |_| |___\___/|_| \_|___|_| \_|\____|
		#
		# .... glad you asked! ill take a coffee, ahh scew it, make it a triple espresso!                                                                  
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
		} # END
		# https://blog.stigok.com/2018/05/03/lvm-in-luks-with-encrypted-boot-partition-and-suspend-to-disk.html
		#   ____ ______   ______ _____ ____  _____ _____ _   _ ____  
		#  / ___|  _ \ \ / /  _ \_   _/ ___|| ____|_   _| | | |  _ \ 
		# | |   | |_) \ V /| |_) || | \___ \|  _|   | | | | | | |_) |
		# | |___|  _ < | | |  __/ | |  ___) | |___  | | | |_| |  __/ 
		#  \____|_| \_\|_| |_|    |_| |____/|_____| |_|  \___/|_|    
		#
		# ...  lvm on luks! Lets put EVERYTHING IN THE LUKS CONTAINER, to put the LVM INSIDE and the installation inside of the LVM "CRYPT --> BOOT/LVM2 --> OS - very simple :)" ...                                     
		CRYPTSETUP () { # https://wiki.archlinux.org/index.php/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS
			echo "${bold}enter the $PV_MAIN password${normal}"
			cryptsetup -v luksFormat --type luks2 $MAIN_PART --debug
			cryptsetup open $MAIN_PART $PV_MAIN
		}
		#  _ __     ____  __ 
		# | |\ \   / /  \/  |
		# | | \ \ / /| |\/| |
		# | |__\ V / | |  | |
		# |_____\_/  |_|  |_|
		#
		# ... LVM = "PV (Physical volume)-> VG (Volume group) > LV (Logical volume) inside of the luks crypt container ...             
		LVMONLUKS () {
			LVM_PV () { # Create physical volume for OS inst.
				pvcreate  /dev/mapper/$PV_MAIN
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
	#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	#  ____  ____  _____ ____   _    ____  _____    ____ _   _ ____   ___   ___ _____ !
	# |  _ \|  _ \| ____|  _ \ / \  |  _ \| ____|  / ___| | | |  _ \ / _ \ / _ \_   _|!
	# | |_) | |_) |  _| | |_) / _ \ | |_) |  _|   | |   | |_| | |_) | | | | | | || |  !
	# |  __/|  _ <| |___|  __/ ___ \|  _ <| |___  | |___|  _  |  _ <| |_| | |_| || |  !
	# |_|   |_| \_\_____|_| /_/   \_\_| \_\_____|  \____|_| |_|_| \_\\___/ \___/ |_|  !
	#										  !
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!	                                                                        
	PREPARE_CHROOT () { # 3.0 PREPARE CHROOT
		#
		#  ____   _____        ___   _ _     ___    _    ____    ____ _____  _    ____ _____ _____ 
		# |  _ \ / _ \ \      / / \ | | |   / _ \  / \  |  _ \  / ___|_   _|/ \  / ___| ____|___ / 
		# | | | | | | \ \ /\ / /|  \| | |  | | | |/ _ \ | | | | \___ \ | | / _ \| |  _|  _|   |_ \ 
		# | |_| | |_| |\ V  V / | |\  | |__| |_| / ___ \| |_| |  ___) || |/ ___ \ |_| | |___ ___) |
		# |____/ \___/  \_/\_/  |_| \_|_____\___/_/   \_\____/  |____/ |_/_/   \_\____|_____|____/ 
		#                                                  
		# ... Downloading the stage tarball ...
		# HTTPS:// ?
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
				wget -O $CHROOTX/stage3.tar.xz http://distfiles.gentoo.org/releases/amd64/autobuilds/"$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64-systemd.txt | sed '/^#/ d' | awk '{print $1}')"
				tar xvJpf $CHROOTX/stage3.tar.xz --xattrs-include='*.*' --numeric-owner -C $CHROOTX 
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
		#  _____ ____  _   _ ___ _     ____  
		# | ____| __ )| | | |_ _| |   |  _ \ 
		# |  _| |  _ \| | | || || |   | | | |
		# | |___| |_) | |_| || || |___| |_| |
		# |_____|____/ \___/|___|_____|____/ 
		#                                   
		# ... Gentoo ebuild repository ...
		EBUILD () { # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Gentoo_ebuild_repository
			mkdir --parents $CHROOTX/etc/portage/repos.conf
			cp $CHROOTX/usr/share/portage/config/repos.conf $CHROOTX/etc/portage/repos.conf/gentoo.conf # copy the Gentoo repository configuration file provided by Portage to the (newly created) repos.conf directory.
			# cat $CHROOTX/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
		}
		#  ____  _   _ ____  
		# |  _ \| \ | / ___| 
		# | | | |  \| \___ \ 
		# | |_| | |\  |___) |
		# |____/|_| \_|____/ 
		#
		# ... copy resolv.conf (DNS info) ...                                          
		RESOLVCONF () { # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Copy_DNS_info
			cp --dereference /etc/resolv.conf $CHROOTX/etc/
		}			
		BASHRC () {
			cat << 'EOF' > $CHROOTX/etc/skel/.bashrc_tmp
			#  ____    _    ____  _   _ ____   ____ 
			# | __ )  / \  / ___|| | | |  _ \ / ___|
			# |  _ \ / _ \ \___ \| |_| | |_) | |    
			# | |_) / ___ \ ___) |  _  |  _ <| |___ 
			# |____/_/   \_\____/|_| |_|_| \_\\____|
			#                      
			#  .bash.rc by alphaaurigae 11.08.19
			# ~/.bashrc: executed by bash(1) for non-login shells.
			# Examples: /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
			[[ $- != *i* ]] && return # # If not running interactively, don't do anything
			shopt -s histappend # append to the history file.
			HISTSIZE=1000 # max bash history lines.
			HISTFILESIZE=2000 # max bash history filesize in bytes.
			shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
			case "$TERM" in # set a fancy prompt (non-color, unless we know we "want" color)
			    xterm-color|*-256color) color_prompt=yes;;
			esac
			force_color_prompt=yes # terminal colors.
			if [ -n "$force_color_prompt" ]; then
			    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
				color_prompt=yes
			    else
				color_prompt=
			    fi
			fi
			if [ "$color_prompt" = yes ]; then
			# PS1='${arch_chroot:+($arch_chroot)}\[\033[01;32m\]\u@\h\[\036[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ ' # default
			PS1='${gentoo_chroot:+($debian_chroot)}\[\033[0;35m\][\[\033[0;32m\]\u\[\033[0;37m\]@\[\033[0;36m\]\h\[\033[0;37m\]:\[\033[0;37m\]\w\[\033[0;35m\]]\[\033[0;37m\]\$\[\033[0;37m\] ' # mod
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
		#  __  __ _   _ _____   _____ ____  
		# |  \/  | \ | |_   _| |  ___/ ___| 
		# | |\/| |  \| | | |   | |_  \___ \ 
		# | |  | | |\  | | |   |  _|  ___) |
		# |_|  |_|_| \_| |_|   |_|   |____/ 
		#                                  
		# ... ...
		MNTFS () { 
			#  ____    _    ____  _____ ______   ______  
			# | __ )  / \  / ___|| ____/ ___\ \ / / ___| 
			# |  _ \ / _ \ \___ \|  _| \___ \\ V /\___ \ 
			# | |_) / ___ \ ___) | |___ ___) || |  ___) |
			# |____/_/   \_\____/|_____|____/ |_| |____/ 
			#
			# ... Mounting the necessary filesystems ...
			MOUNT_BASESYS () { # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Mounting_the_necessary_filesystems
				mount --types proc /proc $CHROOTX/proc
				mount --rbind /sys $CHROOTX/sys
				mount --make-rslave $CHROOTX/sys
				mount --rbind /dev $CHROOTX/dev
				mount --make-rslave $CHROOTX/dev 

				# Warning
				# When using non-Gentoo installation media, this might not be sufficient. Some distributions make /dev/shm a symbolic link to /run/shm/ which, after the chroot, becomes invalid. Making /dev/shm/ a proper tmpfs mount up front can fix this:
				# test -L /dev/shm && rm /dev/shm && mkdir /dev/shm
				# mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
			}	 
			SETMODE_DEVSHM () {	
				chmod 1777 /dev/shm
			}
			MOUNT_BASESYS && echo "${bold}MOUNT_BASESYS - END, proceeding to SETMODE_DEVSHM ....${normal}"
			SETMODE_DEVSHM && echo "${bold}SETMODE_DEVSHM - END ...${normal}"
		}
		DL_STAGE			&& echo "${bold}DL_STAGE - END, proceeding to EBUILD ....${normal}"
		EBUILD				&& echo "${bold}EBUILD - END, proceeding to RESOLVCONF ....${normal}"
		RESOLVCONF			&& echo "${bold}RESOLVCONF - END, proceeding to MNTFS ....${normal}"
		MNTFS				&& echo "${bold}MNTFS - END, proceeding to CHROOT ....${normal}"
	}
#////////////////////////////////////////////////////////////////////////////////////////////////////////
#   ____ _   _ ____   ___   ___ _____   ____   ____ ____  ___ ____ _____   ____ _____  _    ____ _____  /
#  / ___| | | |  _ \ / _ \ / _ \_   _| / ___| / ___|  _ \|_ _|  _ \_   _| / ___|_   _|/ \  |  _ \_   _| /
# | |   | |_| | |_) | | | | | | || |   \___ \| |   | |_) || || |_) || |   \___ \ | | / _ \ | |_) || |   /
# | |___|  _  |  _ <| |_| | |_| || |    ___) | |___|  _ < | ||  __/ | |    ___) || |/ ___ \|  _ < | |   /
#  \____|_| |_|_| \_\\___/ \___/ |_|   |____/ \____|_| \_\___|_|    |_|   |____/ |_/_/   \_\_| \_\|_|   /
#                                                                                                       /
# ... Entering the new environment ... 		                                                        /
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment            /
#													/
#////////////////////////////////////////////////////////////////////////////////////////////////////////
# 4.0 CHROOT
INNER_SCRIPT=$(cat << 'INNERSCRIPT'
#!/bin/bash

		# https://github.com/alphaaurigae

		env-update
		source /etc/profile
		# export PS1="(autochroot) \$PS1" # Not that the user will see this.
		export PS1="(chroot) $PS1" 

		#### option variables start (note!: not all variables are active, depending on the module choices you take! (if there is no docs yet, just read down, very simple  :) ... ) 
		## this is a blueprint prototype for a unified modular gento installation, as script, in one file for easy use 
		# FE: "run virtualbox >> gentominimal https://www.gentoo.org/downloads/ >> wget awesome script >> convert to unix FF >> ./run-awesome.sh  >> awesome new gento install".

		# lets start with a very simple default configuration to simplify things a little and provide a platform to experiment.

		SYSLOCALE="de_DE.UTF-8"
		SYSDATE_SET=AUTO
		SYSDATE_MAN=071604551969
		SYSCLOCK_SET=AUTO # USE MANUAL OR AUTO -- WITH MANUAL YOU DONT GET TIMESYNCED SERVICE
		SYSCLOCK_MAN="1969-07-16 04:55:42"
		SYSTIMEZONE_SET="Europe/Berlin" # Europe/Berlin format for SYSTEMD ; Europe/Brussels foiormat for OPENRC
		PRESET_INPUTEVICE="libinput keyboard"
		PRESET_VIDEODRIVER='amdgpu radeonsi radeon'
		PRESET_LICENCES="-* @FREE" # Only accept licenses in the FREE license group (i.e. Free Software)
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
		PRESET_USEFLAG='X a52 aac aalib acl acpi adns alsa atm audit bash-completion berkdb bidi blas boost branding bzip2 \
					cairo cdda caps cpudetection cjk cracklib crypt cryptsetup css curl cvs cxx dbi dbus device-mapper dns-over-tls dga elfutils \
					efiemu emacs encode exif expat fam ffmpeg filecaps flac fonts fortran ftp geoip gcrypt gd gif git gnuefi gnutls gnuplot \
					hardened highlight gzip ipv6 int64 introspection idn jack jpeg jemalloc kernel kms lame latex ldap libcaca libressl lm_sensors \
					lua lzma lzo lz4 m17n-lib matroska memcached mhash modules mount nettle numa mp3 mp4 mpeg mtp nls ocaml opengl openssl opus osc oss \
					pcre perl png policykit posix pulseaudio python raw readline resolvconf qt5 recode ruby sound seccomp sasl sockets \
					socks5 ssl sssd static-libs sqllite sqlite3 svg systemd sysv-utils szip symlink tcl tcpd themes thin truetype threads tiff udev udisks unicode xkb xvid zip zlib \
					-kde -cups -bluetooth -libnotify -mysql -apache -apache2 -dropbear -redis -mssql -postgres -telnet'
		PRESET_FEATURES="sandbox binpkg-docompress binpkg-dostrip binpkg-dostrip candy cgroup clean-logs collision-protect \
						compress-build-logs downgrade-backup fail-clean fixlafiles force-mirror ipc-sandbox merge-sync \
						network-sandbox noman parallel-fetch parallel-install pid-sandbox userpriv usersandbox"
		PRESET_GENTOMIRRORS="https://ftp.snt.utwente.nl/pub/os/linux/gentoo/ https://mirror.isoc.org.il/pub/gentoo/ \
						https://mirrors.lug.mtu.edu/gentoo/ https://mirror.csclub.uwaterloo.ca/gentoo-distfiles/ \
						https://ftp.jaist.ac.jp/pub/Linux/Gentoo/"

		SYSINITVAR=SYSTEMD # SYSTEMD (default) OR OPENRC - MUST BE ALL CAPS TO MATCH VARIABLE, set and enjoy magig (OPENRC NOT SUPPORTED YET; FEELS FREE TO MAKE OPENRC WORK AND PUSH TO GITHUB :))
		CONFIGKERN=MANUAL # AUTO / MANUAL
		NETWORK_NET=DHCPD # DHCPD or STATIC, config static on your own in the network section.	
		KERNVERS=5.3-rc4
		KERNSOURCES=EMERGE # EMERGE (DEFAULT) ; TORVALDS (git repository)
		CRONSET=CRONIE # CRONIE, DCRON, ANACRON ..... see on your own 
		
		# MISC STATIC
			bold=$(tput bold) # staticvar bold text
			normal=$(tput sgr0) # # staticvar reverse to normal text
			EMERGE_VAR="--quiet --complete-graph --verbose " # !Must keep trailing space!

		BASE_SYSTEM () {
			#  _____ ____  _   _ ___ _     ____    ____  _   _    _    ____  ____  _   _  ___ _____ 
			# | ____| __ )| | | |_ _| |   |  _ \  / ___|| \ | |  / \  |  _ \/ ___|| | | |/ _ \_   _|
			# |  _| |  _ \| | | || || |   | | | | \___ \|  \| | / _ \ | |_) \___ \| |_| | | | || |  
			# | |___| |_) | |_| || || |___| |_| |  ___) | |\  |/ ___ \|  __/ ___) |  _  | |_| || |  
			# |_____|____/ \___/|___|_____|____/  |____/|_| \_/_/   \_\_|   |____/|_| |_|\___/ |_|  
			#     
			CONFIG_PORTAGE () { # https://wiki.gentoo.org/wiki/Portage#emerge-webrsync && https://dev.gentoo.org/~zmedico/portage/doc/man/emerge.1.html
				echo "${bold}CONFIG_PORTAGE${normal}"
				mkdir /usr/portage
				emerge-webrsync
			}
			INSTALL_PCIUTILS () {
				echo "${bold}INSTALL_PCIUTILS${normal}"
				emerge $EMERGE_VAR sys-apps/pciutils 
			}
			INSTALL_MULTIPATH () {
				echo "${bold}INSTALL_MULTIPATH${normal}"
				emerge $EMERGE_VAR sys-fs/multipath-tools
			}
			INSTALL_GNUPG () {
				echo "${bold}INSTALL_GNUPG${normal}"
				emerge $EMERGE_VAR app/crypt/gnupg
				gpg --full-gen-key
			}
			#  ______   ___   _  ____ 
			# / ___\ \ / / \ | |/ ___|
			# \___ \\ V /|  \| | |    
			#  ___) || | | |\  | |___ 
			# |____/ |_| |_| \_|\____|
			#                        
			#
			EMERGE_SYNC () {
				echo "${bold}EMERGE_SYNC${normal}"
				emerge --sync
				echo "${bold}EMERGE_SYNC done${normal}"
			}
			#  ____  _____ _     _____ ____ _____   ____  ____   ___  _____ ___ _     _____ 
			# / ___|| ____| |   | ____/ ___|_   _| |  _ \|  _ \ / _ \|  ___|_ _| |   | ____|
			# \___ \|  _| | |   |  _|| |     | |   | |_) | |_) | | | | |_   | || |   |  _|  
			#  ___) | |___| |___| |__| |___  | |   |  __/|  _ <| |_| |  _|  | || |___| |___ 
			# |____/|_____|_____|_____\____| |_|   |_|   |_| \_\\___/|_|   |___|_____|_____|
			#                                                                                                                     
			SELECT_PROFILE () { # https://wiki.gentoo.org/wiki/Profile_(Portage)
				# eselect profile set 19 # hardened selinux stable 17.1
				echo "${bold}SELECT_PROFILE${normal}"
				eselect profile set 29 # 17.1 systemd
				echo "${bold}SELECT_PROFILE end${normal}"
			}
			#    ______        _____  ____  _     ____  ____  _____ _____ 
			#   / __ \ \      / / _ \|  _ \| |   |  _ \/ ___|| ____|_   _|
			#  / / _` \ \ /\ / / | | | |_) | |   | | | \___ \|  _|   | |  
			# | | (_| |\ V  V /| |_| |  _ <| |___| |_| |___) | |___  | |  
			#  \ \__,_| \_/\_/  \___/|_| \_\_____|____/|____/|_____| |_|  
			#   \____/                                                    
			#                                                    
			WORLDSET () { # https://wiki.gentoo.org/wiki/World_set_(Portage)
				echo "${bold}WORLDSET${normal}"
				emerge $EMERGE_VAR --update --deep --newuse @world
				echo "${bold}WORLDSET done${normal}"
			}
			#  __  __    _    _  _______   ____ ___  _   _ _____ 
			# |  \/  |  / \  | |/ / ____| / ___/ _ \| \ | |  ___|
			# | |\/| | / _ \ | ' /|  _|  | |  | | | |  \| | |_   
			# | |  | |/ ___ \| . \| |___ | |__| |_| | |\  |  _|  
			# |_|  |_/_/   \_\_|\_\_____(_)____\___/|_| \_|_|    
			#
			MAKECONF () { # https://wiki.gentoo.org/wiki//etc/portage/make.conf
				echo "${bold}MAKECONF${normal}"
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
					USE="${COMMON_CPUFLAGS} $PRESET_USEFLAG"
					# https://www.gentoo.org/downloads/mirrors/
					GENTOO_MIRRORS="$PRESET_GENTOMIRRORS"
					# RSYNC MIRRORS https://www.gentoo.org/support/rsync-mirrors
					PORTDIR="/var/db/repos/gentoo"
					DISTDIR="var/cache/distfiles"
					PKGDIR="/var/cache/binpkgs"
					LC_MESSAGE=C
EOF
				}			                         
				MAKECONF_VARIABLES
				emerge $EMERGE_VAR --changed-use @world
				echo "${bold}MAKECONF done${normal}"
			}
			#  ______   ______ _____ _____ __  __   _____ ___ __  __ _____ 
			# / ___\ \ / / ___|_   _| ____|  \/  | |_   _|_ _|  \/  | ____|
			# \___ \\ V /\___ \ | | |  _| | |\/| |   | |  | || |\/| |  _|  
			#  ___) || |  ___) || | | |___| |  | |   | |  | || |  | | |___ 
			# |____/ |_| |____/ |_| |_____|_|  |_|   |_| |___|_|  |_|_____|
			#                                                             
			SYSTEMTIME () { # https://wiki.gentoo.org/wiki/System_time
				echo "${bold}SYSTEMTIME${normal}"
				#  _____ ___ __  __ _____ ________  _   _ _____ 
				# |_   _|_ _|  \/  | ____|__  / _ \| \ | | ____|
				#   | |  | || |\/| |  _|   / / | | |  \| |  _|  
				#   | |  | || |  | | |___ / /| |_| | |\  | |___ 
				#   |_| |___|_|  |_|_____/____\___/|_| \_|_____|
				#                                              
				SET_TIMEZONE () { # https://wiki.gentoo.org/wiki/System_time#Time_zone
					TIMEZONE_OPENRC () { # openrc switch (option variables top)  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Timezone
						echo "$SYSTIMEZONE_SET" > /etc/timezone
						emerge --config sys-libs/timezone-data
					}
					TIMEZONE_SYSTEMD () {
						timedatectl set-timezone $SYSTIMEZONE_SET
					}
					TIMEZONE_$SYSINITVAR
				}
				#  ______   ______ _____ _____ __  __    ____ _     ___   ____ _  __
				# / ___\ \ / / ___|_   _| ____|  \/  |  / ___| |   / _ \ / ___| |/ /
				# \___ \\ V /\___ \ | | |  _| | |\/| | | |   | |  | | | | |   | ' / 
				#  ___) || |  ___) || | | |___| |  | | | |___| |__| |_| | |___| . \ 
				# |____/ |_| |____/ |_| |_____|_|  |_|  \____|_____\___/ \____|_|\_\
				#                                                                  
				SYSTEMCLOCK () { # https://wiki.gentoo.org/wiki/System_time#System_clock
					echo "${bold}SYSTEMCLOCK${normal}"
					OPENRC_SYSTEMCLOCK () {
						OPENRC_SYSCLOCK_MANUAL () { # switch to manual configuration (option variables top)
							OPENRC_SYSTEMCLOCK () {
								date $SYSDATE_MAN
							}
							OPENRC_SYSTEMCLOCK
						}
						OPENRC_OPENNTPD () {
							EMERGE_OPENTPD () {
								emerge $EMERGE_VAR net-misc/openntpd
							}
							SYSSTART_OPENNTPD () {
								/etc/init.d/ntpd start
								rc-update add ntpd default
							}
							EMERGE_OPENTPD
							SYSSTART_OPENNTPD
						}
						# OPENRC_SYSCLOCK_MANUAL # only 1 can be set
						OPENRC_OPENNTPD
					}
					SYSTEMCTL_SYSTEMCLOCK () { # https://wiki.gentoo.org/wiki/System_time#Hardware_clock
						SYSTEMCTL_SYSCLOCK_MANUAL () { # switch to manual configuration (option variables top)
							timedatectl set-time "$SYSCLOCK_MAN"
						}
						SYSTEMCTL_SYSCLOCK_AUTO () { # switch to auto (option variables top)
							SYSSTART_TIMESYND () {
								systemctl enable systemd-timesyncd
								systemctl start systemd-timesyncd
							}
							SYSSTART_TIMESYND
						}
						SYSTEMCTL_SYSCLOCK_$SYSCLOCK_SET
					}
					SYSTEMCLOCK_$SYSINITVAR
				}
				#  _   ___        ______ _     ___   ____ _  __
				# | | | \ \      / / ___| |   / _ \ / ___| |/ /
				# | |_| |\ \ /\ / / |   | |  | | | | |   | ' / 
				# |  _  | \ V  V /| |___| |__| |_| | |___| . \ 
				# |_| |_|  \_/\_/  \____|_____\___/ \____|_|\_\
				#                                             
				HWCLOCK () {
					echo "${bold}HWCLOCK${normal}"
					HWCLOCK_OPENRC () { # openrc switch (option variables top) 
						echo 'placeholder'
					}
					HWCLOCK_SYSTEMD () { # systemd switch (option variables top) 
						timedatectl set-local-rtc 0 # set UTC
					}
					HWCLOCK_$SYSINITVAR
				}
				TIMEZONE
				SYSTEMCLOCK
				HWCLOCK
			}
			#  _     ___   ____    _    _     _____ ____  
			# | |   / _ \ / ___|  / \  | |   | ____/ ___| 
			# | |  | | | | |     / _ \ | |   |  _| \___ \ 
			# | |__| |_| | |___ / ___ \| |___| |___ ___) |
			# |_____\___/ \____/_/   \_\_____|_____|____/ 
			#                                       
			CONF_LOCALES () { # https://wiki.gentoo.org/wiki/Localization/Guide
				echo "${bold}CONF_LOCALES${normal}"
				CONF_LOCALEGEN () {
					cat << EOF > /etc/locale.gen
					$LOCALE_GEN_a1
					$LOCALE_GEN_a2
					$LOCALE_GEN_b1
					$LOCALE_GEN_b2
EOF
				}
				GEN_LOCALE () {
					locale-gen
				}
				SYS_LOCALE () {
					cat << EOF > /etc/env.d/02locale
					LANG="$SYSLOCALE"
					LC_COLLATE="C"
EOF
				}
				RELOAD_LOCALE_ENV () {
					env-update && source /etc/profile && export PS1="(chroot) ${PS1}" # reload
				}
				CONF_LOCALEGEN
				GEN_LOCALE
				# YS_LOCALE
				RELOAD_LOCALE_ENV
				echo "${bold}CONF_LOCALES end${normal}"
			}
			#  ___ _   _ ___ _____ ______   ______ _____ _____ __  __ 
			# |_ _| \ | |_ _|_   _/ ___\ \ / / ___|_   _| ____|  \/  |
			#  | ||  \| || |  | | \___ \\ V /\___ \ | | |  _| | |\/| |
			#  | || |\  || |  | |  ___) || |  ___) || | | |___| |  | |
			# |___|_| \_|___| |_| |____/ |_| |____/ |_| |_____|_|  |_|
			#
			INITSYSTEM () { # https://wiki.gentoo.org/wiki/Init_system && https://wiki.gentoo.org/wiki/Comparison_of_init_systems
				echo "${bold}INITSYSTEM${normal}"
				#   ___  ____  _____ _   _ ____   ____ 
				#  / _ \|  _ \| ____| \ | |  _ \ / ___|
				# | | | | |_) |  _| |  \| | |_) | |    
				# | |_| |  __/| |___| |\  |  _ <| |___ 
				#  \___/|_|   |_____|_| \_|_| \_\\____|
				#                                     
				INITSYS_OPENRC () { # openrc switch (option variables top)  # https://wiki.gentoo.org/wiki/OpenRC
					CONFIG_OPENRC () { # openrc switch (option variables top) 
						#  ____   ____ ____ ___  _   _ _____ 
						# |  _ \ / ___/ ___/ _ \| \ | |  ___|
						# | |_) | |  | |  | | | |  \| | |_   
						# |  _ <| |__| |__| |_| | |\  |  _|  
						# |_| \_\\____\____\___/|_| \_|_|    
						#                                   
						RCCONF () {
							nano -w /etc/rc.conf
						}
						RCCONF
					}
					CONFIG_OPENRC
				}
				#  ______   ______ _____ _____ __  __ ____  
				# / ___\ \ / / ___|_   _| ____|  \/  |  _ \ 
				# \___ \\ V /\___ \ | | |  _| | |\/| | | | |
				#  ___) || |  ___) || | | |___| |  | | |_| |
				# |____/ |_| |____/ |_| |_____|_|  |_|____/ 
				#	
				INITSYS_SYSTEMD () { # systemd switch (option variables top)  # https://wiki.gentoo.org/wiki/Systemd
					REMOVE_UDEV () {
						emerge --deselect sys-fs/udev
						emerge --unmerge sys-fs/udev
					}
					REMOVE_OPENRC () {
						emerge --deselect sys-apps/openrc
						emerge --unmerge sys-apps/openrc
						rm /etc/portage/package.mask/systemd
					}
					EMERGE_SYSTEMDANDDEPS () {
						emerge $EMERGE_VAR sys-apps/pciutils
						emerge $EMERGE_VAR sys-apps/dbus
						emerge $EMERGE_VAR app-portage/gentoolkit
						euse -E cryptsetup systemd gudev dbus
						emerge $EMERGE_VAR sys-apps/systemd
						emerge $EMERGE_VAR sys-apps/systemd-integration
					}
					ETCMTAB () {
						ln -sf /proc/self/mounts /etc/mtab
					}
					REMOVE_UDEV
					REMOVE_OPENRC
					EMERGE_SYSTEMDANDDEPS
					ETCMTAB
					systemctl preset-all
				}
				INITSYS_$SYSINITVAR
				echo "${bold}INITSYSTEM end${normal}"
			}
			#  _____ ___ ____  __  ____        ___    ____  _____ 
			# |  ___|_ _|  _ \|  \/  \ \      / / \  |  _ \| ____|
			# | |_   | || |_) | |\/| |\ \ /\ / / _ \ | |_) |  _|  
			# |  _|  | ||  _ <| |  | | \ V  V / ___ \|  _ <| |___ 
			# |_|   |___|_| \_\_|  |_|  \_/\_/_/   \_\_| \_\_____|
			#
			FIRMWARE () {
				echo "${bold}FIRMWARE${normal}"
				LINUX_FIRMWARE () { # https://wiki.gentoo.org/wiki/Linux_firmware
					emerge $EMERGE_VAR sys-kernel/linux-firmware
				}
				LINUX_FIRMWARE
				echo "${bold}FIRMWARE end${normal}"
			}
			CONFIG_PORTAGE		&& echo "${bold}CONFIG_PORTAGE - END ....${normal}"
			MAKECONF		&& echo "${bold}MAKECONF - END ....${normal}"
			INSTALL_PCIUTILS	&& echo "${bold}INSTALL_PCIUTILS - END ....${normal}"
			INSTALL_MULTIPATH	&& echo "${bold}INSTALL_MULTIPATH - END ....${normal}"
			EMERGE_SYNC		&& echo "${bold}EMERGE_SYNC - END ....${normal}"
			SELECT_PROFILE		&& echo "${bold}SELECT_PROFILE - END ....${normal}"
			WORLDSET		&& echo "${bold}WORLDSET - END ....${normal}"
			# SYSTEMTIME		&& echo "${bold}SYSTEMTIME - END ....${normal}"
			# CONF_LOCALES		&& echo "${bold}CONF_LOCALES - END ....${normal}"
			## INITSYSTEM		&& echo "${bold}INITSYSTEM - END ....${normal}"
			# FIRMWARE		&& echo "${bold}FIRMWARE - END, proceeding to CHROOT ....${normal}"
			echo "${bold}BASE_SYSTEM end${normal}"
		}
		INST_SYSAPP () {
			#   ____ ______   ______ _____ ____  _____ _____ _   _ ____  
			#  / ___|  _ \ \ / /  _ \_   _/ ___|| ____|_   _| | | |  _ \ 
			# | |   | |_) \ V /| |_) || | \___ \|  _|   | | | | | | |_) |
			# | |___|  _ < | | |  __/ | |  ___) | |___  | | | |_| |  __/ 
			#  \____|_| \_\|_| |_|    |_| |____/|_____| |_|  \___/|_|    
			#
			INSTALL_CRYPTSETUP () { # https://wiki.gentoo.org/wiki/Dm-crypt
				emerge $EMERGE_VAR sys-fs/cryptsetup
				SYSSTART_CRYPTSETUP_OPENRC () { # openrc switch (option variables top) 
					rc-update add dmcrypt boot
				}
				SYSSTART_CRYPTSETUP_SYSTEMD () { # systemd switch (option variables top) 
					rc-update add dmcrypt boot
				}
				SYSSTART_CRYPTSETUP_$SYSINITVAR	
			}
			#  _ __     ____  __ ____  
			# | |\ \   / /  \/  |___ \ 
			# | | \ \ / /| |\/| | __) |
			# | |__\ V / | |  | |/ __/ 
			# |_____\_/  |_|  |_|_____|
			#                         
			INSTALL_LVM2 () { # https://wiki.gentoo.org/wiki/LVM/de
				emerge $EMERGE_VAR sys-fs/lvm2
				SYSSTART_LVM2 () {
					BOOT_START_LVM2_OPENRC () { # openrc switch (option variables top) 
						rc-update add lvm boot
					}
					BOOT_START_LVM2_SYSTEMD () { # systemd switch (option variables top) 
						systemctl enable lvm2-monitor.service
					}
					BOOT_START_LVM2_$SYSINITVAR
				}
				CONFIG_LVM2 () {
					LVM_CONF () {
						sed -e 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf > /tmp/lvm.conf && mv /tmp/lvm.conf /etc/lvm/lvm.conf
						# use_lvmetad = 0
					}
					LVM_CONF
				}
				SYSSTART_LVM2
				CONFIG_LVM2
			}
			#  ____  _   _ ____   ___  
			# / ___|| | | |  _ \ / _ \ 
			# \___ \| | | | | | | | | |
			#  ___) | |_| | |_| | |_| |
			# |____/ \___/|____/ \___/ 
			#
			INSTALL_SUDO () { # https://wiki.gentoo.org/wiki/Sudo
				emerge $EMERGE_VAR app-admin/sudo # must keep trailing
				cp /etc/sudoers /etc/sudoers_bak
				sed -i -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
			}
			#  ______   ______  _     ___   ____ 
			# / ___\ \ / / ___|| |   / _ \ / ___|
			# \___ \\ V /\___ \| |  | | | | |  _ 
			#  ___) || |  ___) | |__| |_| | |_| |
			# |____/ |_| |____/|_____\___/ \____|
			#                                   
			INST_LOGGER () {
				LOGROTATION () {
					LOGROTATE () {
						emerge $EMERGE_VAR app-admin/logrotate
					}
					LOGROTATE
				}
				SYSLOG () {
					SYSLOGNG () {
						emerge $EMERGE_VAR app-admin/syslog-ng
						SYSSTART_SYSLOGNG () {
							SYSLOGNG_OPENRC () { # openrc switch (option variables top) 
								rc-update add syslog-ng default
								rc-service syslog-ng start
							}
							SYSLOGNG_SYSTEMD () { # systemd switch (option variables top) 
								systemctl enable syslog-ng@default
								systemctl start syslog-ng@default
							}
							SYSLOGNG_$SYSINITVAR
						}
						SYSSTART_SYSLOGNG
					}
					SYSKLOGD () {
						emerge $EMERGE_VAR app-admin/sysklogd
						rc-update add sysklogd default
						SYSSTART_SYSKLOGD () {
							SYSKLOGD_OPENRC () { # openrc switch (option variables top) 
								echo "palceholder"
							}
							SYSKLOGD_SYSTEMD () { # systemd switch (option variables top) 
								systemctl enable rsyslog
								systemctl start rsyslog
							}
							SYSKLOGD_$SYSINITVAR
						}
						SYSSTART_SYSKLOGD
					}
					SYSLOGNG
					# SYSKLOGD
				}
				LOGROTATION
				SYSLOG
			}
			#   ____ ____   ___  _   _ 
			#  / ___|  _ \ / _ \| \ | |
			# | |   | |_) | | | |  \| |
			# | |___|  _ <| |_| | |\  |
			#  \____|_| \_\\___/|_| \_|
			#                         
			INST_CRON () {
				CRON_CRONIE () {
					emerge $EMERGE_VAR sys-process/cronie
					CRONIE_OPENRC () { # openrc switch (option variables top) 
						rc-update add cronie default
					}
					CRONIE_SYSTEMD () { # systemd switch (option variables top) 
						systemctl enable cronie
						systemctl start cronie 
						systemctl restart cronie 
					}
					CRONIE_$SYSINITVAR
				}
				CRON_DCRON () {
					emerge $EMERGE_VAR dcron
					DCRON_OPENRC () { # openrc switch (option variables top) 
						/etc/init.d/dcron start
						rc-update add dcron default
					}
					DCRON_SYSTEMD () { # systemd switch (option variables top) 
						systemctl enable dcron
						systemctl start dcron 
					}
				CRONIE_$SYSINITVAR
				}
				CRON_ANACRON () {
					emerge $EMERGE_VAR anacron
					ANACRON_OPENRC () { # openrc switch (option variables top) 
						/etc/init.d/anacron start
						rc-update add anacron default
					}
					ANACRON_SYSTEMD () { # systemd switch (option variables top) 
						systemctl enable anacron
						systemctl start anacron 
					}
				ANACRON_$SYSINITVAR
				}
				CRON_FCRON () {
					emerge $EMERGE_VAR fcron
					gpasswd -a $SYSUSERNAME fcron
					FCRON_OPENRC () { # openrc switch (option variables top) 
						/etc/init.d/fcron start
						rc-update add fcron default
					}
					FCRON_SYSTEMD () { # systemd switch (option variables top) 
						systemctl enable fcron
						systemctl start fcron 
					}
				FCRON_$SYSINITVAR
				}
				CRON_BCRON () {
					emerge $EMERGE_VAR bcron
					BCRON_OPENRC () { # openrc switch (option variables top) 
						/etc/init.d/bcron start
						rc-update add bcron default
					}
					BCRON_SYSTEMD () { # systemd switch (option variables top) 
					systemctl enable bcron
					systemctl start bcron 
					}
				BCRON_$SYSINITVAR
				}
				CRON_VIXICRON () {
					emerge $EMERGE_VAR fcron
					VIXICRON_OPENRC () { # openrc switch (option variables top) 
						/etc/init.d/vixi start
						rc-update add vixi default
					}
					VIXICRON_SYSTEMD () { # systemd switch (option variables top) 
						systemctl enable vixi
						systemctl start vixi 
					}
				VIXICRON_$SYSINITVAR
				}
				CRON_$CRONSET
				# CRON_DCRON
				# CRON_ANACRON
				# CRON_FCRON
				# CRON_BCRON
				# CRON_VIXICRON
				crontab /etc/crontab
			}
			#  _____ ___ _     _____   ___ _   _ ____  _______  __
			# |  ___|_ _| |   | ____| |_ _| \ | |  _ \| ____\ \/ /
			# | |_   | || |   |  _|    | ||  \| | | | |  _|  \  / 
			# |  _|  | || |___| |___   | || |\  | |_| | |___ /  \ 
			# |_|   |___|_____|_____| |___|_| \_|____/|_____/_/\_\
			#
			FILEINDEXING () {
				emerge $EMERGE_VAR sys-apps/mlocate
			}
			#  _____ ____ _____ ___   ___  _     ____  
			# |  ___/ ___|_   _/ _ \ / _ \| |   / ___| 
			# | |_  \___ \ | || | | | | | | |   \___ \ 
			# |  _|  ___) || || |_| | |_| | |___ ___) |
			# |_|   |____/ |_| \___/ \___/|_____|____/ 
			#                                         
			FSTOOLS () {
				emerge $EMERGE_VAR sys-fs/e2fsprogs # Ext2, 3, and 4
				# emerge $EMERGE_VAR sys-fs/xfsprogs # XFS 			
				# emerge $EMERGE_VAR sys-fs/reiserfsprogs # ReiserFS	
				# emerge $EMERGE_VAR sys-fs/jfsutils # JFS 	
				## emerge $EMERGE_VAR sys-fs/dosfstools # VFAT (FAT32, ...) 	
				# emerge $EMERGE_VAR sys-fs/btrfs-progs # Btrfs 
			}
			INSTALL_GIT () {
				emerge $EMERGE_VAR dev-vcs/git
			}
			INSTALL_GIT
			INSTALL_CRYPTSETUP
			INSTALL_LVM2
			INSTALL_SUDO
			INST_LOGGER
			INST_CRON
			# FILEINDEXING
			FSTOOLS
		}
			# sys-apps/pciutils  	app-crypt/gnupg sys-fs/multipath-tools
			#  _  _______ ____  _   _ _____ _     
			# | |/ / ____|  _ \| \ | | ____| |    
			# | ' /|  _| | |_) |  \| |  _| | |    
			# | . \| |___|  _ <| |\  | |___| |___ 
			# |_|\_\_____|_| \_\_| \_|_____|_____|
			#                           
			BUILD_KERNEL () { # https://wiki.gentoo.org/wiki/Kernel
				KERNEL_SOURCE () { # we need some sources, kinda obv xD
					KERN_SOURCES_EMERGE () { # so shall it be the gentoo kernel?
						emerge $EMERGE_VAR sys-kernel/gentoo-sources
					}
					KERN_SOURCES_TORVALDS () { # or lets fetch one of f some stranger github profile? (hope you installed git :) )
						git clone https://github.com/torvalds/linux # clone to usr src linux
						rm -rf /usr/src/linux
						mv linux /usr/src/linux
						cd /usr/src/linux
						git fetch && git fetch --tags
						git checkout v$KERNVERS
					}
					KERN_SOURCES_$KERNSOURCES
				}
				CONFIGURE_KERNEL () {
					CONFKERN_MANUAL () { # switch to manual configuration (option variables top) # guess an initramfs needs to be generated with dracut or the like? still new to gentoo, using genkernel for testing.
					lsmod # active modules by install medium.
						CNFG_KERN_PASTE () { # lets paste our own config here (maybe this should go to auto afterall)
							mv /usr/src/linux/.conf /usr/src/linux/.oldconf
							touch /usr/src/linux/.conf
							cat < EOF > /usr/src/linux/.conf
							PLACEHOLDER - your custom linux/.conf kernel conf goes here!
EOF
						}
						MKERNBUILD (){
							/usr/src/linux/make menuconfig
							cd /usr/src/linux
							make -j $(nproc) -o /usr/src/linux/.conf
							make -j $(nproc) -o /usr/src/linux/.conf modules
							sudo make modules_install
							sudo make install
						}
						# CNFG_KERN_PASTE
						MKERNBUILD
					}
					CONFKERN_AUTO () { # switch to auto (option variables top) # switch to auto configuration (option variables top)
						GENKERNEL () {
							CKA_OPENRC () { # openrc switch (option variables top)  # ONLY SAMPLE; FIX ON YOUR OWN OERR USE SYSTEMD # config kernel with genkernel for openrc		
								emerge $EMERGE_VAR sys-kernel/genkernel
								CONFGENKERNEL_OPENRC () { # openrc switch (option variables top) 
									cat < EOF > /etc/genkernel.conf
									placeholder
EOF
								}
								RUNGENKERNEL_OPENRC () { # openrc switch (option variables top) 
									# genkernel "$GENKERNEL_ALL_VAR" # generate kernel WITHOUT initramfs
									genkernel "$GENKERNEL_ALL_VAR" initramfs # generate kernel and initramfs
								}
								GENKERNEL_OPENRC
								CONFGENKERNEL_OPENRC
							}
							CKA_SYSTEMD () { # systemd switch (option variables top)  # config kernel with genkernel-next for systemd
								emerge $EMERGE_VAR sys-kernel/genkernel-next
								CONFGENKERNEL_SYSTEMD () { # systemd switch (option variables top) 
									cat < 'EOF' > /etc/genkernel.conf
									INSTALL="yes"
									MOUNTBOOT="yes"
									OLDCONFIG="yes"
									MENUCONFIG="yes"
									NCONFIG="no"
									CLEAN="yes"
									MRPROPER="yes"
									SYMLINK="yes"
									SAVE_CONFIG="yes"
									USECOLOR="yes"
									CLEAR_CACHE_DIR="yes"
									POSTCLEAR="1"
									MAKEOPTS="-j$(nproc) --quiet "
									LVM="yes"
									LUKS="yes"
									GPG="yes"
									DMRAID="no"
									#MDADM="no"
									BUSYBOX="yes"
									UDEV="yes"
									MULTIPATH="yes"
									ISCSI="yes"
									E2FSPROGS="yes"
									FIRMWARE="yes"
									FIRMWARE_SRC="/lib/firmware"
									SPLASH="no"
									SPLASH_THEME="gentoo"
									SAVE_CONFIG="yes"
									MICROCODE="all"
									DISKLABEL="yes"
									# PLYMOUTH="yes"
									BOOTDIR="/boot"
									GK_SHARE="${GK_SHARE:-/usr/share/genkernel}"
									CACHE_DIR="/var/cache/genkernel"
									DISTDIR="/var/lib/genkernel/src"
									LOGFILE="/var/log/genkernel.log"
									LOGLEVEL=1
									DEFAULT_KERNEL_SOURCE="/usr/src/linux"
									COMPRESS_INITRD="yes"
									COMPRESS_INITRD_TYPE="best"
									BOOTLOADER="grub2"
									#INTEGRATED_INITRAMFS="1"
									#ALLRAMDISKMODULES="1"
EOF
								}
								RUNGENKERNEL_SYSTEMD () { # systemd switch (option variables top) 
										# genkernel-next  # generate kernel WITHOUT initramfs
										genkernel-next all # generate kernel and initramfs
								}
								CONFGENKERNEL_SYSTEMD
								RUN_GENKERNELNEXT_SYSTEMD
							}
							CKA_$SYSINITVAR && echo "${bold}CKA_$SYSINITVAR - END ....${normal}"
						} # genkernel end
						GENKERNEL
					}
					CONFKERN_$CONFIGKERN
					cd /
				}
				KERNEL_SOURCE # a source is required, the variable can be set on top in the option variable section.
				CONFIGURE_KERNEL # this is a little more compex and probably not 100% implemented yet. select auto or manual in the variable section - you can paste, run menuconfig, copy default generic and so on, depending on how far this script has gone.
			}
			#  ___ _   _ ___ ____      _    __  __ _____ ____  
			# |_ _| \ | |_ _|  _ \    / \  |  \/  |  ___/ ___| 
			#  | ||  \| || || |_) |  / _ \ | |\/| | |_  \___ \ 
			#  | || |\  || ||  _ <  / ___ \| |  | |  _|  ___) |
			# |___|_| \_|___|_| \_\/_/   \_\_|  |_|_|   |____/ 
			#                                                  
			INITRAMFS () { # https://wiki.gentoo.org/wiki/Initramfs
				# IF GENKERNEL USED WITH "INITRAMFS VAR SKIP THIS, OR REMOVE VAR AND USE DRACUT
				DRACUT () { 
					emerge $EMERGE_VAR sys-kernel/dracut
					cat < 'EOF' >> /etc/dracut.conf.d/usrmount.conf
					add_dracutmodules+="usrmount" # Dracut modules to add to the default
EOF
					cat < 'EOF' >> /etc/dracut.conf
					hostonly="yes" # Equivalent to -H
					dracutmodules+="dash i18n kernel-modules rootfs-block udev-rules usrmount base fs-lib shutdown crypt crypt-gpg gensplash lvm multipath plymouth selinux" # Equivalent to -m "module module module"
EOF
					# dracut
					dracut --hostonly '' $KERNVERS
				}
				DRACUT	
			}
			#  _____ ____ _____  _    ____  
			# |  ___/ ___|_   _|/ \  | __ ) 
			# | |_  \___ \ | | / _ \ |  _ \ 
			# |  _|  ___) || |/ ___ \| |_) |
			# |_|   |____/ |_/_/   \_\____/ 
			#    
			FSTAB () { # https://wiki.gentoo.org/wiki/Fstab
				FSTAB_LVMONLUKS_BIOS () { # bios switch (option variables top)
					cat << EOF > /etc/fstab
					# /dev/mapper/vg0-root:
					UUID="$(blkid -o value -s UUID /dev/mapper/$VG_MAIN--$LV_MAIN)"	/	ext4	rw,relatime	0 1
					# /dev/sdb2:
					UUID="$(blkid -o value -s UUID $BOOT_PART)"	/boot	ext2	rw,relatime	0 2
EOF
				}
				FASTAB_LVMONLUKS_UEFI () {
					echo "placeholder"

				}
				FSTAB_LVMONLUKS_BIOS
				# FASTAB_LVMONLUKS_UEFI
			}
			#  _  _________   ____  __    _    ____  ____  
			# | |/ / ____\ \ / /  \/  |  / \  |  _ \/ ___| 
			# | ' /|  _|  \ V /| |\/| | / _ \ | |_) \___ \ 
			# | . \| |___  | | | |  | |/ ___ \|  __/ ___) |
			# |_|\_\_____| |_| |_|  |_/_/   \_\_|   |____/ 
			#                                             
			KEYMAPS () {
				KEYMAPS_SYSTEMD () { # systemd switch (option variables top) 
					VCONSOLE_CONF () { # https://wiki.archlinux.org/index.php/Keyboard_configuration_in_console
						cat << EOF > etc/vconsole.conf
						KEYMAP=$VCONSOLE_KEYMAP
						FONT=$VCONSOLE_FONT
EOF
					}
					VCONSOLE_CONF
				}
				KEYMAPS_$SYSINITVAR
			}
			#  _   _ _____ _______        _____  ____  _  __
			# | \ | | ____|_   _\ \      / / _ \|  _ \| |/ /
			# |  \| |  _|   | |  \ \ /\ / / | | | |_) | ' / 
			# | |\  | |___  | |   \ V  V /| |_| |  _ <| . \ 
			# |_| \_|_____| |_|    \_/\_/  \___/|_| \_\_|\_\
			#                                            
			NETWORKING () {
				GENTOONET () {
					emerge $EMERGE_VAR --noreplace net-misc/netifrc
					# Please read /usr/share/doc/netifrc-*/net.example.bz2 for a list of all available options. Be sure to also read up on the DHCP client man page if specific DHCP options need to be set. 
					cat << 'EOF' >> /ETC/conf.d/net 
					config_eth0="dhcp"
EOF
				}
				HOSTSFILE () {
					echo "$HOSTNAME" > /etc/hostname
					echo "127.0.0.1	localhost
					::1		localhost
					127.0.1.1	$HOSTNAME.$DOMAIN	$HOSTNAME" > /etc/hosts
				}
				SYSTEMD_NETWORKD () { # https://wiki.archlinux.org/index.php/Systemd-networkd
					systemctl enable systemd-networkd.service
					systemctl start systemd-networkd.service 
					REPLACE_RESOLVECONF () {
						ln -snf /run/systemd/resolve/resolv.conf /etc/resolv.conf
						systemctl enable systemd-resolved.service
						systemctl start systemd-resolved.service 
					}
					WIRED_DHCPD () {
						cat < 'EOF' > etc/systemd/network/20-wired.network
						[ Match ]
						Name=enp1s0

						[ Network ]
						DHCP=ipv4
EOF
					}
					WIRED_STATIC () {
						cat < 'EOF' > etc/systemd/network/20-wired.network
						[ Match ]
						Name=enp1s0

						[ Network ]
						Address=10.1.10.9/24
						Gateway=10.1.10.1
						DNS=10.1.10.1
						#DNS=8.8.8.8
EOF
					}
					REPLACE_RESOLVECONF
					WIRED_$NETWORK_NET
					
				}
				INST_DHCP () { # https://wiki.gentoo.org/wiki/Dhcpcd
					EMERGE_DHCPD () {
						emerge $EMERGE_VAR net-misc/dhcpcd
					}
					SYSSTART_DHCPD_OPENRC () { # openrc switch (option variables top) 
						rc-update add dhcpcd default
						/etc/init.d/dhcpcd start 
					}
					SYSSTART_DHCPD_SYSTEMD () { # systemd switch (option variables top) 
						systemctl enable dhcpcd
						systemctl start dhcpcd 
					}
					EMERGE_DHCPD
					SYSSTART_DHCPD_$SYSINITVAR
				}
				GENTOONET
				HOSTSFILE
				SYSTEMD_NETWORKD
				# INST_DHCP
			}
			#  ____   ___   ___ _____ _     ___    _    ____  _____ ____  
			# | __ ) / _ \ / _ \_   _| |   / _ \  / \  |  _ \| ____|  _ \ 
			# |  _ \| | | | | | || | | |  | | | |/ _ \ | | | |  _| | |_) |
			# | |_) | |_| | |_| || | | |__| |_| / ___ \| |_| | |___|  _ < 
			# |____/ \___/ \___/ |_| |_____\___/_/   \_\____/|_____|_| \_\
			#                                                            
			BOOTLOAD () {
				#   ____ ____  _   _ ____ ____  
				#  / ___|  _ \| | | | __ )___ \ 
				# | |  _| |_) | | | |  _ \ __) |
				# | |_| |  _ <| |_| | |_) / __/ 
				#  \____|_| \_\\___/|____/_____|
				#
				GRUB2_SETUP () {
					emerge $EMERGE_VAR sys-boot/grub:2
					GRUB2_OPENRC () { # openrc switch (option variables top)  # https://wiki.gentoo.org/wiki/GRUB2
						GRUB2_BIOS_OPENRC () { # openrc switch (option variables top) 
							grub-install $HDD1
						}
						GRUB2_UEFI_OPENRC () { # openrc switch (option variables top) 
							sed -i -e '/GRUB_PLATFORMS="efi-64/d' >> /etc/portage/make.conf
							echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
							grub-install --target=x86_64-efi --efi-directory=/boot
							# mount -o remount,rw /sys/firmware/efi/efivars # If grub_install returns an error like Could not prepare Boot variable: Read-only file system, it may be necessary to remount the efivars special mount as read-write in order to succeed:
							# grub-install --target=x86_64-efi --efi-directory=/boot --removable # # Some motherboard manufacturers seem to only support the /efi/boot/ directory location for the .EFI file in the EFI System Partition (ESP). 
						}
						CONF_GRUB2_OPENRC () { # openrc switch (option variables top)  # CONFIG REQUIRED, ONLY A COPY FROM SYSTEMD
							cp /etc/default/grub /etc/default/grub_bak

							sed -i -e 's#GRUB_CMDLINE_LINUX="#GRUB_CMDLINE_LINUX=#g' /etc/default/grub # remove quotation mark as sed wont handle it together with functions
							#sed -i -e "s#GRUB_CMDLINE_LINUX=#GRUB_CMDLINE_LINUX=cryptdevice=UUID=$(blkid -o value -s UUID $MAIN_PART):$PV_MAIN:allow-discards root=/dev/mapper/$VG_MAIN-$LV_MAIN #g" /etc/default/grub # # encrypt
							sed -i -e "s#GRUB_CMDLINE_LINUX=#GRUB_CMDLINE_LINUX=rd.luks.name=$(blkid -o value -s UUID $MAIN_PART)=$PV_MAIN root=/dev/mapper/$VG_MAIN-$LV_MAIN #g" /etc/default/grub # sd-encrypt systemd
							sed -i -e 's#GRUB_CMDLINE_LINUX=#GRUB_CMDLINE_LINUX="#g' /etc/default/grub # bring quotation mark back
							sed -i -e 's#""#"#g' /etc/default/grub # remove quotation mark
							sed -i -e 's#GRUB_PRELOAD_MODULES="#GRUB_PRELOAD_MODULES=#g' /etc/default/grub # remove quotation mark as sed wont handle it together with functions
							sed -i -e "s#GRUB_PRELOAD_MODULES=#GRUB_PRELOAD_MODULES=lvm #g" /etc/default/grub # parse the config
							sed -i -e 's#GRUB_PRELOAD_MODULES=#GRUB_PRELOAD_MODULES="#g' /etc/default/grub # bring quotation mark back
							sed -i -e 's#""#"#g' /etc/default/grub # remove quotation mark
							sed -i -e 's/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/g' /etc/default/grub
							# sed -i -e 's/#GRUB_DISABLE_LINUX_UUID=true/GRUB_DISABLE_LINUX_UUID=true/g' /etc/default/grub # disable grub UUID
							sed -i -e 's/part_msdos//g' /etc/default/grub # disable grub UUID
							sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT=""/g' /etc/default/grub # disable grub UUID
						}
						GRUB2_BIOS_OPENRC
						# GRUB2_UEFI_OPENRC
						CONF_GRUB2_OPENRC
						
					}
					GRUB2_SYSTEMD () { # systemd switch (option variables top)  # https://wiki.gentoo.org/wiki/GRUB2
						GRUB2_BIOS_SYSTEMD () { # systemd switch (option variables top)
							grub-install $HDD1
						}
						GRUB2_UEFI_SYSTEMD () { # systemd switch (option variables top) 
							sed -i -e '/GRUB_PLATFORMS="efi-64/d' >> /etc/portage/make.conf
							echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
							grub-install --target=x86_64-efi --efi-directory=/boot
							# mount -o remount,rw /sys/firmware/efi/efivars # If grub_install returns an error like Could not prepare Boot variable: Read-only file system, it may be necessary to remount the efivars special mount as read-write in order to succeed:
							# grub-install --target=x86_64-efi --efi-directory=/boot --removable # # Some motherboard manufacturers seem to only support the /efi/boot/ directory location for the .EFI file in the EFI System Partition (ESP). 
						}
						CONF_GRUB2_SYSTEMD () { # systemd switch (option variables top) 
							cp /etc/default/grub /etc/default/grub_bak

							sed -i -e 's#GRUB_CMDLINE_LINUX="#GRUB_CMDLINE_LINUX=#g' /etc/default/grub # remove quotation mark as sed wont handle it together with functions
							#sed -i -e "s#GRUB_CMDLINE_LINUX=#GRUB_CMDLINE_LINUX=cryptdevice=UUID=$(blkid -o value -s UUID $MAIN_PART):$PV_MAIN:allow-discards root=/dev/mapper/$VG_MAIN-$LV_MAIN #g" /etc/default/grub # # encrypt
							sed -i -e "s#GRUB_CMDLINE_LINUX=#GRUB_CMDLINE_LINUX=init=/lib/systemd/systemd rd.luks.name=$(blkid -o value -s UUID $MAIN_PART)=$PV_MAIN root=/dev/mapper/$VG_MAIN-$LV_MAIN #g" /etc/default/grub # sd-encrypt systemd
							sed -i -e 's#GRUB_CMDLINE_LINUX=#GRUB_CMDLINE_LINUX="#g' /etc/default/grub # bring quotation mark back
							sed -i -e 's#""#"#g' /etc/default/grub # remove quotation mark
							sed -i -e 's#GRUB_PRELOAD_MODULES="#GRUB_PRELOAD_MODULES=#g' /etc/default/grub # remove quotation mark as sed wont handle it together with functions
							sed -i -e "s#GRUB_PRELOAD_MODULES=#GRUB_PRELOAD_MODULES=lvm #g" /etc/default/grub # parse the config
							sed -i -e 's#GRUB_PRELOAD_MODULES=#GRUB_PRELOAD_MODULES="#g' /etc/default/grub # bring quotation mark back
							sed -i -e 's#""#"#g' /etc/default/grub # remove quotation mark
							sed -i -e 's/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/g' /etc/default/grub
							# sed -i -e 's/#GRUB_DISABLE_LINUX_UUID=true/GRUB_DISABLE_LINUX_UUID=true/g' /etc/default/grub # disable grub UUID
							sed -i -e 's/part_msdos//g' /etc/default/grub # disable grub UUID
							sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT=""/g' /etc/default/grub # disable grub UUID
						}
						GRUB2_BIOS_SYSTEMD
						# GRUB2_UEFI_SYSTEMD
						CONF_GRUB2_SYSTEMD	
					}
					GEN_GRUBCONF () {
						grub-mkconfig -o /boot/grub/grub.cfg
					}
					GRUB2_$SYSINITVAR
					GEN_GRUBCONF
				}
				GRUB2_SETUP
			}
			#  ____ ___ ____  ____  _        _ __   __     __ __     _____ ____  _____ ___  
			# |  _ \_ _/ ___||  _ \| |      / \\ \ / /    / / \ \   / /_ _|  _ \| ____/ _ \ 
			# | | | | |\___ \| |_) | |     / _ \\ V /    / /   \ \ / / | || | | |  _|| | | |
			# | |_| | | ___) |  __/| |___ / ___ \| |    / /     \ V /  | || |_| | |__| |_| |
			# |____/___|____/|_|   |_____/_/   \_\_|   /_/       \_/  |___|____/|_____\___/ 
			#
			DISPLAYVIDEO () {
				#   ____ ____  _   _ 
				#  / ___|  _ \| | | |
				# | |  _| |_) | | | |
				# | |_| |  __/| |_| |
				#  \____|_|    \___/ 
				#                   
				#SETUP_GPU () {
				#	NVIDIA () {
				#	echo "nvidia placeholder"
				#	}
				#	AMD () {
				#		RADEON () {
				#			echo "radeon placeholder"
				#		}
				#		AMDGPU () {
				#			echo "amdgpu placeholder"
				#		# radeon-ucode
				#		}
				#		# RADEON
				#		AMDGPU
				#	}
				#	# NVIDIA
				#	# AMD
				#}
				# SETUP_GPU
				# __        _____ _   _ ____   _____        __  ______   ______  
				# \ \      / /_ _| \ | |  _ \ / _ \ \      / / / ___\ \ / / ___| 
				#  \ \ /\ / / | ||  \| | | | | | | \ \ /\ / /  \___ \\ V /\___ \ 
				#   \ V  V /  | || |\  | |_| | |_| |\ V  V /    ___) || |  ___) |
				#    \_/\_/  |___|_| \_|____/ \___/  \_/\_/    |____/ |_| |____/ 
				#
				WINDOWSYS () {
					# __  ___ _ 
					# \ \/ / / |
					#  \  /| | |
					#  /  \| | |
					# /_/\_\_|_|
					#
					X11 () { # https://wiki.gentoo.org/wiki/Xorg/Guide
						EMERGE_XORG () {
							emerge $EMERGE_VAR x11-base/xorg-server
							# emerge --pretend --verbose x11-base/xorg-drivers
							env-update
							source /etc/profile 
						}
						EMERGE_XORG
					}
					X11
				}
				#  ____ ___ ____  ____  _        _ __   __  __  __  ____ ____  
				# |  _ \_ _/ ___||  _ \| |      / \\ \ / / |  \/  |/ ___|  _ \ 
				# | | | | |\___ \| |_) | |     / _ \\ V /  | |\/| | |  _| |_) |
				# | |_| | | ___) |  __/| |___ / ___ \| |   | |  | | |_| |  _ < 
				# |____/___|____/|_|   |_____/_/   \_\_|   |_|  |_|\____|_| \_\
				#
				DISPLAYMGR () {
					# OPTIONS: https://wiki.gentoo.org/wiki/Display_manager
					#  1. CDM (The Console Display Manager) 
					#  2. GDM (GNOME Display Manager) 
					#  3. LightDM (A Lightweight Display Manager) 
					#  4. LXDM (LXDE Display Manager) 
					#  5. Qingy (Qingy Is Not GettY) 
					#  6. SDDM (Simple Desktop Display Manager) 
					#  7. SLiM (Simple Login Manager) 
					#  8. WDM (WINGs Display Manager) 
					#  9. XDM (X Display Manager) 
					#  _     ___ ____ _   _ _____ ____  __  __ 
					# | |   |_ _/ ___| | | |_   _|  _ \|  \/  |
					# | |    | | |  _| |_| | | | | | | | |\/| |
					# | |___ | | |_| |  _  | | | | |_| | |  | |
					# |_____|___\____|_| |_| |_| |____/|_|  |_|
					#                                         
					LIGHTDM () {
						emerge $EMERGE_VAR x11-misc/lightdm
						LIGHTDM_OPENRC () { # openrc switch (option variables top) 
							rc-update add dbus default
							rc-update add xdm default

							/etc/init.d/dbus start
							/etc/init.d/xdm start
						}
						LIGHTDM_SYSTEMCTL () {
							systemctl enable lightdm
							systemctl start lightdm
						}
						LIGHTDM_$SYSINITVAR
					}
					#  _    __  ______  __  __ 
					# | |   \ \/ /  _ \|  \/  |
					# | |    \  /| | | | |\/| |
					# | |___ /  \| |_| | |  | |
					# |_____/_/\_\____/|_|  |_|
					#                         
					# ... YES; THIS IS PART OF LXDE
					LXDM () {
						INSTALL_LXDM () {
							EMERGE_LXDM () {
								emerge $EMERGE_VAR lxde-base/lxdm
							}
							AUTOSTART_LXDM () {
								LXDM_OPENRC () { # openrc switch (option variables top) 
									echo "exec startlxde" >> ~/.xinitrc
								}
								LXDM_SYSTEMD () { # systemd switch (option variables top) 
									systemctl enable lxdm
								}
								LXDM_$SYSINITVAR
							}
							EMERGE_LXDM
							AUTOSTART_LXDM
						}
						CONFIGURE_LXDM () {
							echo "configure lxde placeholder"	
						}
						INSTALL_LXDM
						CONFIGURE_LXDM
					}
					LXDM
				}
				#  ____  _____ ____  _  _______ ___  ____    _____ _   ___     __
				# |  _ \| ____/ ___|| |/ /_   _/ _ \|  _ \  | ____| \ | \ \   / /
				# | | | |  _| \___ \| ' /  | || | | | |_) | |  _| |  \| |\ \ / / 
				# | |_| | |___ ___) | . \  | || |_| |  __/  | |___| |\  | \ V /  
				# |____/|_____|____/|_|\_\ |_| \___/|_|     |_____|_| \_|  \_/                                                         
				#
				DESKTOP_ENV () {
					# OPTIONS: (random priority order) https://wiki.gentoo.org/wiki/Desktop_environment
					# 1.  Budgie
					# 2.  Cinnamon
					# 3.  Deepin Desktop Environment
					# 4.  FVWM-Crystal
					# 5.  GNOME
					# 6.  KDE Plasma
					# 7.  LXDE
					# 8.  LXQt
					# 9.  Lumina
					# 10. MATE
					# 11. TDE
					# 12. Xfce
					# __  _______ ____ _____ _  _   
					# \ \/ /  ___/ ___| ____| || |  
					#  \  /| |_ | |   |  _| | || |_ 
					#  /  \|  _|| |___| |___|__   _|
					# /_/\_\_|   \____|_____|  |_|  
					#
					XFCE4 () { # https://wiki.gentoo.org/wiki/Xfce
						EMERGE_XFCE4 () {
							eselect profile set default/linux/amd64/17.0/desktop
							app-text/poppler -qt5 # app-text/poppler have +qt5 by default
							emerge $EMERGE_VAR xfce-base/xfce4-meta xfce-extra/xfce4-notifyd
							emerge $EMERGE_VAR --deselect=y xfce-extra/xfce4-notifyd
							emerge $EMERGE_VAR xfce-base/xfwm4 xfce-base/xfce4-panel
						}
						W_DISPLAYMGR () { # https://wiki.gentoo.org/wiki/Xfce#Display_managers
							XFCE4_LXDM () {
								sed -i -e 's;^# session=/usr/bin/startlxde;session=/usr/bin/startxfce4;g' /etc/lxdm/lxdm.conf
							}
							XFCE4_LXDM
						}
						WO_DISPLAYMGR () { # https://wiki.gentoo.org/wiki/Xfce#Starting_Xfce_without_a_display_manager
							# startx and startxfce4 -  starting Xfce without using a display manager.
							# startx
							XFCE_STARTX_OPENRC () { # openrc switch (option variables top) 
								cat < 'EOF' > ~/.xinitrc 
								exec startxfce4
EOF
							}
							XFCE_STARTX_OPENRC
						}
						XFCE4_MISC () {
							emerge $EMERGE_VAR xfce-extra/xfce4-mount-plugin
							emerge $EMERGE_VAR xfce-base/thunar
							# emerge $EMERGE_VAR x11-terms/xfce4-terminal
							emerge $EMERGE_VAR app-editors/mousepad
							emerge $EMERGE_VAR xfce4-pulseaudio-plugin
							emerge $EMERGE_VAR xfce-extra/xfce4-mixer 
							emerge $EMERGE_VAR xfce-extra/xfce4-alsa-plugin
							# emerge $EMERGE_VAR xfce-extra/thunar-volman
						}
						EMERGE_XFCE4
						W_DISPLAYMGR
						# WO_DISPLAYMGR
						XFCE4_MISC
					}
					XFCE4
				}
				WINDOWSYS
				DISPLAYMGR
				DESKTOP_ENV
			}
			#     _   _   _ ____ ___ ___  
			#    / \ | | | |  _ \_ _/ _ \ 
			#   / _ \| | | | | | | | | | |
			#  / ___ \ |_| | |_| | | |_| |
			# /_/   \_\___/|____/___\___/ 
			# 		            
			AUDIO () {
				emerge $EMERGE_VAR media-sound/pavucontrol
			}
			#  _   _ ____  _____ ____  
			# | | | / ___|| ____|  _ \ 
			# | | | \___ \|  _| | |_) |
			# | |_| |___) | |___|  _ < 
			#  \___/|____/|_____|_| \_\
			#
			USER () {
				useradd -m -g users -G wheel,storage,power -s /bin/bash $SYSUSERNAME
				echo "${bold}enter new $SYSUSERNAME password${normal}"
				passwd $SYSUSERNAME
				echo "${bold}enter new root password${normal}"
				passwd
			}
			#     _    ____  ____  _     ___ ____    _  _____ ___ ___  _   _ ____  
			#    / \  |  _ \|  _ \| |   |_ _/ ___|  / \|_   _|_ _/ _ \| \ | / ___| 
			#   / _ \ | |_) | |_) | |    | | |     / _ \ | |  | | | | |  \| \___ \ 
			#  / ___ \|  __/|  __/| |___ | | |___ / ___ \| |  | | |_| | |\  |___) |
			# /_/   \_\_|   |_|   |_____|___\____/_/   \_\_| |___\___/|_| \_|____/ 
			#                                                                    
			# APPLICATIONS () {
			# 
			# }
			#**********************************************************************************
			#  _______  _____ _____   _____ _   _ _____    ____ _   _ ____   ___   ___ _____  *
			# | ____\ \/ /_ _|_   _| |_   _| | | | ____|  / ___| | | |  _ \ / _ \ / _ \_   _| *
			# |  _|  \  / | |  | |     | | | |_| |  _|   | |   | |_| | |_) | | | | | | || |   *
			# | |___ /  \ | |  | |     | | |  _  | |___  | |___|  _  |  _ <| |_| | |_| || |   *
			# |_____/_/\_\___| |_|     |_| |_| |_|_____|  \____|_| |_|_| \_\\___/ \___/ |_|   *
			#										  *
			#**********************************************************************************
			EXIT_CHROOT () {
				rm /stage3-*.tar.*
			}
			#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			#  ____  _   _ _   _   _____ _   _ ___ ____    ____   ____ ____  ___ ____ _____  ~
			# |  _ \| | | | \ | | |_   _| | | |_ _/ ___|  / ___| / ___|  _ \|_ _|  _ \_   _| ~
			# | |_) | | | |  \| |   | | | |_| || |\___ \  \___ \| |   | |_) || || |_) || |   ~
			# |  _ <| |_| | |\  |   | | |  _  || | ___) |  ___) | |___|  _ < | ||  __/ | |   ~
			# |_| \_\\___/|_| \_|   |_| |_| |_|___|____/  |____/ \____|_| \_\___|_|    |_|   ~
			#										 ~
			#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			BASE_SYSTEM 		&& echo "${bold}BASE_SYSTEM - END${normal}"
			#INST_SYSAPP		&& echo "${bold}INST_SYSAPP - END${normal}"
			#BUILD_KERNEL		&& echo "${bold}BUILD_KERNEL - END${normal}"
			#INITRAMFS		&& echo "${bold}INITRAMFS - END${normal}"
			## INITSYSTEM		&& echo "${bold}INITSYSTEM - END${normal}" deactivatved for systemd profile - other profiels made issues with openrc removal.
			#FSTAB			&& echo "${bold}FSTAB - END${normal}"
			#KEYMAPS		&& echo "${bold}KEYMAPS - END${normal}"
			#NETWORKING		&& echo "${bold}NETWORKING - END${normal}"
			#BOOTLOAD		&& echo "${bold}BOOTLOAD - END${normal}"
			#DISPLAYVIDEO		&& echo "${bold}DISPLAYVIDEO - END${normal}"
			#AUDIO			&& echo "${bold}AUDIO - END${normal}"
			#USER			&& echo "${bold}USER - END${normal}"
			#APPLICATIONS		&& echo "${bold}APPLICATIONS - END${normal}"
			#EXIT_CHROOT		&& echo "${bold}EXIT_CHROOT - END${normal}"
			# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			#   ____ _   _ ____   ___   ___ _____   ____   ____ ____  ___ ____ _____   _____ _   _ ____   +
			#  / ___| | | |  _ \ / _ \ / _ \_   _| / ___| / ___|  _ \|_ _|  _ \_   _| | ____| \ | |  _ \  +
			# | |   | |_| | |_) | | | | | | || |   \___ \| |   | |_) || || |_) || |   |  _| |  \| | | | | +
			# | |___|  _  |  _ <| |_| | |_| || |    ___) | |___|  _ < | ||  __/ | |   | |___| |\  | |_| | +
			#  \____|_| |_|_| \_\\___/ \___/ |_|   |____/ \____|_| \_\___|_|    |_|   |_____|_| \_|____/  +
			#                                                                                             +
			# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			# IMPORTANT INTENDATION - Must follow intendation, not only for the "innerscript" but across the entire script. Why? tell me if you figure, i didnt but it works and thats why im writing this ... :)

INNERSCRIPT
)

#### RUN ALL
BANNER 			&& echo "${bold}BANNER - END, proceeding to DEPLOY_BASESYS ....${normal}"
#DEPLOY_BASESYS 		&& echo "${bold}DEPLOY_BASESYS - END, proceeding to PREPARE_CHROOT ....${normal}"
#PREPARE_CHROOT		&& echo "${bold}PREPARE_CHROOT - END, proceeding to INNER_CHROOT ....${normal}"

echo "$INNER_SCRIPT" > $CHROOTX/chroot_run.sh
chmod +x $CHROOTX/chroot_run.sh
chroot $CHROOTX /bin/bash ./chroot_run.sh

echo "${bold}CHROOT DONE - END${normal}"









