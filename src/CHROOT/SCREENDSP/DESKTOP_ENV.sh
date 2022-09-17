	DESKTOP_ENV () {  # https://wiki.gentoo.org/wiki/Desktop_environment
	NOTICE_START
		#. /var/app/desk-env.sh
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
		NOTICE_START
			for i in $DESKTOPENV ; do
				DSTENV_XEC=$DESKTOPENV\_DSTENV_XEC
				DSTENV_STARTX=$DESKTOPENV\_DSTENV_STARTX
				DSTENV_EMERGE=$DESKTOPENV\_DSTENV_EMERGE
			done
		NOTICE_END
		}
		ADDREPO_DSTENV () {
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
		EMERGE_DSTENV () {
		NOTICE_START
			# emerge --ask gnome-extra/nm-applet
			if [ "$DESKTOPENV" == "DDM" ]; then
				GIT () {
				NOTICE_START
					APPAPP_EMERGE="dev-vcs/git "
					EMERGE_USERAPP_DEF
				NOTICE_END
				}
				ESELECT () {
				NOTICE_START
					APPAPP_EMERGE="app-eselect/eselect-repository "
					EMERGE_USERAPP_DEF
				NOTICE_END
				}
				DEEPIN_GIT () {
				NOTICE_START
					MAIN () {
					NOTICE_START
					eselect repository add deepin git https://github.com/zhtengw/deepin-overlay.git
					APPAPP_EMERGE="deepin "
					EMERGE_USERAPP_DEF
					NOTICE_END
					}
					PLUGIN () {
					NOTICE_START
					mkdir -pv /etc/portage/package.use
					sed -ie '#dde-base/dde-meta multimedia#d' /etc/portage/package.use/deepin
					echo "dde-base/dde-meta multimedia" >> /etc/portage/package.use/deepin
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
				PANTHEON_MAIN () {
				NOTICE_START
					APPAPP_EMERGE="pantheon-base/pantheon-shell "
					EMERGE_USERAPP_DEF
				NOTICE_END
				}
				PANTHEON_ADDON () {
				NOTICE_START
					APPAPP_EMERGE="media-video/audience x11-terms/pantheon-terminal "
					EMERGE_USERAPP_DEF
				NOTICE_END
				}
				PANTHEON_MAIN
				PANTHEON_ADDON
			elif [ "$DESKTOPENV" == "XFCE" ]; then
				MISC_XFCE () {
				NOTICE_START
					XFCEADDON () {
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
					EMERGE_ATWORLD_B
					EMERGE_USERAPP_DEF
					XFCEADDON
				NOTICE_END
				}
				MISC_XFCE
			else
				emerge $DSTENV_EMERGE
			fi
			ENVUD
		NOTICE_END
		}
		MAIN_DESKTPENV_OPENRC () {
		NOTICE_START
			AUTOSTART_NAME_OPENRC="dbus"
			AUTOSTART_DEFAULT_OPENRC
			AUTOSTART_NAME_OPENRC="xdm"
			AUTOSTART_DEFAULT_OPENRC
			AUTOSTART_NAME_OPENRC="elogind"  # elogind The systemd project's "logind", extracted to a standalone package https://github.com/elogind/elogind
			AUTOSTART_BOOT_OPENRC
		NOTICE_END
		}
		MAIN_DESKTPENV_SYSTEMD () {
		NOTICE_START
			AUTOSTART_NAME_SYSTEMD="dbus"
			AUTOSTART_DEFAULT_SYSTEMD
			AUTOSTART_NAME_SYSTEMD="systemd-logind"
			AUTOSTART_DEFAULT_SYSTEMD
			ENVUD
		NOTICE_END
		}
		DESKTENV_SOLO () {
		NOTICE_START
			DESKTENV_STARTX () {
			NOTICE_START
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
			NOTICE_END
			}
			DESKTENV_AUTOSTART_OPENRC () {
			NOTICE_START
				if [ "$DESKTOPENV" == "CINNAMON" ]; then
					cp /etc/xdg/autostart/nm-applet.desktop /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
					echo 'X-GNOME-Autostart-enabled=false' >> /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
					chown $SYSUSERNAME:$SYSUSERNAME /home/$SYSUSERNAME/.config/autostart/nm-applet.desktop
				else
					NOTICE_PLACEHOLDER
				fi
			NOTICE_END
			}
			DESKTENV_AUTOSTART_SYSTEMD () {
			NOTICE_START
				NOTICE_PLACEHOLDER
			NOTICE_END
			}
			DESKTENV_STARTX
			DESKTENV_AUTOSTART_$SYSINITVAR
		NOTICE_END
		}
		W_D_MGR () {  # Display_manager https://wiki.gentoo.org/wiki/Display_manager
		NOTICE_START
			#. /var/app/display-mgr.sh
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
			NOTICE_START
				for i in $DISPLAYMGR
				do
					DSTENV_XEC=$DESKTOPENV\_DSTENV_XEC
					DSTENV_STARTX=$DESKTOPENV\_DSTENV_STARTX
					DSPMGR_AS=$i\_DSPMGR_$SYSINITVAR
					DSPMGR_XEC=$i\_DSPMGR_XEC
					DSPMGR_STARTX=$i\_DSPMGR_STARTX
					APPAPP_EMERGE=$i\_APPAPP_EMERGE
				done
			NOTICE_END
			}
			DSPMGR_OPENRC () {
			NOTICE_START
				sed -ie "s#llxdm#xdm#g" /etc/conf.d/display-manager
				sed -ie "s#lxdm#xdm#g" /etc/conf.d/display-manager
				sed -ie "s#xdm#${!DSPMGR_AS}#g" /etc/conf.d/display-manager
				 cat /etc/conf.d/display-manager 
				cat << EOF > ~/.xinitrc 
				exec ${!DSTENV_STARTX}
EOF
				cat ~/.xinitrc 
				rc-update add dbus default
				rc-update add ${!DSPMGR_AS} default
			NOTICE_END
			}
			DSPMGR_SYSTEMD () {
			NOTICE_START
				systemctl enable $DSPMGR_SYSTEMD
			NOTICE_END
			}
			CONFIGURE_DSPMGR () {
			NOTICE_START
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
			NOTICE_END
			}
			SETVAR_DSPMGR
			EMERGE_USERAPP_RD1
			DSPMGR_$SYSINITVAR
			CONFIGURE_DSPMGR
		NOTICE_END
		}
		SETVAR_DSKTENV  # set the variables
		ADDREPO_DSTENV
		EMERGE_DSTENV
		MAIN_DESKTPENV_$SYSINITVAR
		$DISPLAYMGR_YESNO
	NOTICE_END
	}