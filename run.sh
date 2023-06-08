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
PRE_NOMENU () {  # PREPARE CHROOT ALL without menu
NOTICE_START

	PRE_RUNALL () {
		printf "%s%s%s\n" "${BOLD}${GREEN}" "PPPPPPPPPPPPPPPPP   RRRRRRRRRRRRRRRRR   EEEEEEEEEEEEEEEEEEEEEE" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "P::::::::::::::::P  R::::::::::::::::R  E::::::::::::::::::::E" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "P::::::PPPPPP:::::P R::::::RRRRRR:::::R E::::::::::::::::::::E" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "PP:::::P     P:::::PRR:::::R     R:::::REE::::::EEEEEEEEE::::E" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::P     P:::::P  R::::R     R:::::R  E:::::E       EEEEEE" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::P     P:::::P  R::::R     R:::::R  E:::::E             " "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::PPPPPP:::::P   R::::RRRRRR:::::R   E::::::EEEEEEEEEE   " "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P:::::::::::::PP    R:::::::::::::RR    E:::::::::::::::E   " "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::PPPPPPPPP      R::::RRRRRR:::::R   E:::::::::::::::E   " "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::P              R::::R     R:::::R  E::::::EEEEEEEEEE   " "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::P              R::::R     R:::::R  E:::::E             " "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::P              R::::R     R:::::R  E:::::E       EEEEEE" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "PP::::::PP          RR:::::R     R:::::REE::::::EEEEEEEE:::::E" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "P::::::::P          R::::::R     R:::::RE::::::::::::::::::::E" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "P::::::::P          R::::::R     R:::::RE::::::::::::::::::::E" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "PPPPPPPPPP          RRRRRRRR     RRRRRRREEEEEEEEEEEEEEEEEEEEEE" "${RESET}"
		INIT
		PARTITIONING
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
		printf "%s%s%s\n" "${BOLD}${GREEN}" "PPPPPPPPPPPPPPPPP   RRRRRRRRRRRRRRRRR   EEEEEEEEEEEEEEEEEEEEEE" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "P::::::::::::::::P  R::::::::::::::::R  E::::::::::::::::::::E" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "P::::::PPPPPP:::::P R::::::RRRRRR:::::R E::::::::::::::::::::E" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "PP:::::P     P:::::PRR:::::R     R:::::REE::::::EEEEEEEEE::::E" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::P     P:::::P  R::::R     R:::::R  E:::::E       EEEEEE" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::P     P:::::P  R::::R     R:::::R  E:::::E             " "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::PPPPPP:::::P   R::::RRRRRR:::::R   E::::::EEEEEEEEEE   " "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P:::::::::::::PP    R:::::::::::::RR    E:::::::::::::::E   " "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::PPPPPPPPP      R::::RRRRRR:::::R   E:::::::::::::::E   " "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::P              R::::R     R:::::R  E::::::EEEEEEEEEE   " "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::P              R::::R     R:::::R  E:::::E             " "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "  P::::P              R::::R     R:::::R  E:::::E       EEEEEE" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "PP::::::PP          RR:::::R     R:::::REE::::::EEEEEEEE:::::E" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "P::::::::P          R::::::R     R:::::RE::::::::::::::::::::E" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "P::::::::P          R::::::R     R:::::RE::::::::::::::::::::E" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "PPPPPPPPPP          RRRRRRRR     RRRRRRREEEEEEEEEEEEEEEEEEEEEE" "${RESET}"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "PRE menu:" "${RESET}"
		#printf "OPTION1 Menu:\n"
		printf "1. INIT (src/PRE/INIT.sh)\n"
		printf "2. PARTITIONING (src/PRE/INIT.sh)\n"
		printf "3. CRYPTSETUP (src/PRE/INIT.sh)\n"
		printf "4. LVMSETUP (src/PRE/INIT.sh)\n"
		printf "5. STAGE3 (src/PRE/INIT.sh)\n"
		printf "6. MNTFS (src/PRE/INIT.sh)\n"
		printf "7. COPY_CONFIGS (src/PRE/INIT.sh)\n"
		printf "8. ALL PRE functions (src/PRE/....)\n"
		printf "0. Return to Main Menu\n"

		read -p "Enter your choice: " choice
		printf "\n"

		case $choice in
			1)
				printf "INIT\n"
				INIT
				;;
			2)
				printf "PARTITIONING\n"
				PARTITIONING
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
			8)
				printf "running INIT;PARTITIONING;CRYPTSETUP;LVMSETUP;STAGE3;MNTFS;COPY_CONFIGS\n"
				INIT
				PARTITIONING
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
	for f in src/PRE/*; do . $f && echo $f; done  # source src/PRE/
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

			printf "%s%s%s\n" "${BOLD}${GREEN}" "######     #     #####  ####### " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "#     #   # #   #     # #       " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "#     #  #   #  #       #       " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "######  #     #  #####  #####   " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "#     # #######       # #       " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "#     # #     # #     # #       " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "######  #     #  #####  ####### " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "chroot base:" "${RESET}"

			SWAPFILE  # run SWAPFILE
			MAKECONF  # run MAKECONF
			CONF_LOCALES  # run CONF_LOCALES
			PORTAGE  # run PORTAGE
			##EMERGE_SYNC  # run EMERGE_SYNC
			ESELECT_PROFILE  # run ESELECT_PROFILE
			##SETFLAGS1  # run SETFLAGS1 #  PLACEHOLDER
			EMERGE_ATWORLD_A  # run EMERGE_ATWORLD_A
			##MISC1_CHROOT  # run MISC1_CHROOT  # PLACEHOLDER
			##RELOADING_SYS  # run RELOADING_SYS  # PLACEHOLDER
			SYSTEMTIME  # run SYSTEMTIME
			KEYMAP_CONSOLEFONT  # run KEYMAP_CONSOLEFONT
			FIRMWARE  # run FIRMWARE
			CP_BASHRC  # run CP_BASHRC
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		}
		CORE () {
		NOTICE_START

			for f in gentoo_unattented-setup/src/CHROOT/CORE/*; do . $f && echo $f; done

			printf "%s%s%s\n" "${BOLD}${GREEN}" "  .d8888b.  .d88888b. 8888888b. 8888888888 " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" " d88P  Y88bd88P" "Y88b888   Y88b888        " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" " 888    888888     888888    888888        " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" " 888       888     888888   d88P8888888    " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" " 888       888     8888888888P" 888        " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" " 888    888888     888888 T88b  888        " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" " Y88b  d88PY88b. .d88P888  T88b 888        " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "  *Y8888P*  *Y88888P* 888   T88b8888888888 " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "chroot core:" "${RESET}"

			SYSCONFIG_CORE  # run SYSCONFIG_CORE
			SYSFS  # run SYSFS
			APPADMIN  # run APPADMIN
			SYSAPP  # run SYSAPP
			APP  # run APP
			SYSPROCESS  # run SYSPROCESS
			KERNEL  # run KERNEL
			INITRAM  # run INITRAM
			SYSBOOT  # run SYSBOOT
			## MODPROBE_CHROOT  # run MODPROBE_CHROOT
			APPEMULATION  # run APPEMULATION
			AUDIO  # run AUDIO
			## GPU  # run GPU
			NETWORK  # run NETWORK
		NOTICE_END
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		}
		SCREENDSP () {  # note: replace visual header with "screen and desktop"
		NOTICE_START

			for f in gentoo_unattented-setup/src/CHROOT/SCREENDSP/*; do . $f && echo $f; done

			printf "%s%s%s\n" "${BOLD}${GREEN}" " .--.  .--. .---.  .--.  .--. .-..-..---.  .--. .---.  " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" ": .--': .--': .; :: .--': .--': `: :: .  :: .--': .; : " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "`. `. : :   :   .': `;  : `;  : .` :: :: :`. `. :  _.' " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" " _`, :: :__ : :.`.: :__ : :__ : :. :: :; : _`, :: :    " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "`.__.'`.__.':_;:_;`.__.'`.__.':_;:_;:___.'`.__.':_;    " "${RESET}"

			WINDOWSYS
			DESKTOP_ENV
		NOTICE_END
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		}
		USERAPP () {  # (!todo)
		NOTICE_START

			for f in gentoo_unattented-setup/src/CHROOT/USERAPP/*; do . $f && echo $f; done

			printf "%s%s%s\n" "${BOLD}${GREEN}" "     :::    ::: :::::::: :::::::::::::::::::     :::    ::::::::: ::::::::: " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "    :+:    :+::+:    :+::+:       :+:    :+:  :+: :+:  :+:    :+::+:    :+: " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "   +:+    +:++:+       +:+       +:+    +:+ +:+   +:+ +:+    +:++:+    +:+  " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "  +#+    +:++#++:++#+++#++:++#  +#++:++#: +#++:++#++:+#++:++#+ +#++:++#+    " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" " +#+    +#+       +#++#+       +#+    +#++#+     +#++#+       +#+           " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "#+#    #+##+#    #+##+#       #+#    #+##+#     #+##+#       #+#            " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "########  ######## #############    ######     ######       ###             " "${RESET}"

			# GIT
			WEBBROWSER
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		USERS () {
		NOTICE_START

			for f in gentoo_unattented-setup/src/CHROOT/USERS/*; do . $f && echo $f; done

			printf "%s%s%s\n" "${BOLD}${GREEN}" "_|    _|    _|_|_|  _|_|_|_|  _|_|_|      _|_|_|  " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "_|    _|  _|        _|        _|    _|  _|        " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "_|    _|    _|_|    _|_|_|    _|_|_|      _|_|    " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "_|    _|        _|  _|        _|    _|        _|  " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "  _|_|    _|_|_|    _|_|_|_|  _|    _|  _|_|_|    " "${RESET}"

			ROOT
			ADMIN
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



			TIDY_STAGE3
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		## (RUN ENTIRE SCRIPT) (!changeme)
		CHROOT_NOMENU () {

			printf "%s%s%s\n" "${BOLD}${GREEN}" " CCCCC  HH   HH RRRRRR   OOOOO   OOOOO  TTTTTTT " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "CC    C HH   HH RR   RR OO   OO OO   OO   TTT   " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "CC      HHHHHHH RRRRRR  OO   OO OO   OO   TTT   " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" "CC    C HH   HH RR  RR  OO   OO OO   OO   TTT   " "${RESET}"
			printf "%s%s%s\n" "${BOLD}${GREEN}" " CCCCC  HH   HH RR   RR  OOOO0   OOOO0    TTT   " "${RESET}"

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
			# since the chroot script cant be run outside of chroot the script and possibly sourced functions and variables scripts need to be copied accordingly.
			# for the onefile setup this is simply done by echoing the 'INNERSCRIPT" ... if the setup is split in multiple files for readability, every file or alt the gentoo script repo needs to be copied to make all functions and variables available.
			# only variables outside the chroot innerscript for now 27.8.22
			# IMPORTANT blow commands are executed BEFORE the above INNERSCRIPT! (BELOW chroot $CHROOTX /bin/bash ./chroot_run.sh). if a file needs to be made available in the INNERSCRIPT, copy it before ( chroot $CHROOTX /bin/bash ./chroot_run.sh ) below in this CHROOT function!!!

			rm -rf $CHROOTX/gentoo_unattented-setup
			cp /root/gentoo_unattented-setup $CHROOTX/gentoo_unattented-setup

			
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
				printf "%s%s%s\n" "${BOLD}${GREEN}" "######     #     #####  ####### " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "#     #   # #   #     # #       " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "#     #  #   #  #       #       " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "######  #     #  #####  #####   " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "#     # #######       # #       " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "#     # #     # #     # #       " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "######  #     #  #####  ####### " "${RESET}"

				printf "%s%s%s\n" "${BOLD}${GREEN}" "chroot base:" "${RESET}"

				printf "1. step 1. SWAPFILE\n"
				printf "2. step 2. MAKECONF\n"
				printf "3. step 3. CONF_LOCALES\n"
				printf "4. step 4. PORTAGE\n"
				## PLACEHOLDER for later use (maybe) EMERGE_SYNC  # run EMERGE_SYNC
				printf "5. step 5. ESELECT_PROFILE\n"
				printf "6. (just a placeholder NOT REQUIRED) step 6. SETFLAGS1\n"
				printf "7. step 7. EMERGE_ATWORLD_A\n" # temporary added rust emere as bugfix for srvg lib error as suggested by sam_ #gentoo librachat irc - see https://bugs.gentoo.org/907492
				## PLACEHOLDER for later use (maybe) #MISC1_CHROOT  # run MISC1_CHROOT  # PLACEHOLDER
				## PLACEHOLDER for later use (maybe) RELOADING_SYS  # run RELOADING_SYS  # PLACEHOLDER
				printf "8. step 8. SYSTEMTIME\n"
				printf "9. step 9. KEYMAP_CONSOLEFONT\n"
				printf "10. step 10. FIRMWARE\n"
				printf "11. step 11. CP_BASHRC\n"
				printf "\n"
				printf "run multi step\n"
				printf "21. run steps 1.; 2. & 3. create swap for setup; copy make.conf locales to run portage in next step - prints emerge at world which is neede dfor make.conf\n"
				printf "22. run steps 2. & 3. to run portage in next step - prints emerge at world which is neede dfor make.conf\n"
				printf "23. run steps 4. 5, 6. 7.. eselect profile and 6. emergeatworld \n"
				printf "24. run steps 8. & 9. .. setup system time and keymap \n"
				printf "25. run steps 10. & 11. .. setup firmaware and copy bashrc\n"
				printf "26. run steps 2-10\n"
				printf "27. run steps 1-10\n"

				printf  "0. Exit\n"

				read -p "Enter your choice: " choice
				printf "\n"

				case $choice in
				1)
					SWAPFILE  # step 1.
					;;
				2)
					MAKECONF  # step 2.
					;;
				3)
					CONF_LOCALES  # step 3.
					;;
				4)
					PORTAGE  # step 4.
					;;
				5)
					ESELECT_PROFILE  # step 5.
					;;
				6)
					SETFLAGS1  # step 6.
					;;
				7)
					EMERGE_ATWORLD_A  # step 6.
					;;
				8)
					SYSTEMTIME  # step 7.
					;;
				9)
					KEYMAP_CONSOLEFONT  # step 8.
					;;
				10)
					FIRMWARE  # step 9.
					;;
				11)
					CP_BASHRC  # step 10.
					;;
				21)
					SWAPFILE  # step 1.
					MAKECONF  # step 2.
					CONF_LOCALES  # step 3.
					;;
				22)
					MAKECONF  # step 2.
					CONF_LOCALES  # step 3.
					;;
				23)
					PORTAGE  # step 4.
					ESELECT_PROFILE  # step 5.
					SETFLAGS1  # step 6.
					EMERGE_ATWORLD_A  # step 7.
					;;
				24)
					SYSTEMTIME  # step 8.
					KEYMAP_CONSOLEFONT  # step 9.
					;;
				25)
					FIRMWARE  # step 10.
					CP_BASHRC  # step 11.
					;;
				26)
					MAKECONF  # step 2.
					CONF_LOCALES  # step 3.
					PORTAGE  # step 4.
					ESELECT_PROFILE  # step 5
					SETFLAGS1  # step 6.
					EMERGE_ATWORLD_A  # step 7.
					SYSTEMTIME  # step 8.
					KEYMAP_CONSOLEFONT  # step 9.
					FIRMWARE  # step 10.
					CP_BASHRC  # step 11.
					;;
				27)
					SWAPFILE  # step 1.
					MAKECONF  # step 2.
					CONF_LOCALES  # step 3.
					PORTAGE  # step 4.
					ESELECT_PROFILE  # step 5.
					SETFLAGS1  # step 6.
					EMERGE_ATWORLD_A  # step 7.
					SYSTEMTIME  # step 8.
					KEYMAP_CONSOLEFONT  # step 9.
					FIRMWARE  # step 10.
					CP_BASHRC  # step 11.
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
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		}
		CORE () {
		NOTICE_START
			for f in gentoo_unattented-setup/src/CHROOT/CORE/*; do . $f && echo $f; done

		CHROOT_CORE_MENU () {
			CHROOT_CORE_CHOOSE() {
				printf "%s%s%s\n" "${BOLD}${GREEN}" "  .d8888b.  .d88888b. 8888888b. 8888888888 " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" " d88P  Y88bd88P" "Y88b888   Y88b888        " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" " 888    888888     888888    888888        " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" " 888       888     888888   d88P8888888    " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" " 888       888     8888888888P" 888        " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" " 888    888888     888888 T88b  888        " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" " Y88b  d88PY88b. .d88P888  T88b 888        " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "  *Y8888P*  *Y88888P* 888   T88b8888888888 " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "chroot core:" "${RESET}"

				printf  "1. step 1. SYSCONFIG_CORE\n"
				printf  "2. step 2. SYSFS\n"
				printf  "3. step 3. APPADMIN\n"
				printf  "4. step 4. SYSAPP\n"
				printf  "5. step 5. APP\n"
				printf  "6. step 6. SYSPROCESS\n"
				printf  "7. step 7. KERNEL\n"
				printf  "8. step 8. INITRAM\n"
				printf  "9. step 9. SYSBOOT\n"
				# printf "10. step 10. MODPROBE_CHROOT\n"
				printf "11. step 11. APPEMULATION\n"
				printf "12. step 12. AUDIO\n"
				# printf "13. step 13. GPU\n"
				printf "14. step 14. NETWORK\n"
				printf "\n"
				printf "\e[1m run multi step\e[0m\n"
				printf "21. steps 1. 2. 3. \n"
				printf "22. steps 2. 3. \n"
				printf "23. steps 4. 5. 6.\n"
				printf "24. steps 7. 8. \n"
				printf "25. steps 9-11 (modprobe not necessary here - skip 10) \n"
				printf "26. steps 12-14 (gpu driver deaktivated - skip 13.)\n"
				printf "27. steps 1-5\n"
				printf "28. steps 6-10 \n"
				printf "29. steps 11-14 (gpu driver deaktivated - skip 13.)\n"
				printf "30. ALL ... steps 1-14 (modprobe not nessecary here - skip 10., gpu driver deactivated - skip 13.)\n"

				printf  "0. Exit\n"

				read -p "Enter your choice: " choice
				printf "\n"

				case $choice in
				1)
					SYSCONFIG_CORE  # step 1.
					;;
				2)
					SYSFS  # step 2.
					;;
				3)
					APPADMIN  # step 3.
					;;
				4)
					SYSAPP  # step 4.
					;;
				5)
					APP  # step 5.
					;;
				6)
					SYSPROCESS  # step 6.
					;;
				7)
					KERNEL  # step 7.
					;;
				8)
					INITRAM  # step 8.
					;;
				9)
					SYSBOOT  # step 9.
					;;
				10)
					MODPROBE_CHROOT  # step 10.
					;;
				11)
					APPEMULATION  # step 11.
					;;
				12)
					AUDIO  # step 12.
					;;
				13)
					GPU  # step 13.
					;;
				14)
					NETWORK  # step 10.
					;;
				21)
					SYSCONFIG_CORE  # step 1.
					SYSFS  # step 2.
					APPADMIN  # step 3.
					;;
				22)
					SYSFS  # step 2.
					APPADMIN  # step 3.
					;;
				23)
					SYSAPP  # step 4.
					APP  # step 5.
					SYSPROCESS  # step 6.
					;;
				24)
					KERNEL  # step 7.
					INITRAM  # step 8.
					;;
				25)
					SYSBOOT  # step 9.
					#MODPROBE_CHROOT  # step 10.
					APPEMULATION  # step. 11
					;;
				26)
					AUDIO  # step 12.
					#GPU  # step 13.
					NETWORK  # step. 14.
					;;
				27)
					SYSCONFIG_CORE # step 1.
					SYSFS  # step 2.
					APPADMIN  # step 3.
					SYSAPP  # step 4.
					APP  # step 5
					;;
				28)
					SYSPROCESS  # step 6.
					KERNEL  # step 7.
					INITRAM  # step 8.
					SYSBOOT  # step 9.
					# MODPROBE_CHROOT  # step 10.
					;;
				29)
					APPEMULATION  # step 11.
					AUDIO  # step 12.
					# GPU  # step 13.
					NETWORK  # step 14.
					;;
				30)
					SYSCONFIG_CORE # step 1.
					SYSFS  # step 2.
					APPADMIN  # step 3.
					SYSAPP  # step 4.
					APP  # step 5
					SYSPROCESS  # step 6.
					KERNEL  # step 7.
					INITRAM  # step 8.
					SYSBOOT  # step 9.
					# MODPROBE_CHROOT  # step 10.
					APPEMULATION  # step 11.
					AUDIO  # step 12.
					# GPU  # step 13.
					NETWORK  # step 14.
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
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		}
		SCREENDSP () {  # note: replace visual header with "screen and desktop"
		NOTICE_START
			for f in gentoo_unattented-setup/src/CHROOT/SCREENDSP/*; do . $f && echo $f; done

			CHROOT_SCREENDSP_MENU () {
				CHROOT_SCREENDSP_CHOOSE() {
				printf "%s%s%s\n" "${BOLD}${GREEN}" " .--.  .--. .---.  .--.  .--. .-..-..---.  .--. .---.  " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" ": .--': .--': .; :: .--': .--': `: :: .  :: .--': .; : " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "`. `. : :   :   .': `;  : `;  : .` :: :: :`. `. :  _.' " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" " _`, :: :__ : :.`.: :__ : :__ : :. :: :; : _`, :: :    " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "`.__.'`.__.':_;:_;`.__.'`.__.':_;:_;:___.'`.__.':_;    " "${RESET}"

					printf "%s%s%s\n" "${BOLD}${GREEN}" "chroot screen and display" "${RESET}"

					printf  "1. step 1. WINDOWSYS\n"
					printf  "2. step 2. DESKTOP_ENV\n"

					printf "\n"
					printf "run multi step\n"
					printf "21. run steps 1 && 2\n"

					printf  "0. Exit\n"

					read -p "Enter your choice: " choice
					printf "\n"

					case $choice in
					1)
						WINDOWSYS  # step 1.
						;;
					2)
						DESKTOP_ENV  # step 2.
						;;
					21)
						WINDOWSYS  # step 1.
						DESKTOP_ENV  # step 2.
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
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		}
		USERAPP () {  # (!todo)
		NOTICE_START
			for f in gentoo_unattented-setup/src/CHROOT/USERAPP/*; do . $f && echo $f; done

				printf "%s%s%s\n" "${BOLD}${GREEN}" "     :::    ::: :::::::: :::::::::::::::::::     :::    ::::::::: ::::::::: " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "    :+:    :+::+:    :+::+:       :+:    :+:  :+: :+:  :+:    :+::+:    :+: " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "   +:+    +:++:+       +:+       +:+    +:+ +:+   +:+ +:+    +:++:+    +:+  " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "  +#+    +:++#++:++#+++#++:++#  +#++:++#: +#++:++#++:+#++:++#+ +#++:++#+    " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" " +#+    +#+       +#++#+       +#+    +#++#+     +#++#+       +#+           " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "#+#    #+##+#    #+##+#       #+#    #+##+#     #+##+#       #+#            " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "########  ######## #############    ######     ######       ###             " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "chroot userapp" "${RESET}"
			# GIT
			WEBBROWSER

		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		USERS () {
		NOTICE_START
			for f in gentoo_unattented-setup/src/CHROOT/USERS/*; do . $f && echo $f; done

				printf "%s%s%s\n" "${BOLD}${GREEN}" "_|    _|    _|_|_|  _|_|_|_|  _|_|_|      _|_|_|  " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "_|    _|  _|        _|        _|    _|  _|        " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "_|    _|    _|_|    _|_|_|    _|_|_|      _|_|    " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "_|    _|        _|  _|        _|    _|        _|  " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "  _|_|    _|_|_|    _|_|_|_|  _|    _|  _|_|_|    " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "chroot users" "${RESET}"

			ROOT
			ADMIN
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


			TIDY_STAGE3
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		CHROOT_MENU () {
			CHROOT_CHOOSE() {
				printf "%s%s%s\n" "${BOLD}${GREEN}" " CCCCC  HH   HH RRRRRR   OOOOO   OOOOO  TTTTTTT " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "CC    C HH   HH RR   RR OO   OO OO   OO   TTT   " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "CC      HHHHHHH RRRRRR  OO   OO OO   OO   TTT   " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "CC    C HH   HH RR  RR  OO   OO OO   OO   TTT   " "${RESET}"
				printf "%s%s%s\n" "${BOLD}${GREEN}" " CCCCC  HH   HH RR   RR  OOOO0   OOOO0    TTT   " "${RESET}"
				printf "\e[1m CHROOT Menu:\e[0m\n"
				printf "%s%s%s\n" "${BOLD}${GREEN}" "CHROOT Menu:" "${RESET}"

				printf "1. BASE steps menu\n"
				printf "2. CORE steps menu\n"
				printf "3. SCREENDSP steps menu\n"
				printf "4. USERAPP run as predefined in variables\n"
				printf "5. USERS run as predefined in variables\n"
				printf "6. FINISH run as predefined\n"
				printf "0. Exit\n"

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
	printf "%s%s%s\n" "${BOLD}${GREEN}" " / \ / \ / \ / \ / \ / \ / \ / \ / \ " "${RESET}"
	printf "%s%s%s\n" "${BOLD}${GREEN}" "( M | A | I | N |   | M | E | N | U )" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${GREEN}" " \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ " "${RESET}"

	printf "%s%s%s\n" "${BOLD}${GREEN}" "MAIN Menu:" "${RESET}"

	printf "1. PRE - no menu\n"
	printf "2. CHROOT - no menu\n"
	printf "3. PRE && CHROOT - no menu\n"
	printf "4. PRE menu\n"
	printf "5. CHROOT menu\n"
	printf "6. PRE menu && CHROOT menu\n"
	printf "0. Exit\n"

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
	printf "Running the semi unattended setup as configured in 10 seconds... Exit now to see options with -h or enter the menu when running the program with -m.\n"
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
