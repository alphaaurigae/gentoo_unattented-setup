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
