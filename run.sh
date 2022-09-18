#!/bin/bash

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# STATUS main Readme.md
# github.com/alphaaurigae/gentoo_unattended_modular-setup.sh

# FUNCTION  # run FUNCTION  > placeholder to easy replace uncommented / commented with sed -ie 's/PRE  # run PRE/PRE  # run PRE/g' 
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# VARIABLE && FUNCTONS (options) ##unfinished
## PRE
. func/func_main.sh
. var/var_main.sh
. var/1_PRE_main.sh
## CHROOT
. src/CHROOT/DEBUG.sh
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PRE () {  # PREPARE CHROOT
NOTICE_START

	# source src/PRE/
	for f in src/PRE/*; do . $f && echo $f; done

	#. src/PRE/INIT.sh
	#. src/PRE/CRYPTSETUP.sh
	#. src/PRE/LVMSETUP.sh
	#. src/PRE/STAGE3.sh
	#. src/PRE/MNTFS.sh
	#. src/PRE/COPY_CONFIGS.sh

	INIT
	PARTITIONING
	CRYPTSETUP
	LVMSETUP
	STAGE3
	MNTFS
	COPY_CONFIGS
NOTICE_END
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

CHROOT () {	# 4.0 CHROOT # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment
NOTICE_START
INNER_SCRIPT=$(cat << 'INNERSCRIPT'
#!/bin/bash

# https://github.com/alphaaurigae/gentoo_unattented-setup
### +++ lines for quick scrolling section indication
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
. /func_main.sh
. /func_chroot_main.sh
. /var_main.sh
. /chroot_variables.sh
#. /kern.config.sh
#. func/chroot_static-functions.sh
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
BASE () {
NOTICE_START
	#for f in gentoo_unattented-setup/src/CHROOT/BASE/*; do . $f && echo $f; done
	. /SWAPFILE.sh
	. /MAKECONF.sh
	. /CONF_LOCALES.sh
	. /ESELECT_PROFILE.sh
	. /SETFLAGS1.sh
	. /PORTAGE.sh
	. /EMERGE_SYNC.sh
	. /MISC1_CHROOT.sh
	. /RELOADING_SYS.sh
	. /SYSTEMTIME.sh
	. /KEYMAP_CONSOLEFONT.sh
	. /FIRMWARE.sh
	. /CP_BASHRC.sh


	#SWAPFILE  # run SWAPFILE
	#MAKECONF  # run MAKECONF
	#CONF_LOCALES  # run CONF_LOCALES
	#PORTAGE  # run PORTAGE
	##EMERGE_SYNC  # run EMERGE_SYNC
	#ESELECT_PROFILE  # run ESELECT_PROFILE
	##SETFLAGS1  # run SETFLAGS1 #  PLACEHOLDER
	#EMERGE_ATWORLD_A  # run EMERGE_ATWORLD_A
	##MISC1_CHROOT  # run MISC1_CHROOT  # PLACEHOLDER
	##RELOADING_SYS  # run RELOADING_SYS  # PLACEHOLDER
	#SYSTEMTIME  # run SYSTEMTIME
	#KEYMAP_CONSOLEFONT  # run KEYMAP_CONSOLEFONT
	#FIRMWARE  # run FIRMWARE
	#CP_BASHRC  # run CP_BASHRC
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}
CORE () {
NOTICE_START
	#for f in gentoo_unattented-setup/src/CHROOT/CORE/*; do . $f && echo $f; done
	. /SYSCONFIG_CORE.sh
	. /SYSFS.sh
	. /APPADMIN.sh
	. /SYSAPP.sh
	. /APP.sh
	. /SYSPROCESS.sh
	. /KERNEL.sh
	. /INITRAM.sh
	. /MODPROBE_CHROOT.sh
	. /SYSBOOT.sh
	. /APPEMULATION.sh
	. /AUDIO.sh
	# . /GPU.sh
	. /NETWORK.sh

	#SYSCONFIG_CORE  # run SYSCONFIG_CORE
	#SYSFS  # run SYSFS
	#APPADMIN  # run APPADMIN
	#SYSAPP  # run SYSAPP
	#APP  # run APP
	#SYSPROCESS  # run SYSPROCESS
	#KERNEL  # run KERNEL
	#INITRAM  # run INITRAM
	#SYSBOOT  # run SYSBOOT
	## MODPROBE_CHROOT  # run MODPROBE_CHROOT
	#APPEMULATION  # run APPEMULATION
	#AUDIO  # run AUDIO
	## GPU  # run GPU
	#NETWORK  # run NETWORK
NOTICE_END
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}
SCREENDSP () {  # note: replace visual header with "screen and desktop"
NOTICE_START
	#for f in gentoo_unattented-setup/src/CHROOT/SCREENDSP/*; do . $f && echo $f; done
	. /WINDOWSYS.sh
	. /DESKTOP_ENV.sh

	WINDOWSYS
	DESKTOP_ENV
NOTICE_END
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}
USERAPP () {  # (!todo)
NOTICE_START
	#for f in gentoo_unattented-setup/src/CHROOT/USERAPP/*; do . $f && echo $f; done
	. /USERAPP_GIT.sh
	. /WEBBROWSER.sh

	# GIT
	WEBBROWSER
NOTICE_END
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
USERS () {
NOTICE_START
	#for f in gentoo_unattented-setup/src/CHROOT/USERS/*; do . $f && echo $f; done
	. /ROOT.sh
	. /ADMIN.sh

	ROOT
	ADMIN
NOTICE_END
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
FINISH () {  # tidy up installation files - ok
NOTICE_START
	#for f in gentoo_unattented-setup/src/CHROOT/FINISH/*; do . $f && echo $f; done
	. /TIDY_STAGE3.sh

	TIDY_STAGE3
NOTICE_END
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## (RUN ENTIRE SCRIPT) (!changeme)
#BASE  # run BASE
#CORE  # run BASE
#SCREENDSP  # run BASE
USERAPP  # run BASE
USERS  # run BASE
#FINISH  # run BASE
NOTICE_END
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
########## CHROOT ENDS HERE ##########
INNERSCRIPT
)
	CP_CHROOT () {
	NOTICE_START
		# since the chroot script cant be run outside of chroot the script and possibly sourced functions and variables scripts need to be copied accordingly.
		# for the onefile setup this is simply done by echoing the 'INNERSCRIPT" ... if the setup is split in multiple files for readability, every file or alt the gentoo script repo needs to be copied to make all functions and variables available.
		# only variables outside the chroot innerscript for now 27.8.22
		# IMPORTANT blow commands are executed BEFORE the above INNERSCRIPT! (BELOW chroot $CHROOTX /bin/bash ./chroot_run.sh). if a file needs to be made available in the INNERSCRIPT, copy it before ( chroot $CHROOTX /bin/bash ./chroot_run.sh ) below in this CHROOT function!!!




		cp var/chroot_variables.sh $CHROOTX/chroot_variables.sh # sourced on top of the INNERSCRIPT
		cp var/var_main.sh $CHROOTX/var_main.sh # sourced on top of the INNERSCRIPT
		cp func/func_main.sh $CHROOTX/func_main.sh
		cp func/func_chroot_main.sh $CHROOTX/func_chroot_main.sh
		cp configs/required/kern.config.sh $CHROOTX/kern.config # 09.09.22 updated for linux-5.15.59-gentoo on virtualbox # linux kernel config! this could also be pasted in the INNERSCRIPT above but for readability this should be outside, else this file is bblow up for xxxxx lines.
		cp configs/default/.bashrc.sh $CHROOTX/.bashrc.sh
		# chroot inner
		# base
		cp src/CHROOT/BASE/SWAPFILE.sh $CHROOTX/SWAPFILE.sh
		cp src/CHROOT/BASE/MAKECONF.sh $CHROOTX/MAKECONF.sh
		cp src/CHROOT/BASE/CONF_LOCALES.sh $CHROOTX/CONF_LOCALES.sh
		cp src/CHROOT/BASE/ESELECT_PROFILE.sh $CHROOTX/ESELECT_PROFILE.sh
		cp src/CHROOT/BASE/SETFLAGS1.sh $CHROOTX/SETFLAGS1.sh
		cp src/CHROOT/BASE/PORTAGE.sh $CHROOTX/PORTAGE.sh
		cp src/CHROOT/BASE/EMERGE_SYNC.sh $CHROOTX/EMERGE_SYNC.sh
		cp src/CHROOT/BASE/MISC1_CHROOT.sh $CHROOTX/MISC1_CHROOT.sh
		cp src/CHROOT/BASE/RELOADING_SYS.sh $CHROOTX/RELOADING_SYS.sh
		cp src/CHROOT/BASE/SYSTEMTIME.sh $CHROOTX/SYSTEMTIME.sh
		cp src/CHROOT/BASE/KEYMAP_CONSOLEFONT.sh $CHROOTX/KEYMAP_CONSOLEFONT.sh
		cp src/CHROOT/BASE/FIRMWARE.sh $CHROOTX/FIRMWARE.sh
		cp src/CHROOT/BASE/CP_BASHRC.sh $CHROOTX/CP_BASHRC.sh
		# core
		cp src/CHROOT/CORE/SYSCONFIG_CORE.sh $CHROOTX/SYSCONFIG_CORE.sh
		cp src/CHROOT/CORE/SYSFS.sh $CHROOTX/SYSFS.sh
		cp src/CHROOT/CORE/APPADMIN.sh $CHROOTX/APPADMIN.sh
		cp src/CHROOT/CORE/SYSAPP.sh $CHROOTX/SYSAPP.sh
		cp src/CHROOT/CORE/APP.sh $CHROOTX/APP.sh
		cp src/CHROOT/CORE/SYSPROCESS.sh $CHROOTX/SYSPROCESS.sh
		cp src/CHROOT/CORE/KERNEL.sh $CHROOTX/KERNEL.sh
		cp src/CHROOT/CORE/INITRAM.sh $CHROOTX/INITRAM.sh
		cp src/CHROOT/CORE/MODPROBE_CHROOT.sh $CHROOTX/MODPROBE_CHROOT.sh
		cp src/CHROOT/CORE/SYSBOOT.sh $CHROOTX/SYSBOOT.sh
		cp src/CHROOT/CORE/APPEMULATION.sh $CHROOTX/APPEMULATION.sh
		cp src/CHROOT/CORE/AUDIO.sh $CHROOTX/AUDIO.sh
		cp src/CHROOT/CORE/GPU.sh $CHROOTX/GPU.sh
		cp src/CHROOT/CORE/NETWORK.sh $CHROOTX/NETWORK.sh
		# SCREENDSP
		cp src/CHROOT/SCREENDSP/WINDOWSYS.sh $CHROOTX/WINDOWSYS.sh
		cp src/CHROOT/SCREENDSP/DESKTOP_ENV.sh $CHROOTX/DESKTOP_ENV.sh
		# USERAPP
		cp src/CHROOT/USERAPP/USERAPP_GIT.sh $CHROOTX/USERAPP_GIT.sh
		cp src/CHROOT/USERAPP/WEBBROWSER.sh $CHROOTX/WEBBROWSER.sh
		# USERS
		cp src/CHROOT/USERS/ROOT.sh $CHROOTX/ROOT.sh
		cp src/CHROOT/USERS/ADMIN.sh $CHROOTX/ADMIN.sh
		# FINISH
		cp src/CHROOT/FINISH/TIDY_STAGE3.sh $CHROOTX/TIDY_STAGE3.sh
		# cp -R configs/default $CHROOTX/configs/default  # sample
		# cp -R configs/optional $CHROOTX/configs/optional # sample
		# cp -R func $CHROOTX/func  # old kept as sample
	NOTICE_END
	}
	CHROOT_INNER () { # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment
	NOTICE_START
		echo "$INNER_SCRIPT" > $CHROOTX/chroot_main.sh
		chmod +x $CHROOTX/chroot_main.sh
		chroot $CHROOTX /bin/bash ./chroot_main.sh
	NOTICE_END
	}
	CP_CHROOT
	CHROOT_INNER
NOTICE_END
}
#####  RUN ALL #####

#PRE  # run PRE
CHROOT  # run CHROOT
#DEBUG  # run DEBUG

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
