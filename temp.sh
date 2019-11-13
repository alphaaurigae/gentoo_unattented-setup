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
		LOCALE_CONF="en_US.UTF-8" # (!changeme)
		X11KEYMAP="de" # (!changeme) keymap for desktop environment 

		SYSLOCALE="de_DE.UTF-8" # (!changeme)
		SYSDATE_SET=AUTO # (!default)
		SYSDATE_MAN=071604551969 # hack time :)
		SYSCLOCK_SET=AUTO # USE AUTO (!default) / MANUAL -- MANUAL="NO TIMESYNCED SERVICE"
		SYSCLOCK_MAN="1969-07-16 04:55:42" # hack time :)
		SYSTIMEZONE_SET="UTC" # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Timezone

		## NETWORK - https://en.wikipedia.org/wiki/Public_recursive_name_server
		HOSTNAME=p1p1 # (!changeme) define hostname
		DOMAIN=p1p1 # (!changeme) define domain
		NETWORK_NET=DHCPD # DHCPD or STATIC, config static on your own in the network section.	

		## DNS
		NAMESERVER1_IPV4=1.1.1.1 # (!changeme) 1.1.1.1 ns1 cloudflare ipv4
		NAMESERVER1_IPV6=2606:4700:4700::1111 # (!changeme) ipv6 ns1 2606:4700:4700::1111 cloudflare ipv6
		NAMESERVER2_IPV4=1.0.0.1 # (!changeme) 1.0.0.1 ns2 cloudflare ipv4
		NAMESERVER2_IPV6=2606:4700:4700::1001 # (!changeme) ipv6 ns2 2606:4700:4700::1001 cloudflare ipv6

		## DISPLAY
		GPU_SET=NONE # NONE. AMD_V***. NVIDIA_V***
		DISPLAYSERV=X11 # see options
		DISPLAYMGR_YESNO=W_D_MGR # W_D_MGR (WITH display manager) / SOLO (without display manager)
		DISPLAYMGR=LXDM # see options
		DESKTOPENV=XFCE4 # see options

		## USER
		SYSUSERNAME=gentoo # (!changeme) wheel group member - name of the login sysadmin user

		## KERNEL
		INITRAMFSVAR="--lvm --mdadm"

		## DISPLAY
		GPU_DRIVER=amdgpu # (!changeme) amdgpu, radeon
		
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
		CDM_DSPMGR_EMRGE=x11-misc/cdm
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# GDM - https://wiki.gentoo.org/wiki/GNOME/gdm
		GDM_DSPMGR_SYSTEMD=cdm.service
		GDM_DSPMGR_OPENRC=gdm
		GDM_DSPMGR_EMRGE=gnome-base/gdm                                     
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# LIGHTDM - https://wiki.gentoo.org/wiki/LightDM
		LIGHTDM_DSPMGR_SYSTEMD=lightdm.service
		LIGHTDM_DSPMGR_OPENRC=lightdm
		LIGHTDM_DSPMGR_EMRGE=x11-misc/lightdm                       
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# LXDM - https://wiki.gentoo.org/wiki/LXDE (always links to lxde by time of this writing)					
		LXDM_DSPMGR_SYSTEMD=lxdm.service
		LXDM_DSPMGR_OPENRC=lxdm # (startlxde ?)
		LXDM_DSPMGR_EMRGE=lxde-base/lxdm                          
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# QINGY - https://wiki.gentoo.org/wiki/ QINGY				
		QINGY_DSPMGR_SYSTEMD=qingy.service
		QINGY_DSPMGR_OPENRC=qingy
		QINGY_DSPMGR_EMRGE=placeholder                      
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# SSDM - https://wiki.gentoo.org/wiki/SSDM
		SSDM_DSPMGR_SYSTEMD=sddm.service
		SSDM_DSPMGR_OPENRC=sddm
		SSDM_DSPMGR_EMRGE=x11-misc/sddm                      
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# SLIM - https://wiki.gentoo.org/wiki/SLiM
		SLIM_DSPMGR_SYSTEMD=slim.service
		SLIM_DSPMGR_OPENRC=slim
		SLIM_DSPMGR_EMRGE=x11-misc/slim                                            
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# WDM - https://wiki.gentoo.org/wiki/WDM
		WDM_DSPMGR_SYSTEMD=wdm.service
		WDM_DSPMGR_OPENRC=wdm
		WDM_DSPMGR_EMRGE=x11-misc/wdm                 
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# XDM - https://packages.gentoo.org/packages/x11-apps/xdm
		XDM_DSPMGR_SYSTEMD=xdm.service
		XDM_DSPMGR_OPENRC=xdm
		XDM_DSPMGR_EMRGE=x11-apps/xdm


		## DESKTOP ENV
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                 
		# BUDGIE - https://wiki.gentoo.org/wiki/Budgie
		BUDGIE_DSTENV_XEC=budgie_dpmexec
		BUDGIE_DSTENV_STARTX=budgie
		BUDGIE_DSTENV_EMRGE=budgie                                                       
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                              
		# CINNAMON - https://wiki.gentoo.org/wiki/Cinnamon
		CINNAMON_DSTENV_XEC=gnome-session-cinnamon
		CINNAMON_DSTENV_STARTX=cinnamon-session
		CINNAMON_DSTENV_EMRGE=gnome-extra/cinnamon                
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                              
		# DDE "Deepin Desktop Environment" - https://wiki.gentoo.org/wiki/DDE
		DDE_DSTENV_XEC=DDE
		DDE_DSTENV_STARTX=DDE
		DDE_DSTENV_EMRGE=DDE                                                                     
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                              
		# FVWM-Crystal - FVWM-Crystal
		FVWMCRYSTAL_DSTENV_XEC=fvwm-crystal
		FVWMCRYSTAL_DSTENV_STARTX=fvwm-crystal
		FVWMCRYSTAL_DSTENV_EMRGE=x11-themes/fvwm-crystal                             
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# GNOME - https://wiki.gentoo.org/wiki/GNOME
		GNOME_DSTENV_XEC=gnome-session
		GNOME_DSTENV_STARTX=GNOME
		GNOME_DSTENV_EMRGE=gnome-base/gnome           
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# KDE - FVWM-Crystal					
		KDE_DSTENV_XEC=kde-plasma/startkde
		KDE_DSTENV_STARTX=startkde
		KDE_DSTENV_EMRGE=kde-plasma/plasma-meta
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# LXDE - https://wiki.gentoo.org/wiki/LXDE
		LXDE_DSTENV_XEC=lxde-meta
		LXDE_DSTENV_STARTX=lxde-meta
		LXDE_DSTENV_EMRGE=lxde-base/lxde-meta              
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# LXQT - FVWM-Crystal		
		LXQT_DSTENV_XEC=startlxqt
		LXQT_DSTENV_STARTX=startlxqt
		LXQT_DSTENV_EMRGE=lxqt-base/lxqt-meta
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                  
		# LUMINA - https://wiki.gentoo.org/wiki/Lumina
		LUMINA_DSTENV_XEC=start-lumina-desktop
		LUMINA_DSTENV_STARTX=start-lumina-desktop
		LUMINA_DSTENV_EMRGE=x11-wm/lumina                     
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                  
		# MATE - https://wiki.gentoo.org/wiki/MATE
		MATE_DSTENV_XEC=mate-session
		MATE_DSTENV_STARTX=mate-session
		MATE_DSTENV_EMRGE=mate-base/mate                                             
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# PANTHEON - https://wiki.gentoo.org/wiki/Pantheon
		PANTHEON_DSTENV_XEC=PANTHEON
		PANTHEON_DSTENV_STARTX=PANTHEON
		PANTHEON_DSTENV_EMRGE=PANTHEON    
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# RAZORQT - FVWM-Crystal
		RAZORQT_DSTENV_XEC=razor-session
		RAZORQT_DSTENV_STARTX=razor-session
		RAZORQT_DSTENV_EMRGE=RAZORQT              
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# TDE - https://wiki.gentoo.org/wiki/Trinity_Desktop_Environment
		TDE_DSTENV_XEC=tde-session
		TDE_DSTENV_STARTX=tde-session
		TDE_DSTENV_EMRGE=trinity-base/tdebase-meta
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# XFCE - https://wiki.gentoo.org/wiki/Xfce
		XFCE4_DSTENV_XEC=XFCE4-session
		XFCE4_DSTENV_STARTX=startxfce4
		XFCE4_DSTENV_EMRGE=xfce-base/xfce4-meta 

		## LOG          
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                  
		# SYSLOGNG
		SYSLOGNG_SYSLOG_SYSTEMD=syslog-ng@default
		SYSLOGNG_SYSLOG_OPENRC=syslog-ng
		SYSLOGNG_SYSLOG_EMRGE=app-admin/syslog-ng              
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# SYSKLOGD
		SYSKLOGD_SYSLOG_SYSTEMD=systemctl enable rsyslog
		SYSKLOGD_SYSLOG_OPENRC=sysklogd
		SYSKLOGD_SYSLOG_EMRGE=app-admin/sysklogd

		## CRON - https://wiki.gentoo.org/wiki/Cron#Which_cron_is_right_for_the_job.3F                         
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                                  
		# BCRON
		BCRON_CRON_SYSTEMD=mate-session
		BCRON_CRON_OPENRC=mate-session
		BCRON_CRON_EMRGE=sys-process/bcron                                          
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# FCRON
		FCRON_CRON_SYSTEMD=PANTHEON
		FCRON_CRON_OPENRC=PANTHEON
		FCRON_CRON_EMRGE=sys-process/fcron 
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# DCRON - FVWM-Crystal
		DCRON_CRON_SYSTEMD=razor-session
		DCRON_CRON_OPENRC=razor-session
		DCRON_CRON_EMRGE=sys-process/dcron              
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# CRONIE
		CRONIE_CRON_SYSTEMD=tde-session
		CRONIE_CRON_OPENRC=tde-session
		CRONIE_CRON_EMRGE=sys-process/cronie
		# ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
		# VIXICRON
		VIXICRON_CRON_SYSTEMD=vixi
		VIXICRON_CRON_OPENRC=vixi
		VIXICRON_EMRGE=sys-process/vixie-cron

		INSTALL_CRYPTSETUP=YES
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
		FS_EXT=sys-fs/e2fsprogs
		FS_XFS=sys-fs/xfsprogs
		FS_REISER=sys-fs/reiserfsprogs
		FS_JFS=sys-fs/jfsutils
		FS_VFAT=sys-fs/dosfstools # (FAT32, ...) 
		FS_BTRFS=sys-fs/btrfs-progs

		INSTALL_GIT=YES
		INSTALL_FIREFOX=YES
		INSTALL_MIDORI=YES

		ESELECT_PROFILE=29 # 17.1 systemd
		# MISC
		bold=$(tput bold) # staticvar bold text
		normal=$(tput sgr0) # # staticvar reverse to normal text
		EMERGE_VAR="--quiet --complete-graph --verbose --update --deep --newuse " # !Must keep trailing space!
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
		BASESYS () { 
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
				emerge --quiet --complete-graph --verbose --update --deep --newuse @world
				emerge --oneshot virtual/udev virtual/libudev # ! If your system set provides sys-fs/eudev, virtual/udev and virtual/libudev may be preventing systemd.  https://wiki.gentoo.org/wiki/Systemd
			}
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			SYSTEMTIME () { # https://wiki.gentoo.org/wiki/System_time                                       
				SET_TIMEZONE () { # https://wiki.gentoo.org/wiki/System_time#Time_zone
					TIMEZONE_OPENRC () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Timezone
						echo "$SYSTIMEZONE_SET" > /etc/timezone
						emerge --config sys-libs/timezone-data
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
								SYSTEMD enable systemd-timesyncd
								SYSTEMD start systemd-timesyncd
							}
							SYSSTART_TIMESYND
						}
						SYSTEMD_SYSCLOCK_$SYSCLOCK
					}
					SYSTEMCLOCK_$SYSINITVAR 
				}                                         
				SET_HWCLOCK () {
					HWCLOCK_OPENRC () { 
						echo 'placeholder'
					}
					HWCLOCK_SYSTEMD () {  
						timedatectl set-local-rtc 0 # 0 set UTC
					}
					HWCLOCK_$SYSINITVAR
				}
				SET_TIMEZONE && echo "${bold}SET_TIMEZONE end${normal}"
				#SET_SYSTEMCLOCK && echo "${bold}SYSTEMCLOCK end${normal}"
				#SET_HWCLOCK && echo "${bold}SET_HWCLOCK end${normal}"
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
						localectl set-x11-keymap it
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
			##EMERGE_SYNC		&& echo "${bold}EMERGE_SYNC - END ....${normal}"
			SELECT_PROFILE		&& echo "${bold}SELECT_PROFILE - END ....${normal}"
			WORLDSET		&& echo "${bold}WORLDSET - END ....${normal}"
			## SYSTEMTIME		&& echo "${bold}SYSTEMTIME - END ....${normal}"
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
			INSTALL_CRYPTSETUP () { # https://wiki.gentoo.org/wiki/Dm-crypt
				emerge $EMERGE_VAR sys-fs/cryptsetup
				SYSSTART_CRYPTSETUP_OPENRC () { 
					rc-update add dmcrypt boot
				}
				SYSSTART_CRYPTSETUP_SYSTEMD () {  
					echo placeholder
				}
				SYSSTART_CRYPTSETUP_$SYSINITVAR	
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
						sed -e 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf > /tmp/lvm.conf && mv /tmp/lvm.conf /etc/lvm/lvm.conf
						# use_lvmetad = 0
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
				sed -i -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
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
						echo $SYSLOG_EMRGE
					}

					if [ "$SYSLOG" = "SYSLOGNG" ]; then
					SYSLOG_SYSTEMD=$SYSLOGNG_SYSLOG_SYSTEMD && SYSLOG_OPENRC=$SYSLOGNG_CRON_OPENRC && CRON_EMRGE=$SYSLOGNG_CRON_EMRGE && DEBUG_CRON
					elif [ "$SYSLOG" = "SYSKLOGD" ] 
					then CRON_SYSTEMD=$SYSKLOGD_CRON_SYSTEMD && SYSLOG_OPENRC=$SYSKLOGD_CRON_OPENRC && CRON_EMRGE=$SYSKLOGD_CRON_EMRGE && DEBUG_CRON
					else
					DEBUG_CRON
					echo "${bold}ERROR: !${normal}"
					fi
				}
				EMERGE_SYSLOG () {
					emerge --ask $SYSLOG_CRON_EMRGE
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
					}
					LOGROTATE
				}
				CRON_ANACRON #  dont know where else to put this 
				SETVAR_CRON
				EMERGE_CRON
				CRON_$SYSINITVAR
				CONFIGURE_CRON
				LOGROTATION
			}
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			INSTALL_CRON () {
				SETVAR_CRON () {
					DEBUG_CRON () {
						echo "CRON set $CRON"
						echo $CRON_SYSTEMD 
						echo $CRON_OPENRC
						echo $CRON_EMRGE
					}

					if [ "$CRON" = "BCRON" ]; then
					CRON_SYSTEMD=$BCRON_CRON_SYSTEMD && CRON_OPENRC=$BCRON_CRON_OPENRC && CRON_EMRGE=$BCRON_CRON_EMRGE && DEBUG_CRON
					elif [ "$CRON" = "FCRON" ] 
					then CRON_SYSTEMD=$FCRON_CRON_SYSTEMD && CRON_OPENRC=$BCRON_CRON_OPENRC && CRON_EMRGE=$BCRON_CRON_EMRGE && DEBUG_CRON
					elif [ "$CRON" = "DCRON" ] 
					then CRON_SYSTEMD=$DCRON_CRON_SYSTEMD && CRON_OPENRC=$DCRON_CRON_OPENRC && CRON_EMRGE=$DCRON_CRON_EMRGE && DEBUG_CRON
					elif [ "$CRON" = "CRONIE" ] 
					then CRON_SYSTEMD=$CRONIE_CRON_SYSTEMD && CRON_OPENRC=$CRONIE_CRON_OPENRC && CRON_EMRGE=$CRONIE_CRON_EMRGE && DEBUG_CRON
					elif [ "$CRON" = "VIXICRON" ] 
					then CRON_SYSTEMD=$VIXICRON_CRON_SYSTEMD && CRON_OPENRC=$VIXICRON_CRON_OPENRC && CRON_EMRGE=$VIXICRON_CRON_EMRGE && DEBUG_CRON
					else 
					echo wtf
					fi
				}
				EMERGE_CRON () {
					emerge --ask $CRON_CRON_EMRGE
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
				CRON_ANACRON () { # dont know where else to put this # https://wiki.gentoo.org/wiki/Cron#anacron "... it will run jobs that were missed while the system was down. Anacron usually relies on a cron daemon to run it each day."
					emerge $EMERGE_VAR anacron
					ANACRON_OPENRC () { 
						/etc/init.d/anacron start
						rc-update add anacron default
					}
					ANACRON_SYSTEMD () {  
						systemctl enable anacron
					}
					ANACRON_$SYSINITVAR
				}
				CRON_ANACRON #  dont know where else to put this 
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
						echo $FSTOOLS_EMRGE
					}
					if (( "$BOOT_FS" = "ext2" || "$BOOT_FS" = "ext3" || "$BOOT_FS" = "ext4" || "$MAIN_FS" = "ext2" || "$MAIN_FS" = "ext3" || "$MAIN_FS" = "ext4" )); then
					BOOTFS_EMRGE=$FS_EXT && DEBUG_FSTOOLS
					elif (( "$BOOT_FS" = "xfs" || "$MAIN_FS" = "xfs" )); then
					BOOTFS_EMRGE=$FS_EXT && DEBUG_FSTOOLS
					elif (( "$BOOT_FS" = "reiserfs" || "$MAIN_FS" = "reiserfs" )); then
					BOOTFS_EMRGE=$FS_EXT && DEBUG_FSTOOLS
					elif (( "$BOOT_FS" = "jfs" || "$MAIN_FS" = "jfs" )); then
					BOOTFS_EMRGE=$FS_EXT && DEBUG_FSTOOLS
					elif (( "$BOOT_FS" = "msdos" || "$MAIN_FS" = "msdos" || "$BOOT_FS" = "vfat" || "$MAIN_FS" = "vfat" || "$BOOT_FS" = "fat" || "$MAIN_FS" = "fat" )); then
					BOOTFS_EMRGE=$FS_EXT && DEBUG_FSTOOLS
					elif (( "$BOOT_FS" = "btrfs" || "$MAIN_FS" = "btrfs" )); then
					BOOTFS_EMRGE=$FS_EXT && DEBUG_FSTOOLS
					else 
					echo wtf
					fi
				}
				EMERGE_FSTOOLS () {
					emerge $EMERGE_VAR $FSTOOLS_EMRGE
				}
				SETVAR_FSTOOLS
				EMERGE_FSTOOLS
			}
			## (!changeme)
				if [ "$INSTALL_CRYPTSETUP" = "YES" ]; then
				INSTALL_CRYPTSETUP && echo "${bold}INSTALL_CRYPTSETUP - END ....${normal}"
				else
				echo placeholder
				fi
				if [ "$INSTALL_LVM2" = "YES" ]; then
				INSTALL_LVM2 && echo "${bold}INSTALL_LVM2 - END ....${normal}"
				else
				echo placeholder
				fi
				if [ "$INSTALL_SUDO" = "YES" ]; then
				INSTALL_SUDO && echo "${bold}INSTALL_SUDO - END ....${normal}"
				else
				echo placeholder
				fi
				if [ "$INSTALL_PCIUTILS" = "YES" ]; then
				INSTALL_PCIUTILS && echo "${bold}INSTALL_PCIUTILS - END ....${normal}"
				else
				echo placeholder
				fi
				if [ "$INSTALL_MULTIPATH" = "YES" ]; then
				INSTALL_MULTIPATH && echo "${bold}INSTALL_MULTIPATH - END ....${normal}"
				else
				echo placeholder
				fi
				if [ "$INSTALL_GNUPG" = "YES" ]; then
				INSTALL_GNUPG  && echo "${bold}INSTALL_GNUPG - END ....${normal}"
				else
				echo placeholder
				fi
				if [ "$INSTALL_SYSLOG" = "YES" ]; then
				INSTALL_SYSLOG  && echo "${bold}INSTALL_SYSLOG - END ....${normal}"
				else
				echo placeholder
				fi
				if [ "$INSTALL_CRON" = "YES" ]; then
				INSTALL_CRON  && echo "${bold}INSTALL_CRON - END ....${normal}"
				else
				echo placeholder
				fi
				if [ "$INSTALL_FILEINDEXING" = "YES" ]; then
				INSTALL_FILEINDEXING  && echo "${bold}INSTALL_FILEINDEXING - END ....${normal}"
				else
				echo placeholder
				fi
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
			BUILDKERN () { # https://wiki.gentoo.org/wiki/Kernel
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				KERSRC_SET () { # we need some sources, kinda obv xD
					KERSRC_EMERGE () { # so shall it be the gentoo kernel?
						emerge $EMERGE_VAR sys-kernel/gentoo-sources
					}
					KERSRC_TORVALDS () { # or lets fetch one of f some stranger github profile? (hope you installed git :) )
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
							SYSTEMD_GRUB2_$BOOTSYSINITVAR
							CONF_GRUB2_SYSTEMD	
						}
						GEN_GRUBCONF () {
							grub-mkconfig -o /boot/grub/grub.cfg
						}
						MAIN_GRUB2
						GRUB2_$SYSINITVAR
						GEN_GRUBCONF
					}
					MAIN_GRUB2
					INITSYS_GRUB2_SET
				}
				SETUP_$BOOTLOADER
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
					NONE () {
						 echo placeholder
					}
					NVIDIA () {
						echo placeholder
					}
					AMD () {
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
							# emerge --pretend --verbose x11-base/xorg-drivers
							env-update
							source /etc/profile 
						}
						EMERGE_XORG
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
					STP_DSPMGR () {
						SETVAR_DSPMGR () {
							DEBUG_DSPMGR () {
								echo "desktop env set $DESKTOPENV"
								echo "displaymgr set $DISPLAYMGR"
								echo $DSPMGR_SYSTEMD 
								echo $DSPMGR_OPENRC
								echo $DSPMGR_EMRGE
							}

							if [ "$DISPLAYMGR" = "CDM" ]; then
							DSPMGR_SYSTEMD=$CDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$CDM_DSPMGR_OPENRC && DSPMGR_EMRGE=$CDM_DSPMGR_EMRGE && DEBUG_DSPMGR
							elif [ "$DISPLAYMGR" = "GDM" ] 
							then DSPMGR_SYSTEMD=$GDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$CDM_DSPMGR_OPENRC && DSPMGR_EMRGE=$CDM_DSPMGR_EMRGE && DEBUG_DSPMGR
							elif [ "$DISPLAYMGR" = "LIGHTDM" ] 
							then DSPMGR_SYSTEMD=$LIGHTDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$LIGHTDM_DSPMGR_OPENRC && DSPMGR_EMRGE=$LIGHTDM_DSPMGR_EMRGE && DEBUG_DSPMGR
							elif [ "$DISPLAYMGR" = "LXDM" ] 
							then DSPMGR_SYSTEMD=$LXDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$LXDM_DSPMGR_OPENRC && DSPMGR_EMRGE=$LXDM_DSPMGR_EMRGE && DEBUG_DSPMGR
							elif [ "$DISPLAYMGR" = "QINGY" ] 
							then DSPMGR_SYSTEMD=$QINGY_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$QINGY_DSPMGR_OPENRC && DSPMGR_EMRGE=$QINGY_DSPMGR_EMRGE && DEBUG_DSPMGR
							elif [ "$DISPLAYMGR" = "SSDM" ] 
							then DSPMGR_SYSTEMD=$SSDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$SSDM_DSPMGR_OPENRC && DSPMGR_EMRGE=$SSDM_DSPMGR_EMRGE && DEBUG_DSPMGR
							elif [ "$DISPLAYMGR" = "SLIM" ] 
							then DSPMGR_SYSTEMD=$SLIM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$SLIM_DSPMGR_OPENRC && DSPMGR_EMRGE=$SLIM_DSPMGR_EMRGE && DEBUG_DSPMGR
							elif [ "$DISPLAYMGR" = "WDM" ] 
							then DSPMGR_SYSTEMD=$WDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$WDM_DSPMGR_OPENRC && DSPMGR_EMRGE=$WDM_DSPMGR_EMRGE && DEBUG_DSPMGR
							elif [ "$DISPLAYMGR" = "XDM" ] 
							then DSPMGR_SYSTEMD=$XDM_DSPMGR_SYSTEMD && DSPMGR_OPENRC=$XDM_DSPMGR_OPENRC && DSPMGR_EMRGE=$XDM_DSPMGR_EMRGE && DEBUG_DSPMGR
							else 
							echo wtf
							fi
						}
						EMERGE_DSPMGR () {
							emerge --ask $DISPLAYMGR_DSPMGR_EMRGE
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
					STP_DSPMGR
				}
				#  ____  _____ ____  _  _______ ___  ____    _____ _   ___     __
				# |  _ \| ____/ ___|| |/ /_   _/ _ \|  _ \  | ____| \ | \ \   / /
				# | | | |  _| \___ \| ' /  | || | | | |_) | |  _| |  \| |\ \ / / 
				# | |_| | |___ ___) | . \  | || |_| |  __/  | |___| |\  | \ V /  
				# |____/|_____|____/|_|\_\ |_| \___/|_|     |_____|_| \_|  \_/                                                         
				#
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				DESKTOP_ENV () { # https://wiki.gentoo.org/wiki/Desktop_environment
					STP_DSKTENV () {
						SETVAR_DSKTENV () {
							DEBUG_DSKTENV () {
								echo "desktop env set $DESKTOPENV"
								echo "displaymgr set $DISPLAYMGR"
								echo $DSTENVDSTENV_XEC 
								echo $DSTENV_STARTX
								echo $DSTENV_EMRGE
							}
							
							if [ "$DESKTOPENV" = "BUDGIE" ]; then
							DSTENVDSTENV_XEC=$DSTENV_XEC && DSTENV_STARTX=$DSTENV_STARTX && DSTENV_EMRGE=$DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "CINNAMON" ] 
							then DSTENVDSTENV_XEC=$DSTENV_XEC && DSTENV_STARTX=$DSTENV_STARTX && DSTENV_EMRGE=$DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "DDE" ] 
							then DSTENVDSTENV_XEC=$DDE_DSTENV_XEC && DSTENV_STARTX=$DDE_DSTENV_STARTX && DSTENV_EMRGE=$DDE_DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "FVWMCRYSTAL" ] 
							then DSTENVDSTENV_XEC=$FVWMCRYSTAL_DSTENV_XEC && DSTENV_STARTX=$CINNAMON_DSTENV_STARTX && DSTENV_EMRGE=$CINNAMON_DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "GNOME" ] 
							then DSTENVDSTENV_XEC=$GNOME_DSTENV_XEC && DSTENV_STARTX=$GNOME_DSTENV_STARTX && DSTENV_EMRGE=$GNOME_DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "KDE" ] 
							then DSTENVDSTENV_XEC=$KDE_DSTENV_XEC && DSTENV_STARTX=$KDE_DSTENV_STARTX && DSTENV_EMRGE=$KDE_DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "LXDE" ] 
							then DSTENVDSTENV_XEC=$LXDE_DSTENV_XEC && DSTENV_STARTX=$LXDE_DSTENV_STARTX && DSTENV_EMRGE=$LXDE_DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "LXQT" ] 
							then DSTENVDSTENV_XEC=$LXQT_DSTENV_XEC && DSTENV_STARTX=$LXQT_DSTENV_STARTX && DSTENV_EMRGE=$LXQT_DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "LUMINA" ] 
							then DSTENVDSTENV_XEC=$LUMINA_DSTENV_XEC && DSTENV_STARTX=$LUMINA_DSTENV_STARTX && DSTENV_EMRGE=$LUMINA_DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "MATE" ] 
							then DSTENVDSTENV_XEC=$MATE_DSTENV_XEC && DSTENV_STARTX=$MATE_DSTENV_STARTX && DSTENV_EMRGE=$MATE_DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "PANTHEON" ] 
							then DSTENVDSTENV_XEC=$PANTHEON_DSTENV_XEC && DSTENV_STARTX=$PANTHEON_DSTENV_STARTX && DSTENV_EMRGE=$PANTHEON_DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "RAZORQT" ] 
							then DSTENVDSTENV_XEC=$RAZORQT_DSTENV_XEC && DSTENV_STARTX=$RAZORQT_DSTENV_STARTX && DSTENV_EMRGE=$RAZORQT_DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "TDE" ] 
							then DSTENVDSTENV_XEC=$TDE_DSTENV_XEC && DSTENV_STARTX=$TDE_DSTENV_STARTX && DSTENV_EMRGE=$TDE_DSTENV_EMRGE && DEBUG_DSKTENV
							elif [ "$DESKTOPENV" = "XFCE4" ] 
							then DSTENVDSTENV_XEC=$XFCE4_DSTENV_XEC && DSTENV_STARTX=$XFCE4_DSTENV_STARTX && DSTENV_EMRGE=$XFCE4_DSTENV_EMRGE && DEBUG_DSKTENV
							else 
							echo wtf
							fi
						}
						ADDREPO_DSTENV () {
							if [ "$DESKTOPENV" = "PANTHEON" ]; then
							layman -a elementary
							eselect repository enable elementary
							emerge --sync elementary 
							else
							echo nothing to be done
							fi
						}
						EMERGE_DSTENV () {
							if [ "$DESKTOPENV" = "DDM" ]; then
							emerge --ask --noreplace app-eselect/eselect-repository dev-vcs/git
							eselect repository add deepin git https://github.com/zhtengw/deepin-overlay.git
							emerge --sync deepin
							mkdir -pv /etc/portage/package.use
							echo "dde-base/dde-meta multimedia" >> /etc/portage/package.use/deepin
							emerge --ask --verbose --keep-going dde-base/dde-meta

							elif [ "$DESKTOPENV" = "PANTHEON" ]; then
							emerge --ask pantheon-base/pantheon-shell
							emerge --ask media-video/audience x11-terms/pantheon-terminal
							elif [ "$DESKTOPENV" = "XFCE4" ]; then
							
							MISC_XFCE4 () {
								emerge $EMERGE_VAR xfce-base/xfwm4
								emerge $EMERGE_VAR xfce-base/xfce4-panel
								# emerge $EMERGE_VAR xfce-extra/xfce4-notifyd
								emerge $EMERGE_VAR xfce-extra/xfce4-mount-plugin
								emerge $EMERGE_VAR xfce-base/thunar
								# emerge $EMERGE_VAR x11-terms/xfce4-terminal
								emerge $EMERGE_VAR app-editors/mousepad
								emerge $EMERGE_VAR xfce4-pulseaudio-plugin
								emerge $EMERGE_VAR xfce-extra/xfce4-mixer 
								emerge $EMERGE_VAR xfce-extra/xfce4-alsa-plugin
								# emerge $EMERGE_VAR xfce-extra/thunar-volman
							}
							MISC_XFCE4

							else
							emerge --ask $DSTENV_EMRGE
							fi
							emerge --ask app-text/poppler -qt5 # app-text/poppler have +qt5 by default
							env-update && source /etc/profile
						}
						MAIN_DESKTPENV_OPENRC () {
							rc-update add dbus default
							rc-update add xdm default
							rc-update add elogind boot # elogind The systemd project's "logind", extracted to a standalone package https://github.com/elogind/elogind
						}
						MAIN_DESKTPENV_SYSTEMD () {
							enable systemd-logind.service
							systemctl enable dbus.service && systemctl start dbus.service && systemctl daemon-reload
						}
						W_D_MGR () {
							WDMGR_LXDM () {
								MAIN_LXDM () {
									sed -i -e 's;^# session=/usr/bin/startlxde;session=/usr/bin/$DSTENV_XEC;g' /etc/lxdm/lxdm.conf
								}
								MAIN_LXDM
								MAIN_DESKTPENV_$SYSINITVAR
							}
							WDMGR_$DISPLAYMGR
						}
						DESKTENV_SOLO () {					
							DESKTENV_STARTX () { 
								if lumina
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
								if [ "$DESKTOPENV" = "CINNAMON" ]; then
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
						MAIN_DESKTPENV_$SYSINITVAR
						ADDREPO_DSTENV
						EMERGE_DSTENV
						DISPLAYMGR_YESNO
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
						emerge --ask --changed-use --deep @world
						emerge --ask media-sound/alsa-utils
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
						# rc-update add consolekit default
						echo placeholder
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
			#  _   _ _____ _______        _____  ____  _  __
			# | \ | | ____|_   _\ \      / / _ \|  _ \| |/ /
			# |  \| |  _|   | |  \ \ /\ / / | | | |_) | ' / 
			# | |\  | |___  | |   \ V  V /| |_| |  _ <| . \ 
			# |_| \_|_____| |_|    \_/\_/  \___/|_| \_\_|\_\
			#                                            
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			NETWORKING () { # (!todo)
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
				USERAPP_EMERGE=placeholder # (! this is supposed to be a placeholder, dont remove)
				GIT_EMERGE=dev-vcs/git
				FIREFOX_EMERGE=www-client/firefox
				MIDORY_EMERGE=www-client/midori
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				EMERGE_USERAPP () {
					emerge $EMERGE_VAR $USERAPP_EMERGE
				}
				for USERAPPS in (( $GIT_EMERGE $FIREFOX_EMERGE $MIDORY_EMERGE ))
				do
					if [ "$USERAPPS" = "YES" ]; then
					$USERAPP_EMERGE=$GIT_EMERGE EMERGE_USERAPP
					else
					echo placeholder
					fi
					if [ "$INSTALL_FIREFOX" = "YES" ]; then
					$USERAPP_EMERGE=$FIREFOX_EMERGE EMERGE_USERAPP
					else
					echo placeholder
					fi
					if [ "$INSTALL_MIDORI" = "YES" ]; then
					USERAPP_EMERGE=$INSTALL_MIDORI INSTALL_MIDORI
					else
					echo placeholder
					fi
				done
			}
			#  _   _ ____  _____ ____  
			# | | | / ___|| ____|  _ \ 
			# | | | \___ \|  _| | |_) |
			# | |_| |___) | |___|  _ < 
			#  \___/|____/|_____|_| \_\
			#
			# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
			USERS () { # setup users
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				ROOT () { # (! default)
					echo "${bold}enter new root password${normal}"
					passwd
				}
				# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
				ADMIN () { # (! default)
					useradd -m -g users -G wheel,storage,power -s /bin/bash $SYSUSERNAME
					echo "${bold}enter new $SYSUSERNAME password${normal}"
					passwd $SYSUSERNAME
				}
				ROOT
				ADMIN
			}

			## (!changeme)
			BUILDKERN	&& echo "${bold}BUILD_KERNEL - END${normal}"
			### INITRAMFS	&& echo "${bold}INITRAMFS - END${normal}" (! disabled for default setup)
			if [ "$CONFIGKERN" != "AUTO" ]; then
			INITRAMFS
			else
			echo 'CONFIGKERN AUTO DETECTED, skipping initramfs'
			fi
			FSTAB		&& echo "${bold}FSTAB - END${normal}"
			KEYMAPS		&& echo "${bold}KEYMAPS - END${normal}"
			BOOTLOAD	&& echo "${bold}BOOTLOAD - END${normal}"
			VISUAL		&& echo "${bold}DISPLAYVIDEO - END${normal}"
			# AUDIO		&& echo "${bold}AUDIO - END${normal}"
			# USERS		&& echo "${bold}USER - END${normal}"
			# NETWORKING	&& echo "${bold}NETWORKING - END${normal}"
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
		## RUN ENTIRE SCRIPT (!changeme)
		BASE	&& echo "${bold}BASE - END${normal}"
		SYSAPP	&& echo "${bold}SYSAPP - END${normal}"
		CORE	&& echo "${bold}CORE - END${normal}"
		#FINISH	&& echo "${bold}FINISH - END${normal}"
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
		# IMPORTANT INTENDATION - Must follow intendation, not only for the "innerscript" but across the entire script. Why? tell me if you figure, i didnt but it works and thats why im writing this ... :)
