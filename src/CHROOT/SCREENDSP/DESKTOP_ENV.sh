DESKTOP_ENV() { # https://wiki.gentoo.org/wiki/Desktop_environment
	NOTICE_START


#	sanitize_varname() {
#	  echo "$1" | tr '/-' '__'
#	}
#
#	SETVAR_DSKTENV() {
#		NOTICE_START
#		. /gentoo_unattented-setup/var/app/desktop_env.sh
#		local sanitized
#		sanitized=$(sanitize_varname "$DESKTOPENV")
#
#		local DSTENV_XEC_VAR="${sanitized}_DSTENV_XEC"
#		DSTENV_XEC="${!DSTENV_XEC_VAR}"
#
#		local DSTENV_STARTX_VAR="${sanitized}_DSTENV_STARTX"
#		DSTENV_STARTX="${!DSTENV_STARTX_VAR}"
#
#		local DSTENV_EMERGE_VAR="${sanitized}_DSTENV_EMERGE"
#		DSTENV_EMERGE="${!DSTENV_EMERGE_VAR}"
#
#		NOTICE_END
#	}
	SETVAR_DSKTENV() {
		NOTICE_START
		for i in $DESKTOPENV; do
			DSTENV_XEC=$DESKTOPENV\_DSTENV_XEC
			DSTENV_STARTX=$DESKTOPENV\_DSTENV_STARTX
			DSTENV_EMERGE=$DESKTOPENV\_DSTENV_EMERGE
		done
		NOTICE_END
	}
	ADDREPO_DSTENV() {
		NOTICE_START
		if [ "$DESKTOPENV" == "PANTHEON" ]; then
			layman -a elementary
			eselect repository enable elementary
			emerge --sync elementary
		else
			NOTICE_PLACEHOLDER
		fi
		NOTICE_END
	}
	EMERGE_DSTENV() {
		NOTICE_START
		# emerge --ask gnome-extra/nm-applet
		if [ "$DESKTOPENV" == "DDM" ]; then
			GIT() {
				NOTICE_START
				APPAPP_EMERGE="dev-vcs/git "
				EMERGE_USERAPP_DEF
				NOTICE_END
			}
			ESELECT() {
				NOTICE_START
				APPAPP_EMERGE="app-eselect/eselect-repository "
				EMERGE_USERAPP_DEF
				NOTICE_END
			}
			DEEPIN_GIT() {
				NOTICE_START
				MAIN() {
					NOTICE_START
					eselect repository add deepin git https://github.com/zhtengw/deepin-overlay.git
					APPAPP_EMERGE="deepin "
					EMERGE_USERAPP_DEF
					NOTICE_END
				}
				PLUGIN() {
					NOTICE_START
					mkdir -pv /etc/portage/package.use
					sed -i '/dde-base\/dde-meta multimedia/d' /etc/portage/package.use/deepin
					printf '%s\n' "dde-base/dde-meta multimedia" >>/etc/portage/package.use/deepin
					APPAPP_EMERGE="dde-base/dde-meta "
					EMERGE_USERAPP_DEF
					NOTICE_END
				}
				MAIN
				PLUGIN
				NOTICE_END
			}
			GIT
			ESELECT
			DEEPIN_GIT
		elif [ "$DESKTOPENV" == "PANTHEON" ]; then
			PANTHEON_MAIN() {
				NOTICE_START
				APPAPP_EMERGE="pantheon-base/pantheon-shell "
				EMERGE_USERAPP_DEF
				NOTICE_END
			}
			PANTHEON_ADDON() {
				NOTICE_START
				APPAPP_EMERGE="media-video/audience x11-terms/pantheon-terminal "
				EMERGE_USERAPP_DEF
				NOTICE_END
			}
			PANTHEON_MAIN
			PANTHEON_ADDON
		elif [ "$DESKTOPENV" == "XFCE" ]; then
			MISC_XFCE() {
				NOTICE_START
				XFCEADDON() {
					NOTICE_START
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
					#emerge XFCE-pulseaudio-plugin
					# emerge xfce-extra/xfce4-mixer  # not found 17.11.19
					emerge xfce-extra/xfce4-alsa-plugin
					# emerge xfce-extra/thunar-volman
					NOTICE_END
				}
				APPAPP_EMERGE="xfce-base/xfce4-meta "
				PACKAGE_USE
				EMERGE_ATWORLD
				EMERGE_USERAPP_DEF
				XFCEADDON
				NOTICE_END
			}
			MISC_XFCE
		else
			emerge "$DSTENV_EMERGE"
		fi
		ENVUD
		NOTICE_END
	}
	MAIN_DESKTPENV_OPENRC() {
		NOTICE_START
		AUTOSTART_NAME_OPENRC="dbus"
		AUTOSTART_DEFAULT_OPENRC
		AUTOSTART_NAME_OPENRC="xdm"
		AUTOSTART_DEFAULT_OPENRC
		AUTOSTART_NAME_OPENRC="elogind" # elogind The systemd project's "logind", extracted to a standalone package https://github.com/elogind/elogind
		AUTOSTART_BOOT_OPENRC
		NOTICE_END
	}
	MAIN_DESKTPENV_SYSTEMD() {
		NOTICE_START
		AUTOSTART_NAME_SYSTEMD="dbus"
		AUTOSTART_DEFAULT_SYSTEMD
		AUTOSTART_NAME_SYSTEMD="systemd-logind"
		AUTOSTART_DEFAULT_SYSTEMD
		ENVUD
		NOTICE_END
	}
	DESKTENV_SOLO() {
		NOTICE_START
		DESKTENV_STARTX() {
			NOTICE_START
			if [ "$DESKTOPENV" == "LUMINA" ]; then
				cat <<-EOF >~/.xinitrc
					[[ -f ~/.Xresources ]]
					xrdb -merge -I/home/$SYSUSERNAME ~/.Xresources
					exec start-lumina-desktop
				EOF
			else
				cat <<-EOF >~/.xinitrc
					exec $DSTENV_STARTX
				EOF
			fi
			NOTICE_END
		}
		DESKTENV_AUTOSTART_OPENRC() {
			NOTICE_START
			if [ "$DESKTOPENV" == "CINNAMON" ]; then
				#cp /etc/xdg/autostart/nm-applet.desktop /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
				mkdir -p /home/$SYSUSERNAME/.config/autostart
				local SRC="/etc/xdg/autostart/nm-applet.desktop"
				local DST="/home/$SYSUSERNAME/.config/autostart/nm-applet.desktop"
				cp "$SRC" "$DST" && VERIFY_COPY "$SRC" "$DST"

				printf '%s\n' 'X-GNOME-Autostart-enabled=false' >>/home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
				chown $SYSUSERNAME:$SYSUSERNAME /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
			else
				NOTICE_PLACEHOLDER
			fi
			NOTICE_END
		}
		DESKTENV_AUTOSTART_SYSTEMD() {
			NOTICE_START
			NOTICE_PLACEHOLDER
			NOTICE_END
		}
		DESKTENV_STARTX
		DESKTENV_AUTOSTART_$SYSINITVAR
		NOTICE_END
	}
	W_D_MGR() { # Display_manager https://wiki.gentoo.org/wiki/Display_manager
		NOTICE_START
		. gentoo_unattented-setup/var/app/display_mgr.sh  

#		SETVAR_DSPMGR() {
#			NOTICE_START
#			local sanitized
#			sanitized=$(sanitize_varname "$DISPLAYMGR")
#
#			local DSTENV_XEC_VAR="${sanitized}_DSTENV_XEC"
#			DSTENV_XEC="${!DSTENV_XEC_VAR}"
#
#			local DSTENV_STARTX_VAR="${sanitized}_DSTENV_STARTX"
#			DSTENV_STARTX="${!DSTENV_STARTX_VAR}"
#
#			local DSPMGR_AS_VAR="${sanitized}_DSPMGR_${SYSINITVAR}"
#			DSPMGR_AS="${!DSPMGR_AS_VAR}"
#
#			local DSPMGR_XEC_VAR="${sanitized}_DSPMGR_XEC"
#			DSPMGR_XEC="${!DSPMGR_XEC_VAR}"
#
#			local DSPMGR_STARTX_VAR="${sanitized}_DSPMGR_STARTX"
#			DSPMGR_STARTX="${!DSPMGR_STARTX_VAR}"
#
#			local APPAPP_EMERGE_VAR="${sanitized}_APPAPP_EMERGE"
#			APPAPP_EMERGE="${!APPAPP_EMERGE_VAR}"
#
#			NOTICE_END
#		}
		SETVAR_DSPMGR() {
			NOTICE_START
			for i in $DISPLAYMGR; do
				DSTENV_XEC="${DESKTOPENV}_DSTENV_XEC"
				DSTENV_STARTX="${DESKTOPENV}_DSTENV_STARTX"
				DSPMGR_AS="${i}_DSPMGR_${SYSINITVAR}"
				DSPMGR_XEC="${i}_DSPMGR_XEC"
				DSPMGR_STARTX="${i}_DSPMGR_STARTX"
				APPAPP_EMERGE="${i}_APPAPP_EMERGE"
			done
			NOTICE_END
		}
		DSPMGR_OPENRC() {
			NOTICE_START
			sed -ie "s#llxdm#xdm#g" /etc/conf.d/display-manager
			sed -ie "s#lxdm#xdm#g" /etc/conf.d/display-manager
			sed -ie "s#xdm#${!DSPMGR_AS}#g" /etc/conf.d/display-manager
			cat /etc/conf.d/display-manager
			cat <<-EOF >~/.xinitrc
				exec ${!DSTENV_STARTX}
			EOF
			cat ~/.xinitrc
			rc-update add dbus default
			rc-update add ${!DSPMGR_AS} default
			NOTICE_END
		}
		DSPMGR_SYSTEMD() {
			NOTICE_START
			systemctl enable "$DSPMGR_SYSTEMD"
			NOTICE_END
		}
		CONFIGURE_DSPMGR() {
			NOTICE_START
			if [ "$DISPLAYMGR" == "LXDM" ]; then
				printf '%s\n' " ${!DSPMGR_AS}"
				sed -ie "s;^# session=/usr/bin/startlxde;session=/usr/bin/${!DSTENV_STARTX};g" /etc/lxdm/lxdm.conf
			elif [ "$DISPLAYMGR" == "LIGHTDM" ]; then
				cat <<-'EOF' >/usr/share/lightdm/lightdm.conf.d/50-xfce-greeter.conf
					[SeatDefaults]
					greeter-session=unity-greeter
					user-session=xfce
				EOF
			else
				NOTICE_PLACEHOLDER
			fi
			NOTICE_END
		}
		SETVAR_DSPMGR
		EMERGE_USERAPP_RD1
		DSPMGR_$SYSINITVAR
		CONFIGURE_DSPMGR
		NOTICE_END
	}
	SETVAR_DSKTENV
	ADDREPO_DSTENV
	EMERGE_DSTENV
	MAIN_DESKTPENV_$SYSINITVAR
	$DISPLAYMGR_YESNO
	NOTICE_END
}
