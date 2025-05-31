#!/bin/bash

#  d888b  d88888b d8b   db d888888b  .d88b.   .d88b.          db    db d8b   db  .d8b.  d888888b d888888b d88888b d8b   db d888888b d88888b d8888b.        .d8888. d88888b d888888b db    db d8888b. 
# 88' Y8b 88'     888o  88 `~~88~~' .8P  Y8. .8P  Y8.         88    88 888o  88 d8' `8b `~~88~~' `~~88~~' 88'     888o  88 `~~88~~' 88'     88  `8D        88'  YP 88'     `~~88~~' 88    88 88  `8D 
# 88      88ooooo 88V8o 88    88    88    88 88    88         88    88 88V8o 88 88ooo88    88       88    88ooooo 88V8o 88    88    88ooooo 88   88        `8bo.   88ooooo    88    88    88 88oodD' 
# 88  ooo 88~~~~~ 88 V8o88    88    88    88 88    88         88    88 88 V8o88 88~~~88    88       88    88~~~~~ 88 V8o88    88    88~~~~~ 88   88 C8888D   `Y8b. 88~~~~~    88    88    88 88~~~   
# 88. ~8~ 88.     88  V888    88    `8b  d8' `8b  d8'         88b  d88 88  V888 88   88    88       88    88.     88  V888    88    88.     88  .8D        db   8D 88.        88    88b  d88 88      
#  Y888P  Y88888P VP   V8P    YP     `Y88P'   `Y88P'  C88888D ~Y8888P' VP   V8P YP   YP    YP       YP    Y88888P VP   V8P    YP    Y88888P Y8888D'        `8888Y' Y88888P    YP    ~Y8888P' 88     
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# STATUS Readme.md
# github.com/alphaaurigae/gentoo_unattended_modular-setup.sh


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# VARIABLE && FUNCTONS
## PRE
. func/func_main.sh
. var/var_main.sh
. var/1_PRE_main.sh
## CHROOT
. src/CHROOT/DEBUG.sh

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

PRE_BANNER () {

printf "%s%s%s\n" "${BOLD}${GREEN}" "▗▄▄▖ ▗▄▄▖ ▗▄▄▄▖▗▄▄▖  ▗▄▖ ▗▄▄▖ ▗▄▄▄▖     ▗▄▄▖▗▖ ▗▖▗▄▄▖  ▗▄▖  ▗▄▖▗▄▄▄▖" "${RESET}"
printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌       ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌ █  " "${RESET}"
printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▛▀▘ ▐▛▀▚▖▐▛▀▀▘▐▛▀▘ ▐▛▀▜▌▐▛▀▚▖▐▛▀▀▘    ▐▌   ▐▛▀▜▌▐▛▀▚▖▐▌ ▐▌▐▌ ▐▌ █  " "${RESET}"
printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌   ▐▌ ▐▌▐▙▄▄▖▐▌   ▐▌ ▐▌▐▌ ▐▌▐▙▄▄▖    ▝▚▄▄▖▐▌ ▐▌▐▌ ▐▌▝▚▄▞▘▝▚▄▞▘ █  " "${RESET}"

}

PRE_NOMENU () {  # PREPARE CHROOT ALL without menu
NOTICE_START

	PRE_RUNALL () {
		PRE_BANNER

		INIT
		PARTITIONING_MAIN
		CRYPTSETUP
		LVMSETUP
		STAGE3
		MNTFS
		COPY_CONFIGS
	}
	for f in src/PRE/*; do . $f && echo $f; done  # source src/PRE/
	PRE_RUNALL
}

PRE_MENU () {  # PREPARE CHROOT with menu
NOTICE_START

	PRE_CHOOSE() {
		PRE_BANNER
		printf "%s\n" "----------------------------------------------------------------------------------"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "Select e.g 1:" "${RESET}"
		printf "%s\n" "----------------------------------------------------------------------------------"
		printf "Single:\n"
		printf "[1] --> INIT (src/PRE/INIT.sh)\n"
		printf "[2] --> PARTITIONING_MAIN (src/PRE/INIT.sh)\n"
		printf "[3] --> CRYPTSETUP (src/PRE/INIT.sh)\n"
		printf "[4] --> LVMSETUP (src/PRE/INIT.sh)\n"
		printf "[5] --> STAGE3 (src/PRE/INIT.sh)\n"
		printf "[6] --> MNTFS (src/PRE/INIT.sh)\n"
		printf "[7] --> COPY_CONFIGS (src/PRE/INIT.sh)\n"
		printf "%s\n" "----------------------------------------------------------------------------------"
		printf "Multi:\n"
		printf "[21] --> [1] & [2] INIT && PARTITIONING\n"
		printf "[22] --> [3] & [4] CRYPTSETUP;LVMSETUP\n"
		printf "[23] --> [5]-[7] STAGE3;MNTFS;COPY_CONFIGS\n"
		printf "[24] --> [1]-[7] INIT;PARTITIONING_MAIN;CRYPTSETUP;LVMSETUP;STAGE3;MNTFS;COPY_CONFIGS\n"
		printf "%s\n" "----------------------------------------------------------------------------------"
		printf "[0] --> Return to Main Menu\n"

		read -p "Enter your choice: " choice
		printf "\n"

		case $choice in
			1)
				printf "INIT\n"
				INIT
				;;
			2)
				printf "PARTITIONING\n"
				PARTITIONING_MAIN
				;;
			3)
				printf "CRYPTSETUP\n"
				CRYPTSETUP
				;;
			4)
				printf "LVMSETUP\n"
				LVMSETUP
				;;
			5)
				printf "STAGE3\n"
				STAGE3
				;;
			6)
				printf "MNTFS\n"
				MNTFS
				;;
			7)
				printf "COPY_CONFIGS\n"
				COPY_CONFIGS
				;;
			21)
				printf "[1] & [2] INIT && PARTITIONING\n"
				INIT
				PARTITIONING
				;;
			22)
				printf "[3] & [4] CRYPTSETUP;LVMSETUP\n"
				CRYPTSETUP
				LVMSETUP
				;;
			23)
				printf "[5]-[7] STAGE3;MNTFS;COPY_CONFIGS\n"
				STAGE3
				MNTFS
				COPY_CONFIGS
				;;
			24)
				printf "[1]-[7] INIT;PARTITIONING;CRYPTSETUP;LVMSETUP;STAGE3;MNTFS;COPY_CONFIGS\n"
				INIT
				PARTITIONING_MAIN
				CRYPTSETUP
				LVMSETUP
				STAGE3
				MNTFS
				COPY_CONFIGS
				;;
			0)
				printf  "Returning to Main Menu...\n"
				return
				;;
			*)
				printf "Invalid choice. Please try again.\n"
				;;
		esac

		printf "\n"
		PRE_CHOOSE
	}
	for f in src/PRE/*; do . $f ; done  # source src/PRE/
	PRE_CHOOSE

NOTICE_END
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CHROOT_NOMENU () {	# 4.0 CHROOT # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment
NOTICE_START
	CHROOT_RUNALL () {
		INNER_SCRIPT=$(cat <<- 'INNERSCRIPT'
		#!/bin/bash

		# https://github.com/alphaaurigae/gentoo_unattented-setup
		### +++ lines for quick scrolling section indication.
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		. $CHROOTX/gentoo_unattented-setup/func/func_main.sh
		. $CHROOTX/gentoo_unattented-setup/func/func_chroot_main.sh
		. $CHROOTX/gentoo_unattented-setup/var/var_main.sh
		. $CHROOTX/gentoo_unattented-setup/var/chroot_variables.sh
		#. $CHROOTX//gentoo_unattented-setup/configs/required/kern.config.sh
		#. $CHROOTX/gentoo_unattented-setup/func/chroot_static-functions.sh
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		BASE () {
		NOTICE_START

			for f in $CHROOTX/gentoo_unattented-setup/src/CHROOT/BASE/*; do . $f && echo $f; done

			printf "%s%s%s\n" "${BOLD}${GREEN}" "▗▄▄▖  ▗▄▖  ▗▄▄▖▗▄▄▄▖" "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌   " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▛▀▚▖▐▛▀▜▌ ▝▀▚▖▐▛▀▀▘" "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▙▄▞▘▐▌ ▐▌▗▄▄▞▘▐▙▄▄▖" "${RESET}"
			printf "%s\n" "----------------------------------------------------------------------------------"
			SWAPFILE  # src/CHROOT/BASE/SWAPFILE.sh
			MAKECONF  # src/CHROOT/BASE/MAKECONF.sh
			CONF_LOCALES  # src/CHROOT/BASE/CONF_LOCALES.sh
			PORTAGE  # src/CHROOT/BASE/PORTAGE.sh
			##EMERGE_SYNC  # src/CHROOT/BASE/EMERGE_SYNC.sh
			ESELECT_PROFILE  # src/CHROOT/BASE/ESELECT_PROFILE.sh
			##SETFLAGS1  # src/CHROOT/BASE/SETFLAGS1.sh #  PLACEHOLDER
			EMERGE_ATWORLD_A  #
			##MISC1_CHROOT  # src/CHROOT/BASE/MISC1_CHROOT.sh  # PLACEHOLDER
			##RELOADING_SYS  # src/CHROOT/BASE/RELOADING_SYS.sh  # PLACEHOLDER
			SYSTEMTIME  # src/CHROOT/BASE/SYSTEMTIME.sh
			KEYMAP_CONSOLEFONT  # src/CHROOT/BASE/KEYMAP_CONSOLEFONT.sh
			FIRMWARE  # src/CHROOT/BASE/FIRMWARE.sh
			CP_BASHRC  # src/CHROOT/BASE/CP_BASHRC.sh
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		CORE () {
		NOTICE_START

			for f in gentoo_unattented-setup/src/CHROOT/CORE/*; do . $f && echo $f; done

			printf "%s%s%s\n" "${BOLD}${GREEN}" " ▗▄▄▖ ▗▄▖ ▗▄▄▖ ▗▄▄▄▖" "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌   " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌   ▐▌ ▐▌▐▛▀▚▖▐▛▀▀▘" "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▝▚▄▄▖▝▚▄▞▘▐▌ ▐▌▐▙▄▄▖" "${RESET}"
			printf "%s\n" "----------------------------------------------------------------------------------"
			SYSCONFIG_CORE  # src/CHROOT/CORE/SYSCONFIG_CORE.sh
			SYSFS  # src/CHROOT/CORE/SYSFS.sh
			APPADMIN  # src/CHROOT/CORE/APPADMIN.sh
			SYSAPP  # src/CHROOT/CORE/SYSAPP.sh
			APP  # src/CHROOT/CORE/APP.sh
			SYSPROCESS  # src/CHROOT/CORE/SYSPROCESS.sh
			KERNEL  # src/CHROOT/CORE/KERNEL.sh
			INITRAM  # src/CHROOT/CORE/INITRAM.sh
			SYSBOOT  # src/CHROOT/CORE/SYSBOOT.sh
			## MODPROBE_CHROOT  # src/CHROOT/CORE/MODPROBE_CHROOT.sh
			APPEMULATION  # src/CHROOT/CORE/APPEMULATION.sh
			AUDIO  # src/CHROOT/CORE/AUDIO.sh
			## GPU  # src/CHROOT/CORE/GPU.sh
			NETWORK  # src/CHROOT/CORE/NETWORK.sh
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		SCREENDSP () {  # note: replace visual header with "screen and desktop"
		NOTICE_START

			for f in gentoo_unattented-setup/src/CHROOT/SCREENDSP/*; do . $f && echo $f; done

			printf "%s%s%s\n" "${BOLD}${GREEN}" " ▗▄▄▖ ▗▄▄▖▗▄▄▖ ▗▄▄▄▖▗▄▄▄▖▗▖  ▗▖▗▄▄▄  ▗▄▄▖▗▄▄▖ " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌   ▐▌   ▐▌ ▐▌▐▌   ▐▌   ▐▛▚▖▐▌▐▌  █▐▌   ▐▌ ▐▌" "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" " ▝▀▚▖▐▌   ▐▛▀▚▖▐▛▀▀▘▐▛▀▀▘▐▌ ▝▜▌▐▌  █ ▝▀▚▖▐▛▀▘ " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▗▄▄▞▘▝▚▄▄▖▐▌ ▐▌▐▙▄▄▖▐▙▄▄▖▐▌  ▐▌▐▙▄▄▀▗▄▄▞▘▐▌   " "${RESET}"
			printf "%s\n" "----------------------------------------------------------------------------------"
			WINDOWSYS # src/CHROOT/SCREENDSP/WINDOWSYS.sh
			DESKTOP_ENV # src/CHROOT/SCREENDSP/DESKTOP_ENV.sh
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		USERAPP () {  # (!todo)
		NOTICE_START

			for f in gentoo_unattented-setup/src/CHROOT/USERAPP/*; do . $f && echo $f; done

			printf "%s%s%s\n" "${BOLD}${GREEN}" "▗▖ ▗▖ ▗▄▄▖▗▄▄▄▖▗▄▄▖  ▗▄▖ ▗▄▄▖ ▗▄▄▖ " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌ ▐▌▐▌   ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌" "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌ ▐▌ ▝▀▚▖▐▛▀▀▘▐▛▀▚▖▐▛▀▜▌▐▛▀▘ ▐▛▀▘ " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▝▚▄▞▘▗▄▄▞▘▐▙▄▄▖▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌   " "${RESET}"
			printf "%s\n" "----------------------------------------------------------------------------------"
			# GIT # src/CHROOT/USERAPP/USERAPP_GIT.sh
			WEBBROWSER # src/CHROOT/USERAPP/WEBBROWSER.sh
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		USERS () {
		NOTICE_START

			for f in gentoo_unattented-setup/src/CHROOT/USERS/*; do . $f && echo $f; done

			printf "%s%s%s\n" "${BOLD}${GREEN}" "▗▖ ▗▖ ▗▄▄▖▗▄▄▄▖▗▄▄▖  ▗▄▄▖" "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌ ▐▌▐▌   ▐▌   ▐▌ ▐▌▐▌   " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌ ▐▌ ▝▀▚▖▐▛▀▀▘▐▛▀▚▖ ▝▀▚▖" "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▝▚▄▞▘▗▄▄▞▘▐▙▄▄▖▐▌ ▐▌▗▄▄▞▘" "${RESET}"
			printf "%s\n" "----------------------------------------------------------------------------------"
			ROOT # src/CHROOT/USERS/ROOT.sh
			ADMIN # src/CHROOT/USERS/ADMIN.sh
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		FINISH () {  # tidy up installation files - ok
		NOTICE_START

			for f in gentoo_unattented-setup/src/CHROOT/FINISH/*; do . $f && echo $f; done

			printf "%s%s%s\n" "${BOLD}${GREEN}" "  ________________________________________  " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" " / CONGRATS!                              \\" "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" " \\ Setup done, you did it!                /" "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "  ----------------------------------------  " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "         \   ^__^                           " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "          \  (xx)\_______                   " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "             (__)\       )\/\               " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "                 ||----- |                  " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "                 ||     ||                  " "${RESET}"
			printf "%s\n" "----------------------------------------------------------------------------------"
			TIDY_STAGE3 # src/CHROOT/FINISH/TIDY_STAGE3.sh
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		## (RUN ENTIRE SCRIPT) (!changeme)
		CHROOT_NOMENU () {

			printf "%s%s%s\n" "${BOLD}${GREEN}" " ▗▄▄▖▗▖ ▗▖▗▄▄▖  ▗▄▖  ▗▄▖▗▄▄▄▖" "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌ █  " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌   ▐▛▀▜▌▐▛▀▚▖▐▌ ▐▌▐▌ ▐▌ █  " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "▝▚▄▄▖▐▌ ▐▌▐▌ ▐▌▝▚▄▞▘▝▚▄▞▘ █  " "${RESET}"
			printf "%s\n" "----------------------------------------------------------------------------------"
			BASE  # src/CHROOT/BASE/*  # as defined in var/
			CORE  # src/CHROOT/CORE/*  # as defined in var/
			SCREENDSP  # src/CHROOT/SCREENDSP/*  # as defined in var/
			USERAPP  # src/CHROOT/USERAPP/*  # as defined in var/
			USERS  # src/CHROOT/USERS/*  # as defined in var/
			FINISH  # src/CHROOT/FINISH/*  # as defined in var/
		}
		CHROOT_NOMENU
		NOTICE_END
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		########## CHROOT ENDS HERE ##########
		INNERSCRIPT
		)
		CP_CHROOT () {
		NOTICE_START
			# Since the chroot script can't be run outside of chroot, the script, and possibly sourced functions as well as variable scripts, need to be copied accordingly. For simplicity, copy the whole repo.
			# IMPORTANT: The following commands are executed BEFORE the above INNERSCRIPT (BELOW chroot $CHROOTX /bin/bash ./chroot_run.sh). If a file needs to be made available in the INNERSCRIPT, copy it before (chroot $CHROOTX /bin/bash ./chroot_run.sh) within this CHROOT function!
			rm -rf $CHROOTX/gentoo_unattented-setup
			ls -la /root
			echo $CHROOTX
			cp -R /root/gentoo_unattented-setup $CHROOTX/gentoo_unattented-setup
			ls -la $CHROOTX
			
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
	}
	CHROOT_RUNALL
NOTICE_END
}

CHROOT_MENU () {	# 4.0 CHROOT # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment
NOTICE_START
	CHROOT_CHOOSE () {
		INNER_SCRIPT=$(cat <<- 'INNERSCRIPT'
		#!/bin/bash

		# https://github.com/alphaaurigae/gentoo_unattented-setup
		### +++ lines for quick scrolling section indication
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		. $CHROOTX/gentoo_unattented-setup/func/func_main.sh
		. $CHROOTX/gentoo_unattented-setup/func/func_chroot_main.sh
		. $CHROOTX/gentoo_unattented-setup/var/var_main.sh
		. $CHROOTX/gentoo_unattented-setup/var/chroot_variables.sh
		#. $CHROOTX//gentoo_unattented-setup/configs/required/kern.config.sh
		#. $CHROOTX/gentoo_unattented-setup/func/chroot_static-functions.sh
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		BASE () {
		NOTICE_START
			for f in $CHROOTX/gentoo_unattented-setup/src/CHROOT/BASE/*; do . $f && echo $f; done

			CHROOT_BASE_MENU () {
				CHROOT_BASE_CHOOSE() {
					printf "%s%s%s\n" "${BOLD}${GREEN}" "▗▄▄▖  ▗▄▖  ▗▄▄▖▗▄▄▄▖" "${RESET}"
					printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌   " "${RESET}"
					printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▛▀▚▖▐▛▀▜▌ ▝▀▚▖▐▛▀▀▘" "${RESET}"
					printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▙▄▞▘▐▌ ▐▌▗▄▄▞▘▐▙▄▄▖" "${RESET}"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf "%s%s%s\n" "${BOLD}${GREEN}" "Select e.g 1:" "${RESET}"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf "Single\n"
					printf "[1] --> SWAPFILE\n"
					printf "[2] --> MAKECONF\n"
					printf "[3] --> CONF_LOCALES\n"
					printf "[4] --> PORTAGE\n"
					## PLACEHOLDER for later use (maybe) EMERGE_SYNC  # run EMERGE_SYNC
					printf "[5] --> ESELECT_PROFILE\n"
					printf "[6] (just a placeholder NOT REQUIRED) --> SETFLAGS1\n"
					printf "[7] --> EMERGE_ATWORLD_A\n" # temporary added rust emere as bugfix for srvg lib error as suggested by sam_ #gentoo librachat irc - see https://bugs.gentoo.org/907492
					## PLACEHOLDER for later integration (maybe) #MISC1_CHROOT  # run MISC1_CHROOT  # PLACEHOLDER
					## PLACEHOLDER for later integration (maybe) RELOADING_SYS  # run RELOADING_SYS  # PLACEHOLDER
					printf "[8] --> SYSTEMTIME\n"
					printf "[9] --> KEYMAP_CONSOLEFONT\n"
					printf "[10] --> FIRMWARE\n"
					printf "[11] --> CP_BASHRC\n"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf "Multi\n"
					printf "[21] --> [1]-[3] create swap for setup; copy make.conf locales to run portage in next step - prints emerge at world which is neede dfor make.conf\n"
					printf "[22] --> [2] & [3] to run portage in next step - prints emerge at world which is neede dfor make.conf\n"
					printf "[23] --> [4]-[7].. eselect profile and 6. emergeatworld \n"
					printf "[24] --> [8] & [9] .. setup system time and keymap \n"
					printf "[25] --> [10] & [11] .. setup firmaware and copy bashrc\n"
					printf "[26] --> [2]-[10]\n"
					printf "[27] --> [1]-[11]\n"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf  "0. Exit\n"

					read -p "Enter your choice: " choice
					printf "\n"

					case $choice in
					1)
						SWAPFILE  # [1] # src/CHROOT/BASE/SWAPFILE.sh
						;;
					2)
						MAKECONF  # [2] # src/CHROOT/BASE/MAKECONF.sh
						;;
					3)
						CONF_LOCALES  # [3] # src/CHROOT/BASE/CONF_LOCALES.sh
						;;
					4)
						PORTAGE  # [4] # src/CHROOT/BASE/PORTAGE.sh
						;;
					5)
						ESELECT_PROFILE  # [5] # src/CHROOT/BASE/ESELECT_PROFILE.sh
						;;
					6)
						SETFLAGS1  # [6] # src/CHROOT/BASE/SETFLAGS1.sh #  PLACEHOLDER
						;;
					7)
						EMERGE_ATWORLD_A  # [7]
						;;
					8)
						SYSTEMTIME  # [8] # src/CHROOT/BASE/SYSTEMTIME.sh
						;;
					9)
						KEYMAP_CONSOLEFONT  # [9] # src/CHROOT/BASE/KEYMAP_CONSOLEFONT.sh
						;;
					10)
						FIRMWARE  # [10] # src/CHROOT/BASE/FIRMWARE.sh
						;;
					11)
						CP_BASHRC  # [11] # src/CHROOT/BASE/CP_BASHRC.sh
						;;
					21)
						SWAPFILE  # [1]
						MAKECONF  # [2]
						CONF_LOCALES  # [3]
						;;
					22)
						MAKECONF  # [2]
						CONF_LOCALES  # [3]
						;;
					23)
						PORTAGE  # [4]
						ESELECT_PROFILE  # [5]
						SETFLAGS1  # [6]
						EMERGE_ATWORLD_A  # [7]
						;;
					24)
						SYSTEMTIME  # [8]
						KEYMAP_CONSOLEFONT  # [9]
						;;
					25)
						FIRMWARE  # [10]
						CP_BASHRC  # [11]
						;;
					26)
						MAKECONF  # [2]
						CONF_LOCALES  # [3]
						PORTAGE  # [4]
						ESELECT_PROFILE  # [5]
						SETFLAGS1  # [6]
						EMERGE_ATWORLD_A  # [7]
						SYSTEMTIME  # [8]
						KEYMAP_CONSOLEFONT  # [9]
						FIRMWARE  # [10]
						CP_BASHRC  # [11]
						;;
					27)
						SWAPFILE  # [1]
						MAKECONF  # [2]
						CONF_LOCALES  # [3]
						PORTAGE  # [4]
						ESELECT_PROFILE  # [5]
						SETFLAGS1  # [6]
						EMERGE_ATWORLD_A  # [7]
						SYSTEMTIME  # [8]
						KEYMAP_CONSOLEFONT  # [9]
						FIRMWARE  # [10]
						CP_BASHRC  # [11]
						;;
					0)
						printf  "Returning to Main Menu...\n"
						return
						;;
					*)
						printf "Invalid choice. Please try again.\n"
						;;
					esac

					printf "\n"
					CHROOT_BASE_CHOOSE
				}
				CHROOT_BASE_CHOOSE	
			}
			CHROOT_BASE_MENU
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		CORE () {
		NOTICE_START
			for f in gentoo_unattented-setup/src/CHROOT/CORE/*; do . $f && echo $f; done

			CHROOT_CORE_MENU () {
				CHROOT_CORE_CHOOSE() {
					printf "%s%s%s\n" "${BOLD}${GREEN}" " ▗▄▄▖ ▗▄▖ ▗▄▄▖ ▗▄▄▄▖" "${RESET}"
					printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌   " "${RESET}"
					printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌   ▐▌ ▐▌▐▛▀▚▖▐▛▀▀▘" "${RESET}"
					printf "%s%s%s\n" "${BOLD}${GREEN}" "▝▚▄▄▖▝▚▄▞▘▐▌ ▐▌▐▙▄▄▖" "${RESET}"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf "%s%s%s\n" "${BOLD}${GREEN}" "Select e.g 1:" "${RESET}"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf "Single\n"
					printf  "[1] SYSCONFIG_CORE\n"
					printf  "[2] SYSFS\n"
					printf  "[3] APPADMIN\n"
					printf  "[4] SYSAPP\n"
					printf  "[5] APP\n"
					printf  "[6] SYSPROCESS\n"
					printf  "[7] KERNEL\n"
					printf  "[8] INITRAM\n"
					printf  "[9] SYSBOOT\n"
					# printf "[10] MODPROBE_CHROOT\n"
					printf "[11] APPEMULATION\n"
					printf "[12] AUDIO\n"
					# printf "[13] GPU\n"
					printf "[14] NETWORK\n"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf "Multi\n"
					printf "[21] --> [1]-[3] \n"
					printf "[22] --> [2] & [3] \n"
					printf "[23] --> [4]-[6]\n"
					printf "[24] --> [7] & [8] \n"
					printf "[25] --> [9]-[11] *modprobe not necessary here - skip [10]* \n"
					printf "[26] --> [12]-[14] *gpu driver deaktivated - skip [13]* \n"
					printf "[27] --> [1]-[5]\n"
					printf "[28] --> [6]-[10] \n"
					printf "[29] --> [11]-[14] *gpu driver deaktivated - skip [13]* \n"
					printf "[30] ALL ... steps [1]-[14] *modprobe not nessecary here - skip [10], gpu driver deactivated - skip [13]* \n"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf  "[0] Exit\n"

					read -p "Enter your choice: " choice
					printf "\n"

					case $choice in
					1)
						SYSCONFIG_CORE  # [1] # src/CHROOT/CORE/SYSCONFIG_CORE.sh
						;;
					2)
						SYSFS  # [2] # src/CHROOT/CORE/SYSFS.sh
						;;
					3)
						APPADMIN  # [3] # src/CHROOT/CORE/APPADMIN.sh
						;;
					4)
						SYSAPP  # [4] # src/CHROOT/CORE/SYSAPP.sh
						;;
					5)
						APP  # [5] # src/CHROOT/CORE/APP.sh
						;;
					6)
						SYSPROCESS  # [6] # src/CHROOT/CORE/SYSPROCESS.sh
						;;
					7)
						KERNEL  # [7] # src/CHROOT/CORE/KERNEL.sh
						;;
					8)
						INITRAM  # [8] # src/CHROOT/CORE/INITRAM.sh
						;;
					9)
						SYSBOOT  # [9] # src/CHROOT/CORE/SYSBOOT.sh
						;;
					10)
						MODPROBE_CHROOT  # [10] # src/CHROOT/CORE/MODPROBE_CHROOT.sh
						;;
					11)
						APPEMULATION  # [11] # src/CHROOT/CORE/APPEMULATION.sh
						;;
					12)
						AUDIO  # [12] # src/CHROOT/CORE/AUDIO.sh
						;;
					13)
						GPU  # [13] # src/CHROOT/CORE/GPU.sh
						;;
					14)
						NETWORK  # [10] # src/CHROOT/CORE/NETWORK.sh
						;;
					21)
						SYSCONFIG_CORE  # [1]
						SYSFS  # [2]
						APPADMIN  # [3]
						;;
					22)
						SYSFS  # [2]
						APPADMIN  # [3]
						;;
					23)
						SYSAPP  # [4]
						APP  # [5]
						SYSPROCESS  # [6]
						;;
					24)
						KERNEL  # [7]
						INITRAM  # [8]
						;;
					25)
						SYSBOOT  # step 9]
						#MODPROBE_CHROOT  # [10]
						APPEMULATION  # step. [11]
						;;
					26)
						AUDIO  # [12]
						#GPU  # [13]
						NETWORK  # step. [14]
						;;
					27)
						SYSCONFIG_CORE # [1]
						SYSFS  # [2]
						APPADMIN  # [3]
						SYSAPP  # [4]
						APP  # [5]
						;;
					28)
						SYSPROCESS  # [6]
						KERNEL  # [7]
						INITRAM  # [8]
						SYSBOOT  # [9]
						# MODPROBE_CHROOT  # [10]
						;;
					29)
						APPEMULATION  # [11]
						AUDIO  # [12]
						# GPU  # [13]
						NETWORK  # [14]
						;;
					30)
						SYSCONFIG_CORE # [1]
						SYSFS  # [2]
						APPADMIN  # [3]
						SYSAPP  # [4]
						APP  # [5]
						SYSPROCESS  # [6]
						KERNEL  # [7]
						INITRAM  # [8]
						SYSBOOT  # [9]
						# MODPROBE_CHROOT  # [10]
						APPEMULATION  # [11]
						AUDIO  # [12]
						# GPU  # [13]
						NETWORK  # [14]
						;;
					0)
						printf  "Returning to Main Menu...\n"
						return
						;;
					*)
						printf "Invalid choice. Please try again.\n"
						;;
					esac

					printf "\n"
					CHROOT_CORE_CHOOSE
				}
				CHROOT_CORE_CHOOSE	
			}
			CHROOT_CORE_MENU
			NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		SCREENDSP () {  # note: replace visual header with "screen and desktop"
		NOTICE_START
			for f in gentoo_unattented-setup/src/CHROOT/SCREENDSP/*; do . $f && echo $f; done

			CHROOT_SCREENDSP_MENU () {
				CHROOT_SCREENDSP_CHOOSE() {
					printf "%s%s%s\n" "${BOLD}${GREEN}" " ▗▄▄▖ ▗▄▄▖▗▄▄▖ ▗▄▄▄▖▗▄▄▄▖▗▖  ▗▖▗▄▄▄  ▗▄▄▖▗▄▄▖ " "${RESET}"
					printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌   ▐▌   ▐▌ ▐▌▐▌   ▐▌   ▐▛▚▖▐▌▐▌  █▐▌   ▐▌ ▐▌" "${RESET}"
					printf "%s%s%s\n" "${BOLD}${GREEN}" " ▝▀▚▖▐▌   ▐▛▀▚▖▐▛▀▀▘▐▛▀▀▘▐▌ ▝▜▌▐▌  █ ▝▀▚▖▐▛▀▘ " "${RESET}"
					printf "%s%s%s\n" "${BOLD}${GREEN}" "▗▄▄▞▘▝▚▄▄▖▐▌ ▐▌▐▙▄▄▖▐▙▄▄▖▐▌  ▐▌▐▙▄▄▀▗▄▄▞▘▐▌   " "${RESET}"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf "%s%s%s\n" "${BOLD}${GREEN}" "Select e.g 1:" "${RESET}"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf "Single\n"
					printf  "[1] --> WINDOWSYS\n"
					printf  "[2] --> DESKTOP_ENV\n"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf "Multi\n"
					printf "[21] run steps [1] && [2]\n"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf  "0. Exit\n"

					read -p "Enter your choice: " choice
					printf "\n"

					case $choice in
					1)
						WINDOWSYS  # [1] # src/CHROOT/SCREENDSP/WINDOWSYS.sh
						;;
					2)
						DESKTOP_ENV  # [2] # src/CHROOT/SCREENDSP/DESKTOP_ENV.sh
						;;
					21)
						WINDOWSYS  # [1]
						DESKTOP_ENV  # [2]
						;;

					0)
						printf  "Returning to Main Menu...\n"
						return
						;;
					*)
						printf "Invalid choice. Please try again.\n"
						;;
					esac

					printf "\n"
					CHROOT_SCREENDSP_CHOOSE
				}
				CHROOT_SCREENDSP_CHOOSE	
			}
			CHROOT_SCREENDSP_MENU
			NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		USERAPP () {  # (!todo)
		NOTICE_START
			for f in gentoo_unattented-setup/src/CHROOT/USERAPP/*; do . $f && echo $f; done

				printf "%s%s%s\n" "${BOLD}${GREEN}" "▗▖ ▗▖ ▗▄▄▖▗▄▄▄▖▗▄▄▖  ▗▄▖ ▗▄▄▖ ▗▄▄▖ " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌ ▐▌▐▌   ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌" "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌ ▐▌ ▝▀▚▖▐▛▀▀▘▐▛▀▚▖▐▛▀▜▌▐▛▀▘ ▐▛▀▘ " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "▝▚▄▞▘▗▄▄▞▘▐▙▄▄▖▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌   " "${RESET}"
				printf "%s\n" "----------------------------------------------------------------------------------"
			# GIT # src/CHROOT/USERAPP/USERAPP_GIT.sh
			WEBBROWSER # src/CHROOT/USERAPP/WEBBROWSER.sh

		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		USERS () {
		NOTICE_START
			for f in gentoo_unattented-setup/src/CHROOT/USERS/*; do . $f && echo $f; done

				printf "%s%s%s\n" "${BOLD}${GREEN}" "▗▖ ▗▖ ▗▄▄▖▗▄▄▄▖▗▄▄▖  ▗▄▄▖" "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌ ▐▌▐▌   ▐▌   ▐▌ ▐▌▐▌   " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌ ▐▌ ▝▀▚▖▐▛▀▀▘▐▛▀▚▖ ▝▀▚▖" "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "▝▚▄▞▘▗▄▄▞▘▐▙▄▄▖▐▌ ▐▌▗▄▄▞▘" "${RESET}"
				printf "%s\n" "----------------------------------------------------------------------------------"
			ROOT # src/CHROOT/USERS/ROOT.sh
			ADMIN # src/CHROOT/USERS/ADMIN.sh
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		FINISH () {  # tidy up installation files - ok
		NOTICE_START
			for f in gentoo_unattented-setup/src/CHROOT/FINISH/*; do . $f && echo $f; done

				printf "%s%s%s\n" "${BOLD}${GREEN}" "  ________________________________________  " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" " / CONGRATS!                              \\" "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" " \\ Setup done, you did it!                /" "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "  ----------------------------------------  " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "         \   ^__^                           " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "          \  (xx)\_______                   " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "             (__)\       )\/\               " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "                 ||----- |                  " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "                 ||     ||                  " "${RESET}"
				printf "%s\n" "----------------------------------------------------------------------------------"

			TIDY_STAGE3 # src/CHROOT/FINISH/TIDY_STAGE3.sh
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		CHROOT_MENU () {
			CHROOT_CHOOSE() {

				printf "%s%s%s\n" "${BOLD}${GREEN}" " ▗▄▄▖▗▖ ▗▖▗▄▄▖  ▗▄▖  ▗▄▖▗▄▄▄▖" "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌ █  " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌   ▐▛▀▜▌▐▛▀▚▖▐▌ ▐▌▐▌ ▐▌ █  " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "▝▚▄▄▖▐▌ ▐▌▐▌ ▐▌▝▚▄▞▘▝▚▄▞▘ █  " "${RESET}"
				printf "%s\n" "----------------------------------------------------------------------------------"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "Select e.g 1:" "${RESET}"
				printf "%s\n" "----------------------------------------------------------------------------------"
				printf "[1] --> BASE\n"
				printf "[2] --> CORE\n"
				printf "[3] --> SCREENDSP\n"
				printf "[4] --> USERAPP as predefined in variables\n"
				printf "[5] --> USERS as predefined in variables\n"
				printf "[6] --> FINISH\n"
				printf "%s\n" "----------------------------------------------------------------------------------"
				printf "[0] --> Exit\n"
				read -p "Enter your choice: " choice
				printf "\n"

				case $choice in
				1)
					BASE
					;;
				2)
					CORE
					;;
				3)
					SCREENDSP
					;;
				4)
					USERAPP
					;;
				5)
					USERS
					;;
				6)
					FINISH
					;;
				0)
					printf  "Returning to Main Menu...\n"
					return
					;;
				*)
					printf "Invalid choice. Please try again.\n"
					;;
				esac

				printf "\n"
				CHROOT_CHOOSE
			}
			CHROOT_CHOOSE	
		}
		CHROOT_MENU
		NOTICE_END
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		########## CHROOT ENDS HERE ##########
		INNERSCRIPT
		)
		CP_CHROOT () {
		NOTICE_START
			# Since the chroot script can't be run outside of chroot, the script, and possibly sourced functions as well as variable scripts, need to be copied accordingly. For simplicity, copy the whole repo.
			# IMPORTANT: The following commands are executed BEFORE the above INNERSCRIPT (BELOW chroot $CHROOTX /bin/bash ./chroot_run.sh). If a file needs to be made available in the INNERSCRIPT, copy it before (chroot $CHROOTX /bin/bash ./chroot_run.sh) within this CHROOT function!
			rm -rf $CHROOTX/gentoo_unattented-setup
			ls -la /root
			echo $CHROOTX
			cp -R /root/gentoo_unattented-setup $CHROOTX/gentoo_unattented-setup
			ls -la $CHROOTX
			
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
	}
	CHROOT_CHOOSE
NOTICE_END
}

MAIN_MENU() {
	printf "%s%s%s\n" "${BOLD}${GREEN}" " ▗▄▄▖▗▄▄▄▖▗▄▄▄▖▗▖ ▗▖▗▄▄▖     ▗▖  ▗▖ ▗▄▖ ▗▄▄▄▖▗▖  ▗▖" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${GREEN}" "▐▌   ▐▌     █  ▐▌ ▐▌▐▌ ▐▌    ▐▛▚▞▜▌▐▌ ▐▌  █  ▐▛▚▖▐▌" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${GREEN}" " ▝▀▚▖▐▛▀▀▘  █  ▐▌ ▐▌▐▛▀▘     ▐▌  ▐▌▐▛▀▜▌  █  ▐▌ ▝▜▌" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${GREEN}" "▗▄▄▞▘▐▙▄▄▖  █  ▝▚▄▞▘▐▌       ▐▌  ▐▌▐▌ ▐▌▗▄█▄▖▐▌  ▐▌" "${RESET}"
	printf "%s\n" "----------------------------------------------------------------------------------"
	printf "%s%s%s\n" "${BOLD}${GREEN}" "Select e.g: 1" "${RESET}"
	printf "[1] --> PRE - NO menu\n"
	printf "[2] --> CHROOT - NO menu\n"
	printf "[3] --> PRE && CHROOT - NO menu\n"
	printf "[4] --> PRE - menu\n"
	printf "[5] --> CHROOT - menu\n"
	printf "[6] --> PRE menu && CHROOT - menu\n"
	printf "[0] --> Exit\n"

	read -p "Enter your choice: " choice
	printf "\n"

	case $choice in
		1)
			printf "Running the semi unattended PRE setup as configured in 10 seconds... Exit now to see options with -h or enter the menu when running the program with -m.\n"
			printf "(default PRE asks for crypt password and disk wipe confirmation)"
			sleep 10
			PRE_NOMENU
			;;
		2)
			printf "Running the semi unattended CHROOT setup as configured in 10 seconds... Exit now to see options with -h or enter the menu when running the program with -m.\n"
			printf "(Default CHROOT asks for kernel config menuconfig confirmation or edit and GPG password)"
			sleep 10
			CHROOT_NOMENU
			;;
		3)
			printf "Running the semi unattended setup as configured in 10 seconds... Exit now to see options with -h or enter the menu when running the program with -m.\n"
			printf "(Default PRE asks for crypt password and disk wipe confirmation)"
			printf "(Default CHROOT asks for kernel config menuconfig confirmation or edit and GPG password)"
			sleep 10
			PRE_NOMENU
			CHROOT_NOMENU
			;;
		4)
			PRE_MENU
			;;
		5)
			CHROOT_MENU
			;;
		6)
			PRE_MENU
			CHROOT_MENU
			;;
		0)
			printf "Exiting...\n"
			exit
			;;
		*)
			printf "Invalid choice. Please try again.\n"
			;;
	esac

	printf "\n"
	MAIN_MENU
}
# Check if the script is run with the -h option
if [[ "$1" == "-a" ]]; then
	printf "Running the semi unattended setup as configured in 10 seconds... \n"
	printf "Exit now to see options with -h or enter the menu when running the program with -m.\n"
	printf "(Default PRE asks for crypt password and disk wipe confirmation)"
	printf "(Default CHROOT asks for kernel config menuconfig confirmation or edit and GPG password)"
	sleep 10

	PRE_NOMENU
	CHROOT_NOMENU
elif [[ "$1" == "-m" ]]; then
	MAIN_MENU  # Run the program with the menu
else

	#printf "WELCOME TO THE GENTOO SETUP (unattended by default testing in virtualbox) .... \n"
	printf "\n"
	printf "%s%s%s\n" "${BOLD}${BRIGHT_GREEN}" "WELCOME :)" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${MAGENTA}" "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${MAGENTA}" "|g|e|n|t|o|o|_|u|n|a|t|t|e|n|t|e|d|-|s|e|t|u|p|" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${MAGENTA}" "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${BRIGHT_GREEN}" "https://github.com/alphaaurigae/gentoo_unattented-setup" "${RESET}"$'\n'

	printf "%s%s%s\n" "${BOLD}${YELLOW}" "Usage: ./run.sh ARG" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${YELLOW}" "ARG -a run entire setup ... CHECK gentoo_unattented-setup/var/*" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${YELLOW}" "ARG -m enters menu mode (useful fe to save state in vm's" "${RESET}"
	printf "\n"
	printf "Refer to the readme.md file for more information. Check the readme.md file for the latest status message at the top. \n"
	printf "Check the variables if its not a VM!!!\n"
	printf "PRE setup wipes and encrypts the defined main disk but issues warning.  \n"
	printf "Works by default in virtualbox. \n"
	printf "Cloning the VM for testing works fine if its a full clone ... \n"
	printf "\n"

	exit
fi


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
