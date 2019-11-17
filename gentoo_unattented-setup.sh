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
	+   modular, mostly unattended						+
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
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Full/Installation

# https://wiki.gentoo.org/wiki/Security_Handbook/Full

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
		# 1.5.3 LVM_LV ((!volume group $LV_MAIN) only 		on the $PV_MAIN for the OS installation as root)
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
	#SWAP0=swap0 # LVM swap NAME for sorting of swap partitions.
	# SWAP_SIZE="1GB"  # (INSIDE LVM MAIN_PART - mainhdd only has boot & fainfs
	# SWAP_FS=linux-swap # swapfs

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
	PRESET_USEFLAG="X a52 aac aalib acl acpi alsa apparmor audit bash-completion boost branding bzip2 \
			cairo cpudetection cjk cracklib crypt cryptsetup cxx dbus git gpg gtk \
			hardened initramfs int64 lzma lzo mount opengl pulseaudio systemd threads udev udisks unicode -cups -bluetooth -libnotify -mysql -apache -apache2 -dropbear -redis -mssql -postgres -telnet"

	PRESET_FEATURES="sandbox binpkg-docompress binpkg-dostrip binpkg-dostrip candy cgroup clean-logs collision-protect \
			compress-build-logs downgrade-backup fail-clean fixlafiles force-mirror ipc-sandbox merge-sync \
			network-sandbox noman parallel-fetch parallel-install pid-sandbox userpriv usersandbox"
	PRESET_GENTOMIRRORS="https://mirror.eu.oneandone.net/linux/distributions/gentoo/gentoo/ \
				https://ftp.snt.utwente.nl/pub/os/linux/gentoo/ https://mirror.isoc.org.il/pub/gentoo/ \
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
		# PARTITIONING ...                                                            
		PARTITIONING () {
			PARTED () {
				# https://wiki.archlinux.org/index.php/GNU_Parted ## for virtualbox uefi go here: https://wiki.archlinux.org/index.php/VirtualBox#Installation_steps_for_Arch_Linux_guests
				sgdisk --zap-all /dev/sda
				# parted -s $HDD1 rm 1
				# parted -s $HDD1 rm 2
				# parted -s $HDD1 rm 3
				parted -s $HDD1 mklabel gpt # GUID Part-Table
				# 
				parted -s $HDD1 mkpart primary "$GRUB_SIZE" # the BIOS boot partition is needed when a GPT partition layout is used with GRUB2 in PC/BIOS mode. It is not required when booting in EFI/UEFI mode. 
				parted -s $HDD1 name 1 grub # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks#GPT
				parted -s $HDD1 set 1 bios_grub on
				# 
				parted -s $HDD1 mkpart primary $BOOT_FS "$BOOT_SIZE"
				parted -s $HDD1 name 2 boot
				parted -s $HDD1 set 2 boot on
				# 
				parted -s $HDD1 mkpart primary $MAIN_FS "$MAIN_SIZE"
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
		TIMEUPD 	&& echo "${bold}UPDATE_TIME - END ....${normal}"
		MODPROBE 	&& echo "${bold}MODPROBE - END ....${normal}"
		PARTITIONING 	&& echo "${bold}PARTED - END ....${normal}"
		CRYPTSETUP 	&& echo "${bold}CRYPTSETUP_MAIN - END ....${normal}"
		LVMONLUKS 	&& echo "${bold}LVMONLUKS - END, proceeding to PREPARE_CHROOT ....${normal}"
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
			GITCOMMIT () {
			git add .
			git commit -a -m "$1"
			git status
			}
			alias santa=GITCOMMIT
			alias hohoho='git push'
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
					cat << EOF > $CHROOTX/etc/portage/make.conf
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
			MOUNT_BASESYS 	&& echo "${bold}MOUNT_BASESYS - END, proceeding to SETMODE_DEVSHM ....${normal}"
			SETMODE_DEVSHM 	&& echo "${bold}SETMODE_DEVSHM - END ...${normal}"
			MAKECONF 	&& echo "${bold}MAKECONF done${normal}"
		}
		DL_STAGE	&& echo "${bold}DL_STAGE - END, proceeding to EBUILD ....${normal}"
		EBUILD		&& echo "${bold}EBUILD - END, proceeding to RESOLVCONF ....${normal}"
		RESOLVCONF	&& echo "${bold}RESOLVCONF - END, proceeding to MNTFS ....${normal}"
		MNTFS		&& echo "${bold}MNTFS - END, proceeding to CHROOT ....${normal}"
	}
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
# 4.0 CHROOT # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment 
INNER_SCRIPT=$(cat << 'INNERSCRIPT'
#!/bin/bash

		# https://github.com/alphaaurigae/gentoo_unattented-setup

		env-update
		source /etc/profile
		export PS1="(chroot) $PS1"

		## DRIVES & PARTITIONS
		HDD1=/dev/sda # GENTOO
		# GRUB_PART=/dev/sda1 # bios grub
		BOOT_PART=/dev/sda2 # boot # unencrypted unless required changes are made - see CRYPTSETUP_BOOT 
		MAIN_PART=/dev/sda3 # mainfs - lukscrypt cryptsetup container with LVM env inside

		## SWAP - DISABLED -- SEE VAR & LVM SECTION TO ENABLE!
		# SWAP0=swap0 # LVM swap NAME for sorting of swap partitions.
		# SWAP_SIZE="1GB"  # (INSIDE LVM MAIN_PART
		# SWAP_FS=linux-swap # swapfs

		## FILESYSTEMS # !FSTOOLS
		BOOT_FS=ext2 # BOOT
		MAIN_FS=ext4 # GENTOO

		## LVM
		PV_MAIN=pv0_main # LVM PV physical volume
		VG_MAIN=vg0_main # LVM VG volume group
		LV_MAIN=lv0_main # LVM LV logical volume

		## LOCALES / TIME-DATE
		VCONSOLE_KEYMAP=de-latin1 # (!changeme) console keymap systemd
		VCONSOLE_FONT=eurlatgr # (!changeme)
		LOCALE_GEN_a1="en_US ISO-8859-1" # (!changeme)
		LOCALE_GEN_a2="en_US.UTF-8 UTF-8" # (!changeme)
		LOCALE_GEN_b1="de_DE ISO-8859-1" # (!changeme)
		LOCALE_GEN_b2="de_DE.UTF-8 UTF-8" # (!changeme)
		XKEYMAP="de" # (!changeme) keymap for desktop environment ## no config yet

		SYSLOCALE="de_DE.UTF-8" # (!changeme)
		SYSDATE_MAN=071604551969 # hack time :)
		SYSCLOCK_SET=AUTO # USE AUTO (!default) / MANUAL -- MANUAL="NO TIMESYNCED SERVICE"
		SYSCLOCK_MAN="1969-07-16 04:55:42" # hack time :)
		SYSTIMEZONE_SET="UTC" # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Timezone

		## NETWORK - https://en.wikipedia.org/wiki/Public_recursive_name_server
		HOSTNAME=p1p1 # (!changeme) define hostname
		DOMAIN=p1p1 # (!changeme) define domain
		NETWORK_NET=DHCPD # DHCPD or STATIC, config static on your own in the network section.	

		## DNS
		##NAMESERVER1_IPV4=1.1.1.1 # (!changeme) 1.1.1.1 ns1 cloudflare ipv4
		##NAMESERVER1_IPV6=2606:4700:4700::1111 # (!changeme) ipv6 ns1 2606:4700:4700::1111 cloudflare ipv6
		##NAMESERVER2_IPV4=1.0.0.1 # (!changeme) 1.0.0.1 ns2 cloudflare ipv4
		##NAMESERVER2_IPV6=2606:4700:4700::1001 # (!changeme) ipv6 ns2 2606:4700:4700::1001 cloudflare ipv6

		## DISPLAY
		GPU_SET=NONE # NONE. AMD_V***. NVIDIA_V***
		DISPLAYSERV=X11 # see options
		DISPLAYMGR_YESNO=W_D_MGR # W_D_MGR (WITH display manager) / SOLO (without display manager)
		DISPLAYMGR=LXDM # see options
		DESKTOPENV=XFCE4 # see options

		## USER
		SYSUSERNAME=gentoo # (!changeme) wheel group member - name of the login sysadmin user

		## KERNEL

		## INITRAMFS
		##INITRAMFSVAR="--lvm --mdadm"

		## DISPLAY
		GPU_SET=amdgpu # (!changeme) amdgpu, radeon
		
		## SYSTEM
		### INITSYSTEM
		SYSINITVAR=SYSTEMD # SYSTEMD (!default) / OPENRC
		### KERNEL
		CONFIGKERN=AUTO # AUTO (genkernel) / MANUAL 
		KERNVERS=5.3-rc4 # for MANUAL setup
		KERNSOURCES=EMERGE # EMERGE (!default) ; TORVALDS (git repository)
		### BOOT
		BOOTLOADER=GRUB2 # GRUB2 (!default)
		BOOTSYSINITVAR=BIOS # BIOS (!default) / UEFI (!prototype)
		## SYSAPP
		### LOG
		CRON=CRONIE # CRONIE (!default), DCRON, ANACRON ..... see on your own
		
		## DISPLAY MANAGER
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,					
		# CDM - The Console Display Manager https://wiki.gentoo.org/wiki/CDM -- https://github.com/evertiro/cdm
		CDM_DSPMGR_SYSTEMD=cdm.service
		CDM_DSPMGR_OPENRC=cdm
		CDM_DSPMGR_EMERGE=x11-misc/cdm
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# GDM - https://wiki.gentoo.org/wiki/GNOME/gdm
		GDM_DSPMGR_SYSTEMD=cdm.service
		GDM_DSPMGR_OPENRC=gdm
		GDM_DSPMGR_EMERGE=gnome-base/gdm                                     
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# LIGHTDM - https://wiki.gentoo.org/wiki/LightDM
		LIGHTDM_DSPMGR_SYSTEMD=lightdm.service
		LIGHTDM_DSPMGR_OPENRC=lightdm
		LIGHTDM_DSPMGR_EMERGE=x11-misc/lightdm                       
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# LXDM - https://wiki.gentoo.org/wiki/LXDE (always links to lxde by time of this writing)					
		LXDM_DSPMGR_SYSTEMD=lxdm.service
		LXDM_DSPMGR_OPENRC=lxdm # (startlxde ?)
		LXDM_DSPMGR_EMERGE=lxde-base/lxdm                          
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# QINGY - https://wiki.gentoo.org/wiki/ QINGY				
		QINGY_DSPMGR_SYSTEMD=qingy.service
		QINGY_DSPMGR_OPENRC=qingy
		QINGY_DSPMGR_EMERGE=placeholder                      
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# SSDM - https://wiki.gentoo.org/wiki/SSDM
		SSDM_DSPMGR_SYSTEMD=sddm.service
		SSDM_DSPMGR_OPENRC=sddm
		SSDM_DSPMGR_EMERGE=x11-misc/sddm                      
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# SLIM - https://wiki.gentoo.org/wiki/SLiM
		SLIM_DSPMGR_SYSTEMD=slim.service
		SLIM_DSPMGR_OPENRC=slim
		SLIM_DSPMGR_EMERGE=x11-misc/slim                                            
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# WDM - https://wiki.gentoo.org/wiki/WDM
		WDM_DSPMGR_SYSTEMD=wdm.service
		WDM_DSPMGR_OPENRC=wdm
		WDM_DSPMGR_EMERGE=x11-misc/wdm                 
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# XDM - https://packages.gentoo.org/packages/x11-apps/xdm
		XDM_DSPMGR_SYSTEMD=xdm.service
		XDM_DSPMGR_OPENRC=xdm
		XDM_DSPMGR_EMERGE=x11-apps/xdm


		## DESKTOP ENV
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                 
		# BUDGIE - https://wiki.gentoo.org/wiki/Budgie
		BUDGIE_DSTENV_XEC=budgie_dpmexec
		BUDGIE_DSTENV_STARTX=budgie
		BUDGIE_DSTENV_EMERGE=budgie                                                       
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                              
		# CINNAMON - https://wiki.gentoo.org/wiki/Cinnamon
		CINNAMON_DSTENV_XEC=gnome-session-cinnamon
		CINNAMON_DSTENV_STARTX=cinnamon-session
		CINNAMON_DSTENV_EMERGE=gnome-extra/cinnamon                
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                              
		# DDE "Deepin Desktop Environment" - https://wiki.gentoo.org/wiki/DDE
		DDE_DSTENV_XEC=DDE
		DDE_DSTENV_STARTX=DDE
		DDE_DSTENV_EMERGE=DDE                                                                     
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                              
		# FVWM-Crystal - FVWM-Crystal
		FVWMCRYSTAL_DSTENV_XEC=fvwm-crystal
		FVWMCRYSTAL_DSTENV_STARTX=fvwm-crystal
		FVWMCRYSTAL_DSTENV_EMERGE=x11-themes/fvwm-crystal                             
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# GNOME - https://wiki.gentoo.org/wiki/GNOME
		GNOME_DSTENV_XEC=gnome-session
		GNOME_DSTENV_STARTX=GNOME
		GNOME_DSTENV_EMERGE=gnome-base/gnome           
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# KDE - FVWM-Crystal					
		KDE_DSTENV_XEC=kde-plasma/startkde
		KDE_DSTENV_STARTX=startkde
		KDE_DSTENV_EMERGE=kde-plasma/plasma-meta
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# LXDE - https://wiki.gentoo.org/wiki/LXDE
		LXDE_DSTENV_XEC=lxde-meta
		LXDE_DSTENV_STARTX=lxde-meta
		LXDE_DSTENV_EMERGE=lxde-base/lxde-meta              
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# LXQT - FVWM-Crystal		
		LXQT_DSTENV_XEC=startlxqt
		LXQT_DSTENV_STARTX=startlxqt
		LXQT_DSTENV_EMERGE=lxqt-base/lxqt-meta
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                  
		# LUMINA - https://wiki.gentoo.org/wiki/Lumina
		LUMINA_DSTENV_XEC=start-lumina-desktop
		LUMINA_DSTENV_STARTX=start-lumina-desktop
		LUMINA_DSTENV_EMERGE=x11-wm/lumina                     
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                  
		# MATE - https://wiki.gentoo.org/wiki/MATE
		MATE_DSTENV_XEC=mate-session
		MATE_DSTENV_STARTX=mate-session
		MATE_DSTENV_EMERGE=mate-base/mate                                             
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# PANTHEON - https://wiki.gentoo.org/wiki/Pantheon
		PANTHEON_DSTENV_XEC=PANTHEON
		PANTHEON_DSTENV_STARTX=PANTHEON
		PANTHEON_DSTENV_EMERGE=PANTHEON    
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# RAZORQT - FVWM-Crystal
		RAZORQT_DSTENV_XEC=razor-session
		RAZORQT_DSTENV_STARTX=razor-session
		RAZORQT_DSTENV_EMERGE=RAZORQT              
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# TDE - https://wiki.gentoo.org/wiki/Trinity_Desktop_Environment
		TDE_DSTENV_XEC=tde-session
		TDE_DSTENV_STARTX=tde-session
		TDE_DSTENV_EMERGE=trinity-base/tdebase-meta
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# XFCE - https://wiki.gentoo.org/wiki/Xfce
		XFCE4_DSTENV_XEC=XFCE4-session
		XFCE4_DSTENV_STARTX=startxfce4
		XFCE4_DSTENV_EMERGE=xfce-base/xfce4-meta 

		## LOG
		SYSLOG=SYSLOGNG          
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                  
		# SYSLOGNG
		SYSLOGNG_SYSLOG_SYSTEMD=syslog-ng@default
		SYSLOGNG_SYSLOG_OPENRC=syslog-ng
		SYSLOGNG_SYSLOG_EMERGE=app-admin/syslog-ng              
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# SYSKLOGD
		SYSKLOGD_SYSLOG_SYSTEMD=rsyslog
		SYSKLOGD_SYSLOG_OPENRC=sysklogd
		SYSKLOGD_SYSLOG_EMERGE=app-admin/sysklogd

		## CRON - https://wiki.gentoo.org/wiki/Cron#Which_cron_is_right_for_the_job.3F                         
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                  
		# BCRON # http://untroubled.org/bcron
		BCRON_CRON_SYSTEMD=placeholder
		BCRON_CRON_OPENRC=placeholder
		BCRON_CRON_EMERGE=sys-process/bcron                                          
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# FCRON # http://www.linuxfromscratch.org/blfs/view/systemd/general/fcron.html
		FCRON_CRON_SYSTEMD=fcron
		FCRON_CRON_OPENRC=fcron
		FCRON_CRON_EMERGE=sys-process/fcron 
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# DCRON # http://www.linuxfromscratch.org/hints/downloads/files/dcron.txt
		DCRON_CRON_SYSTEMD=razor-session
		DCRON_CRON_OPENRC=razor-session
		DCRON_CRON_EMERGE=sys-process/dcron              
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# CRONIE
		CRONIE_CRON_SYSTEMD=cronie
		CRONIE_CRON_OPENRC=cronie
		CRONIE_CRON_EMERGE=sys-process/cronie
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# VIXICRON
		VIXICRON_CRON_SYSTEMD=vixi
		VIXICRON_CRON_OPENRC=vixi
		VIXICRON_CRON_EMERGE=sys-process/vixie-cron

		INSTALL_DM_CRYPT=YES
		INSTALL_LVM2=YES
		INSTALL_SUDO=YES
		INSTALL_PCIUTILS=YES
		INSTALL_MULTIPATH=YES
		INSTALL_GNUPG=NO
		INSTALL_OSPROBER=YES
		INSTALL_SYSLOG=YES
		INSTALL_CRON=YES
		INSTALL_FILEINDEXING=YES

		## FSTOOLS          
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                  
		FS_EXT_EMERGE=sys-fs/e2fsprogs
		FS_XFS_EMERGE=sys-fs/xfsprogs
		FS_REISER_EMERGE=sys-fs/reiserfsprogs
		FS_JFS_EMERGE=sys-fs/jfsutils
		FS_VFAT_EMERGE=sys-fs/dosfstools # (FAT32, ...) 
		FS_BTRFS_EMERGE=sys-fs/btrfs-progs

		ESELECT_PROFILE=29 # 17.1 systemd

		## USERAPP
		USERAPP_EMERGE=placeholder # (!important) (!static) ( this is supposed to be a placeholder, dont remove)
		GIT_EMERGE=dev-vcs/git
		FIREFOX_EMERGE=www-client/firefox
		MIDORI_EMERGE=www-client/midori

		INSTALL_GIT=YES 
		INSTALL_FIREFOX=YES
		INSTALL_MIDORI=YES

		# MISC
		bold=$(tput bold) # (!important)
		normal=$(tput sgr0) # (!important)
		EMERGE_VAR="--quiet --complete-graph --verbose --update --deep --newuse " # (!trailing space) (!important)

		#
		#  .----------------.  .----------------.  .----------------.  .----------------. 
		# | .--------------. || .--------------. || .--------------. || .--------------. |
		# | |   ______     | || |      __      | || |    _______   | || |  _________   | |
		# | |  |_   _ \    | || |     /  \     | || |   /  ___  |  | || | |_   ___  |  | |
		# | |    | |_) |   | || |    / /\ \    | || |  |  (__ \_|  | || |   | |_  \_|  | |
		# | |    |  __'.   | || |   / ____ \   | || |   '.___`-.   | || |   |  _|  _   | |
		# | |   _| |__) |  | || | _/ /    \ \_ | || |  |`\____) |  | || |  _| |___/ |  | |
		# | |  |_______/   | || ||____|  |____|| || |  |_______.'  | || | |_________|  | |
		# | |              | || |              | || |              | || |              | |
		# | '--------------' || '--------------' || '--------------' || '--------------' |
		#  '----------------'  '----------------'  '----------------'  '----------------' 
		#
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 		
		BASE () { 
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			PORTAGE () { # https://wiki.gentoo.org/wiki/Portage#emerge-webrsync && https://dev.gentoo.org/~zmedico/portage/doc/man/emerge.1.html
				mkdir /usr/portage
				emerge-webrsync
			}
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			EMERGE_SYNC () {
				emerge --sync
			}
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''                                   
			SELECT_PROFILE () { # https://wiki.gentoo.org/wiki/Profile_(Portage)
				eselect profile set $ESELECT_PROFILE
			}                                                 
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			WORLDSET () { # https://wiki.gentoo.org/wiki/World_set_(Portage)
				emerge $EMERGE_VAR --newuse @world
				emerge $EMERGE_VAR --oneshot virtual/udev virtual/libudev # ! If your system set provides sys-fs/eudev, virtual/udev and virtual/libudev may be preventing systemd.  https://wiki.gentoo.org/wiki/Systemd
			}
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			
			RELOAD_SYSTEMD () {
				systemctl daemon-reload
				env-update && source /etc/profile
			}
			SYSTEMTIME () { # https://wiki.gentoo.org/wiki/System_time                                       
				SET_TIMEZONE () { # https://wiki.gentoo.org/wiki/System_time#Time_zone
					echo $SYSTIMEZONE_SET > /etc/timezone
					TIMEZONE_OPENRC () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Timezone
						echo "$SYSTIMEZONE_SET" > /etc/timezone
						emerge $EMERGE_VAR --config sys-libs/timezone-data
					}
					TIMEZONE_SYSTEMD () {
						timedatectl set-timezone $SYSTIMEZONE_SET
					}
					TIMEZONE_$SYSINITVAR
				}                                                                 
				SET_SYSTEMCLOCK () { # https://wiki.gentoo.org/wiki/System_time#System_clock
					SYSTEMCLOCK_OPENRC () {
						OPENRC_SYSCLOCK_MANUAL () { 
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
					SYSTEMCLOCK_SYSTEMD () { # https://wiki.gentoo.org/wiki/System_time#Hardware_clock
						SYSTEMD_SYSCLOCK_MANUAL () { 
							timedatectl set-time "$SYSCLOCK_MAN"
						}
						SYSTEMD_SYSCLOCK_AUTO () { 
							SYSSTART_TIMESYND () {
								systemctl enable systemd-timesyncd
								# timedatectl set-local-rtc 0 # 0 set UTC
							}
							SYSSTART_TIMESYND
						}
						SYSTEMD_SYSCLOCK_$SYSCLOCK_SET
					}
					SYSTEMCLOCK_$SYSINITVAR 
				}                                         
				SET_HWCLOCK () {
					hwclock --systohc # current system clock
				}
				SET_TIMEZONE && echo "${bold}SET_TIMEZONE end${normal}"
				 echo "${bold}SET_TIMEZONE echos err for systemd if install medium isnt systemd${normal}"
				SET_SYSTEMCLOCK && echo "${bold}SYSTEMCLOCK end${normal}"
				echo "${bold}SET_SYSTEMCLOCK echos err for systemd if install medium isnt systemd${normal}"
				SET_HWCLOCK && echo "${bold}SET_HWCLOCK end${normal}"
			}                                      
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			CONF_LOCALES () { # https://wiki.gentoo.org/wiki/Localization/Guide
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
					SYSTEMLOCALE_OPENRC () { # https://wiki.gentoo.org/wiki/Localization/Guide#OpenRC
						cat << EOF > /etc/env.d/02locale
						LANG="$SYSLOCALE"
						LC_COLLATE="C"
EOF
					}
					SYSTEMLOCALE_SYSTEMD () { # https://wiki.gentoo.org/wiki/Localization/Guide#systemd
						localectl set-locale LANG=$SYSLOCALE
						localectl | grep "System Locale"
					}
					SYSTEMLOCALE_OPENRC
				}
				XKEYBOARDLAYOUT () {
					KLAYOUT_SYSTEMD () {
						localectl set-x11-keymap $XKEYMAP
					}
					KLAYOUT_SYSTEMD
				}
				RELOAD_LOCALE_ENV () {
					env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
				}
				CONF_LOCALEGEN && echo "${bold}CONF_LOCALEGEN end${normal}"
				GEN_LOCALE && echo "${bold}GEN_LOCALE end${normal}"
				# SYS_LOCALE && echo "${bold}SYS_LOCALE end${normal}"
				XKEYBOARDLAYOUT && echo "${bold}XKEYBOARDLAYOUT end${normal}"
				RELOAD_LOCALE_ENV && echo "${bold}RELOAD_LOCALE_ENV end${normal}"
				echo "${bold}CONF_LOCALES end${normal}"
			}
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			FIRMWARE () {
				echo "${bold}FIRMWARE${normal}"
				LINUX_FIRMWARE () { # https://wiki.gentoo.org/wiki/Linux_firmware
					emerge $EMERGE_VAR sys-kernel/linux-firmware
					etc-update --automode -3 # (automode -3 = merge all)
				}
				LINUX_FIRMWARE
				echo "${bold}FIRMWARE end${normal}"
			}
			## (!changeme)
			PORTAGE			&& echo "${bold}CONFIG_PORTAGE - END ....${normal}"
			## EMERGE_SYNC		&& echo "${bold}EMERGE_SYNC - END ....${normal}"
			SELECT_PROFILE		&& echo "${bold}SELECT_PROFILE - END ....${normal}"
			WORLDSET		&& echo "${bold}WORLDSET - END ....${normal}"
			RELOAD_SYSTEMD		&& echo "${bold}RELOAD_SYSTEMD - END ....${normal}"
			SYSTEMTIME		&& echo "${bold}SYSTEMTIME - END ....${normal}"
			CONF_LOCALES		&& echo "${bold}CONF_LOCALES - END ....${normal}"
			FIRMWARE		&& echo "${bold}FIRMWARE - END, proceeding to CHROOT ....${normal}"
			echo "${bold}BASE_SYSTEM end${normal}"
		}
		#  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
		# | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
		# | |    _______   | || |  ____  ____  | || |    _______   | || |      __      | || |   ______     | || |   ______     | |
		# | |   /  ___  |  | || | |_  _||_  _| | || |   /  ___  |  | || |     /  \     | || |  |_   __ \   | || |  |_   __ \   | |
		# | |  |  (__ \_|  | || |   \ \  / /   | || |  |  (__ \_|  | || |    / /\ \    | || |    | |__) |  | || |    | |__) |  | |
		# | |   '.___`-.   | || |    \ \/ /    | || |   '.___`-.   | || |   / ____ \   | || |    |  ___/   | || |    |  ___/   | |
		# | |  |`\____) |  | || |    _|  |_    | || |  |`\____) |  | || | _/ /    \ \_ | || |   _| |_      | || |   _| |_      | |
		# | |  |_______.'  | || |   |______|   | || |  |_______.'  | || ||____|  |____|| || |  |_____|     | || |  |_____|     | |
		# | |              | || |              | || |              | || |              | || |              | || |              | |
		# | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
		#  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
		#
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 	
		SYSAPP () {
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			DM_CRYPT () { # https://wiki.gentoo.org/wiki/Dm-crypt
				emerge $EMERGE_VAR sys-fs/cryptsetup
				etc-update --automode -3 # (automode -3 = merge all)
				DM_CRYPT_OPENRC () { 
					rc-update add dmcrypt boot
				}
				DM_CRYPT_SYSTEMD () {
					echo placeholder
					# systemctl enable systemd-cryptsetup@.service # https://www.freedesktop.org/software/systemd/man/systemd-cryptsetup@.service.html
				}
				DM_CRYPT_$SYSINITVAR	
			}                       
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			INSTALL_LVM2 () { # https://wiki.gentoo.org/wiki/LVM/de
				emerge $EMERGE_VAR sys-fs/lvm2
				SYSSTART_LVM2 () {
					BOOT_START_LVM2_OPENRC () { 
						rc-update add lvm boot
					}
					BOOT_START_LVM2_SYSTEMD () {  
						systemctl enable lvm2-monitor.service
					}
					BOOT_START_LVM2_$SYSINITVAR
				}
				CONFIG_LVM2 () {
					LVM_CONF () {
						sed -e 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf > /tmp/lvm.conf && mv /tmp/lvm.conf /etc/lvm/lvm.conf # use_lvmetad = 0
					}
					LVM_CONF
				}
				SYSSTART_LVM2
				CONFIG_LVM2
			}
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			INSTALL_SUDO () { # https://wiki.gentoo.org/wiki/Sudo
				emerge $EMERGE_VAR app-admin/sudo # must keep trailing
				cp /etc/sudoers /etc/sudoers_bak
				sed -ie 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
			}                                          
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			INSTALL_PCIUTILS () {
				echo "${bold}INSTALL_PCIUTILS${normal}"
				emerge $EMERGE_VAR sys-apps/pciutils 
			}                                             
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			INSTALL_MULTIPATH () { # https://wiki.gentoo.org/wiki/Multipath
				echo "${bold}INSTALL_MULTIPATH${normal}"
				emerge $EMERGE_VAR sys-fs/multipath-tools
			}                            
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			INSTALL_GNUPG () {
				echo "${bold}INSTALL_GNUPG${normal}"
				emerge $EMERGE_VAR app/crypt/gnupg
				gpg --full-gen-key
			}                                                   
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			INSTALL_OSPROBER () {
				emerge $EMERGE_VAR sys-boot/os-prober
			}                                 
			# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			INSTALL_SYSLOG () {
				SETVAR_SYSLOG () {
					DEBUG_SYSLOG () {
						echo "${bold}SYSLOG set $SYSLOG ${normal}"
						echo $SYSLOG_SYSTEMD 
						echo $SYSLOG_OPENRC
						echo $SYSLOG_EMERGE
					}

					if [ "$SYSLOG" == "SYSLOGNG" ]; then
					SYSLOG_SYSTEMD=$SYSLOGNG_SYSLOG_SYSTEMD && SYSLOG_OPENRC=$SYSLOGNG_SYSLOG_OPENRC && SYSLOG_EMERGE=$SYSLOGNG_SYSLOG_EMERGE
					elif [ "$SYSLOG" == "SYSKLOGD" ] 
					then SYSLOG_SYSTEMD=$SYSKLOGD_SYSLOG_SYSTEMD && SYSLOG_OPENRC=$SYSKLOGD_SYSLOG_OPENRC && SYSLOG_EMERGE=$SYSKLOGD_SYSLOG_EMERGE
					else
					DEBUG_SYSLOG
					echo "${bold}ERROR: Could not detect '$SYSLOG' - debug syslog $SYSLOG ${normal}"
					fi
					DEBUG_SYSLOG
				}
				EMERGE_SYSLOG () {
					emerge  $EMERGE_VAR $SYSLOG_EMERGE
				}
				SYSLOG_OPENRC () {
					rc-update add $SYSLOG_OPENRC default
				}
				SYSLOG_SYSTEMD () {
					systemctl enable $SYSLOG_SYSTEMD
				}
				CONFIGURE_SYSLOG () {
					echo placeholder
				}
				LOGROTATION () {
					LOGROTATE () {
						emerge $EMERGE_VAR app-admin/logrotate
							SET_LROTATE_OPENRC () {
								echo placeholder
							}
							SET_LROTATE_SYSTEMD () {
								systemd-tmpfiles --create /usr/lib/tmpfiles.d/logrotate.conf
							}
							SET_LROTATE_$SYSINITVAR
					}
					LOGROTATE
				}
				SETVAR_SYSLOG
				EMERGE_SYSLOG
				SYSLOG_$SYSINITVAR
				CONFIGURE_SYSLOG
				LOGROTATION
			}
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			INSTALL_CRON () {
				SETVAR_CRON () {
					DEBUG_CRON () {
						echo "CRON set $CRON"
						echo $CRON_SYSTEMD 
						echo $CRON_OPENRC
						echo $CRON_EMERGE
					}

					if [ "$CRON" == "BCRON" ]; then
					CRON_SYSTEMD=$BCRON_CRON_SYSTEMD && CRON_OPENRC=$BCRON_CRON_OPENRC && CRON_EMERGE=$BCRON_CRON_EMERGE
					elif [ "$CRON" == "FCRON" ] 
					then CRON_SYSTEMD=$FCRON_CRON_SYSTEMD && CRON_OPENRC=$FCRON_CRON_OPENRC && CRON_EMERGE=$FCRON_CRON_EMERGE
					elif [ "$CRON" == "DCRON" ] 
					then CRON_SYSTEMD=$DCRON_CRON_SYSTEMD && CRON_OPENRC=$DCRON_CRON_OPENRC && CRON_EMERGE=$DCRON_CRON_EMERGE
					elif [ "$CRON" == "CRONIE" ] 
					then CRON_SYSTEMD=$CRONIE_CRON_SYSTEMD && CRON_OPENRC=$CRONIE_CRON_OPENRC && CRON_EMERGE=$CRONIE_CRON_EMERGE
					elif [ "$CRON" == "VIXICRON" ] 
					then CRON_SYSTEMD=$VIXICRON_CRON_SYSTEMD && CRON_OPENRC=$VIXICRON_CRON_OPENRC && CRON_EMERGE=$VIXICRON_CRON_EMERGE
					else 
					echo "${bold}ERROR: Could not detect '$CRON' - debug cron $CRON ${normal}"
					fi
					DEBUG_CRON
				}
				EMERGE_CRON () {
					emerge $EMERGE_VAR $CRON_EMERGE
				}
				CRON_OPENRC () {
					rc-update add $CRON_OPENRC default
				}
				CRON_SYSTEMD () {
					systemctl enable $CRON_SYSTEMD
				}
				CONFIGURE_CRON () {
					crontab /etc/crontab	
				}
				SETVAR_CRON
				EMERGE_CRON
				CRON_$SYSINITVAR
				CONFIGURE_CRON
			}
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			INSTALL_FILEINDEXING () {
				emerge $EMERGE_VAR sys-apps/mlocate
			}                                      
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			INSTALL_FSTOOLS () {
				SETVAR_FSTOOLS () {
					DEBUG_FSTOOLS () {
						echo "FSTOOLS set on boot $BOOT_FS and for main $MAIN_FS"
						echo $FSTOOLS_EMERGE
					}
					if (( "$BOOT_FS" == "ext2" || "$BOOT_FS" == "ext3" || "$BOOT_FS" == "ext4" || "$MAIN_FS" == "ext2" || "$MAIN_FS" == "ext3" || "$MAIN_FS" == "ext4" )); then
					BOOTFS_EMERGE=$FS_EXT_EMERGE
					elif (( "$BOOT_FS" == "xfs" || "$MAIN_FS" == "xfs" )); then
					BOOTFS_EMERGE=$FS_XFS_EMERGE
					elif (( "$BOOT_FS" == "reiserfs" || "$MAIN_FS" == "reiserfs" )); then
					BOOTFS_EMERGE=$FS_REISER_EMERGE
					elif (( "$BOOT_FS" == "jfs" || "$MAIN_FS" == "jfs" )); then
					BOOTFS_EMERGE=$FS_JFS_EMERGE
					elif (( "$BOOT_FS" == "msdos" || "$MAIN_FS" == "msdos" || "$BOOT_FS" == "vfat" || "$MAIN_FS" == "vfat" || "$BOOT_FS" == "fat" || "$MAIN_FS" == "fat" )); then
					BOOTFS_EMERGE=$FS_VFAT_EMERGE
					elif (( "$BOOT_FS" == "btrfs" || "$MAIN_FS" == "btrfs" )); then
					BOOTFS_EMERGE=$FS_BTRFS_EMERGE
					else 
					echo "${bold}ERROR: Could not detect '$BOOT_FS' / '$MAIN_FS' - debug bootfs $BOOT_FS mainfs $MAIN_FS ${normal}"
					fi
					DEBUG_FSTOOLS
				}
				EMERGE_FSTOOLS () {
					emerge $EMERGE_VAR $BOOTFS_EMERGE
				}
				SETVAR_FSTOOLS
				EMERGE_FSTOOLS
			}
			## (!changeme)
			if [ "$INSTALL_DM_CRYPT" == "YES" ]; then
			DM_CRYPT && echo "${bold}DM_CRYPT - END ....${normal}"
			else
			echo "${bold}INSTALL_CRYPTSETUP=NO ....${normal}"
			fi
			if [ "$INSTALL_LVM2" == "YES" ]; then
			INSTALL_LVM2 && echo "${bold}INSTALL_LVM2 - END ....${normal}"
			else
			echo "${bold}INSTALL_LVM2=NO ....${normal}"
			fi
			if [ "$INSTALL_SUDO" == "YES" ]; then
			INSTALL_SUDO && echo "${bold}INSTALL_SUDO - END ....${normal}"
			else
			echo "${bold}INSTALL_SUDO=NO ....${normal}"
			fi
			if [ "$INSTALL_PCIUTILS" == "YES" ]; then
			INSTALL_PCIUTILS && echo "${bold}INSTALL_PCIUTILS - END ....${normal}"
			else
			echo "${bold}INSTALL_PCIUTILS=NO ....${normal}"
			fi
			if [ "$INSTALL_MULTIPATH" == "YES" ]; then
			INSTALL_MULTIPATH && echo "${bold}INSTALL_MULTIPATH - END ....${normal}"
			else
			echo "${bold}INSTALL_MULTIPATH=NO ....${normal}"
			fi
			if [ "$INSTALL_GNUPG" == "YES" ]; then
			INSTALL_GNUPG  && echo "${bold}INSTALL_GNUPG - END ....${normal}"
			else
			echo "${bold}INSTALL_GNUPG=NO ....${normal}"
			fi
			if [ "$INSTALL_OSPROBER" == "YES" ]; then
			INSTALL_OSPROBER  && echo "${bold}INSTALL_OSPROBER - END ....${normal}"
			else
			echo "${bold}INSTALL_OSPROBER=NO ....${normal}"
			fi
			if [ "$INSTALL_SYSLOG" == "YES" ]; then
			INSTALL_SYSLOG  && echo "${bold}INSTALL_SYSLOG - END ....${normal}"
			else
			echo "${bold}INSTALL_CRYPTSETUP=NO ....${normal}"
			fi
			if [ "$INSTALL_CRON" == "YES" ]; then
			INSTALL_CRON  && echo "${bold}INSTALL_CRON - END ....${normal}"
			else
			echo "${bold}INSTALL_CRON=NO ....${normal}"
			fi
			if [ "$INSTALL_FILEINDEXING" == "YES" ]; then
			INSTALL_FILEINDEXING  && echo "${bold}INSTALL_FILEINDEXING - END ....${normal}"
			else
			echo "${bold}INSTALL_FILEINDEXING=NO ....${normal}"
			fi
			INSTALL_FSTOOLS
		}
		#
		#  .----------------.  .----------------.  .----------------.  .----------------. 
		# | .--------------. || .--------------. || .--------------. || .--------------. |
		# | |     ______   | || |     ____     | || |  _______     | || |  _________   | |
		# | |   .' ___  |  | || |   .'    `.   | || | |_   __ \    | || | |_   ___  |  | |
		# | |  / .'   \_|  | || |  /  .--.  \  | || |   | |__) |   | || |   | |_  \_|  | |
		# | |  | |         | || |  | |    | |  | || |   |  __ /    | || |   |  _|  _   | |
		# | |  \ `.___.'\  | || |  \  `--'  /  | || |  _| |  \ \_  | || |  _| |___/ |  | |
		# | |   `._____.'  | || |   `.____.'   | || | |____| |___| | || | |_________|  | |
		# | |              | || |              | || |              | || |              | |
		# | '--------------' || '--------------' || '--------------' || '--------------' |
		#  '----------------'  '----------------'  '----------------'  '----------------' 
		#
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 	
		CORE () {
			#  _  _______ ____  _   _ _____ _     
			# | |/ / ____|  _ \| \ | | ____| |    
			# | ' /|  _| | |_) |  \| |  _| | |    
			# | . \| |___|  _ <| |\  | |___| |___ 
			# |_|\_\_____|_| \_\_| \_|_____|_____|
			#                           
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			KERNEL () { # https://wiki.gentoo.org/wiki/Kernel
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				KERSRC_SET () {
					KERSRC_EMERGE () {
						emerge $EMERGE_VAR sys-kernel/gentoo-sources
					}
					KERSRC_TORVALDS () {
						git clone https://github.com/torvalds/linux # clone to usr src linux
						rm -rf /usr/src/linux
						mv linux /usr/src/linux
						cd /usr/src/linux
						git fetch && git fetch --tags
						git checkout v$KERNVERS
					}
					KERSRC_$KERNSOURCES
				}
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				CONFKERN_SET () {
					CONFKERN_MANUAL () {  # guess an initramfs needs to be generated with dracut or the like? still new to gentoo, using genkernel for testing.
					lsmod # active modules by install medium.
						CNFG_KERN_PASTE () { # lets paste our own config here (maybe this should go to auto afterall)
							mv /usr/src/linux/.conf /usr/src/linux/.oldconf
							touch /usr/src/linux/.conf
							cat < EOF > /usr/src/linux/.conf
							# PLACEHOLDER - your custom linux/.conf kernel conf goes here!
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
					CONFKERN_AUTO () { # (!changeme) switch to auto (option variables top) # switch to auto configuration (option variables top)
						GENKERNEL_NEXT () { # # (!default)
							CKA_OPENRC () { # (!todo)	
								emerge $EMERGE_VAR sys-kernel/genkernel
								CONFGENKERNEL_OPENRC () { 
									cat < EOF > /etc/genkernel.conf
									placeholder
EOF
								}
								RUNGENKERNEL_OPENRC () { # (!todo)
									# genkernel "$GENKERNEL_ALL_VAR" # generate kernel WITHOUT initramfs
									genkernel "$GENKERNEL_ALL_VAR" initramfs # generate kernel and initramfs
								}
								GENKERNEL_OPENRC
								CONFGENKERNEL_OPENRC
							}
							CKA_SYSTEMD () { # (!default) # config kernel with genkernel-next for systemd
								emerge $EMERGE_VAR sys-kernel/genkernel-next
								CONFGENKERNEL_SYSTEMD () { # (!default)
									touch /etc/genkernel.conf
									cat << 'EOF' > /etc/genkernel.conf
									INSTALL="yes"
									MOUNTBOOT="yes"
									OLDCONFIG="yes"
									MENUCONFIG="yes"
									NCONFIG="no"
									CLEAN="yes"
									MRPROPER="yes"
									MOUNTBOOT="yes"
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
									MULTIPATH="no" # https://wiki.gentoo.org/wiki/Multipath disabled, dont want to trail and error on this one now.
									ISCSI="no"
									E2FSPROGS="yes"
									# FIRMWARE="yes" # skipping this firmware part for now, note to look after later.
									# FIRMWARE_SRC="/lib/firmware"
									BOOTLOADER="grub2"
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
									#INTEGRATED_INITRAMFS="1"
									#ALLRAMDISKMODULES="1"
EOF
								}
								GENKERNELNEXT_SYSTEMD () {  
										genkernel --config=/etc/genkernel.conf  all # generate kernel and initramfs
								}
								CONFGENKERNEL_SYSTEMD
								GENKERNELNEXT_SYSTEMD
							}
							CKA_$SYSINITVAR && echo "${bold}CKA_$SYSINITVAR - END ....${normal}"
						}
						GENKERNEL_NEXT
					}
					CONFKERN_$CONFIGKERN
					cd /
				}
				KERSRC_SET # a source is required, the variable can be set on top in the option variable section.
				CONFKERN_SET # this is a little more complex and probably not 100% implemented yet. select auto or manual in the variable section - you can paste, run menuconfig, copy default generic and so on, depending on how far this script has gone.
			}
			#  ___ _   _ ___ _____ ____      _    __  __ _____ ____  
			# |_ _| \ | |_ _|_   _|  _ \    / \  |  \/  |  ___/ ___| 
			#  | ||  \| || |  | | | |_) |  / _ \ | |\/| | |_  \___ \ 
			#  | || |\  || |  | | |  _ <  / ___ \| |  | |  _|  ___) |
			# |___|_| \_|___| |_| |_| \_\/_/   \_\_|  |_|_|   |____/ 
			#                                                       
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			INITRAMFS () { # (!todo) # SKIP IF GENKERNEL - https://wiki.gentoo.org/wiki/Initramfs
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				DRACUT () { 
					emerge $EMERGE_VAR sys-kernel/dracut
					cat << 'EOF' >> /etc/dracut.conf.d/usrmount.conf
					add_dracutmodules+="usrmount" # Dracut modules to add to the default
EOF
					cat << 'EOF' >> /etc/dracut.conf
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
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			FSTAB () { # https://wiki.gentoo.org/wiki/Fstab
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				FSTAB_LVMONLUKS_BIOS () { # (!default)
					cat << EOF > /etc/fstab
					# /dev/mapper/vg0-root:
					UUID="$(blkid -o value -s UUID /dev/mapper/$VG_MAIN-$LV_MAIN)"	/	ext4	rw,relatime	0 1
					#/dev/mapper/$VG_MAIN-$LV_MAIN	/	ext4	rw,relatime	0 1
					# /dev/sdb2:
					UUID="$(blkid -o value -s UUID $BOOT_PART)"	/boot	ext2	rw,relatime	0 2
EOF
				}
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				FASTAB_LVMONLUKS_UEFI () {
					echo "placeholder"

				}
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				FSTAB_LVMONLUKS_$BOOTSYSINITVAR
			}
			#  _  _________   ____  __    _    ____  ____  
			# | |/ / ____\ \ / /  \/  |  / \  |  _ \/ ___| 
			# | ' /|  _|  \ V /| |\/| | / _ \ | |_) \___ \ 
			# | . \| |___  | | | |  | |/ ___ \|  __/ ___) |
			# |_|\_\_____| |_| |_|  |_/_/   \_\_|   |____/ 
			#                                             
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			KEYMAPS () {
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				KEYMAPS_SYSTEMD () {  
					VCONSOLE_CONF () { # https://wiki.archlinux.org/index.php/Keyboard_configuration_in_console
						cat << EOF > /etc/vconsole.conf
						KEYMAP=$VCONSOLE_KEYMAP
						FONT=$VCONSOLE_FONT
EOF
					}
					VCONSOLE_CONF
				}
				KEYMAPS_$SYSINITVAR
			}
			#  ____   ___   ___ _____ _     ___    _    ____  _____ ____  
			# | __ ) / _ \ / _ \_   _| |   / _ \  / \  |  _ \| ____|  _ \ 
			# |  _ \| | | | | | || | | |  | | | |/ _ \ | | | |  _| | |_) |
			# | |_) | |_| | |_| || | | |__| |_| / ___ \| |_| | |___|  _ < 
			# |____/ \___/ \___/ |_| |_____\___/_/   \_\____/|_____|_| \_\
			#   
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''                                                   
			BOOTLOAD () { # BOOTSYSINITVAR=BIOS/UEFI
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				SETUP_GRUB2 () {
					MAIN_GRUB2_SET () {
						emerge $EMERGE_VAR sys-boot/grub:2
						MAIN_GRUB2_BIOS () {
							grub-install $HDD1
						}
						MAIN_GRUB2_UEFI () {   
							sed -i -e '/GRUB_PLATFORMS="efi-64/d' >> /etc/portage/make.conf
							echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
							grub-install --target=x86_64-efi --efi-directory=/boot
							# mount -o remount,rw /sys/firmware/efi/efivars # If grub_install returns an error like Could not prepare Boot variable: Read-only file system, it may be necessary to remount the efivars special mount as read-write in order to succeed:
							# grub-install --target=x86_64-efi --efi-directory=/boot --removable # Some motherboard manufacturers seem to only support the /efi/boot/ directory location for the .EFI file in the EFI System Partition (ESP). 
						}
						MAIN_GRUB2_MAIN () {
							cp /etc/default/grub /etc/default/grub_bak
						}
						MAIN_GRUB2_$BOOTSYSINITVAR
						MAIN_GRUB2_MAIN
					}
					INITSYS_GRUB2_SET () {
						GRUB2_OPENRC () {  # (!todo) # https://wiki.gentoo.org/wiki/GRUB2
							OPENRC_GRUB2_BIOS () { 
								echo placeholder
							}
							OPENRC_GRUB2_UEFI () {
								echo placeholder
							}
							CONF_GRUB2_OPENRC () {  # CONFIG REQUIRED, ONLY A COPY FROM SYSTEMD
								echo placeholder
							}
							OPENRC_GRUB2_$BOOTSYSINITVAR
							CONF_GRUB2_OPENRC
							
						}
						GRUB2_SYSTEMD () {   # https://wiki.gentoo.org/wiki/GRUB2
							SYSTEMD_GRUB2_BIOS () {  
								echo placeholder
							}
							SYSTEMD_GRUB2_UEFI () {  
								echo placeholder
							}
							CONF_GRUB2_SYSTEMD () {  
								sed -i -e 's#GRUB_CMDLINE_LINUX="#GRUB_CMDLINE_LINUX=#g' /etc/default/grub # remove quotation mark as sed wont handle it together with functions
								#sed -i -e "s#GRUB_CMDLINE_LINUX=#GRUB_CMDLINE_LINUX=cryptdevice=UUID=$(blkid -o value -s UUID $MAIN_PART):$PV_MAIN:allow-discards root=/dev/mapper/$VG_MAIN-$LV_MAIN #g" /etc/default/grub # # encrypt
								sed -i -e "s#GRUB_CMDLINE_LINUX=#GRUB_CMDLINE_LINUX=init=/lib/systemd/systemd rd.luks.name=$(blkid -o value -s UUID $MAIN_PART)=$PV_MAIN root=/dev/mapper/$VG_MAIN-$LV_MAIN dolvm #g" /etc/default/grub # sd-encrypt systemd
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
							SYSTEMD_GRUB2_$BOOTSYSINITVAR
							CONF_GRUB2_SYSTEMD	
						}
						GEN_GRUBCONF () {
							grub-mkconfig -o /boot/grub/grub.cfg
						}
						GRUB2_$SYSINITVAR
						GEN_GRUBCONF
					}
					MAIN_GRUB2_SET
					INITSYS_GRUB2_SET
				}
				SETUP_$BOOTLOADER
			}
			#     _   _   _ ____ ___ ___  
			#    / \ | | | |  _ \_ _/ _ \ 
			#   / _ \| | | | | | | | | | |
			#  / ___ \ |_| | |_| | | |_| |
			# /_/   \_\___/|____/___\___/ 
			# 		            
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			AUDIO () { # (!todo)
				SOUND_API () {
					ALSA () { # https://wiki.gentoo.org/wiki/ALSA
						euse -E alsa
						emerge $EMERGE_VAR --changed-use --deep @world
						emerge $EMERGE_VAR media-sound/alsa-utils
						USE="ffmpeg" emerge -q media-plugins/alsa-plugins

						ALSASOUND_OPENRC () {
							rc-service alsasound start
							rc-update add alsasound boot
						}
						ALSASOUND_SYSTEMD () {
							systemctl status alsa-restore
						}
						ALSASOUND_$SYSINITVAR
					}
					ALSA
				}
				SOUND_SERVER () {
					PULSEAUDIO () {
						# just igbberish here - ignore for now or fix it xD
						# rc-update add consolekit default
						echo placeholder
						#emerge --ask --changed-use --deep @world # this is to update after setting the use flag
					}
					PULSEAUDIO
				}
				SOUND_MIXER () {

					PAVUCONTROL () {
						emerge $EMERGE_VAR media-sound/pavucontrol
					}
					PAVUCONTROL
				}
				SOUND_API
				SOUND_SERVER
				SOUND_MIXER
			}
			# __     _____ ____  _   _   _    _     
			# \ \   / /_ _/ ___|| | | | / \  | |    
			#  \ \ / / | |\___ \| | | |/ _ \ | |    
			#   \ V /  | | ___) | |_| / ___ \| |___ 
			#    \_/  |___|____/ \___/_/   \_\_____|
			#                                      
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			VISUAL () {
				#   ____ ____  _   _ 
				#  / ___|  _ \| | | |
				# | |  _| |_) | | | |
				# | |_| |  __/| |_| |
				#  \____|_|    \___/ 
				#            
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::    
				GPU () { # (!todo)
					SET_NONE () {
						 echo placeholder
					}
					SET_NVIDIA () {
						echo placeholder
					}
					SET_AMD () {
						RADEON () {
							echo placeholder
						}
						AMDGPU () {
							echo placeholder
						# radeon-ucode
						}
						# RADEON
						AMDGPU
					}
					$GPU_SET
				}
				# __        _____ _   _ ____   _____        __  ______   ______  
				# \ \      / /_ _| \ | |  _ \ / _ \ \      / / / ___\ \ / / ___| 
				#  \ \ /\ / / | ||  \| | | | | | | \ \ /\ / /  \___ \\ V /\___ \ 
				#   \ V  V /  | || |\  | |_| | |_| |\ V  V /    ___) || |  ___) |
				#    \_/\_/  |___|_| \_|____/ \___/  \_/\_/    |____/ |_| |____/ 
				#
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				WINDOWSYS () {
					# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
					X11 () {  # (! default) # https://wiki.gentoo.org/wiki/Xorg/Guide
						EMERGE_XORG () {
							emerge $EMERGE_VAR x11-base/xorg-server
							env-update
							source /etc/profile 
						}
						CONF_XORG () {
							echo placeholder # (!todo)
						}
						EMERGE_XORG
						CONF_XORG
					}
					$DISPLAYSERV
				}
				#  ____ ___ ____  ____  _        _ __   __  __  __  ____ ____  
				# |  _ \_ _/ ___||  _ \| |      / \\ \ / / |  \/  |/ ___|  _ \ 
				# | | | | |\___ \| |_) | |     / _ \\ V /  | |\/| | |  _| |_) |
				# | |_| | | ___) |  __/| |___ / ___ \| |   | |  | | |_| |  _ < 
				# |____/___|____/|_|   |_____/_/   \_\_|   |_|  |_|\____|_| \_\
				#
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				DISPLAYMGR () { # OPTIONS: https://wiki.gentoo.org/wiki/Display_manager
					SETVAR_DSPMGR () {
						DEBUG_DSPMGR () {
							echo "displaymgr set $DISPLAYMGR"
							echo $DSPMGR_SYSTEMD 
							echo $DSPMGR_OPENRC
							echo $DSPMGR_EMERGE
						}

						if [ "$DISPLAYMGR" == "CDM" ]; then
						DSPMGR_SYSTEMD=$CDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$CDM_DSPMGR_OPENRC && DSPMGR_EMERGE=$CDM_DSPMGR_EMERGE
						elif [ "$DISPLAYMGR" == "GDM" ]
						then DSPMGR_SYSTEMD=$GDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$GDM_DSPMGR_OPENRC && DSPMGR_EMERGE=$GDM_DSPMGR_EMERGE
						elif [ "$DISPLAYMGR" == "LIGHTDM" ]
						then DSPMGR_SYSTEMD=$LIGHTDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$LIGHTDM_DSPMGR_OPENRC && DSPMGR_EMERGE=$LIGHTDM_DSPMGR_EMERGE
						elif [ "$DISPLAYMGR" == "LXDM" ]
						then DSPMGR_SYSTEMD=$LXDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$LXDM_DSPMGR_OPENRC && DSPMGR_EMERGE=$LXDM_DSPMGR_EMERGE
						elif [ "$DISPLAYMGR" == "QINGY" ]
						then DSPMGR_SYSTEMD=$QINGY_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$QINGY_DSPMGR_OPENRC && DSPMGR_EMERGE=$QINGY_DSPMGR_EMERGE
						elif [ "$DISPLAYMGR" == "SSDM" ]
						then DSPMGR_SYSTEMD=$SSDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$SSDM_DSPMGR_OPENRC && DSPMGR_EMERGE=$SSDM_DSPMGR_EMERGE
						elif [ "$DISPLAYMGR" == "SLIM" ]
						then DSPMGR_SYSTEMD=$SLIM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$SLIM_DSPMGR_OPENRC && DSPMGR_EMERGE=$SLIM_DSPMGR_EMERGE
						elif [ "$DISPLAYMGR" == "WDM" ]
						then DSPMGR_SYSTEMD=$WDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$WDM_DSPMGR_OPENRC && DSPMGR_EMERGE=$WDM_DSPMGR_EMERGE
						elif [ "$DISPLAYMGR" == "XDM" ]
						then DSPMGR_SYSTEMD=$XDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$XDM_DSPMGR_OPENRC && DSPMGR_EMERGE=$XDM_DSPMGR_EMERGE 
						else
						echo "${bold}ERROR: Could not detect '$DISPLAYMGR' - debug displaymanager $DISPLAYMGR ${normal}"
						fi
						DEBUG_DSPMGR
					}
					EMERGE_DSPMGR () {
						emerge $EMERGE_VAR $DSPMGR_EMERGE
					}
					DSPMGR_OPENRC () {
						# sed -ie 's#/etc/conf.d/xdm#/etc/conf.d/$DSPMGR_OPENRC#g' /etc/conf.d/xdm
						# echo "exec gdm" >> ~/.xinitrc
						# rc-update add xdm default
						echo placeholder
					}
					DSPMGR_SYSTEMD () {
						systemctl enable $DSPMGR_SYSTEMD
					}
					CONFIGURE_DSPMGR () {
						echo placeholder	
					}
					SETVAR_DSPMGR
					EMERGE_DSPMGR
					DSPMGR_$SYSINITVAR
					CONFIGURE_DSPMGR
				}
				#  ____  _____ ____  _  _______ ___  ____    _____ _   ___     __
				# |  _ \| ____/ ___|| |/ /_   _/ _ \|  _ \  | ____| \ | \ \   / /
				# | | | |  _| \___ \| ' /  | || | | | |_) | |  _| |  \| |\ \ / / 
				# | |_| | |___ ___) | . \  | || |_| |  __/  | |___| |\  | \ V /  
				# |____/|_____|____/|_|\_\ |_| \___/|_|     |_____|_| \_|  \_/                                                         
				#
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				DESKTOP_ENV () { # https://wiki.gentoo.org/wiki/Desktop_environment
					SETVAR_DSKTENV () {
						DEBUG_DSKTENV () {
							echo "desktop env set $DESKTOPENV"
							echo $DSTENVDSTENV_XEC 
							echo $DSTENV_STARTX
							echo $DSTENV_EMERGE
						}
						
						if [ "$DESKTOPENV" == "BUDGIE" ]; then
						DSTENVDSTENV_XEC=$BUDGIE_DSTENV_XEC && DSTENV_STARTX=$BUDGIE_DSTENV_STARTX && DSTENV_EMERGE=$BUDGIE_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "CINNAMON" ] 
						then DSTENVDSTENV_XEC=$CINNAMON_DSTENV_XEC && DSTENV_STARTX=$CINNAMON_DSTENV_STARTX && DSTENV_EMERGE=$CINNAMON_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "DDE" ] 
						then DSTENVDSTENV_XEC=$DDE_DSTENV_XEC && DSTENV_STARTX=$DDE_DSTENV_STARTX && DSTENV_EMERGE=$DDE_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "FVWMCRYSTAL" ] 
						then DSTENVDSTENV_XEC=$FVWMCRYSTAL_DSTENV_XEC && DSTENV_STARTX=$FVWMCRYSTAL_DSTENV_STARTX && DSTENV_EMERGE=$FVWMCRYSTAL_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "GNOME" ] 
						then DSTENVDSTENV_XEC=$GNOME_DSTENV_XEC && DSTENV_STARTX=$GNOME_DSTENV_STARTX && DSTENV_EMERGE=$GNOME_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "KDE" ] 
						then DSTENVDSTENV_XEC=$KDE_DSTENV_XEC && DSTENV_STARTX=$KDE_DSTENV_STARTX && DSTENV_EMERGE=$KDE_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "LXDE" ] 
						then DSTENVDSTENV_XEC=$LXDE_DSTENV_XEC && DSTENV_STARTX=$LXDE_DSTENV_STARTX && DSTENV_EMERGE=$LXDE_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "LXQT" ] 
						then DSTENVDSTENV_XEC=$LXQT_DSTENV_XEC && DSTENV_STARTX=$LXQT_DSTENV_STARTX && DSTENV_EMERGE=$LXQT_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "LUMINA" ] 
						then DSTENVDSTENV_XEC=$LUMINA_DSTENV_XEC && DSTENV_STARTX=$LUMINA_DSTENV_STARTX && DSTENV_EMERGE=$LUMINA_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "MATE" ] 
						then DSTENVDSTENV_XEC=$MATE_DSTENV_XEC && DSTENV_STARTX=$MATE_DSTENV_STARTX && DSTENV_EMERGE=$MATE_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "PANTHEON" ] 
						then DSTENVDSTENV_XEC=$PANTHEON_DSTENV_XEC && DSTENV_STARTX=$PANTHEON_DSTENV_STARTX && DSTENV_EMERGE=$PANTHEON_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "RAZORQT" ] 
						then DSTENVDSTENV_XEC=$RAZORQT_DSTENV_XEC && DSTENV_STARTX=$RAZORQT_DSTENV_STARTX && DSTENV_EMERGE=$RAZORQT_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "TDE" ] 
						then DSTENVDSTENV_XEC=$TDE_DSTENV_XEC && DSTENV_STARTX=$TDE_DSTENV_STARTX && DSTENV_EMERGE=$TDE_DSTENV_EMERGE
						elif [ "$DESKTOPENV" == "XFCE4" ] 
						then DSTENVDSTENV_XEC=$XFCE4_DSTENV_XEC && DSTENV_STARTX=$XFCE4_DSTENV_STARTX && DSTENV_EMERGE=$XFCE4_DSTENV_EMERGE
						else 
						echo "${bold}ERROR: Could not detect '$DESKTOPENV' - debug displaymanager $DESKTOPENV ${normal}"
						fi
						DEBUG_DSKTENV
					}
					ADDREPO_DSTENV () {
						if [ "$DESKTOPENV" == "PANTHEON" ]; then
						layman -a elementary
						eselect repository enable elementary
						emerge --sync elementary 
						else
						echo placeholder
						fi
					}
					EMERGE_DSTENV () {
						if [ "$DESKTOPENV" == "DDM" ]; then
						emerge $EMERGE_VAR --noreplace app-eselect/eselect-repository dev-vcs/git
						eselect repository add deepin git https://github.com/zhtengw/deepin-overlay.git
						emerge --sync deepin
						mkdir -pv /etc/portage/package.use
						echo "dde-base/dde-meta multimedia" >> /etc/portage/package.use/deepin
						emerge $EMERGE_VAR --verbose --keep-going dde-base/dde-meta

						elif [ "$DESKTOPENV" == "PANTHEON" ]; then
						emerge $EMERGE_VAR pantheon-base/pantheon-shell
						emerge $EMERGE_VAR media-video/audience x11-terms/pantheon-terminal
						elif [ "$DESKTOPENV" == "XFCE4" ]; then
						
						MISC_XFCE4 () {
							emerge $EMERGE_VAR xfce-base/xfwm4
							emerge $EMERGE_VAR xfce-base/xfce4-panel
							# emerge $EMERGE_VAR xfce-extra/xfce4-notifyd
							emerge $EMERGE_VAR xfce-extra/xfce4-mount-plugin
							emerge $EMERGE_VAR xfce-base/thunar
							# emerge $EMERGE_VAR x11-terms/xfce4-terminal
							emerge $EMERGE_VAR app-editors/mousepad
							emerge $EMERGE_VAR xfce4-pulseaudio-plugin
							# emerge $EMERGE_VAR xfce-extra/xfce4-mixer # not found 17.11.19
							emerge $EMERGE_VAR xfce-extra/xfce4-alsa-plugin
							# emerge $EMERGE_VAR xfce-extra/thunar-volman
						}
						MISC_XFCE4

						else
						emerge $EMERGE_VAR $DSTENV_EMERGE
						fi
						env-update && source /etc/profile
					}
					MAIN_DESKTPENV_OPENRC () {
						rc-update add dbus default
						rc-update add xdm default
						rc-update add elogind boot # elogind The systemd project's "logind", extracted to a standalone package https://github.com/elogind/elogind
					}
					MAIN_DESKTPENV_SYSTEMD () {
						#systemctl enable systemd-logind.service
						# systemctl enable dbus.service && systemctl start dbus.service
						systemctl daemon-reload
						env-update && source /etc/profile
					}
					W_D_MGR () {
						WDMGR_LXDM () {
							MAIN_LXDM () {
								sed -ie 's;^# session=/usr/bin/startlxde;session=/usr/bin/$DSTENV_XEC;g' /etc/lxdm/lxdm.conf
							}
							MAIN_LXDM
							MAIN_DESKTPENV_$SYSINITVAR
						}
						WDMGR_$DISPLAYMGR
					}
					DESKTENV_SOLO () {					
						DESKTENV_STARTX () { 
							if [ "$DESKTOPENV" == "LUMINA" ]; then
							cat << 'EOF' > ~/.xinitrc 
							[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
							exec start-lumina-desktop
EOF
							else

							cat << 'EOF' > ~/.xinitrc 
							exec $DSTENV_STARTX
EOF
							fi
						}
						DESKTENV_AUTOSTART_OPENRC () {
							if [ "$DESKTOPENV" == "CINNAMON" ]; then
							cp /etc/xdg/autostart/nm-applet.desktop /home/userName/.config/autostart/nm-applet.desktop
							echo 'X-GNOME-Autostart-enabled=false' >> /home/userName/.config/autostart/nm-applet.desktop
							chown userName:userName /home/userName/.config/autostart/nm-applet.desktop
							else
							echo placeholder
							fi
						}
						DESKTENV_AUTOSTART_SYSTEMD () {
							echo placeholder
						}
						DESKTENV_STARTX
						DESKTENV_AUTOSTART_$SYSINITVAR
					}
					SETVAR_DSKTENV
					ADDREPO_DSTENV
					EMERGE_DSTENV
					MAIN_DESKTPENV_$SYSINITVAR
					$DISPLAYMGR_YESNO
				}

				#GPU
				WINDOWSYS
				DISPLAYMGR
				DESKTOP_ENV
			}
			#  _   _ _____ _______        _____  ____  _  __
			# | \ | | ____|_   _\ \      / / _ \|  _ \| |/ /
			# |  \| |  _|   | |  \ \ /\ / / | | | |_) | ' / 
			# | |\  | |___  | |   \ V  V /| |_| |  _ <| . \ 
			# |_| \_|_____| |_|    \_/\_/  \___/|_| \_\_|\_\
			#                                            
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			NETWORK () { # (!todo)
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				BASICNET () {
					GENTOONET () { # (! default)
						emerge $EMERGE_VAR --noreplace net-misc/netifrc
						cat << 'EOF' > /etc/conf.d/net # Please read /usr/share/doc/netifrc-*/net.example.bz2 for a list of all available options. DHCP client man page if specific DHCP options need to be set.
						#config_eth0="dhcp"
						config_enp1s0="dhcp"
EOF
					}
					HOSTSFILE () { # (! default)
						echo "$HOSTNAME" > /etc/hostname
						echo "127.0.0.1	localhost
						::1		localhost
						127.0.1.1	$HOSTNAME.$DOMAIN	$HOSTNAME" > /etc/hosts
					}
					GENTOONET
					HOSTSFILE
				}
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				NETWORKD () { # https://wiki.archlinux.org/index.php/Systemd-networkd
					SET_NETD_SYSTEMD () {
						systemctl enable systemd-networkd.service
						systemctl start systemd-networkd.service 
						REPLACE_RESOLVECONF () { (! default)
							ln -snf /run/systemd/resolve/resolv.conf /etc/resolv.conf
							systemctl enable systemd-resolved.service
							systemctl start systemd-resolved.service 
						}
						WIRED_DHCPD () { # (! default)
							cat << 'EOF' > /etc/systemd/network/20-wired.network
							[ Match ]
							Name=enp1s0

							[ Network ]
							DHCP=ipv4
EOF
						}
						WIRED_STATIC () {
							cat << 'EOF' > /etc/systemd/network/20-wired.network
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
					SET_NETD_$SYSINITVAR
				}
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				INST_DHCPCD () { # https://wiki.gentoo.org/wiki/Dhcpcd
					EMERGE_DHCPCD () {
						emerge $EMERGE_VAR net-misc/dhcpcd
					}
					SYSSTART_DHCPD_OPENRC () { 
						rc-update add dhcpcd default
						/etc/init.d/dhcpcd start 
					}
					SYSSTART_DHCPD_SYSTEMD () {  
						systemctl enable dhcpcd
						systemctl start dhcpcd 
					}
					EMERGE_DHCPCD
					SYSSTART_DHCPD_$SYSINITVAR
				}
				BASICNET # (! default)
				NETWORKD # (! default)
				# INST_DHCPCD
			}
			#  _   _ ____  _____ ____      _    ____  ____  
			# | | | / ___|| ____|  _ \    / \  |  _ \|  _ \ 
			# | | | \___ \|  _| | |_) |  / _ \ | |_) | |_) |
			# | |_| |___) | |___|  _ <  / ___ \|  __/|  __/ 
			#  \___/|____/|_____|_| \_\/_/   \_\_|   |_|    
			#                                            
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''  
			USERAPP () { # (!todo)
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				EMERGE_USERAPP () {
					emerge $EMERGE_VAR $USERAPP_EMERGE
				}

				if [ "$INSTALL_GIT" == "YES" ]; then
				USERAPP_EMERGE=$GIT_EMERGE EMERGE_USERAPP
				else
				echo "${bold}USERAPPS=NO ....${normal}"
				fi
				if [ "$INSTALL_FIREFOX" == "YES" ]; then
				USERAPP_EMERGE=$FIREFOX_EMERGE EMERGE_USERAPP
				else
				echo "${bold}INSTALL_FIREFOX=NO ....${normal}"
				fi
				if [ "INSTALL_MIDORI" == "YES" ]; then
				USERAPP_EMERGE=$MIDORI_EMERGE INSTALL_MIDORI
				else
				echo "${bold}INSTALL_MIDORI=NO ....${normal}"
				fi
			}
			#  _   _ ____  _____ ____  
			# | | | / ___|| ____|  _ \ 
			# | | | \___ \|  _| | |_) |
			# | |_| |___) | |___|  _ < 
			#  \___/|____/|_____|_| \_\
			#
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			USERS () {
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				ROOT () { # (! default)
					echo "${bold}enter new root password${normal}"
					until passwd
					do
					  echo "${bold}enter new root password${normal}"
					done
				}
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				ADMIN () { # (! default)
					groupadd plugdev
					groupadd power
					useradd -m -g users -G wheel,plugdev,power -s /bin/bash $SYSUSERNAME
					echo "${bold}enter new $SYSUSERNAME password${normal}"
					until passwd $SYSUSERNAME
					do
					  echo "${bold}enter new $SYSUSERNAME password${normal}"
					done
				}
				ROOT
				ADMIN
			}

			## (!changeme)
			KERNEL	&& echo "${bold}BUILD_KERNEL - END${normal}"
			if [ "$CONFIGKERN" != "AUTO" ]; then
			INITRAMFS && echo "${bold}INITRAMFS - END${normal}" # (! disabled for default setup)
			else
			echo 'CONFIGKERN AUTO DETECTED, skipping initramfs'
			fi
			FSTAB		&& echo "${bold}FSTAB - END${normal}"
			KEYMAPS		&& echo "${bold}KEYMAPS - END${normal}"
			BOOTLOAD	&& echo "${bold}BOOTLOAD - END${normal}"
			AUDIO		&& echo "${bold}AUDIO - END${normal}"
			VISUAL		&& echo "${bold}DISPLAYVIDEO - END${normal}"
			USERAPP		&& echo "${bold}USERAPP - END${normal}"
			USERS		&& echo "${bold}USER - END${normal}"
			NETWORK		&& echo "${bold}NETWORK - END${normal}"
		}
		#
		#  .----------------.  .----------------.  .-----------------. .----------------.  .----------------.  .----------------. 
		# | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
		# | |  _________   | || |     _____    | || | ____  _____  | || |     _____    | || |    _______   | || |  ____  ____  | |
		# | | |_   ___  |  | || |    |_   _|   | || ||_   \|_   _| | || |    |_   _|   | || |   /  ___  |  | || | |_   ||   _| | |
		# | |   | |_  \_|  | || |      | |     | || |  |   \ | |   | || |      | |     | || |  |  (__ \_|  | || |   | |__| |   | |
		# | |   |  _|      | || |      | |     | || |  | |\ \| |   | || |      | |     | || |   '.___`-.   | || |   |  __  |   | |
		# | |  _| |_       | || |     _| |_    | || | _| |_\   |_  | || |     _| |_    | || |  |`\____) |  | || |  _| |  | |_  | |
		# | | |_____|      | || |    |_____|   | || ||_____|\____| | || |    |_____|   | || |  |_______.'  | || | |____||____| | |
		# | |              | || |              | || |              | || |              | || |              | || |              | |
		# | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
		#  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
		FINISH () { # tidy up installation files
			rm /stage3-*.tar.*
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
		## (RUN ENTIRE SCRIPT) (!changeme)
		BASE	&& echo "${bold}BASE - END${normal}"
		SYSAPP	&& echo "${bold}SYSAPP - END${normal}"
		CORE	&& echo "${bold}CORE - END${normal}"
		#FINISH	&& echo "${bold}FINISH - END${normal}"
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
		# IMPORTANT INTENDATION - Must follow intendation, not only for the "innerscript" but across the entire script. Why? tell me if you figure, i didnt but it works and thats why im writing this ... :)
INNERSCRIPT
)
CHROOT () {
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




