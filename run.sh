#!/usr/bin/env bash

                                                                                                                                                              
  ####  ###### #    # #####  ####   ####          #    # #    #   ##   ##### ##### ###### #    # ##### ###### #####         ####  ###### ##### #    # #####  
 #    # #      ##   #   #   #    # #    #         #    # ##   #  #  #    #     #   #      ##   #   #   #      #    #       #      #        #   #    # #    # 
 #      #####  # #  #   #   #    # #    #         #    # # #  # #    #   #     #   #####  # #  #   #   #####  #    # #####  ####  #####    #   #    # #    # 
 #  ### #      #  # #   #   #    # #    #         #    # #  # # ######   #     #   #      #  # #   #   #      #    #            # #        #   #    # #####  
 #    # #      #   ##   #   #    # #    #         #    # #   ## #    #   #     #   #      #   ##   #   #      #    #       #    # #        #   #    # #      
  ####  ###### #    #   #    ####   ####           ####  #    # #    #   #     #   ###### #    #   #   ###### #####         ####  ######   #    ####  #      
                                          #######                                                                                                            

# https://github.com/alphaaurigae/gentoo_unattented-setup


#DEBUG=1
#log() { ((DEBUG)) && echo "DEBUG: $*"; }

. func/func_main.sh
. func/func_menu.sh
. var/var_main.sh
. var/pre_variables.sh
#for f in src/PRE/*; do . $f && printf '%s\n' "$f"; done
for f in src/PRE/*; do . $f; done
for f in banner/* banner/*/* banner/*/*/*; do
	[ -f "$f" ] && . "$f" #&& printf '%s\n' "$f"
done

declare -A PRE_STEPS=(
	[1]="IPTABLES" # (IPTABLES experimental blueprint see src/PRE/IPTABLES.sh)
	[2]="INIT"
	[3]="PARTITIONING_MAIN"
	[4]="CRYPTSETUP"
	[5]="LVMSETUP"
	[6]="STAGE3"
	[7]="MNTFS"
	[8]="COPY_CONFIGS"
	[9]="MAKECONF"
)

declare -A PRE_GROUPS=(
	[21]="1,2"
	[22]="3,4"
	[23]="5,6"
	[24]="7,8,9"
	[25]="2,3,4,5,6,7,8,9"
	[26]="1,2,3,4,5,6,7,8,9"
)

run_all_pre() {
	for k in $(printf '%s\n' "${!PRE_STEPS[@]}" | sort -n); do
		PRE_run_step PRE "$k" "${PRE_STEPS[$k]}"
	done
}

PRE_MENU() {
	PRE_select_steps PRE_STEPS
}

CHROOT_MENU() {

	INNER_SCRIPT=$(
		cat <<-'INNERSCRIPT'

			#!/bin/bash

			# +++++++++++++++++++++++++++++++++++++++++++++++++++
			# Source basic func
			. /gentoo_unattented-setup/func/func_main.sh
			. /gentoo_unattented-setup/func/func_menu.sh
			. /gentoo_unattented-setup/func/func_chroot_main.sh
			# Source chroot variables
			. /gentoo_unattented-setup/var/var_main.sh
			. /gentoo_unattented-setup/var/chroot_variables.sh
			# Source setups from src
			for f in /gentoo_unattented-setup/src/CHROOT/*/*; do
			  [ -f "$f" ] && . "$f" && printf '%s\n' "$f"
			done
			. /gentoo_unattented-setup/banner/CHROOT/BANNER_CHROOT_STEPS.sh
			for f in /gentoo_unattented-setup/banner/CHROOT/*/*; do
			  [ -f "$f" ] && . "$f" && printf '%s\n' "$f"
			done
			# +++++++++++++++++++++++++++++++++++++++++++++++++++


			#set -euo pipefail
			#DEBUG=1
			#  log() { ((DEBUG)) && echo "CHROOT DEBUG: $*"; }

			declare -A CHROOT_STEPS=(
				[1]="CHROOT_BASE"
				[2]="CHROOT_CORE"
				[3]="CHROOT_NETWORK"
				[4]="CHROOT_SCREENDSP"
				[5]="CHROOT_USERAPP"
				[6]="CHROOT_USERS"
				[7]="CHROOT_FINISH"
			)

			declare -A CHROOT_BASE=(
				[1]="SWAPFILE"
				[2]="EMERGE_WORLDINIT"
				[3]="CONF_LOCALES"
				[4]="PORTAGE"
				[5]="ESELECT_PROFILE"
				[6]="SETFLAGS1"
				[7]="EMERGE_WORLDINIT"
				[8]="SYSTEMTIME"
				[9]="KEYMAP_CONSOLEFONT"
				[10]="FIRMWARE"
				#[11]="CP_BASHRC"
			)

			declare -A CHROOT_BASE_GROUPS=(
				[21]="1,2,3"
				[22]="4,5"
				[23]="6,7"
				[24]="8,9"
				[25]="10,11"
				[26]="2,3,4,5,6,7,8,9,10"
				[27]="1,2,3,4,5,6,7,8,9,10,11"
			)

			declare -A CHROOT_CORE=(
				[1]="SYSCONFIG_CORE"
				[2]="SYSFS"
				[3]="APPADMIN"
				[4]="SYSAPP"
				[5]="APP"
				[6]="SYSPROCESS"
				[7]="KERNEL"
				[8]="INITRAM"
				[9]="SYSBOOT"
				[11]="APPEMULATION"
				[12]="AUDIO"
				[14]="NETWORK"
			)

			declare -A CHROOT_CORE_GROUPS=(
				[21]="1,2,3"
				[22]="2,3"
				[23]="4,5,6"
				[24]="7,8,9"
				[25]="11,12,14"
				[26]="2,3,4,5,6,7,8,9,11,12,14"
				[27]="1,2,3,4,5,6,7,8,9,11,12,14"
			)

			declare -A CHROOT_NETWORK=(
				[1]="NETWORK_MAIN"
				[2]="NETWORK_FIREWALL"
			)

			declare -A CHROOT_NETWORK_GROUPS=(
				[21]="1,2"
			)

			declare -A CHROOT_SCREENDSP=(
				[1]="WINDOWSYS"
				[2]="DESKTOP"
			)

			declare -A CHROOT_SCREENDSP_GROUPS=(
				[21]="1,2"
			)

			declare -A CHROOT_USERAPP=(
				[1]="WEBBROWSER"
			)


			declare -A CHROOT_USERS=(
				[1]="ROOT"
				[2]="ADMIN"
			)

			declare -A CHROOT_USERS_GROUPS=(
				[21]="1,2"
			)


			declare -A CHROOT_FINISH=(
				[1]="FINISH_CHROOT"
			)

			# run_step func/func_menu.sh

			# run_multistep_group func/func_menu.sh
			# menu select step in func/func_menu.sh


			#---------------------


			run_all_chroot() {
			    for k in $(printf '%s\n' "${!CHROOT_STEPS[@]}" | sort -n); do
				run_step CHROOT "$k" "${CHROOT_STEPS[$k]}"
			    done
			}

			CHROOT_MENU() {
			    CHROOT_select_steps CHROOT_STEPS
			}

			CHROOT_MENU

		INNERSCRIPT
	)
	CP_CHROOT
	CHROOT_INNER

}

CHROOT_ALL() { # DUMMY FUNCTIONS - SOURCING COMMENTED

	INNER_SCRIPT=$(
		cat <<-'INNERSCRIPT'
			#!/bin/bash

			# DUMMY FUNCTIONS FOR TESTING

			# +++++++++++++++++++++++++++++++++++++++++++++++++++
			# Source basic func
			. /gentoo_unattented-setup/func/func_main.sh
			. /gentoo_unattented-setup/func/func_menu.sh
			. /gentoo_unattented-setup/func/func_chroot_main.sh
			# Source chroot variables
			. /gentoo_unattented-setup/var/var_main.sh
			. /gentoo_unattented-setup/var/chroot_variables.sh
			# Source setups from src

			# DUMMY FUNCTIONS FOR TESTING
			# Commented for the dummy test functions below
			for f in /gentoo_unattented-setup/src/CHROOT/*/*; do
			  [ -f "$f" ] && . "$f" && printf '%s\n' "$f"
			done
			. /gentoo_unattented-setup/banner/CHROOT/BANNER_CHROOT_STEPS.sh
			for f in /gentoo_unattented-setup/banner/CHROOT/*/*; do
			  [ -f "$f" ] && . "$f" && printf '%s\n' "$f"
			done
			# +++++++++++++++++++++++++++++++++++++++++++++++++++

			#set -euo pipefail
			#DEBUG=1
			#  log() { ((DEBUG)) && echo "CHROOT DEBUG: $*"; }



			declare -A CHROOT_STEPS=(
			    [1]="CHROOT_BASE"
			    [2]="CHROOT_CORE"
			    [3]="CHROOT_SCREENDSP"
			    [4]="CHROOT_USERAPP"
			    [5]="CHROOT_USERS"
			    [6]="CHROOT_FINISH"
			)

			declare -A CHROOT_BASE=(
			    [1]="SWAPFILE"
			    [2]="EMERGE_ATWORLD"
			    [3]="CONF_LOCALES"
			    [4]="PORTAGE"
			    [5]="ESELECT_PROFILE"
			    [6]="SETFLAGS1"
			    [7]="EMERGE_ATWORLD"
			    [8]="SYSTEMTIME"
			    [9]="KEYMAP_CONSOLEFONT"
			    [10]="FIRMWARE"
			    #[11]="CP_BASHRC"
			)

			declare -A CHROOT_CORE=(
			    [1]="SYSCONFIG_CORE"
			    [2]="SYSFS"
			    [3]="APPADMIN"
			    [4]="SYSAPP"
			    [5]="APP"
			    [6]="SYSPROCESS"
			    [7]="KERNEL"
			    [8]="INITRAM"
			    [9]="SYSBOOT"
			    [11]="APPEMULATION"
			    [12]="AUDIO"
			    [14]="NETWORK"
			)

			declare -A CHROOT_SCREENDSP=(
			    [1]="WINDOWSYS"
			    [2]="DESKTOP"
			)

			declare -A CHROOT_USERAPP=(
			    [1]="WEBBROWSER"
			)

			declare -A CHROOT_USERS=(
			    [1]="ROOT"
			    [2]="ADMIN"
			)

			declare -A CHROOT_FINISH=(
			    [1]="TIDY_STAGE3"
			)

			run_all_chroot() {
			    for k in $(printf '%s\n' "${!CHROOT_STEPS[@]}" | sort -n); do
				group_name="${CHROOT_STEPS[$k]}"
				declare -n step_ref="$group_name"
				for s in $(printf '%s\n' "${!step_ref[@]}" | sort -n); do
				    CHROOT_run_step "$group_name" "$s" "${step_ref[$s]}"
				done
			    done
			}

			run_all_chroot

		INNERSCRIPT
	)
	CP_CHROOT
	CHROOT_INNER

}

if [[ "${1:-}" == "-a" ]]; then
	printf "%s%s%s\n" "${BOLD}${GREEN}" "PRE RUNALL starting in 15 seconds - abort now to stop!" "${RESET}"
	sleep 15
	run_all_pre
	printf "%s%s%s\n" "${BOLD}${GREEN}" "CHROOT RUNALL starting in 15 seconds - abort now to stop!" "${RESET}"
	sleep 15
	CHROOT_ALL
elif [[ "${1:-}" == "-m" ]]; then
	BANNER_SETUP_MAIN
	printf "%s\n" "----------------------------------------------------------------------------------"
	printf "%s%s%s\n" "${BOLD}${WHITE}" "Select:" "${RESET}"
	printf "%s\n" "[1] --> PRE (Preparation of chroot (Format disks, load stage3 etc ...)"
	printf "%s\n" "[2] --> CHROOT (Enter chroot)"
	read -rp "> " stage_choice
	case $stage_choice in
		1) PRE_MENU ;;
		2) CHROOT_MENU ;;
		*) echo "Invalid option" ;;
	esac
else
	BANNER_GENTOOUNATTENDED_TOPLEVEL
	printf "%s\n" "----------------------------------------------------------------------------------"
	printf "%s%s%s\n" "${BOLD}${YELLOW}" "Usage: ./run.sh ARG" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${YELLOW}" "ARG -a run the entire setup [PRE_NOMENU] & [CHROOT_NOMENU]... CHECK var/*" "${RESET}"
	printf "%s%s%s\n" "${BOLD}${YELLOW}" "ARG -m enter menu" "${RESET}"
	printf "\n"
	printf "Doc in doc/ & /README.md \n"
	printf "Variables var/*\n"
	printf "Works by default on virtualbox KVM. \n"
	printf "\n"

	exit
fi
