CRYPTSETUP="NO"  # THIS VAR DEFINES IF CRYPTSETUP IS ACTIVATED FOR ROOT,  # YES DEPENDS ON var/chroot_variables.sh SYSAPP_DMCRYPT="YES"!!!! if set to no and SYSAPP_DMCRYPT="YES" #crypset is defined in useflag as option var/chroot_variables.sh
# OPTION AS IS NO = LVM ON ROOT ; YES = LVM ON CRYPTSETUP_ROOT

BOOTINITVAR="BIOS"  # BIOS  / UEFI   # Used in /gentoo_unattented-setup/src/CHROOT/CORE/SYSCONFIG_CORE.sh && gentoo_unattented-setup/src/CHROOT/CORE/SYSBOOT.s

## DRIVES & PARTITIONS
HDD1="/dev/sda" # GENTOO
# GRUB_PART=/dev/sda1 # var not in use 
BOOT_PART="/dev/sda2" # boot # Unencrypted unless required changes are made
MAIN_PART="/dev/sda3" # mainfs - lukscrypt cryptsetup container with LVM env inside

## SWAP # put here since you can set a swapfile on an external device too.
### SWAPFILE  # useful during install on low ram VM's (use KVM to avoid erros; ex firefox avx2 err.)
SWAPFILE="swapfile1"
SWAPFD="/swapdir" # swap-file directory path
SWAPSIZE="50G"  # swap file size with unit APPEND | G = gigabytes
### SWAP PARTITION
# SWAP0=swap0  # LVM swap NAME for sorting of swap partitions.
# SWAP_SIZE="1GB"  # (inside LVM MAIN_PART)
# SWAP_FS=linux-swap # swapfs

## FILESYSTEMS  # (note!: FSTOOLS ; FSTAB) (note!: nopt a duplicate - match these above)
FILESYSTEM_BOOT="ext2"  # BOOT
FILESYSTEM_MAIN="ext4"  # GENTOO

## LVM
PV_MAIN="pv0"  # LVM PV physical volume
VG_MAIN="vg0"  # LVM VG volume group
LV_MAIN="lv0"  # LVM LV logical volume

# MISC VAR
bold="$(tput bold)"  # (!important)
normal="$(tput sgr0)"  # (!important)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# STATIC CUSTOM
## chroot_variables.sh ; make.conf ; src/CHROOT/SCREENDSP/WINDOWSYS.sh
LANG_MAIN_LOWER="en"
LANG_MAIN_UPPER="US"
LANG_SECOND_LOWER="de"
LANG_SECOND_UPPER="DE"

# LOCALES
# LOCALES / LANG MAIN 
PRESET_LOCALE_A=$LANG_MAIN_LOWER\_$LANG_MAIN_UPPER # lang set 1 # set ISO-8859-1 & UTF-8 locales in  /etc/locale.gen  # used in gentoo_unattented-setup/src/CHROOT/BASE/CONF_LOCALES.sh
PRESET_LOCALE_B=$LANG_SECOND_LOWER\_$LANG_SECOND_UPPER # lang set 2 # "   # used in gentoo_unattented-setup/src/CHROOT/BASE/CONF_LOCALES.sh

# LOCALES LANG KEYMAPS MAIN
KEYMAP="de" # set common (!channgeme)  # used in /gentoo_unattented-setup/src/CHROOT/BASE/KEYMAP_CONSOLEFONT.sh && /gentoo_unattented-setup/src/CHROOT/SCREENDSP/WINDOWSYS.sh
CONSOLEFONT="default8x16" # https://wiki.gentoo.org/wiki/Fonts  # used in gentoo_unattented-setup/src/CHROOT/BASE/KEYMAP_CONSOLEFONT.sh



# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# MAKE.CONF START

## MAKE.CONF PRESET as used in gentoo_unattented-setup/src/CHROOT/BASE/MAKECONF.sh
# https://github.com/gentoo/portage/blob/master/cnf/make.conf.example


PRESET_CC="gcc"  # gcc (!default); the preset compiler

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

# probably firefox build fail if on znver1 and march set to native, need to verify https://wiki.gentoo.org/wiki/Ryzen
PRESET_MARCH="native"  # 1/2 default "native"; see "safe_cflags" & may dep kern settings; proc arch specific
# https://wiki.gentoo.org/wiki/Safe_CFLAGS#Finding_the_CPU

PRESET_CONFIG_PROTECT="/etc /usr/share/gnupg/qualified.txt" # /usr/lib/plexmediaserver/Resources/comskip.ini"

PRESET_COMMON_FLAGS="-march=$PRESET_MARCH -mtune=$PRESET_MARCH -fPIC -O2 -pipe" # -mfma -mavx2" #  -mfma -mavx2 for testing (opus?)
PRESET_CFLAGS="${PRESET_COMMON_FLAGS}"  # https://wiki.gentoo.org/wiki/Safe_CFLAGS
PRESET_CXXFLAGS="${PRESET_COMMON_FLAGS}"
PRESET_FCFLAGS="${PRESET_COMMON_FLAGS}"
PRESET_FFLAGS="${PRESET_COMMON_FLAGS}"
PRESET_LDFLAGS="-Wl,-O1 -Wl,--sort-common -Wl,-z,now -Wl,-z,relro"  # added .08.06.23, copy off sane setup for znver1
PRESET_RUSTFLAGS="-C target-cpu=$PRESET_MARCH"

# https://wiki.gentoo.org/wiki/User:GYakovlev/Rust#Configuration_for_use_with_portage
# https://forums.gentoo.org/viewtopic-p-8492912.html?sid=8298553159a9736fa48ea56002b1b834
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#CFLAGS_and_CXXFLAGS

PRESET_INPUTEVICE="libinput keyboard"
PRESET_VIDEODRIVER="virtualbox"  # amdgpu, radeonsi, radeon, virtualbox ; (!NOTE: if running in virtualbox and intend to build firefox - run KVM and set to your hardware ... "avx2 error firefox")
PRESET_LICENCES="*"  # default is: "-* @FREE" Only accept licenses in the FREE license group (i.e. Free Software) (!todo)


# https://www.gentoo.org/support/use-flags/

PRESET_USEFLAG_CRYPTSETUP="X a52 aac aalib acl acpi apng apparmor audit alsa bash-completion boost branding bzip2 \
cpudetection cjk cxx dbus elogind ffmpeg git gtk gtk3 gzip \
hardened initramfs int64 lzma lzo lvm mount opengl pulseaudio jack policykit postproc secure-delete \
sqlite threads udev udisks unicode zip \
-consolekit -cups -bluetooth -libnotify -modemmanager -mysql -apache -apache2 -dropbear -redis \
-systemd -mssql -postgres -ppp -telnet"

# Copied from cryptsetup, adjust ...
PRESET_USEFLAG_LVMROOT="X a52 aac aalib acl acpi apng apparmor audit alsa bash-completion boost branding bzip2 \
cpudetection cjk cxx dbus elogind ffmpeg git gtk gtk3 gzip \
hardened initramfs int64 lzma lzo lvm mount opengl pulseaudio jack policykit postproc secure-delete \
sqlite threads udev udisks unicode zip \
-consolekit -cups -bluetooth -libnotify -modemmanager -mysql -apache -apache2 -dropbear -redis \
-systemd -mssql -postgres -ppp -telnet"

# mount sandbox missing?
# noman?
# sandbox?
# userpriv?
# force-mirror libsrvg build err, looked like rust problem but wasnt.
# compress logs removed as it corrupted the archives for unknown reason
# collision-protect removed as linux-firmware failed emerging cpio it did emerge but still complained. (cpio removed meanwhile, add collision protect?)
PRESET_FEATURES="sandbox binpkg-docompress binpkg-dostrip candy binpkg-logs \
downgrade-backup ebuild-locks fail-clean fixlafiles ipc-sandbox merge-sync \
network-sandbox noman parallel-fetch parallel-install pid-sandbox userpriv usersandbox "
# Just a placeholder FEATURES="candy binpkg-logs cgroup config-protect-if-modified nostrip distlocks downgrade-backup ebuild-locks fakeroot fixlafiles merge-sync noauto parallel-fetch parallel-install preserve-libs protect-owned sandbox sfperms suidctl split-elog split-log splitdebug test-fail-continue unknown-features-filter unknown-features-warn unmerge-backup unmerge-orphans userfetch userpriv usersandbox usersync xattr ipc-sandbox lmirror multilib-strict buildpkg  compress-index compressdebug" #collision-protect  compress-build-logs' #fail-clean # strict" # sign

# https://www.gentoo.org/downloads/mirrors/
PRESET_GENTOMIRRORS="http://gentoo-mirror.flux.utah.edu"

PRESET_MAKE="-j$(expr $(nproc) "*" 1) --quiet "
PRESET_EMERGE_LOAD="30"
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
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# MAKE.CONF END