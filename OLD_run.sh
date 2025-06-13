#!/bin/bash

#  d888b  d88888b d8b   db d888888b  .d88b.   .d88b.          db    db d8b   db  .d8b.  d888888b d888888b d88888b d8b   db d888888b d88888b d8888b.        .d8888. d88888b d888888b db    db d8888b. 
# 88' Y8b 88'     888o  88 `~~88~~' .8P  Y8. .8P  Y8.         88    88 888o  88 d8' `8b `~~88~~' `~~88~~' 88'     888o  88 `~~88~~' 88'     88  `8D        88'  YP 88'     `~~88~~' 88    88 88  `8D 
# 88      88ooooo 88V8o 88    88    88    88 88    88         88    88 88V8o 88 88ooo88    88       88    88ooooo 88V8o 88    88    88ooooo 88   88        `8bo.   88ooooo    88    88    88 88oodD' 
# 88  ooo 88~~~~~ 88 V8o88    88    88    88 88    88         88    88 88 V8o88 88~~~88    88       88    88~~~~~ 88 V8o88    88    88~~~~~ 88   88 C8888D   `Y8b. 88~~~~~    88    88    88 88~~~   
# 88. ~8~ 88.     88  V888    88    `8b  d8' `8b  d8'         88b  d88 88  V888 88   88    88       88    88.     88  V888    88    88.     88  .8D        db   8D 88.        88    88b  d88 88      
#  Y888P  Y88888P VP   V8P    YP     `Y88P'   `Y88P'  C88888D ~Y8888P' VP   V8P YP   YP    YP       YP    Y88888P VP   V8P    YP    Y88888P Y8888D'        `8888Y' Y88888P    YP    ~Y8888P' 88     
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# STATUS Readme.md
# https://github.com/alphaaurigae/gentoo_unattended_modular-setup


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# VARIABLE && FUNCTONS
## PRE
. func/func_main.sh
. var/var_main.sh
. var/pre_variables.sh
for f in src/PRE/*; do . $f && printf '%s\n' "$f"; done
## CHROOT
. src/CHROOT/DEBUG.sh
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


PRE_NOMENU () {
NOTICE_START
	PRE_RUNALL () {
		PRE_BANNER_MAIN
		INIT # [1]
		PARTITIONING_MAIN # [2]
		CRYPTSETUP # [3]
		LVMSETUP # [4]
		STAGE3 # [5]
		MNTFS # [6]
		COPY_CONFIGS # [7]
		MAKECONF # [8]
	}
	PRE_RUNALL
}

PRE_MENU () {
NOTICE_START

	PRE_CHOOSE() {
		PRE_BANNER_MAIN
		printf "%s\n" "----------------------------------------------------------------------------------"
		printf "%s%s%s\n" "${BOLD}${GREEN}" "Select e.g 1:" "${RESET}"
		printf "%s\n" "----------------------------------------------------------------------------------"
		printf "Single:\n"
		printf "[1] --> INIT (src/PRE/INIT.sh)\n"
		printf "[2] --> PARTITIONING_MAIN (src/PRE/PARTITIONING_MAIN.sh)\n"
		printf "[3] --> CRYPTSETUP (src/PRE/CRYPTSETUP.sh)\n"
		printf "[4] --> LVMSETUP (src/PRE/LVMSETUP.sh)\n"
		printf "[5] --> STAGE3 (src/PRE/STAGE3.sh)\n"
		printf "[6] --> MNTFS (src/PRE/MNTFS.sh)\n"
		printf "[7] --> COPY_CONFIGS (src/PRE/COPY_CONFIGS.sh)\n"
		printf "[8] --> MAKECONF (src/PRE/MAKECONF.sh)\n"
		printf "%s\n" "----------------------------------------------------------------------------------"
		printf "Multi:\n"
		printf "[21] --> [1] & [2] INIT && PARTITIONING\n"
		printf "[22] --> [3] & [4] CRYPTSETUP;LVMSETUP\n"
		printf "[23] --> [5]-[8] STAGE3;MNTFS;COPY_CONFIGS; MAKECONF\n"
		printf "[24] --> [1]-[8] INIT;PARTITIONING_MAIN;CRYPTSETUP;LVMSETUP;STAGE3;MNTFS;COPY_CONFIGS; MAKECONF\n"
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
			8)
				printf "MAKECONF\n"
				MAKECONF
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
				printf "[5]-[7] STAGE3;MNTFS;COPY_CONFIGS; MAKECONF\n"
				STAGE3
				MNTFS
				COPY_CONFIGS
				MAKECONF
				;;
			24)
				printf "[1]-[7] INIT;PARTITIONING;CRYPTSETUP;LVMSETUP;STAGE3;MNTFS;COPY_CONFIGS; MAKECONF\n"
				INIT
				PARTITIONING_MAIN
				CRYPTSETUP
				LVMSETUP
				STAGE3
				MNTFS
				COPY_CONFIGS
				MAKECONF
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
	PRE_CHOOSE

NOTICE_END
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CHROOT_NOMENU () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment
NOTICE_START
	CHROOT_RUNALL () {
		INNER_SCRIPT=$(cat <<- 'INNERSCRIPT'
		#!/bin/bash

		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		# Source basic func
		. $CHROOTX/gentoo_unattented-setup/func/func_main.sh
		. $CHROOTX/gentoo_unattented-setup/func/func_chroot_main.sh
		# Source chroot variables
		. $CHROOTX/gentoo_unattented-setup/var/var_main.sh
		. $CHROOTX/gentoo_unattented-setup/var/chroot_variables.sh
		# Source setups from src
		# Source setup from src
		for f in "$CHROOTX"/gentoo_unattented-setup/src/CHROOT/*/*; do
		  [ -f "$f" ] && . "$f" && printf '%s\n' "$f"
		done
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		BASE () {  # src/CHROOT/BASE/*
		NOTICE_START

			BANNER_CHROOT_BASE_MAIN
			printf "%s\n" "----------------------------------------------------------------------------------"
			SWAPFILE  # [1]
			EMERGE_ATWORLD  # [2]
			CONF_LOCALES  # [3]
			PORTAGE  # [4]
			## PLACEHOLDER for later use (maybe) ##EMERGE_SYNC
			ESELECT_PROFILE  # [5]
			## PLACEHOLDER for later use (maybe) ##SETFLAGS1
			EMERGE_ATWORLD  # [7]
			## PLACEHOLDER for later use (maybe) ##MISC1_CHROOT
			## PLACEHOLDER for later use (maybe) ##RELOADING_SYS
			SYSTEMTIME  # [8]
			KEYMAP_CONSOLEFONT  # [9]
			FIRMWARE  # [10]
			CP_BASHRC  # [11]
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		CORE () {  # src/CHROOT/CORE/*
		NOTICE_START

			BANNER_CHROOT_CORE_MAIN
			printf "%s\n" "----------------------------------------------------------------------------------"
			SYSCONFIG_CORE  # [1]
			SYSFS  # [2]
			APPADMIN  # [3]
			SYSAPP  # [4]
			APP  # [5]
			SYSPROCESS  # [6]
			KERNEL  # [7]
			INITRAM  # [8]
			SYSBOOT  # [9]
			## MODPROBE_CHROOT  # [10]
			APPEMULATION  # [11]
			AUDIO  # [12]
			## GPU  # [13]
			NETWORK  # [14]
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		SCREENDSP () {  # src/CHROOT/SCREENDSP
		NOTICE_START
			BANNER_CHROOT_SCREENDSP_MAIN
			printf "%s\n" "----------------------------------------------------------------------------------"
			WINDOWSYS # [1]
			DESKTOP_ENV # [2]
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		USERAPP () { # src/CHROOT/USERAPP/*
		NOTICE_START
			BANNER_CHROOT_USERAPP_MAIN
			printf "%s\n" "----------------------------------------------------------------------------------"
			# GIT
			WEBBROWSER
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		USERS () {  # src/CHROOT/USERS/*
		NOTICE_START
			BANNER_CHROOT_USERS_MAIN
			printf "%s\n" "----------------------------------------------------------------------------------"
			ROOT  # [1]
			ADMIN  # [2]
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		FINISH () {  # src/CHROOT/FINISH/*
		NOTICE_START
			BANNER_CHROOT_FINISH_MAIN
			printf "%s\n" "----------------------------------------------------------------------------------"
			TIDY_STAGE3  # [1]
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		## (RUN ENTIRE SCRIPT) (!changeme)
		CHROOT_NOMENU () {  # src/CHROOT/*
			BANNER_CHROOT_MAIN
			printf "%s\n" "----------------------------------------------------------------------------------"
			BASE  # [1]
			CORE  # [2]
			SCREENDSP  # [3]
			USERAPP  # [4]
			USERS  # [5]
			FINISH  # [6]
		}
		CHROOT_NOMENU
		NOTICE_END
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		########## CHROOT END ##########
		INNERSCRIPT
		)
		# func/func_main.sh
		CP_CHROOT
		CHROOT_INNER
	}
	CHROOT_RUNALL
NOTICE_END
}

CHROOT_MENU () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Entering_the_new_environment
NOTICE_START
	CHROOT_CHOOSE () {
		INNER_SCRIPT=$(cat <<- 'INNERSCRIPT'
		#!/bin/bash

		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		# Source basic func
		. $CHROOTX/gentoo_unattented-setup/func/func_main.sh
		. $CHROOTX/gentoo_unattented-setup/func/func_chroot_main.sh
		# Source chroot variables
		. $CHROOTX/gentoo_unattented-setup/var/var_main.sh
		. $CHROOTX/gentoo_unattented-setup/var/chroot_variables.sh
		# Source setups from src
		SOURCE_CHROOT
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		BASE () {  # src/CHROOT/BASE/*
		NOTICE_START

			CHROOT_BASE_MENU () {
				CHROOT_BASE_CHOOSE() {
					
					BANNER_CHROOT_BASE_MAIN
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf "%s%s%s\n" "${BOLD}${GREEN}" "Select e.g 1:" "${RESET}"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf "Single\n"
					printf "[1] --> SWAPFILE\n"
					printf "[2] --> EMERGE_ATWORLD (emerge world for the make.conf created during pre setup)\n"
					printf "[3] --> CONF_LOCALES\n"
					printf "[4] --> PORTAGE\n"
					## PLACEHOLDER for later use (maybe) EMERGE_SYNC  # run EMERGE_SYNC
					printf "[5] --> ESELECT_PROFILE\n"
					printf "[6] (just a placeholder NOT REQUIRED) --> SETFLAGS1\n"
					printf "[7] --> EMERGE_ATWORLD\n" # temporary added rust emere as bugfix for srvg lib error as suggested by sam_ #gentoo librachat irc - see https://bugs.gentoo.org/907492
					## PLACEHOLDER for later integration (maybe) #MISC1_CHROOT  # run MISC1_CHROOT  # PLACEHOLDER
					## PLACEHOLDER for later integration (maybe) RELOADING_SYS  # run RELOADING_SYS  # PLACEHOLDER
					printf "[8] --> SYSTEMTIME\n"
					printf "[9] --> KEYMAP_CONSOLEFONT\n"
					printf "[10] --> FIRMWARE\n"
					printf "[11] --> CP_BASHRC\n"
					printf "%s\n" "----------------------------------------------------------------------------------"
					printf "Multi\n"
					printf "[21] --> [1]-[3] create swap for setup; conf locales to run portage in next step - prints emerge at world which is neede dfor make.conf\n"
					printf "[22] --> [3] to run portage in next step - prints emerge at world which is neede dfor make.conf\n"
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
						SWAPFILE  # [1] #
						;;
					2)
						EMERGE_ATWORLD  # [2] 
						;;
					3)
						CONF_LOCALES  # [3] #
						;;
					4)
						PORTAGE  # [4]
						;;
					5)
						ESELECT_PROFILE  # [5]
						;;
					6)
						SETFLAGS1  # [6] PLACEHOLDER
						;;
					7)
						EMERGE_ATWORLD  # [7]
						;;
					8)
						SYSTEMTIME  # [8]
						;;
					9)
						KEYMAP_CONSOLEFONT  # [9]
						;;
					10)
						FIRMWARE  # [10]
						;;
					11)
						CP_BASHRC  # [11]
						;;
					21)
						SWAPFILE  # [1]
						EMERGE_ATWORLD
						CONF_LOCALES  # [3]
						;;
					22)
						EMERGE_ATWORLD
						CONF_LOCALES  # [3]
						;;
					23)
						PORTAGE  # [4]
						ESELECT_PROFILE  # [5]
						SETFLAGS1  # [6]
						EMERGE_ATWORLD  # [7]
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
						EMERGE_ATWORLD  # [2]
						CONF_LOCALES  # [3]
						PORTAGE  # [4]
						ESELECT_PROFILE  # [5]
						SETFLAGS1  # [6]
						EMERGE_ATWORLD  # [7]
						SYSTEMTIME  # [8]
						KEYMAP_CONSOLEFONT  # [9]
						FIRMWARE  # [10]
						CP_BASHRC  # [11]
						;;
					27)
						SWAPFILE  # [1]
						EMERGE_ATWORLD  # [2]
						CONF_LOCALES  # [3]
						PORTAGE  # [4]
						ESELECT_PROFILE  # [5]
						SETFLAGS1  # [6]
						EMERGE_ATWORLD  # [7]
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
		CORE () {  # src/CHROOT/CORE/*
		NOTICE_START

			CHROOT_CORE_MENU () {
				CHROOT_CORE_CHOOSE() {

					BANNER_CHROOT_CORE_MAIN
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
						SYSCONFIG_CORE  # [1]
						;;
					2)
						SYSFS  # [2]
						;;
					3)
						APPADMIN  # [3]
						;;
					4)
						SYSAPP  # [4]
						;;
					5)
						APP  # [5]
						;;
					6)
						SYSPROCESS  # [6]
						;;
					7)
						KERNEL  # [7]
						;;
					8)
						INITRAM  # [8]
						;;
					9)
						SYSBOOT  # [9]
						;;
					10)
						MODPROBE_CHROOT  # [10]
						;;
					11)
						APPEMULATION  # [11]
						;;
					12)
						AUDIO  # [12]
						;;
					13)
						GPU  # [13]
						;;
					14)
						NETWORK  # [14]
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
		SCREENDSP () {  # src/CHROOT/SCREENDSP/*
		NOTICE_START
			CHROOT_SCREENDSP_MENU () {
				CHROOT_SCREENDSP_CHOOSE() {
					BANNER_CHROOT_SCREENDSP_MAIN
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
						WINDOWSYS  # [1]
						;;
					2)
						DESKTOP_ENV  # [2]
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
		USERAPP () {  # src/CHROOT/USERAPP/*
		NOTICE_START
			BANNER_CHROOT_USERAPP_MAIN
			printf "%s\n" "----------------------------------------------------------------------------------"
			# GIT
			WEBBROWSER
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		USERS () {  # src/CHROOT/USERS/*
		NOTICE_START
			BANNER_CHROOT_USERS_MAIN
			printf "%s\n" "----------------------------------------------------------------------------------"
			ROOT
			ADMIN
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		FINISH () {  # src/CHROOT/FINISH/*
		NOTICE_START
			BANNER_CHROOT_FINISH_MAIN
			printf "%s\n" "----------------------------------------------------------------------------------"
			TIDY_STAGE3
		NOTICE_END
		}
		# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		CHROOT_MENU () {
			CHROOT_CHOOSE() {
				BANNER_CHROOT_MAIN
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
		########## CHROOT END ##########
		INNERSCRIPT
		)
		# func/func_main.sh
		CP_CHROOT
		CHROOT_INNER
	}
	CHROOT_CHOOSE
NOTICE_END
}

MAIN_MENU() {
	BANNER_SETUP_MAIN
	printf "%s\n" "----------------------------------------------------------------------------------"
	printf "%s%s%s\n" "${BOLD}${GREEN}" "Select e.g: 1" "${RESET}"
	printf "[1] --> (DISABLED) PRE - NO menu\n"
	printf "[2] --> (DISABLED) CHROOT - NO menu\n"
	printf "[3] --> (DISABLED) PRE && CHROOT - NO menu\n"
	printf "[4] --> PRE - menu\n"
	printf "[5] --> CHROOT - menu\n"
	printf "[0] --> Exit\n"

	read -p "Enter your choice: " choice
	printf "\n"

	case $choice in
		1)
			printf "Running the semi unattended PRE setup as configured in 10 seconds... Exit now to see options with -h or enter the menu when running the program with -m.\n"
			printf "(default PRE asks for crypt password and disk wipe confirmation)"
			printf "RUN ./run.sh -m, AUTO DISABLED"
			sleep 10
			#PRE_NOMENU
			;;
		2)
			printf "Running the semi unattended CHROOT setup as configured in 10 seconds... Exit now to see options with -h or enter the menu when running the program with -m.\n"
			printf "(Default CHROOT asks for kernel config menuconfig confirmation or edit and GPG password)"
			printf "RUN ./run.sh -m, AUTO DISABLED"
			sleep 10
			#CHROOT_NOMENU
			;;
		3)
			PRE_MENU
			;;
		4)
			CHROOT_MENU
			;;
		0)
			printf "Exit...\n"
			exit
			;;
		*)
			printf "Invalid choice. Please try again.\n"
			;;
	esac

	printf "\n"
	MAIN_MENU
}

if [[ "$1" == "-a" ]]; then
	BANNER_GENTOOUNATTENDED_TOPLEVEL
	printf "%s\n" "----------------------------------------------------------------------------------"
	printf "Running the semi unattended setup as configured in 10 seconds... \n"
	printf "Exit now to see options with -h or enter the menu when running the program with -m.\n"
	printf "(Default PRE will ask for crypt password and disk wipe confirmation)"
	printf "[1] --> (DISABLED) PRE && CHROOT - NO menu\n"
	printf "[0] --> Exit\n"
	read -p "Enter your choice: " choice
	printf "\n"

	case $choice in
	1)
		#PRE_NOMENU
		#CHROOT_NOMENU
		echo "test"
		;;
	0)
		printf "Exit...\n"
		exit
		;;
	*)
		printf "Invalid choice. Please try again.\n"
		;;

elif [[ "$1" == "-m" ]]; then
	MAIN_MENU
else
	BANNER_GENTOOUNATTENDED_TOPLEVEL
	printf "%s\n" "----------------------------------------------------------------------------------"
	printf "%s%s%s\n" "${BOLD}${YELLOW}" "Usage: ./run.sh ARG" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${YELLOW}" "ARG -a run the entire setup [PRE_NOMENU] & [CHROOT_NOMENU]... CHECK var/*" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${YELLOW}" "ARG -m enters menu" "${RESET}"
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





