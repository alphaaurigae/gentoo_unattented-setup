CRYPTSETUP="NO" # THIS VAR DEFINES IF CRYPTSETUP IS ACTIVATED FOR ROOT,  # YES DEPENDS ON var/chroot_variables.sh SYSAPP_DMCRYPT="YES"!!!! if set to no and SYSAPP_DMCRYPT="YES" #crypset is defined in useflag as option var/chroot_variables.sh
# OPTION AS IS NO = LVM ON ROOT ; YES = LVM ON CRYPTSETUP_ROOT
DSK_SRV="DESKTOP" # DESKTOP, SERVER (setup in progress, doesent change anything except USE set for make.conf which is also the same yet....

BOOTINITVAR="BIOS" # BIOS  / UEFI   # Used in src/CHROOT/CORE/SYSCONFIG_CORE.sh && src/CHROOT/CORE/SYSBOOT.s

## DRIVES & PARTITIONS
HDD1="/dev/sda"
# GRUB_PART=/dev/sda1
BOOT_PART="/dev/sda2"
MAIN_PART="/dev/sda3"

## SWAP # put here since you can set a swapfile on an external device too.
### SWAPFILE  # Useful during install on low ram VM's (use KVM to avoid erros; ex firefox avx2 err.)
SWAPFILE="swapfile1"
SWAPFD="/swapdir" # swap-file directory path
SWAPSIZE="50G"    # swap file size with unit APPEND | G = gigabytes
### SWAP PARTITION
# SWAP0=swap0  # LVM swap NAME for sorting of swap partitions.
# SWAP_SIZE="1GB"  # (inside LVM MAIN_PART)
# SWAP_FS=linux-swap # swapfs

## FILESYSTEMS  # (Note!: FSTOOLS ; FSTAB) (note!: nopt a duplicate - match these above)
FILESYSTEM_BOOT="ext2" # BOOT
FILESYSTEM_MAIN="ext4" # GENTOO

## LVM
PV_MAIN="pv0" # LVM PV physical volume
VG_MAIN="vg0" # LVM VG volume group
LV_MAIN="lv0" # LVM LV logical volume

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# STATIC CUSTOM
## chroot_variables.sh ; make.conf ; src/CHROOT/SCREENDSP/WINDOWSYS.sh
LANG_MAIN_LOWER="en"
LANG_MAIN_UPPER="US"
LANG_SECOND_LOWER="de"
LANG_SECOND_UPPER="DE"

# LOCALES
# LOCALES / LANG MAIN
PRESET_LOCALE_A=$LANG_MAIN_LOWER\_$LANG_MAIN_UPPER     # lang set 1 # set ISO-8859-1 & UTF-8 locales in  /etc/locale.gen  # src/CHROOT/BASE/CONF_LOCALES.sh
PRESET_LOCALE_B=$LANG_SECOND_LOWER\_$LANG_SECOND_UPPER # lang set 2 # "   # src/CHROOT/BASE/CONF_LOCALES.sh

# LOCALES LANG KEYMAPS MAIN
KEYMAP="de"               # set common (!channgeme)  # src/CHROOT/BASE/KEYMAP_CONSOLEFONT.sh && src/CHROOT/SCREENDSP/WINDOWSYS.sh
CONSOLEFONT="default8x16" # https://wiki.gentoo.org/wiki/Fonts  # src/CHROOT/BASE/KEYMAP_CONSOLEFONT.sh

#XkbVariant="neo" # de: neu # en:dvorak
# ++++++++++++++++++++++++++++++++++++++++++++++++++++
# MAKE.CONF START

## MAKE.CONF PRESET src/CHROOT/BASE/MAKECONF.sh
# https://github.com/gentoo/portage/blob/master/cnf/make.conf.example

PRESET_CC="gcc" # gcc (!default);

# https://wiki.gentoo.org/wiki/ACCEPT_KEYWORDS
PRESET_ACCEPT_KEYWORDS="amd64" # "amd64" = stable

# CHOST # https://wiki.gentoo.org/wiki/CHOST
PRESET_CHOST_ARCH="x86_64"
PRESET_CHOST_VENDOR="pc"
PRESET_CHOST_OS="linux"
PRESET_CHOST_LIBC="gnu"

# https://wiki.gentoo.org/wiki/CHOST
# https://wiki.gentoo.org/wiki/GCC_optimization

PRESET_CPU_FLAGS_X86="$(cpuid2cpuflags | cut -d: -f2 | xargs | cat -A)"

# firefox build fail on znver1 if march set to native
PRESET_MARCH="znver1" # 1/2 default "native"; see "safe_cflags" & may dep kern settings; proc arch specific
# https://wiki.gentoo.org/wiki/Safe_CFLAGS#Finding_the_CPU

PRESET_CONFIG_PROTECT="/etc /usr/share/config /usr/share/gnupg/qualified.txt"
PRESET_CONFIG_PROTECT_MASK=""

PRESET_COMMON_FLAGS="-march=$PRESET_MARCH -mtune=$PRESET_MARCH -fPIC -O2 -pipe -fstack-protector-strong "
#PRESET_COMMON_FLAGS="-march=$PRESET_MARCH -mtune=$PRESET_MARCH -fPIC -O2 -pipe"
PRESET_CFLAGS="${PRESET_COMMON_FLAGS}"                                          # https://wiki.gentoo.org/wiki/Safe_CFLAGS
PRESET_CXXFLAGS="${PRESET_COMMON_FLAGS}"
PRESET_FCFLAGS="${PRESET_COMMON_FLAGS}"
PRESET_FFLAGS="${PRESET_COMMON_FLAGS}"
#PRESET_LDFLAGS="-Wl,-O1 -Wl,--sort-common -Wl,-z,now -Wl,-z,relro"
PRESET_LDFLAGS="-Wl,-O1 -Wl,--as-needed -Wl,--sort-common -Wl,-z,now -Wl,-z,relro"
PRESET_RUSTFLAGS="-C target-cpu=$PRESET_MARCH"

# https://wiki.gentoo.org/wiki/User:GYakovlev/Rust#Configuration_for_use_with_portage
# https://forums.gentoo.org/viewtopic-p-8492912.html?sid=8298553159a9736fa48ea56002b1b834
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#CFLAGS_and_CXXFLAGS

PRESET_INPUTEVICE="libinput keyboard"
PRESET_VIDEODRIVER="virtualbox" # amdgpu, radeonsi, radeon, virtualbox ; (!NOTE: Virtualbox and intend to build firefox - run KVM and set to your hardware, native arch with virtualbox display driver fails - set arch ... "avx2 error firefox")
PRESET_LICENCES="*"           # Default: "-* @FREE" Only accept licenses in the FREE license group (i.e. Free Software) (!todo)

# https://www.gentoo.org/support/use-flags/

PRESET_USEFLAG_CRYPTSETUP_DESKTOP="X a52 aac aalib acl acpi apng apparmor audit alsa bash-completion boost branding bzip2 \
cpudetection cjk cxx dbus elogind ffmpeg git gtk gtk3 gzip \
hardened initramfs int64 lzma lzo lvm mount opengl pulseaudio jack policykit postproc secure-delete \
sqlite threads udev udisks unicode zip \
-consolekit -cups -bluetooth -libnotify -modemmanager -mysql -apache -apache2 -dropbear -redis \
-systemd -mssql -postgres -ppp -telnet"

PRESET_USEFLAG_CRYPTSETUP_SERVER="X a52 aac aalib acl acpi apng apparmor audit alsa bash-completion boost branding bzip2 \
cpudetection cjk cxx dbus elogind ffmpeg git gtk gtk3 gzip \
hardened initramfs int64 lzma lzo lvm mount opengl pulseaudio jack policykit postproc secure-delete \
sqlite threads udev udisks unicode zip \
-consolekit -cups -bluetooth -libnotify -modemmanager -mysql -apache -apache2 -dropbear -redis \
-systemd -mssql -postgres -ppp -telnet"

# Copied from cryptsetup, adjust ...
PRESET_USEFLAG_LVMROOT_DESKTOP="X a52 aac aalib acl acpi apng apparmor audit alsa bash-completion boost branding bzip2 \
cpudetection cjk cxx dbus elogind ffmpeg git gtk gtk3 gzip \
hardened initramfs int64 lzma lzo lvm mount opengl pulseaudio jack policykit postproc secure-delete \
sqlite threads udev udisks unicode zip \
-consolekit -cups -bluetooth -libnotify -modemmanager -mysql -apache -apache2 -dropbear -redis \
-systemd -mssql -postgres -ppp -telnet"

PRESET_USEFLAG_LVMROOT_SERVER="X a52 aac aalib acl acpi apng apparmor audit alsa bash-completion boost branding bzip2 \
cpudetection cjk cxx dbus elogind ffmpeg git gtk gtk3 gzip \
hardened initramfs int64 lzma lzo lvm mount opengl pulseaudio jack policykit postproc secure-delete \
sqlite threads udev udisks unicode zip \
-consolekit -cups -bluetooth -libnotify -modemmanager -mysql -apache -apache2 -dropbear -redis \
-systemd -mssql -postgres -ppp -telnet"

# test
#PRESET_USEFLAG_LVMROOT="X a52 aac aalib acl acpi apng apparmor alsa bash-completion boost branding bzip2 \
#cpudetection cjk cxx dbus elogind ffmpeg git gtk gtk3 gzip \
#hardened initramfs int64 lzma lzo lvm mount opengl pulseaudio jack policykit postproc \
#sqlite threads udev udisks unicode zip \
#-consolekit -cups -bluetooth -libnotify -modemmanager -mysql -apache -apache2 -dropbear -redis \
#-systemd -mssql -postgres -ppp -telnet"
# test
#PRESET_USEFLAG_CRYPTSETUP="-X a52 aac aalib acl acpi apng apparmor audit -alsa bash-completion boost branding bzip2 \
#cpudetection cjk cxx dbus elogind ffmpeg -git -gtk -gtk3 gzip \
#hardened initramfs int64 lzma lzo lvm mount opengl -pulseaudio -jack policykit postproc secure-delete \
#sqlite threads udev udisks unicode zip \
#-consolekit -cups -bluetooth -libnotify -modemmanager -mysql -apache -apache2 -dropbear -redis \
#-systemd -mssql -postgres -ppp -telnet"
# test
# Copied from cryptsetup, adjust ...
#PRESET_USEFLAG_LVMROOT="-X a52 aac aalib acl acpi apng apparmor audit -alsa bash-completion boost branding bzip2 \
#cpudetection cjk cxx dbus elogind ffmpeg -git -gtk -gtk3 gzip \
#hardened initramfs int64 lzma lzo lvm mount opengl -pulseaudio -jack policykit postproc secure-delete \
#sqlite threads udev udisks unicode zip \
#-consolekit -cups -bluetooth -libnotify -modemmanager -mysql -apache -apache2 -dropbear -redis \
#-systemd -mssql -postgres -ppp -telnet"

PRESET_FEATURES="sandbox binpkg-docompress binpkg-dostrip candy binpkg-logs \
downgrade-backup ebuild-locks fail-clean fixlafiles ipc-sandbox merge-sync \
network-sandbox noman parallel-fetch parallel-install pid-sandbox userpriv usersandbox "

# https://www.gentoo.org/downloads/mirrors/
PRESET_GENTOMIRRORS="https://mirror.init7.net/gentoo"

#PRESET_MAKE="-j$(expr $(nproc) "*" 1) --quiet "
physical_cores=$(lscpu | awk '/^Core\(s\) per socket:/ {cores=$4} /^Socket\(s\):/ {sockets=$2} END {print cores * sockets}')
PRESET_MAKE="-j${physical_cores} --quiet"
emerge_jobs=$(( physical_cores / 2 ))
[ $emerge_jobs -lt 1 ] && emerge_jobs=1
PRESET_EMERGE_JOBS="$emerge_jobs"
PRESET_EMERGE_LOAD="$physical_cores"
PRESET_EMERGE_DEFAULT_OPTS="--quiet --complete-graph --verbose --update --deep --newuse --jobs $PRESET_EMERGE_JOBS --load-average $PRESET_EMERGE_LOAD"
PRESET_PORTDIR="/var/db/repos/gentoo"
PRESET_DISTDIR="/var/cache/distfiles"
PRESET_PKGDIR="/var/cache/binpkgs"
PRESET_PORTAGE_TMPDIR="/var/tmp"
PRESET_PORTAGE_LOGDIR="/var/log/portage"
PRESET_PORTAGE_ELOG_CLASSES="log warn error"
PRESET_PORTAGE_ELOG_SYSTEM="echo save"
PRESET_LINGUAS="$LANG_MAIN_LOWER $LANG_MAIN_LOWER-$LANG_MAIN_UPPER $LANG_SECOND_LOWER $LANG_SECOND_LOWER-$LANG_SECOND_UPPER"
PRESET_L10N="$LANG_MAIN_LOWER $LANG_MAIN_LOWER-$LANG_MAIN_UPPER $LANG_SECOND_LOWER $LANG_SECOND_LOWER-$LANG_SECOND_UPPER"
PRESET_LC_MESSAGES="C"
# PRESET_CURL_SSL="$SSLD_CONF"
# MAKE.CONF END
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Network
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Moved network variables to var/var_main.sh for network custimzation during chroot e.g iptables
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

FIREWALL="UFW" # UFW, IPTABLES (IPTABLES experimental blueprint see src/CHROOT/NETWORK/NETWORK_FIREWALL.sh)
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
# DNS; NTP & SSH are set separately on the firwall setups .... see variables below and src/PRE/IPTABLES.sh for livecd firewall w IPTABLES and src/CHROOT/NETWORK/NETWORK_FIREWALL.sh for the chroot setup system.
ALLOW_PORT_OUT="80/tcp 443/tcp 22/tcp 873/tcp"

# Define ips / subnets that are allowed to connect to ALLOW_IN ports IN.
DNS_ALLOW_OUT="YES" # Unless you do not want DNS allowed for either DEFAULT (ISP) ; CUSTOM (custom DNS on $NAMESERVER* or dnsmsaq with $NAMESERVER* - leave this YES ... See src/CORE/NETWORK/NETWORK_FIREWALL.sh
USE_DNSMASQ="NO"  # not integrated yet, this variable only tells IPTABLES that its not a dnsmasq setup as of now.

SSH_IN="YES"
# SSH_PORT="22"

ALLOW_SSH_REMOTE_IPV4_IN=""
ALLOW_SSH_REMOTE_IPV6_IN=""
ALLOW_SSH_LOCAL_IPV4_IN="192.168.178.0/24"
ALLOW_SSH_LOCAL_IPV6_IN="2003:d1:b74e:b300::/64"

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

############



