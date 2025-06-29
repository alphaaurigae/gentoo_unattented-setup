# USEFLAGS # func/func_chroot_main.sh to set the useflags with emerged packages in src/CHROOT/*
# SET USEFLAGS (!NOTE: names follow a pattern which must be kept for functions to read it ... "USERFLADS_"emerge_ name"  : "-" is replaced with "_" and lower converted to uppercase letters)

. /gentoo_unattented-setup/var/var_main.sh

# CHROOT ENV
SOURCE_CHROOT() {
	NOTICE_START
	env-update
	source /etc/profile
	export PS1="(chroot) $PS1"
	NOTICE_END
}
SOURCE_CHROOT # (must run before CHROOT VARIABLES??)

# BASE
### INITSYSTEM
SYSINITVAR="OPENRC" # OPENRC; SYSTEMD (!todo) # Used script-wide to choose install routine for based on initsystem

# ESELECT PROFILE  # https://wiki.gentoo.org/wiki/Profile_(Portage)
ESELECT_PROFILE="41" # run.sh and src/CHROOT/BASE/ESELECT_PROFILE.sh

## LOCALES TIME / DATE MAIN
SYSDATE_MAN_OPENRC="071604551969" # src/CHROOT/BASE/SYSTEMTIME.sh
SYSDATE_MAN_SYSTEMD="1969-07-16 04:55:42"
SYSCLOCK_SET="AUTO"     # USE AUTO / MANUAL -- MANUAL="NO TIMESYNCED SERVICE"   # src/CHROOT/BASE/SYSTEMTIME.sh
SYSTIMEZONE_SET="UTC"   # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Timezone # https://wiki.gentoo.org/wiki/System_time#Time_zone   # src/CHROOT/BASE/SYSTEMTIME.sh
SET_RTC="UTC"           # local / UTC hwclock
NTP_PROVIDER="openntpd" # "openntpd", "crony", "ntpd" for both openrc and systemd. For systemd additoinal "systemd-timesyncd"


# ++++++++++++++++++++++++++++++++++++++++++++++++
# CORE - START
# ++++++++++++++++++++++++++++++++++++++++++++++++

USEFLAGS_LINUX_FIRMWARE="initramfs redistributable unknown-license" # https://packages.gentoo.org/packages/sys-kernel/linux-firmware https://wiki.gentoo.org/wiki/Linux_firmware

## KERNEL VAR START ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
INSTALLKERNEL="true" # true # false to use installkernel https://wiki.gentoo.org/wiki/Installkernel
KERNDEPLOY="MANUAL"  # MANUAL # AUTO (genkernel)  # src/CHROOT/CORE/KERNEL.sh
KERNVERS="5.3-rc4"   # NO EFFECT FOR DEFAULT EMERGE # src/CHROOT/CORE/KERNEL.sh
KERNSOURCES="EMERGE" # EMERGE # TORVALDS (git repository) # src/CHROOT/CORE/KERNEL.sh

# ----------------------------------------------------------------------------------------------
## SAMPLE FOR "KERNCONFD=" on the bottom of this section.

## MENUCONFIG_NEW = (menuconfig - ONLY)

## Update current config utilising a provided .config as base
## OLDCONFIG_NOMENU = (defconfig - ONLY)
## OLDCONFIG_MENU = (oldconfig + menuconfig)

## Same as oldconfig but sets new symbols to their default value without prompting
## OLDDEFCONFIG_NOMENU = (olddefconfig - ONLY)
## OLDDEFCONFIG_MENU = (olddefconfig + menuconfig)

## New config where all options are accepted with yes
## ALLYESCONFIG_NOMENU = (allyesconfig - ONLY)
## ALLYESCONFIG_MENU = (allyesconfig + menuconfig)

## New config with default from ARCH supplied defconfig
## DEFCONFIG_NOMENU = (defconfig - ONLY)
## DEFCONFIG_MENU = (defconfig + menuconfig)

## Configure the tiniest possible kernel
## TINY_NOMENU = (defconfig - ONLY)
## TINY_MENU = (defconfig + menuconfig)

KERNCONFD="OLDCONFIG_MENU"    # OLDCONFIG_MENU  # src/CHROOT/CORE/KERNEL.sh ; Preconfigured kernel updated with Y / N prompt and additional menuconfig.
USEFLAGS_INSTALLKERNEL="dracut grub" # https://wiki.gentoo.org/wiki/Installkernel

# ----------------------------------------------------------------------------------------------

### INITRAMFS
GENINITRAMFS="DRACUT" # DRACUT; GENKERNEL # src/CHROOT/CORE/INITRAM.sh

## GENKERNEL
GENKERNEL_CMD="--luks --lvm --no-zfs all" # src/CHROOT/CORE/INITRAM.sh
USEFLAGS_GENKERNEL="cryptsetup"

## INITRAM VAR START ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
## DRACUT

# <key>+=" <values> ": <values> should have surrounding white spaces!
DRACUT_CONF_MODULES_LVM=" i18n kernel-modules rootfs-block udev-rules usrmount base fs-lib shutdown lvm debug dm "                        # For LVM on /dev/sd**  (CRYPSETUP="NO" /var/var_main )  # src/CHROOT/CORE/INITRAM.sh
DRACUT_CONF_MODULES_CRYPTSETUP=" i18n kernel-modules rootfs-block udev-rules usrmount base fs-lib shutdown crypt crypt-gpg lvm debug dm " # For LVM on cryptsetup /dev/sd** (CRYPSETUP="YES" /var/var_main ) # src/CHROOT/CORE/INITRAM.sh
DRACUT_CONF_HOSTONLY="yes"                                                                                                                # src/CHROOT/CORE/INITRAM.sh
DRACUT_CONF_LVMCONF="yes"                                                                                                                 # src/CHROOT/CORE/INITRAM.sh
#DRACUT_CONFD_ADD_DRACUT_MODULES="usrmount"  # src/CHROOT/CORE/INITRAM.sh
USEFLAGS_DRACUT="device-mapper" #  https://wiki.gentoo.org/wiki/Dracut https://packages.gentoo.org/packages/sys-kernel/dracut


## BOOT VAR START ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
BOOTLOADER="GRUB2" # GRUB2 ..... src/CHROOT/CORE/SYSBOOT.sh
GRUB_PRELOAD_MODULES_CRYPTSETUP="cryptodisk luks luks2 lvm ext2 part_msdos part_gpt gcry_*"
GRUB_PRELOAD_MODULES_DEFAULT="cryptodisk luks luks2 lvm ext2 part_msdos part_gpt gcry_*"
USEFLAGS_GRUB2="fonts device-mapper mount nls " # https://packages.gentoo.org/packages/sys-boot/grub https://wiki.gentoo.org/wiki/GRUB2


## SYSAPP VAR START ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
### CRON
CRON="CRONIE" # CRONIE, DCRON, ANACRON # src/CHROOT/CORE/SYSPROCESS.sh

# FSTOOLS -- (note!: this is not activating kernel settings yet - solely for FSTOOLS)
# placeholder? check later
FSTOOLS_EXT="YES"
FSTOOLS_XFS="NO"
FSTOOLS_REISER="NO"
FSTOOLS_JFS="NO"
FSTOOLS_VFAT="NO"
FSTOOLS_BTRFS="NO"

## LOG
SYSLOG="SYSLOGNG" # src/CHROOT/CORE/APPADMIN.sh

# SYSAPP_ YES / NO
SYSAPP_DMCRYPT="YES" # var/chroot_variables.sh && src/CHROOT/BASE/MAKECONF.sh
USEFLAGS_CRYPTSETUP="udev argon2 " # global https://packages.gentoo.org/packages/sys-fs/cryptsetup
SYSAPP_LVM2="YES"    # must be set to YES, required with all setups for now - lvm on root and lvm on cryptsetup
SYSAPP_SUDO="YES"
SYSAPP_PCIUTILS="YES"
SYSAPP_MULTIPATH="YES"
SYSAPP_GNUPG="NO"
SYSAPP_OSPROBER="YES"
SYSAPP_SYSLOG="NO"
SYSAPP_CRON="NO"
SYSAPP_FILEINDEXING="NO"

## NETWORK  # src/CHROOT/CORE/NETWORK.sh
HOSTNAME="gentoohost"
DOMAIN="gentoodomain"
IPV4_CONF="YES" # YES ; NO # IF set to YES for DHCP setup no further settings need to be customized - for STATIC check the configs...
IPV6_CONF="YES"  # "
NETWORK_NET="DHCP"  # DHCP or STATIC (static blueprint only)
NETWORK_CHOICE="NETIFRC" # NETWORKMANAGER or NETIFRC (ifrc not completed yet, blueprint only) (choose between networkmanager or ifrc setup.
NETWMGR="NETWORKMANAGER" # NETWORKMANAGER  (for later integration w possible different networkmanagers)
# NIC1="enp0s3" # not in use , defined by functinon in src/CORE/NETWORK_MAIN.sh - based on pci slot (not relevant for dhcp setup)

MTU_NIC1="1500"
NETMASK_NIC1_STATIC="255.255.255.0"
IPV4_NIC1_STATIC="192.168.178.7"
IPV6_NIC1_STATIC="2003:d1:b74e:b300:abcd:ef12:3456:789a"
IPV6_PREFIX_NIC1_STATIC="64"
IPV4_GATEWAY_STATIC="192.168.178.1"
IPV6_GATEWAY_STATIC="fe80::f2b0:14ff:fee9:f625"

NETIFRC_IPV6_ENABLE="no" # Enables IPv6 stack for interface.
NETIFRC_IPV6_DHCP_ENABLE="no" # Enables the DHCPv6 client requesting IPv6 addresses or options from a DHCPv6 server.

FIREWALL="IPTABLES" # UFW, IPTABLES (iptables blueprint only)
# DEFAULT RULES  # Space deparated list of port/protocol e.g 1337/udp - default is deny in and out.

# ------------------
# Basic Workstation OUT
# 80/tcp - HTTP
# 443/tcp - HTTPS
# 53/udp - DNS
# 22/tcp - SSH
# 873/tcp - Rsync
# 123/udp - NTP
# ------------------
# Default reject / deny all OUT
# DNS already set to specific destination. Thus 53/udp not enabled here. See src/CORE/NETWORK/NETWORK_FIREWALL.sh
ALLOW_PORT_OUT="80/tcp 443/tcp 22/tcp 873/tcp 123/udp"

# Define ips / subnets that are allowed to connect to ALLOW_IN ports IN.
DNS_ALLOW_OUT="YES" # Unless you do not want DNS allowed for either DEFAULT (ISP) ; CUSTOM (custom DNS on $NAMESERVER* or dnsmsaq with $NAMESERVER* - leave this YES ... See src/CORE/NETWORK/NETWORK_FIREWALL.sh
USE_DNSMASQ="NO"  # not integrated yet, this variable only tells IPTABLES that its not a dnsmasq setup as of now.

SSH_IN="YES"
# SSH_PORT="22"
ALLOW_SSH_LOCAL_IN="192.168.178.0/24"
ALLOW_SSH_REMOTE_IN="" # none by default

# Default reject / deny all IN - may allow port/protocol in 
ALLOW_PORT_IN=""


# DNS
DNS_PROVIDER="CUSTOM" # CUSTOM (As defined in variables below; DEFAULT (No custom DNS servers added)
# https://en.wikipedia.org/wiki/Public_recursive_name_server
# Cloudflare set default!
NAMESERVER1_IPV4="1.1.1.1"
NAMESERVER1_IPV6="2606:4700:4700::1111"
NAMESERVER2_IPV4="1.0.0.1"
NAMESERVER2_IPV6="2606:4700:4700::1001"

USEFLAGS_NETWORKMANAGER="dhcpcd -modemmanager -ppp" # https://packages.gentoo.org/packages/net-misc/networkmanager https://wiki.gentoo.org/wiki/NetworkManager

# VIRTUALIZATION
SYSVARD="GUEST" # host is GUEST & HOST ... for virtualbization setup  # src/CHROOT/CORE/APPEMULATION.sh
USEFLAGS_VIRTUALBOX_GUEST_ADDITIONS="X" # https://packages.gentoo.org/packages/app-emulation/virtualbox-guest-additions

# DISPLAY / SCREEN  # src/CHROOT/SCREENDSP/WINDOWSYS.sh
DISPLAYSERV="X11"
DISPLAYMGR_YESNO="W_D_MGR" # W_D_MGR (WITH display manager) / SOLO (without display manager)
DISPLAYMGR="LXDM"          # CDM; GDM; LIGHTDM; LXDM (!default - other env untested / todo); QINGY; SSDM; SLIM; WDM; XDM
DESKTOPENV="XFCE"          # XFCE - other env untested / todo); BUDGIE; CINNAMON; FVWM; GNOME; KDE; LXDE; LXQT; LUMINA; MATE; PANTHEON; RAZORQT; TDE;
USEFLAGS_XFCE4_META="gtk3 gcr" # https://packages.gentoo.org/packages/xfce-base/xfce4-meta https://wiki.gentoo.org/wiki/Xfce

# X11
## X11 KEYBOARD  # src/CHROOT/SCREENDSP/WINDOWSYS.sh
X11_KEYBOARD_XKB_VARIANT="altgr-intl,abnt2"
X11_KEYBOARD_XKB_OPTIONS="grp:shift_toggle,grp_led:scroll"
X11_KEYBOARD_MATCHISKEYBOARD="on"
USEFLAGS_XORG_SERVER="xvfb"    # https://packages.gentoo.org/packages/x11-base/xorg-server https://wiki.gentoo.org/wiki/Xorg

# GRAPHIC UNIT  # src/CHROOT/CORE/GPU.sh
#GPU_SET="amdgpu"  # amdgpu, radeon # (!todo)

# AUDIO
# USEFLAGS_ALSA=""  # https://packages.gentoo.org/packages/media-sound/alsa-utils  https://wiki.gentoo.org/wiki/ALSA
USEFLAGS_PULSEAUDIO="" # https://packages.gentoo.org/packages/media-sound/pulseaudio https://wiki.gentoo.org/wiki/PulseAudio

# USERAPP
USERAPP_GIT="NO" # (!todo)

# WEBBROWSER
USERAPP_FIREFOX="YES"
USEFLAGS_FIREFOX="bindist eme-free geckodriver hwaccel jack -system-libvpx -system-icu" # https://packages.gentoo.org/packages/www-client/firefox

USERAPP_CHROMIUM="NO" # (!NOTE !todo !bug ..)
USEFLAGS_CHROMIUM="official -cups -hangouts -kerberos -screencast -pic"  # https://packages.gentoo.org/packages/www-client/chromium # https://wiki.gentoo.org/wiki/Chromium

USERAPP_MIDORI="NO"   # (!NOTE: some unmask thing .. ruby?)  # https://astian.org/en/midori-browser/
USEFLAGS_MIDORI=""

## USER
SYSUSERNAME="admini"  #  wheel group member - name of the login sysadmin user  # src/CHROOT/USERS/ADMIN.sh && src/CHROOT/SCREENDSP/DESKTOP_ENV.sh
USERGROUPS="wheel plugdev power video" # (!NOTE: virtualbox groups set if guest / host system is set)  # src/CHROOT/USERS/ADMIN.sh





