#!/bin/bash
		# CHROOT START >>> alphaaurigae/gentoo_unattented-setup | https://github.com/alphaaurigae/gentoo_unattented-setup

		[ !PASTE_DEF_CONFIG: VARIABLES 2 "repo_path: configs/2_variables_chroot" - copy paste your config here ]
		############################################################################################################################################################################################################################################################################################################################################################################################
		# MISC FUNCTIONS
		EMERGE_USERAPP_DEF () {
			echo "emerging $APPAPP_EMERGE "
			emerge $APPAPP_EMERGE
		}
		EMERGE_USERAPP_RD1 () {
			echo "emerging ${!APPAPP_EMERGE}"
			emerge ${!APPAPP_EMERGE}  # (note!: for redirected var.)
		}
		NOTICE_PLACEHOLDER () {
			echo "nothing todo here"
		}
		ENVUD () {
			env-update
			source /etc/profile
		}
		ACC_KEYWORDS_USERAPP () {
			sed -ie "s#$APPAPP_EMERGE ~amd64##g" /etc/portage/package.accept_keywords
			echo "$APPAPP_EMERGE ~amd64" >> /etc/portage/package.accept_keywords
		}

		APPAPP_NAME_SIMPLE="$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}')"  # get the name of the app (!NOTE: fetch EMERGE_USERAPP_DEF --> remove slash --> show second coloumn = name
		PORTAGE_USE_DIR="/etc/portage/package.use"

		PACKAGE_USE () {
				SETVAR_PACKAGE_USE () {
					x=$(echo 'USEFLAGS_')
					x+=$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}' | sed -e 's/-/_/g'  | sed -e 's/://g' | tr [:lower:] [:upper:])
					combined=${!x}
					echo "${!x}"
					o=$(echo $PORTAGE_USE_DIR)
					o+=$(echo $APPAPP_NAME_SIMPLE)

					m="$( printf '%s\n' "$APPAPP_EMERGE " )"
					m+="$(echo " ")"
					m+=${!x}
				}
				SETVAR_PACKAGE_USE
				printf '%s\n' "$m"  > /etc/portage/package.use/$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}')  #  variable only works here and not if forwarded from above.
		}
		AUTOSTART_DEFAULT_OPENRC () {
			rc-update add $AUTOSTART_NAME_OPENRC default
		}
		AUTOSTART_DEFAULT_SYSTEMD () { (!todo)
			systemctl enable dbus.service 
			systemctl start dbus.service
			systemctl daemon-reload
		}
		AUTOSTART_BOOT_OPENRC () {
			rc-service $AUTOSTART_NAME_OPENRC start
			rc-update add $AUTOSTART_NAME_OPENRC boot
			rc-service $AUTOSTART_NAME_OPENRC restart
		}
		AUTOSTART_BOOT_SYSTEMD () {
			NOTICE_PLACEHOLDER
			systemctl enable $AUTOSTART_NAME_SYSTEMD
			# systemctl enable $AUTOSTART_BOOT_SYSTEMD@.service # https://www.freedesktop.org/software/systemd/man/systemd-cryptsetup@.service.html
		}
		LICENSE_SET () {
			mkdir -p /etc/portage/package.license
			#sed -ie "/$APPAPP_EMERGE @BINARY-REDISTRIBUTABLE/d" /etc/portage/package.license/$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}')
			echo "$APPAPP_EMERGE @BINARY-REDISTRIBUTABLE" > /etc/portage/package.license/$(echo $APPAPP_EMERGE | sed -e "s#/# #g" | awk  '{print $2}')
		}
		EMERGE_ATWORLD_A () {
			emerge @world  # this is to update after setting the use flag
		}
		EMERGE_ATWORLD_B () {
			emerge --changed-use --deep @world
			emerge --update --deep --newuse @world
		}
		# END MISC FUNCTIONS

		BASE () {
			SWAPFILE () {
				DEBUG_SWAPFILE () {
					swapon -s
					ls -lh $SWAPFD/$SWAPFILE_$SWAPSIZE
				}
				CREATE_FILE () {
					mkdir -p $SWAPFD
					fallocate -l $SWAPSIZE $SWAPFD/$SWAPFILE_$SWAPSIZE
					chmod 600 $SWAPFD/$SWAPFILE_$SWAPSIZE
					mkswap $SWAPFD/$SWAPFILE_$SWAPSIZE
				}
				CREATE_SWAP () {
					swapon  $SWAPFD/$SWAPFILE_$SWAPSIZE
				}
				PERMANENT () {
					echo "$SWAPFD/$SWAPFILE_SWAPSIZE none swap sw 0 0" >> /etc/fstab
					cat /etc/fstab
				}
				CREATE_FILE
				# DEBUG_SWAPFILE
				CREATE_SWAP
				# DEBUG_SWAPFILE
				# PERMANENT
			}
			MAKECONF () {  # /etc/portage/make.conf # https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/USE
				MAKECONF_VARIABLES () {
					cat << EOF > /etc/portage/make.conf
					CC="$PRESET_CC"
					ACCEPT_KEYWORDS="$PRESET_ACCEPT_KEYWORDS"
					CHOST="$PRESET_CHOST_ARCH-$PRESET_CHOST_VENDOR-$PRESET_CHOST_OS-$PRESET_CHOST_LIBC"
					
					# (!NOTE) (!todo - not sure if this is "perfect" yet.. anyways, "it works". 
					CPU_FLAGS_X86="$PRESET_CPU_FLAGS_X86" # workaround to insert sse3 and sse4a - intentianal, no idea if requ - testing…
					# CPU_FLAGS_X86="$(lscpu | grep Flags: | sed -e 's/Flags:               //g')" # lscpu hides sse3 and sse4a which are shown in cpuid.
					CFLAGS="$PRESET_CFLAGS"
					CXXFLAGS="${PRESET_CFLAGS}"
					FCFLAGS="${PRESET_CFLAGS}"
					FFLAGS="${PRESET_CFLAGS}"
					MAKEOPTS="$PRESET_MAKE"
					EMERGE_DEFAULT_OPTS="$PRESET_EMERGE_DEFAULT_OPTS"
					INPUT_DEVICES="$PRESET_INPUTEVICE"
					VIDEO_CARDS="$PRESET_VIDEODRIVER"
					ACCEPT_LICENSE="$PRESET_LICENCES"
					FEATURES="$PRESET_FEATURES"
					USE="$PRESET_USEFLAG"
					GENTOO_MIRRORS="$PRESET_GENTOMIRRORS"
					PORTDIR="$PRESET_PORTDIR"
					DISTDIR="$PRESET_DISTDIR"
					PKGDIR="$PRESET_PKGDIR"
					PORTAGE_TMPDIR="$PRESET_PORTAGE_TMPDIR"
					PORTAGE_LOGDIR="$PRESET_PORTAGE_LOGDIR"
					PORTAGE_ELOG_CLASSES="$PRESET_PORTAGE_ELOG_CLASSES"
					PORTAGE_ELOG_SYSTEM="$PRESET_PORTAGE_ELOG_SYSTEM"
					LINGUAS="$PRESET_LINGUAS"
					L10N="$PRESET_L10N"  # IETF language tags
					LC_MESSAGES="$PRESET_LC_MESSAGES"
					# CURL_SSL="$PRESET_CURL_SSL"
EOF
				}
				MAKECONF_VARIABLES
				EMERGE_ATWORLD_B
			}
			ESELECT_PROFILE () {
				eselect profile set $ESELECT_PROFILE
			}
			SETFLAGS1 () {  # set custom flags (!NOTE: disabled by default) (!NOTE; was systemd specific, systemd not compete yet 05.11.2020)
				SETFLAGSS1_OPENRC () {
					NOTICE_PLACEHOLDER
				}
				SETFLAGSS1_SYSTEMD () {  #(!todo)
					APPAPP_EMERGE="virtual/libudev "  # ! If your system set provides sys-fs/eudev, virtual/udev and virtual/libudev may be preventing systemd.  https://wiki.gentoo.org/wiki/Systemd
					EMERGE_USERAPP_DEF
					sed -ie '#echo "sys-apps/systemd cryptsetup#d'
					echo /etc/portage/package.use/systemd"sys-apps/systemd cryptsetup" >> /etc/portage/package.use/systemd
				}
				SETFLAGSS1_$SYSINITVAR
			}
			PORTAGE () {  # https://wiki.gentoo.org/wiki/Portage#emerge-webrsync # https://dev.gentoo.org/~zmedico/portage/doc/man/emerge.1.html
				mkdir /usr/portage
				emerge-webrsync
			}
			EMERGE_SYNC () {
				emerge --sync
			}
			MISC1_CHROOT () {
				MISC1CHROOT_OPENRC () {
					NOTICE_PLACEHOLDER
				}
				MISC1CHROOT_SYSTEMD () {
					systemctl preset-all
					systemctl daemon-reload
					ENVUD
				}
				MISC1CHROOT_$SYSINITVAR
			}
			RELOADING_SYS () {
				RELOAD_OPENRC () {
					NOTICE_PLACEHOLDER
				}
				RELOAD_SYSTEMD () {
					systemctl preset-all
					systemctl daemon-reload
					ENVUD
				}
				RELOAD_$SYSINITVAR
			}
			SYSTEMTIME () {  # https://wiki.gentoo.org/wiki/System_time
				SET_TIMEZONE () {
					echo $SYSTIMEZONE_SET > /etc/timezone
					TIMEZONE_OPENRC () {
						echo "$SYSTIMEZONE_SET" > /etc/timezone
						APPAPP_EMERGE=" --config sys-libs/timezone-data "
						EMERGE_USERAPP_DEF
					}
					TIMEZONE_SYSTEMD () {
						timedatectl set-timezone $SYSTIMEZONE_SET
					}
					TIMEZONE_$SYSINITVAR
				}
				SET_SYSTEMCLOCK () {  # https://wiki.gentoo.org/wiki/System_time#System_clock
					SYSTEMCLOCK_OPENRC () {
						OPENRC_SYSCLOCK_MANUAL () {
							OPENRC_SYSTEMCLOCK () {
								date $SYSDATE_MAN
							}
							OPENRC_SYSTEMCLOCK
						}
						OPENRC_OPENNTPD () {
							APPAPP_EMERGE="net-misc/openntpd"
							SYSSTART_OPENNTPD () {
								AUTOSTART_NAME_OPENRC="ntpd"
								AUTOSTART_DEFAULT_OPENRC
							}
							EMERGE_USERAPP_DEF
							SYSSTART_OPENNTPD
						}
						# OPENRC_SYSCLOCK_MANUAL  # (!changeme: only 1 can be set)
						OPENRC_OPENNTPD
					}
					SYSTEMCLOCK_SYSTEMD () {  # https://wiki.gentoo.org/wiki/System_time#Hardware_clock
						SYSTEMD_SYSCLOCK_MANUAL () {
							timedatectl set-time "$SYSCLOCK_MAN"
						}
						SYSTEMD_SYSCLOCK_AUTO () { 
							SYSSTART_TIMESYND () {
								AUTOSTART_NAME_SYSTEMD="systemd-timesyncd"
								AUTOSTART_DEFAULT_SYSTEMD
								# timedatectl set-local-rtc 0 # 0 set UTC
							}
							SYSSTART_TIMESYND
						}
						SYSTEMD_SYSCLOCK_$SYSCLOCK_SET
					}
					SYSTEMCLOCK_$SYSINITVAR
				}
				SET_HWCLOCK () {
					hwclock --systohc
				}
				SET_TIMEZONE  # echos err for systemd if install medium isnt systemd
				SET_SYSTEMCLOCK  # echos err for systemd, if install medium isnt systemd
				SET_HWCLOCK
			}
			CONF_LOCALES () {  # https://wiki.gentoo.org/wiki/Localization/Guide
				CONF_LOCALEGEN () {
					cat << EOF > /etc/locale.gen
					$PRESET_LOCALE_A ISO-8859-1
					$PRESET_LOCALE_A.UTF-8 UTF-8
					$PRESET_LOCALE_B ISO-8859-1
					$PRESET_LOCALE_B.UTF-8 UTF-8
EOF
				}
				GEN_LOCALE () {
					locale-gen
				}
				SYS_LOCALE () {  # (!todo)
					SYSLOCALE="$PRESET_LOCALE_A.UTF-8"
					SYSTEMLOCALE_OPENRC () {  # https://wiki.gentoo.org/wiki/Localization/Guide#OpenRC
						cat << EOF > /etc/env.d/02locale
						LANG="$SYSLOCALE"
						LC_COLLATE="C" # Define alphabetical ordering of strings. This affects e.g. output of sorted directory listings.
						# LC_CTYPE=$PRESET_LOCALE_A.UTF-8 # (!NOTE: not tested yet)
EOF
					}
					SYSTEMLOCALE_SYSTEMD () {  # https://wiki.gentoo.org/wiki/Localization/Guide#systemd
						localectl set-locale LANG=$SYSLOCALE
						localectl | grep "System Locale"
					}
					SYSTEMLOCALE_$SYSINITVAR
				}
				CONF_LOCALEGEN
				GEN_LOCALE
				SYS_LOCALE
			}
			KEYMAPS () {  # https://wiki.gentoo.org/wiki/Keyboard_layout_switching  ## (note:: theres a second place where keymaps are set, which is:"X11 KEYS SET = WINDOWSYS --> X11")
				KEYMAPS_OPENRC () {
					KEYLANGORC () {
						AUTOSTART_NAME_OPENRC="keymaps"
						CONFIG_KEYLANGORC () {
							sed -ie 's/keymap="us"/keymap="$KEYMAP"/g' /etc/conf.d/keymaps
							sed -ie "s/\$KEYMAP/$KEYMAP/g" /etc/conf.d/keymaps
						}
						CONFIG_KEYLANGORC
						AUTOSTART_BOOT_OPENRC
						rc-update add keymaps boot
					}
					CONSOLEFONTORC () {
						AUTOSTART_NAME_OPENRC="consolefont"
						CONFIG_CONSOLEFONTORC () {
							sed -ie 's/consolefont="default8x16"/consolefont="$CONSOLEFONT"/g' /etc/conf.d/consolefont
							sed -ie "s/\$CONSOLEFONT/$CONSOLEFONT/g" /etc/conf.d/consolefont  # note: consolefont file also contains "conoletranslation=" ;  "unicodemap=" - not set here - disabled by default.
						}
						CONFIG_CONSOLEFONTORC
						AUTOSTART_BOOT_OPENRC
					}
					etc-update --automode -3
					KEYLANGORC
					CONSOLEFONTORC
				}
				KEYMAPS_SYSTEMD () {
					VCONSOLE_CONF () {  # https://wiki.archlinux.org/index.php/Keyboard_configuration_in_console
						AUTOSTART_NAME_SYSTEMD="placeholder"
						### LOCALES LANG KEYMAPS SYSTEMD
						# -------------------------------------------
						VCONSOLE_KEYMAP=$KEYMAP-latin1 # (!changeme) console keymap systemd
						VCONSOLE_FONT="$CONSOLEFONT" # (!changeme)
						cat << EOF > /etc/vconsole.conf
						KEYMAP=$VCONSOLE_KEYMAP
						FONT=$VCONSOLE_FONT
EOF
					}
					VCONSOLE_CONF
				}
				ENVUD
				KEYMAPS_$SYSINITVAR
			}
			FIRMWARE () {  # BUG https://bugs.gentoo.org/318841#c20
				LINUX_FIRMWARE () {  # https://wiki.gentoo.org/wiki/Linux_firmware
					APPAPP_EMERGE="sys-kernel/linux-firmware "
					PACKAGE_USE				
					LICENSE_SET
					EMERGE_ATWORLD_A
					EMERGE_USERAPP_DEF
					etc-update --automode -3  # (automode -3 = merge all)
				}
				LINUX_FIRMWARE
			}
			BASHRC () {  # (!NOTE: custom .bashrc) (!todo) (!changeme)
				cat << 'EOF' > $CHROOTX/etc/skel/.bashrc
				#  (!NOTE: .bash.rc by alphaaurigae 11.08.19)
				#  ~/.bashrc: executed by bash(1) for non-login shells.
				#  Examples: /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
				[[ $- != *i* ]] && return  # If not running interactively, don't do anything
				shopt -s histappend  # append to the history file.
				HISTSIZE=1000  # max bash history lines.
				HISTFILESIZE=2000  # max bash history filesize in bytes.
				shopt -s checkwinsize  # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
				case "$TERM" in  # set a fancy prompt (non-color, unless we know we "want" color)
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
				PS1='\t ${gentoo_chroot:+($gentoo_chroot)}\[\033[0;35m\][\[\033[0;32m\]\u\[\033[0;37m\]@\[\033[0;36m\]\h\[\033[0;37m\]:\[\033[0;37m\]\w\[\033[0;35m\]]\[\033[0;37m\]\$\[\033[01;38;5;220m\] '  # mod
				else
				    PS1='${gentoo_chroot:+($gentoo_chroot)}\u@\h:\w\$ '
				fi
				unset color_prompt force_color_prompt
				case "$TERM" in  # If this is an xterm set the title to user@host:dir
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
				export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'  # colored GCC warnings and errors
				if [ -f ~/.bash_aliases ]; then  # ~/.bash_aliases, instead of adding them here directly.
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
			SWAPFILE
			MAKECONF
			PORTAGE
			# EMERGE_SYNC  # probably can leave this out if everything already latest ...
			ESELECT_PROFILE
			SETFLAGS1
			EMERGE_ATWORLD_A
			MISC1_CHROOT
			RELOADING_SYS
			SYSTEMTIME
			CONF_LOCALES
			KEYMAPS
			FIRMWARE
			BASHRC
			# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		}
		CORE () {
			FSTAB () {  # https://wiki.gentoo.org/wiki/Fstab
				FSTAB_LVMONLUKS_BIOS () {  # (!default)
					cat << EOF > /etc/fstab
					# ROOT MAIN FS
					/dev/mapper/$VG_MAIN-$LV_MAIN	/	$FILESYSTEM_MAIN	errors=remount-ro	0 1
					# BOOT
					UUID="$(blkid -o value -s UUID $BOOT_PART)"	/boot	$FILESYSTEM_BOOT	rw,relatime	0 2
EOF
				} 
				FSTAB_LVMONLUKS_UEFI () {
					cat << EOF > /etc/fstab
					# ROOT MAIN FS
					/dev/mapper/$VG_MAIN-$LV_MAIN	/	$FILESYSTEM_MAIN	errors=remount-ro	0 1
					# BOOT
					UUID="$(blkid -o value -s UUID $BOOT_PART)"	/boot	$FILESYSTEM_BOOT	rw,relatime	0 2
EOF
				}
				FSTAB_LVMONLUKS_$BOOTSYSINITVAR
			}
			CRYPTTABD () {
				cat << EOF > /etc/crypttab
					# crypt-container
					$PV_MAIN UUID=$(blkid -o value -s UUID $MAIN_PART) none luks,discard
EOF
			}
			SYSAPP () {
				SYSAPP_DMCRYPT () {  # https://wiki.gentoo.org/wiki/Dm-crypt
					APPAPP_EMERGE="sys-fs/cryptsetup "
					AUTOSTART_NAME_OPENRC="dmcrypt"
					AUTOSTART_NAME_SYSTEMD="systemd-cryptsetup"
					PACKAGE_USE
					ACC_KEYWORDS_USERAPP
					EMERGE_ATWORLD_A
					EMERGE_USERAPP_DEF
					etc-update --automode -3  # (automode -3 = merge all)
					AUTOSTART_BOOT_$SYSINITVAR
				} 
				SYSAPP_LVM2 () {  # https://wiki.gentoo.org/wiki/LVM/de
					APPAPP_EMERGE="sys-fs/lvm2"
					AUTOSTART_NAME_OPENRC="lvm"  # (!important: "lvm" instead of "lvm2" as label)
					AUTOSTART_NAME_SYSTEMD="$APPAPP_NAME_SIMPLE-monitor"
					CONFIG_LVM2 () {
						sed -e 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf > /tmp/lvm.conf
						mv /tmp/lvm.conf /etc/lvm/lvm.conf
					}
					EMERGE_USERAPP_DEF
					AUTOSTART_BOOT_$SYSINITVAR
					CONFIG_LVM2
				}
				SYSAPP_SUDO () {  # https://wiki.gentoo.org/wiki/Sudo
					APPAPP_EMERGE="app-admin/sudo "  # (note!: must keep trailing)
					CONFIG_SUDO () {
						cp /etc/sudoers /etc/sudoers_bak
						sed -ie 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
					}
					EMERGE_USERAPP_DEF
					CONFIG_SUDO
				}
				SYSAPP_PCIUTILS () {
					APPAPP_EMERGE="sys-apps/pciutils "
					EMERGE_USERAPP_DEF
				}
				SYSAPP_MULTIPATH () {  # https://wiki.gentoo.org/wiki/Multipath
					APPAPP_EMERGE="sys-fs/multipath-tools "
					EMERGE_USERAPP_DEF
				}
				SYSAPP_GNUPG () {
					APPAPP_EMERGE="app/crypt/gnupg "
					EMERGE_USERAPP_DEF
					gpg --full-gen-key
				}
				SYSAPP_OSPROBER () {
					APPAPP_EMERGE="sys-boot/os-prober "
					EMERGE_USERAPP_DEF
				}
				SYSAPP_SYSLOG () {
					# SYSLOGNG
					SYSLOGNG_SYSLOG_SYSTEMD="syslog-ng@default"
					SYSLOGNG_SYSLOG_OPENRC="syslog-ng"
					SYSLOGNG_SYSLOG_EMERGE="app-admin/syslog-ng "
					# SYSKLOGD
					SYSKLOGD_SYSLOG_SYSTEMD=rsyslog
					SYSKLOGD_SYSLOG_OPENRC=sysklogd
					SYSKLOGD_SYSLOG_EMERGE="app-admin/sysklogd "
					
					SETVAR_SYSLOG () {
					
						if [ "$SYSLOG" == "SYSLOGNG" ]; then
							AUTOSTART_NAME_SYSTEMD=$SYSLOGNG_SYSLOG_SYSTEMD
							AUTOSTART_NAME_OPENRC=$SYSLOGNG_SYSLOG_OPENRC
							SYSLOG_EMERGE=$SYSLOGNG_SYSLOG_EMERGE
						elif [ "$SYSLOG" == "SYSKLOGD" ] 
							then AUTOSTART_NAME_SYSTEMD=$SYSKLOGD_SYSLOG_SYSTEMD
							AUTOSTART_NAME_OPENRC=$SYSKLOGD_SYSLOG_OPENRC
							SYSLOG_EMERGE=$SYSLOGNG_SYSLOG_EMERGE
						else
							echo "${bold}ERROR: Could not detect '$SYSLOG' - debug syslog $SYSLOG ${normal}"
						fi
					
					}
					SETVAR_SYSLOG
					APPAPP_EMERGE="$SYSLOG_EMERGE "
					EMERGE_USERAPP_DEF
					# SYSLOG_$SYSINITVAR  # (note!: autostart TODO)
					LOGROTATE () {
						APPAPP_EMERGE="app-admin/logrotate "
						CONFIG_LOGROTATE_OPENRC () {
							NOTICE_PLACEHOLDER
						}
						CONFIG_LOGROTATE_SYSTEMD () {
							systemd-tmpfiles --create /usr/lib/tmpfiles.d/logrotate.conf
						}
						EMERGE_USERAPP_DEF
						CONFIG_LOGROTATE_$SYSINITVAR
					}
					LOGROTATE
				}
				SYSAPP_CRON () {
					## CRON - https://wiki.gentoo.org/wiki/Cron#Which_cron_is_right_for_the_job.3F
					# BCRON # http://untroubled.org/bcron
					BCRON_CRON_SYSTEMD=placeholder
					BCRON_CRON_OPENRC=placeholder
					BCRON_CRON_EMERGE=sys-process/bcron
					# FCRON # http://www.linuxfromscratch.org/blfs/view/systemd/general/fcron.html
					FCRON_CRON_SYSTEMD=fcron
					FCRON_CRON_OPENRC=fcron
					FCRON_CRON_EMERGE=sys-process/fcron
					# DCRON # http://www.linuxfromscratch.org/hints/downloads/files/dcron.txt
					DCRON_CRON_SYSTEMD=razor-session
					DCRON_CRON_OPENRC=razor-session
					DCRON_CRON_EMERGE=sys-process/dcron
					# CRONIE
					CRONIE_CRON_SYSTEMD=cronie
					CRONIE_CRON_OPENRC=cronie
					CRONIE_CRON_EMERGE=sys-process/cronie
					# VIXICRON
					VIXICRON_CRON_SYSTEMD=vixi
					VIXICRON_CRON_OPENRC=vixi
					VIXICRON_CRON_EMERGE=sys-process/vixie-cron
					SETVAR_CRON () {
						for i in $CRON
						do
							CRON_SYSTEMD=$i\_CRON_SYSTEMD
							CRON_OPENRC=$i\_CRON_OPENRC
							CRON_EMERGE=$i\_CRON_EMERGE
						done
					}
					CONFIG_CRON () {
						crontab /etc/crontab	
					}
					SETVAR_CRON
					APPAPP_EMERGE="${!CRON_EMERGE}"
					AUTOSTART_NAME_OPENRC="${!CRON_OPENRC}"
					AUTOSTART_NAME_OPENRC="${!CRON_SYSTEMD}"
					echo $APPAPP_EMERGE
					EMERGE_USERAPP_DEF
					CONFIG_CRON
					AUTOSTART_DEFAULT_$SYSINITVAR
				}
				SYSAPP_FILEINDEXING () {
					APPAPP_EMERGE="sys-apps/mlocate "
					EMERGE_USERAPP_DEF
				}
				RUN_ALL_YES () {
					for i in ${!SYSAPP_*}
					do
						$i
					done
				}
				RUN_ALL_YES
			}
			# (note!: kernel configuration for filesystems not automated yet)
			I_FSTOOLS () {  # (! e2fsprogs # Ext2, 3, and 4) # optional, add to variables at time.
				## (note!: this is a little workaround to make sure FS support is installed.  This is missing a routine to avoid double emerges as of 16 01 2021)
					## FSTOOLS
					FST_EMERGE_EXT=sys-fs/e2fsprogs
					FST_EMERGE_XFS=sys-fs/xfsprogs
					FST_EMERGE_REISER=sys-fs/reiserfsprogs
					FST_EMERGE_JFS=sys-fs/jfsutils
					FST_EMERGE_VFAT=sys-fs/dosfstools # (FAT32, ...) 
					FST_EMERGE_BTRFS=sys-fs/btrfs-progs
					MAIN () {
						ALL_YES () {
							for i in  ${!FSTOOLS_*}
							do
								if [ $(printf '%s\n' "${!i}") == "YES" ]; then
									APPAPP_EMERGE=$(printf '%s\n' "$i" | sed -e s'/FSTOOLS_/FST_EMERGE_/g')
									EMERGE_USERAPP_RD1
								else 
									APPAPP_EMERGE=$(printf '%s\n' "$i" | sed -e s'/FSTOOLS_/FST_EMERGE_/g' )
									MATCHFS="$(printf '%s\n' "$i" | sed -e s'/FSTOOLS_/FST_EMERGE_/g' )"
									LDGFSE="$(printf '%s\n' "${!MATCHFS}" |   sed -e 's/-progs//g' | sed -e 's/progs//g' | sed -e 's#sys-fs/##g')"
									printf '%s\n' "$APPAPP_EMERGE  is set to NO, test for boot fs ..."
									for i in  ${!FILESYSTEM_*}
									do
										if [ "${!i}" == "$LDGFSE" ]; then
											echo "system / boot FS ${!i} = $LDGFSE pattern in search string for fstools repo variables $i "
											echo "emerging ${!APPAPP_EMERGE}"
											#EMERGE_USERAPP_RD1
										else
											#printf '%s\n' "${!MATCHFS}"
											#printf '%s\n' "${!i}"
											echo "system / boot FS ${!i} != $LDGFSE pattern in search string for fstools repo variables $i "
										fi
									done
								fi
							done
						}
						FILTER_YES () {
							for i in ${!FILESYSTEM_*}
							do
								if [[ "${!i}" == "msdos" || "${!FILESYSTEM_*}" == "vfat" || "${!FILESYSTEM_*}" == "fat" ]]; then
									echo "${!i} IS BINGO dos fs"
									APPAPP_EMERGE="$(printf '%s\n' "$FST_EMERGE_VFAT")"
									echo "emerging ${!APPAPP_EMERGE}"
									EMERGE_USERAPP_DEF
								else
									#printf '%s\n' "${!MATCHFS}"
									#printf '%s\n' "${!i}"
									echo "${!i} is not dos fs"
								fi
								if [[ "${!i}" == *"ext"* ]]; then
									echo "${!i} IS BINGO ext fs"
									APPAPP_EMERGE="$(printf '%s\n' "$FST_EMERGE_EXT")"
									echo "emerging $APPAPP_EMERGE "
									EMERGE_USERAPP_DEF
								else
									#printf '%s\n' "${!MATCHFS}"
									#printf '%s\n' "${!i}"
									echo "${!i} is not ext fs"
								fi
							done
						}
						ALL_YES
						FILTER_YES
					}
					MAIN
				}
			BOOTLOAD () {  # BOOTSYSINITVAR=BIOS/UEFI
				SETUP_GRUB2 () {  # (!NOTE:  https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt) 
					LOAD_GRUB2 () {
						PRE_GRUB2 () {
							etc-update --automode -3
							APPAPP_EMERGE="sys-boot/grub:2 "
							ACC_KEYWORDS_USERAPP
							PACKAGE_USE
							EMERGE_ATWORLD_A
							EMERGE_USERAPP_DEF
						}
						GRUB2_BIOS () {
							PRE_GRUB2BIOS () {
								sed -ie '/GRUB_PLATFORMS=/d' /etc/portage/make.conf
								echo 'GRUB_PLATFORMS="pc"' >> /etc/portage/make.conf
								EMERGE_ATWORLD_A
							}
							PRE_GRUB2BIOS
							grub-install --recheck --target=i386-pc $HDD1
						}
						GRUB2_UEFI () {
							PRE_GRUB2UEFI () {
								sed -ie '/GRUB_PLATFORMS=/d' /etc/portage/make.conf
								sed -ie '/GRUB_PLATFORMS="efi-64/d' /etc/portage/make.conf
								echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
								EMERGE_ATWORLD_A
							}
							PRE_GRUB2UEFI
							grub-install --target=x86_64-efi --efi-directory=/boot
							## (!NOTE: optional)# mount -o remount,rw /sys/firmware/efi/efivars  # If grub_install returns an error like Could not prepare Boot variable: Read-only file system, it may be necessary to remount the efivars special mount as read-write in order to succeed:
							## (!NOTE: optional)# grub-install --target=x86_64-efi --efi-directory=/boot --removable  # Some motherboard manufacturers seem to only support the /efi/boot/ directory location for the .EFI file in the EFI System Partition (ESP). 
						}
						PRE_GRUB2
						GRUB2_$BOOTSYSINITVAR
					}
					CONFIGGRUB2_DMCRYPT () { # ( !note: config is edited partially after pasting, to be fully integrated in variables. )
					
						CONFGRUBDMCRYPT_MAIN () {
							etc-update --automode -3
							cat << EOF > /etc/default/grub
							# If you change this file, run 'update-grub' afterwards to update
							# /boot/grub/grub.cfg.
							# For full documentation of the options in this file, see:
							#   info -f grub -n 'Simple configuration'
							GRUB_DEFAULT=0
							GRUB_TIMEOUT_STYLE=countdown
							GRUB_TIMEOUT=2
							#GRUB_FONT=/boot/grub/fonts/unicode.pf2
							#GRUB_DISTRIBUTOR=``
							GRUB_CMDLINE_LINUX_DEFAULT=""
							GRUB_CMDLINE_LINUX=""
							# Uncomment to enable BadRAM filtering, modify to suit your needs
							# This works with Linux (no patch required) and with any kernel that obtains
							# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
							#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"
							# Uncomment to disable graphical terminal (grub-pc only)
							#GRUB_TERMINAL=console
							# The resolution used on graphical terminal
							# note that you can use only modes which your graphic card supports via VBE
							# you can see them in real GRUB with the command vbeinfo
							#GRUB_GFXMODE=640x480
							
							# ############################################################################################################################################################################ 
							# https://www.gnu.org/software/grub/manual/grub/html_node/Root-Identifcation-Heuristics.html              #
							#													  #
							# Initrd-detected| GRUB_DISABLE_LINUX_PARTUUID |GRUB_DISABLE_LINUX_UUID	| Linux Root ID Method  	  #
							# false			false			false			part UUID			  #
							# false			false			true			part UUID			  #
							# false			true			false			dev name			  #
							# false			true			true			dev name			  #
							# true			false			false			fs UUID				  #
							# true			false			true			part UUID				  #
							# true			true			false			fs UUID				  #
							# true			true			true			dev name				  #
							#														  #
							# Remember, ‘GRUB_DISABLE_LINUX_PARTUUID’ and ‘GRUB_DISABLE_LINUX_UUID’ are also considered to be set to  #
							# ... ‘false’ when they are unset. 									  #
							# ############################################################################################################################################################################ 
							# Uncomment if you don't want GRUB to pass "root=UUID=xxx" parameter to Linux
							GRUB_DISABLE_LINUX_UUID=false
							
							# Since version 2.04. If false, and if there is either no initramfs or GRUB_DISABLE_LINUX_UUID is set to true, ${GRUB_DEVICE_PARTUUID} is passed in the root parameter on the kernel command line. See Root identification Heuristics
							GRUB_DISABLE_LINUX_PARTUUID=false
							# Uncomment to disable generation of recovery mode menu entries
							#GRUB_DISABLE_RECOVERY="true"
							# Uncomment to get a beep at grub start
							#GRUB_INIT_TUNE="480 440 1"
							GRUB_ENABLE_CRYPTODISK=y
							GRUB_PRELOAD_MODULES="lvm luks cryptodisk crypto ext2 part_gpt part_msdos gettext gzio"
EOF
						}
						CONFGRUBDMCRYPT_OPENRC () {  # https://wiki.gentoo.org/wiki/GRUB2
						
							sed -ie '/GRUB_CMDLINE_LINUX=/d' /etc/default/grub
							cat << EOF >> /etc/default/grub
							# If the root file system is contained in a logical volume of a fully encrypted LVM, the device mapper for it will be in the general form of root=/dev/volumegroup/logicalvolume. https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration
							GRUB_CMDLINE_LINUX="raid=noautodetect cryptdevice=PARTUUID=$(blkid -s PARTUUID -o value $MAIN_PART):$PV_MAIN root=UUID=$(blkid -s UUID -o value /dev/$VG_MAIN/$LV_MAIN) rootfstype=ext4 dolvm"
							# (!NOTE: etc/crypttab not required under default openrc, "luks on lvm", GPT, bios - setup) # Warning: If you are using /etc/crypttab or /etc/crypttab.initramfs together with luks.* or rd.luks.* parameters, only those devices specified on the kernel command line will be activated and you will see Not creating device 'devicename' because it was not specified on the kernel command line.. To activate all devices in /etc/crypttab do not specify any luks.* parameters and use rd.luks.*. To activate all devices in /etc/crypttab.initramfs do not specify any luks.* or rd.luks.* parameters.
EOF
						}
						CONFGRUBDMCRYPT_SYSTEMD () {  # https://wiki.gentoo.org/wiki/GRUB2
						
							sed -ie '/GRUB_CMDLINE_LINUX=/d' /etc/default/grub
							cat << EOF >> /etc/default/grub
							# If the root file system is contained in a logical volume of a fully encrypted LVM, the device mapper for it will be in the general form of root=/dev/volumegroup/logicalvolume. https://wiki.archlinux.org/index.php/Dm-crypt/System_configuration
							GRUB_CMDLINE_LINUX="rd.luks.name=$(blkid -o value -s UUID $MAIN_PART)=$PV_MAIN root=UUID=$(blkid -s UUID -o value /dev/$VG_MAIN/$LV_MAIN) rootfstype=ext4 dolvm " #real_init=/lib/systemd/systemd
							# rd.luks.name= is honored only by initial RAM disk (initrd) while luks.name= is honored by both the main system and the initrd. https://www.freedesktop.org/software/systemd/man/systemd-cryptsetup-generator.html
EOF
						}
						CONFGRUBDMCRYPT_MAIN
						CONFGRUBDMCRYPT_$SYSINITVAR
					}
					UPDTE_GRUB () {
						grub-mkconfig -o /boot/grub/grub.cfg
					}
					LOAD_GRUB2
					CONFIGGRUB2_DMCRYPT
					UPDTE_GRUB
				}
				SETUP_LILO () {
					APPAPP_EMERGE="sys-boot/lilo "
					CONF_LILO () {  # https://wiki.gentoo.org/wiki/LILO # https://github.com/a2o/lilo/blob/master/sample/lilo.example.conf
						cat << EOF > /etc/lilo.conf
						# [ !PASTE_OPTIONAL_CONFIG: lilo config (!note: not fully integrated / automated yet) ]
EOF
					}
					EMERGE_USERAPP_DEF
					CONF_LILO
				}
				SETUP_$BOOTLOADER
			}                        
			KERNEL () {  # https://wiki.gentoo.org/wiki/Kernel
				KERN_LOAD () {
					KERN_EMERGE () {
						APPAPP_EMERGE="sys-kernel/gentoo-sources "
						ACC_KEYWORDS_USERAPP
						EMERGE_ATWORLD_A
						EMERGE_USERAPP_DEF
					}
					KERN_TORVALDS () {
						rm -rf /usr/src/linux
						git clone https://github.com/torvalds/linux /usr/src/linux
						cd /usr/src/linux
						git fetch
						git fetch --tags
						git checkout v$KERNVERS  # get desired branch / tag
					}
					KERN_$KERNSOURCES
				}
				KERN_DEPLOY () {
					KERN_MANUAL () {
						KERN_CONF () {
							KERNCONF_PASTE () {  # paste own config here ( ~ this should go to auto)
							
								mv /usr/src/linux/.config /usr/src/linux/.oldconfig 
								echo "ignore err"
								touch /usr/src/linux/.config
								
								[ !PASTE_DEF_CONFIG: "KERNEL" .config for the kernel in the cat paste below. and comment this line + below out ] comment this line
								############################################################################################################################################################################################################################################################################################################################################################################################
								cat << 'EOF' > /usr/src/linux/.config  # stripped version infos for refetch
###################### REPLACE this w .config ##########################
EOF
							}
							KERNCONF_DEFCONFIG () {
								cd /usr/src/linux
								make clean
								make proper
								make -j $(nproc) defconfig
							}
							KERNCONF_MENUCONFIG () {
								cd /usr/src/linux
								make clean
								make proper
								make -j $(nproc) menuconfig
							}
							KERNCONF_ALLYESCONFIG () {  # New config where all options are accepted with yes
								cd /usr/src/linux
								make clean
								make proper
								make -j $(nproc) allyesconfig
							}
							KERNCONF_OLDCONFIG () {  # (!testing) (!todo)
								cd /usr/src/linux
								make clean
								make proper
								make -j $(nproc) oldconfig
							}
							if [ "$KERNCONFD" != "DEFCONFIG" ]; then
								KERNCONF_PASTE
								KERNCONF_$KERNCONFD
							else
								KERNCONF_DEFCONFIG
							fi
						}
						KERN_BUILD () {  # (!incomplete (works but) modules setup *smart)
							cd /usr/src/linux  # enter build directory (required?)
							make -j$(nproc) dep
							make -j$(nproc) -o /usr/src/linux/.config # build kernel based on .config file
							make -j$(nproc) -o /usr/src/linux/.config modules # build modules based on .config file
							make -j$(nproc) bzImage
							sudo make install  # install the kernel
							sudo make modules_install  # install the modules
						}
						lsmod  # active modules by install medium.
						KERN_CONF  # kernel configure set
						KERN_BUILD  # kernel build set
						grub-mkconfig -o /boot/grub/grub.cfg  # update grub in case its already installed ....
					}
					KERN_AUTO () {  # (!changeme) switch to auto (option variables top) # switch to auto configuration (option variables top)
						GENKERNEL_NEXT () {  # # (!incomplete)
							CONF_GENKERNEL () {  # (!incomplete)
								touch /etc/genkernel.conf
								cat << 'EOF' > /etc/genkernel.conf
								# [!PASTE_OPTIONAL_CONFIG: config/other_optional/genkernel.conf - not yet intgreated in variables and fully tested, ]
EOF
							}
							RUN_GENKERNEL () {
								# genkernel --config=/etc/genkernel.conf all
								genkernel --luks --lvm --no-zfs all
								rub-mkconfig -o /boot/grub/grub.cfg  # update grub in case its already installed ....
							}
							APPAPP_EMERGE="sys-kernel/genkernel-next"
							PACKAGE_USE
							ACC_KEYWORDS_USERAPP
							EMERGE_ATWORLD_A
							EMERGE_USERAPP_DEF
							# CONF_GENKERNEL
							RUN_GENKERNEL
						}
						GENKERNEL_NEXT
					}
					KERN_$KERNDEPLOY
					cd /
				}
				KERN_LOAD  # load kernel source (download, copy ; etc ....)
				KERN_DEPLOY  # config / build
			}
			INITRAMFS () {  # https://wiki.gentoo.org/wiki/Initramfs
				INITRFS_GENKERNEL () {
					# genkernel --config=/etc/genkernel.conf initramfs
					genkernel $GENKERNEL_CMD
				}
				INITRFS_DRACUT () {  # https://wiki.gentoo.org/wiki/Dracut
					APPAPP_EMERGE="sys-kernel/dracut"
					CONFIG_DRACUT () {
						DRACUT_USERMOUNTCONF () {
							cat << EOF > /etc/dracut.conf.d/usrmount.conf
							add_dracutmodules+="$DRACUT_CONFD_ADD_DRACUT_MODULES" # Dracut modules to add to the default
EOF
						}
						DRACUT_DRACUTCONF () {
							cat << EOF > /etc/dracut.conf
							hostonly="$DRACUT_CONF_HOSTONLY"
							lvmconf="$DRACUT_CONF_LVMCONF"
							dracutmodules+="$DRACUT_CONF_MODULES"
EOF
						}
						DRACUT_USERMOUNTCONF
						DRACUT_DRACUTCONF
					}
					PACKAGE_USE
					EMERGE_USERAPP_DEF
					CONFIG_DRACUT
					dracut --force '' $(ls /lib/modules)
				}
				INITRFS_$GENINITRAMFS  # config / build
				etc-update --automode -3
			}
			MODPROBE_CHROOT () {
				modprobe -a dm-mod dm-crypt sha256 aes aes_generic xts
			}
			VIRTUALIZATION () {
				SYS_HOST () {
					NOTICE_PLACEHOLDER
				}
				SYS_GUEST () {
					GUE_VIRTUALBOX () {
					# which kernel variables set the dependencies?
						APPAPP_EMERGE="app-emulation/virtualbox-guest-additions"
						AUTOSTART_NAME_OPENRC="virtualbox-guest-additions"
						PACKAGE_USE
						EMERGE_ATWORLD_B
						EMERGE_USERAPP_DEF
						AUTOSTART_DEFAULT_OPENRC
						VBoxClient-all
						rc-update add dbus boot
					}
					GUE_VIRTUALBOX
				}
				SYS_$SYSVARD
			}
			AUDIO () {  # (!todo)
				SOUND_API () {
					ALSA () {  # https://wiki.gentoo.org/wiki/ALSA
						APPAPP_EMERGE="media-sound/alsa-utils"
						AUTOSTART_NAME_OPENRC="alsasound"
						AUTOSTART_NAME_SYSTEMD="alsa-restore"
						# euse -E alsa
						EMERGE_ATWORLD_B
						EMERGE_USERAPP_DEF
						APPAPP_EMERGE="media-plugins/alsa-plugins "
						# USE="ffmpeg" emerge -q media-plugins/alsa-plugins
						EMERGE_USERAPP_DEF
						AUTOSTART_DEFAULT_$SYSINITVAR
					}
					ALSA
				}
				SOUND_SERVER () {
					PULSEAUDIO () {
						#  (!todo)
						# EMERGE_ATWORLD_B
					}
					PULSEAUDIO
				}
				SOUND_MIXER () {
					PAVUCONTROL () {
						APPAPP_EMERGE="media-sound/pavucontrol "
						EMERGE_USERAPP_DEF
					}
					PAVUCONTROL
				}
				SOUND_API
				SOUND_SERVER
				SOUND_MIXER
			}
		#	GPU () {  # (!todo)
		#		SET_NONE () {
		#			NOTICE_PLACEHOLDER
		#		
		#		}
		#		SET_NVIDIA () {  # (!todo)
		#			NOTICE_PLACEHOLDER
		#		} 
		#		SET_AMD () {  # (!todo)
		#			RADEON () {  # (!todo)
		#				APPAPP_EMERGE=" "
		#				EMERGE_USERAPP_DEF
		#			}
		#			AMDGPUDEF () {  # (!todo)
		#				APPAPP_EMERGE=" "
		#				EMERGE_USERAPP_DEF
		#				# radeon-ucode
		#			}
		#			AMDGPUPRO () {  # (!todo)
		#				APPAPP_EMERGE="dev-libs/amdgpu-pro-opencl "
		#				EMERGE_USERAPP_DEF
		#			}
		#			# RADEON
		#			# AMDGPUDEF
		#			AMDGPUPRO
		#		}
		#		$GPU_SET
		#	}
			NETWORK_MAIN () {  # (!todo)
				HOSTSFILE () {  # (! default)
					echo "$HOSTNAME" > /etc/hostname
					echo "127.0.0.1	localhost
					::1		localhost
					127.0.1.1	$HOSTNAME.$DOMAIN	$HOSTNAME" > /etc/hosts
					cat /etc/hosts
				}
				NETWORK_MGMT () {
					GENTOO_DEFAULT () {
						NETIFRC () {  # (! default)
							APPAPP_EMERGE="net-misc/netifrc "
							VAR_EMERGE=" --noreplace net-misc/netifrc " 
							AUTOSTART_NAME_OPENRC="net.$NETIFACE_MAIN "
							AUTOSTART_NAME_SYSTEMD="net@$NETIFACE_MAIN"
							CONF_NETIFRC () {
								cat << EOF > /etc/conf.d/net  # Please read /usr/share/doc/netifrc-*/net.example.bz2 for a list of all available options. DHCP client man page if specific DHCP options need to be set.
								config_$NETIFACE_MAIN="dhcp"
EOF
								cat /etc/conf.d/net
							}
							EMERGE_USERAPP_DEF
							CONF_NETIFRC
							AUTOSTART_DEFAULT_$SYSINITVAR
						}
						NETIFRC
					}
					OPENRC_DEFAULT () {
						NOTICE_PLACEHOLDER
					}
					SYSTEMD_DEFAULT () {
						NETWORKD () {  # https://wiki.archlinux.org/index.php/Systemd-networkd
							systemctl enable systemd-networkd.service
							REPLACE_RESOLVECONF () {  # (! default)
								ln -snf /run/systemd/resolved.conf /etc/resolv.conf
								systemctl enable systemd-resolved.service
							}
							WIRED_DHCPD () {  # (! default)
								cat << 'EOF' > /etc/systemd/network/20-wired.network
								[ Match ]
								Name=enp0s3
								[ Network ]
								DHCP=ipv4
EOF
							}
							WIRED_STATIC () {
								cat << 'EOF' > /etc/systemd/network/20-wired.network
								[ Match ]
								Name=enp0s3
								[ Network ]
								Address=10.1.10.9/24
								Gateway=10.1.10.1
								DNS=10.1.10.1
								# DNS=8.8.8.8
EOF
							}
							REPLACE_RESOLVECONF
							WIRED_$NETWORK_NET
						}
						NETWORKD
					}
					DHCCLIENT () {
						DHCPCD () {  # https://wiki.gentoo.org/wiki/Dhcpcd
							APPAPP_EMERGE="net-misc/dhcpcd "
							AUTOSTART_NAME_OPENRC="dhcpcd"
							AUTOSTART_NAME_SYSTEMD="dhcpcd"
							EMERGE_USERAPP_DEF
							AUTOSTART_DEFAULT_$SYSINITVAR
						}
						DHCPCD
					}
					NETWORKMANAGER () {
						EMERGE_NETWORKMANAGER () {
							APPAPP_EMERGE="net-misc/networkmanager "
							AUTOSTART_NAME_OPENRC="NetworkManager"
							AUTOSTART_NAME_SYSTEMD="NetworkManager"
							PACKAGE_USE
							ACC_KEYWORDS_USERAPP
							EMERGE_ATWORLD_A
							EMERGE_USERAPP_DEF
							AUTOSTART_DEFAULT_$SYSINITVAR
						}
						EMERGE_NETWORKMANAGER
						AUTOSTART_DEFAULT_$SYSINITVAR
					}
					DHCCLIENT
					$NETWMGR
				}
				HOSTSFILE
				NETWORK_MGMT
			}
			FSTAB
			## CRYPTTABD  # (!info: not required for the default lvm on luks gpt bios grub - setup)
			SYSAPP  # (!NOTE !todo !bug : virtualbox) other issues?
			I_FSTOOLS
			BOOTLOAD
			KERNEL
			if [ "$CONFIGBUILDKERN" != "AUTO" ]; then
				INITRAMFS
			else
				echo 'CONFIGBUILDKERN AUTO DETECTED, skipping initramfs'
			fi
			## MODPROBE_CHROOT  # (!info: not required for the default lvm on luks gpt bios grub - setup)
			VIRTUALIZATION  # (!info !bug !todo : worked previously with virtualbox set as gpu in make.conf, curiously.)
			AUDIO
			##GPU # (!note: incomplete)
			NETWORK_MAIN
			# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
		}
		SCREENDSP () {  # note: replace visual header with "screen and desktop"
			WINDOWSYS () {
				X11 () {  # (! default) # https://wiki.gentoo.org/wiki/Xorg/Guide
					EMERGE_XORG () {
						APPAPP_EMERGE="x11-libs/gdk-pixbuf "
						EMERGE_USERAPP_DEF
						APPAPP_EMERGE="x11-base/xorg-server "
						PACKAGE_USE
						EMERGE_USERAPP_DEF
						ENVUD 
					}
					CONF_XORG () {
						CONF_X11_KEYBOARD () {
							touch /usr/share/X11/xorg.conf.d/10-keyboard.conf
							cat << EOF > /usr/share/X11/xorg.conf.d/10-keyboard.conf
							Section "InputClass"
							    Identifier "keyboard-all"
							
							    Option "XkbLayout" "$LANG_MAIN_LOWER,$LANG_SECOND_LOWER"
							    Option "XkbVariant" "$X11_XKBVARIANT"
							    Option "XkbOptions" "$X11_KEYBOARD_XKB_OPTIONS"
							    MatchIsKeyboard "$X11_KEYBOARD_MATCHISKEYBOARD"
							EndSection
EOF
						}
						CONF_X11_KEYBOARD
					}
					EMERGE_XORG
					CONF_XORG
					ENVUD
				}
				$DISPLAYSERV
			}
			DESKTOP_ENV () {  # https://wiki.gentoo.org/wiki/Desktop_environment
				#  BUDGIE - https://wiki.gentoo.org/wiki/Budgie
				BUDGIE_DSTENV_XEC=budgie_dpmexec
				BUDGIE_DSTENV_STARTX=budgie
				BUDGIE_DSTENV_EMERGE=budgie
				#  CINNAMON - https://wiki.gentoo.org/wiki/Cinnamon
				CINNAMON_DSTENV_XEC=gnome-session-cinnamon
				CINNAMON_DSTENV_STARTX=cinnamon-session
				CINNAMON_DSTENV_EMERGE=gnome-extra/cinnamon
				#  DDE "Deepin Desktop Environment" - https://wiki.gentoo.org/wiki/DDE
				DDE_DSTENV_XEC=DDE
				DDE_DSTENV_STARTX=DDE
				DDE_DSTENV_EMERGE=DDE
				#  FVWM-Crystal - FVWM-Crystal
				FVWMCRYSTAL_DSTENV_XEC=fvwm-crystal
				FVWMCRYSTAL_DSTENV_STARTX=fvwm-crystal
				FVWMCRYSTAL_DSTENV_EMERGE=x11-themes/fvwm-crystal
				#  GNOME - https://wiki.gentoo.org/wiki/GNOME
				GNOME_DSTENV_XEC=gnome-session
				GNOME_DSTENV_STARTX=GNOME
				GNOME_DSTENV_EMERGE=gnome-base/gnome
				#  KDE - FVWM-Crystal
				KDE_DSTENV_XEC=kde-plasma/startkde
				KDE_DSTENV_STARTX=startkde
				KDE_DSTENV_EMERGE=kde-plasma/plasma-meta
				#  LXDE - https://wiki.gentoo.org/wiki/LXDE
				LXDE_DSTENV_XEC=startlxde
				LXDE_DSTENV_STARTX=startlxde
				LXDE_DSTENV_EMERGE=lxde-base/lxde-meta
				#  LXQT - FVWM-Crystal
				LXQT_DSTENV_XEC=startlxqt
				LXQT_DSTENV_STARTX=startlxqt
				LXQT_DSTENV_EMERGE=lxqt-base/lxqt-meta
				#  LUMINA - https://wiki.gentoo.org/wiki/Lumina
				LUMINA_DSTENV_XEC=start-lumina-desktop
				LUMINA_DSTENV_STARTX=start-lumina-desktop
				LUMINA_DSTENV_EMERGE=x11-wm/lumina
				#  MATE - https://wiki.gentoo.org/wiki/MATE
				MATE_DSTENV_XEC=mate-session
				MATE_DSTENV_STARTX=mate-session
				MATE_DSTENV_EMERGE=mate-base/mate
				#  PANTHEON - https://wiki.gentoo.org/wiki/Pantheon
				PANTHEON_DSTENV_XEC=PANTHEON
				PANTHEON_DSTENV_STARTX=PANTHEON
				PANTHEON_DSTENV_EMERGE=PANTHEON
				#  RAZORQT - FVWM-Crystal
				RAZORQT_DSTENV_XEC=razor-session
				RAZORQT_DSTENV_STARTX=razor-session
				RAZORQT_DSTENV_EMERGE=RAZORQT
				#  TDE - https://wiki.gentoo.org/wiki/Trinity_Desktop_Environment
				TDE_DSTENV_XEC=tde-session
				TDE_DSTENV_STARTX=tde-session
				TDE_DSTENV_EMERGE=trinity-base/tdebase-meta
				#  XFCE - https://wiki.gentoo.org/wiki/Xfce
				XFCE_DSTENV_XEC=xfce4-session
				XFCE_DSTENV_STARTX=startxfce4
				XFCE_DSTENV_EMERGE=xfce-base/xfce4-meta
				SETVAR_DSKTENV () {
					for i in $DESKTOPENV ; do
						DSTENV_XEC=$DESKTOPENV\_DSTENV_XEC
						DSTENV_STARTX=$DESKTOPENV\_DSTENV_STARTX
						DSTENV_EMERGE=$DESKTOPENV\_DSTENV_EMERGE
					done
				}
				ADDREPO_DSTENV () {
					if [ "$DESKTOPENV" == "PANTHEON" ]; then
						layman -a elementary
						eselect repository enable elementary
						emerge --sync elementary 
					else
						NOTICE_PLACEHOLDER
					fi
				}
				EMERGE_DSTENV () {
					# emerge --ask gnome-extra/nm-applet
					if [ "$DESKTOPENV" == "DDM" ]; then
						GIT () {
							APPAPP_EMERGE="dev-vcs/git "
							EMERGE_USERAPP_DEF
						}
						ESELECT () {
							APPAPP_EMERGE="app-eselect/eselect-repository "
							EMERGE_USERAPP_DEF
						}
						DEEPIN_GIT () {
							MAIN () {
							eselect repository add deepin git https://github.com/zhtengw/deepin-overlay.git
							APPAPP_EMERGE="deepin "
							EMERGE_USERAPP_DEF
							}
							PLUGIN () {
							mkdir -pv /etc/portage/package.use
							sed -ie '#dde-base/dde-meta multimedia#d' /etc/portage/package.use/deepin
							echo "dde-base/dde-meta multimedia" >> /etc/portage/package.use/deepin
							APPAPP_EMERGE="dde-base/dde-meta "
							EMERGE_USERAPP_DEF
							}
							MAIN
							PLUGIN
						}
						GIT
						ESELECT
						DEEPIN_GIT
					elif [ "$DESKTOPENV" == "PANTHEON" ]; then
						PANTHEON_MAIN () {
							APPAPP_EMERGE="pantheon-base/pantheon-shell "
							EMERGE_USERAPP_DEF
						
						}
						PANTHEON_ADDON () {
							APPAPP_EMERGE="media-video/audience x11-terms/pantheon-terminal "
							EMERGE_USERAPP_DEF
						}
						PANTHEON_MAIN
						PANTHEON_ADDON
					elif [ "$DESKTOPENV" == "XFCE" ]; then
						MISC_XFCE () {
							XFCEADDON () {
								emerge xfce-base/xfce4-session
								emerge xfce-base/xfce4-settings
								emerge xfce-base/xfwm4
								emerge xfce-base/xfce4-panel
								# emerge xfce-extra/xfce4-notifyd
								# emerge xfce-extra/xfce4-mount-plugin  #(!bug) failed to emerge
								emerge xfce-base/thunar
								emerge x11-terms/xfce4-terminal
								emerge app-editors/mousepad
								#emerge --ask media-sound/tudor-volumed
								# emerge XFCE-pulseaudio-plugin
								# emerge xfce-extra/xfce4-mixer  # not found 17.11.19
								emerge xfce-extra/xfce4-alsa-plugin
								# emerge xfce-extra/thunar-volman
							}
							APPAPP_EMERGE="xfce-base/xfce4-meta "
							PACKAGE_USE
							EMERGE_ATWORLD_B
							EMERGE_USERAPP_DEF
							XFCEADDON
						}
						MISC_XFCE
					else
						emerge $DSTENV_EMERGE
					fi
					ENVUD
				}
				MAIN_DESKTPENV_OPENRC () {
					AUTOSTART_NAME_OPENRC="dbus"
					AUTOSTART_DEFAULT_OPENRC
					AUTOSTART_NAME_OPENRC="xdm"
					AUTOSTART_DEFAULT_OPENRC
					AUTOSTART_NAME_OPENRC="elogind"  # elogind The systemd project's "logind", extracted to a standalone package https://github.com/elogind/elogind
					AUTOSTART_BOOT_OPENRC
				}
				MAIN_DESKTPENV_SYSTEMD () {
					AUTOSTART_NAME_SYSTEMD="dbus"
					AUTOSTART_DEFAULT_SYSTEMD
					AUTOSTART_NAME_SYSTEMD="systemd-logind"
					AUTOSTART_DEFAULT_SYSTEMD
					ENVUD
				}
				DESKTENV_SOLO () {
					DESKTENV_STARTX () {
						if [ "$DESKTOPENV" == "LUMINA" ]; then
							cat << 'EOF' > ~/.xinitrc 
							[[ -f ~/.Xresources ]]
							xrdb -merge -I/home/$SYSUSERNAME ~/.Xresources
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
							cp /etc/xdg/autostart/nm-applet.desktop /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
							echo 'X-GNOME-Autostart-enabled=false' >> /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
							chown $SYSUSERNAME:$SYSUSERNAME /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
						else
							NOTICE_PLACEHOLDER
						fi
					}
					DESKTENV_AUTOSTART_SYSTEMD () {
						NOTICE_PLACEHOLDER
					}
					DESKTENV_STARTX
					DESKTENV_AUTOSTART_$SYSINITVAR
				}
				W_D_MGR () {  # Display_manager https://wiki.gentoo.org/wiki/Display_manager
					#  CDM - The Console Display Manager https://wiki.gentoo.org/wiki/CDM -- https://github.com/evertiro/cdm
					CDM_DSPMGR_SYSTEMD=cdm.service
					CDM_DSPMGR_OPENRC=cdm
					CDM_APPAPP_EMERGE=x11-misc/cdm
					#  GDM - https://wiki.gentoo.org/wiki/GNOME/gdm
					GDM_DSPMGR_SYSTEMD=cdm.service
					GDM_DSPMGR_OPENRC=gdm
					GDM_APPAPP_EMERGE=gnome-base/gdm                                     
					#  LIGHTDM - https://wiki.gentoo.org/wiki/LightDM
					LIGHTDM_DSPMGR_SYSTEMD=lightdm.service
					LIGHTDM_DSPMGR_OPENRC=lightdm
					LIGHTDM_APPAPP_EMERGE=x11-misc/lightdm                       
					#  LXDM - https://wiki.gentoo.org/wiki/LXDE (always links to lxde by time of this writing)					
					LXDM_DSPMGR_SYSTEMD=lxdm.service
					LXDM_DSPMGR_OPENRC=lxdm # (startlxde ?)
					LXDM_APPAPP_EMERGE=lxde-base/lxdm
					#  QINGY - https://wiki.gentoo.org/wiki/ QINGY
					QINGY_DSPMGR_SYSTEMD=qingy.service
					QINGY_DSPMGR_OPENRC=qingy
					QINGY_APPAPP_EMERGE=placeholder
					#  SSDM - https://wiki.gentoo.org/wiki/SSDM
					SSDM_DSPMGR_SYSTEMD=sddm.service
					SSDM_DSPMGR_OPENRC=sddm
					SSDM_APPAPP_EMERGE=x11-misc/sddm                      
					#  SLIM - https://wiki.gentoo.org/wiki/SLiM
					SLIM_DSPMGR_SYSTEMD=slim.service
					SLIM_DSPMGR_OPENRC=slim
					SLIM_APPAPP_EMERGE=x11-misc/slim                                            
					#  WDM - https://wiki.gentoo.org/wiki/WDM
					WDM_DSPMGR_SYSTEMD=wdm.service
					WDM_DSPMGR_OPENRC=wdm
					WDM_APPAPP_EMERGE=x11-misc/wdm                 
					#  XDM - https://packages.gentoo.org/packages/x11-apps/xdm
					XDM_DSPMGR_SYSTEMD=xdm.service
					XDM_DSPMGR_OPENRC=xdm
					XDM_APPAPP_EMERGE=x11-apps/xdm
					SETVAR_DSPMGR () {
						for i in $DISPLAYMGR
						do
							DSTENV_XEC=$DESKTOPENV\_DSTENV_XEC
							DSTENV_STARTX=$DESKTOPENV\_DSTENV_STARTX
							DSPMGR_AS=$i\_DSPMGR_$SYSINITVAR
							DSPMGR_XEC=$i\_DSPMGR_XEC
							DSPMGR_STARTX=$i\_DSPMGR_STARTX
							APPAPP_EMERGE=$i\_APPAPP_EMERGE
						done
					}
					DSPMGR_OPENRC () {
						sed -ie "s#llxdm#xdm#g" /etc/conf.d/xdm
						sed -ie "s#lxdm#xdm#g" /etc/conf.d/xdm
						sed -ie "s#xdm#${!DSPMGR_AS}#g" /etc/conf.d/xdm
						 cat /etc/conf.d/xdm
						cat << EOF > ~/.xinitrc 
						exec ${!DSTENV_STARTX}
EOF
						cat ~/.xinitrc 
						rc-update add dbus default
						rc-update add ${!DSPMGR_AS} default
					}
					DSPMGR_SYSTEMD () {
						systemctl enable $DSPMGR_SYSTEMD
					}
					CONFIGURE_DSPMGR () {
						if [ "$DISPLAYMGR" == "LXDM" ]; then 
						printf '%s\n' " ${!DSPMGR_AS}"
							sed -ie "s;^# session=/usr/bin/startlxde;session=/usr/bin/${!DSTENV_STARTX};g" /etc/lxdm/lxdm.conf
						elif [ "$DISPLAYMGR" == "LIGHTDM" ]; then 
							cat << 'EOF' > /usr/share/lightdm/lightdm.conf.d/50-xfce-greeter.conf
							[SeatDefaults]
							greeter-session=unity-greeter
							user-session=xfce
EOF
						else
							NOTICE_PLACEHOLDER
						fi
					}
					SETVAR_DSPMGR
					EMERGE_USERAPP_RD1
					DSPMGR_$SYSINITVAR
					CONFIGURE_DSPMGR
				}
				SETVAR_DSKTENV  # set the variables
				ADDREPO_DSTENV
				EMERGE_DSTENV
				MAIN_DESKTPENV_$SYSINITVAR
				$DISPLAYMGR_YESNO
			}
			WINDOWSYS
			DESKTOP_ENV
			# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		}
		USERAPP () {  # (!todo)
			USERAPP_GIT () {  # (note: already setup through use flag make.conf?)
				APPAPP_EMERGE="dev-vcs/git"
				PACKAGE_USE
				EMERGE_USERAPP_DEF
			}
			WEBBROWSER () {
				USERAPP_FIREFOX () {
					APPAPP_EMERGE="www-client/firefox"
					PACKAGE_USE
					ACC_KEYWORDS_USERAPP
					EMERGE_USERAPP_DEF
				}
				USERAPP_CHROMIUM () {  # (!todo)
					APPAPP_EMERGE="www-client/chromium"
					PACKAGE_USE
					EMERGE_USERAPP_DEF
					etc-update --automode -3
				}
				USERAPP_MIDORI () {  # (!todo)
					APPAPP_EMERGE="www-client/midori"
					PACKAGE_USE
					EMERGE_USERAPP_DEF
				}
				RUN_ALLYES () {
					for i in  ${!USERAPP_*}
					do
						if [ $(printf '%s\n' "${!i}") == "YES" ]; then
							$i
						else 
							printf '%s\n' "$i is set to ${!i}, test for boot fs ..." 
						fi
					done
				}
				RUN_ALLYES
			}
			# GIT
			WEBBROWSER
		}
		USERS () {
			ROOT () {  # (! default)
				echo "${bold}enter new root password${normal}"
				until passwd
				do
				  echo "${bold}enter new root password${normal}"
				done
			}
			ADMIN () {  # (!NOTE: default) - ok 
				ADD_GROUPS () {
				  # for group user sets in var do groupadd -- changeme
					groupadd plugdev
					groupadd power
					groupadd adm
				}
				ADD_USER () {
					ASK_PASSWD () {
						echo "${bold}enter new $SYSUSERNAME password${normal}"
						until passwd $SYSUSERNAME
						do
						  echo "${bold}enter new $SYSUSERNAME password${normal}"
						done
					}
					useradd -m -g users -G $USERGROUPS -s /bin/bash $SYSUSERNAME
					ASK_PASSWD
				}
				VIRTADMIN () {
					groupadd vboxguest
					gpasswd -a $SYSUSERNAME vboxguest
				}
				ADD_GROUPS
				ADD_USER
				VIRTADMIN
			}
			ROOT
			ADMIN
		} 
		FINISH () {  # tidy up installation files - ok
		
			rm -f /stage3-*.tar.*
			echo "${bold}Script finished all operations - END${normal}"
		
		} 
		## (RUN ENTIRE SCRIPT) (!changeme)
		#BASE  # (!test 19.01.2021 - ok) (keymaps for multilang ; update config aat keymaps corerct? !todo)
		#CORE
		#SCREENDSP
		USERAPP
		USERS
		# FINISH