
SYSINITVAR="openrc" # openrc (Lowercase !important (for url fetch stage3 (!default); SYSTEMD (!todo)
STAGE3TAG="hardened-$SYSINITVAR"


## PARTITION SIZE
GRUB_SIZE="1M 1G"   # (!changeme) Bios grub sector start/end M for megabytes, G for gigabytes
BOOT_SIZE="1G 3G"   # (!changeme) Boot sector start/end
MAIN_SIZE="3G 100%" # (!changeme) Primary partition start/end

## PROFILE
STAGE3DEFAULT="latest-stage3-amd64-$STAGE3TAG" # Latest-stage3-amd64; latest-stage3-amd64-systemd; latest-stage3-amd64-nomultilib; latest-stage3-amd64-hardened; latest-stage3-amd64-hardened-selinux; latest-stage3-amd64-hardened-selinux+nomultilib; latest-stage3-amd64-hardened+nomultilib
CHROOTX="/mnt/gentoo"  # Chroot directory

# GPG_VERIFY
GPG_KEYSERV="hkps://keys.gentoo.org"                                     # https://sks-keyservers.net/overview-of-pools.php
GENTOO_EBUILD_KEYFINGERPRINT1="13EBBDBEDE7A12775DFDB1BABB572E0E2D182910" # Gentoo Linux Release Engineering (Automated Weekly Release Key) # https://www.gentoo.org/downloads/signatures/
GENTOO_EBUILD_KEYFINGERPRINT2="DCD05B71EAB94199527F44ACDB6B8C1F96D8BF6D" # Gentoo ebuild repository signing key (Automated Signing Key) # https://www.gentoo.org/downloads/signatures/
GENTOO_EBUILD_KEYFINGERPRINT3="534E4209AB49EEE1C19D96162C44695DB9F6043D" # 534E4209AB49EEE1C19D96162C44695DB9F6043D is a subkey of 13EBBDBEDE7A12775DFDB1BABB572E0E2D182910 https://forums.gentoo.org/viewtopic-t-1116176-start-0.html
GENTOO_EBUILD_KEYFINGERPRINT4="D99EAC7379A850BCE47DA5F29E6438C817072058" # Gentoo Linux Release Engineering (Gentoo Linux Release Signing Key) https://www.gentoo.org/downloads/signatures/
# Dl
GENTOO_RELEASE_URL="https://distfiles.gentoo.org/releases/amd64/autobuilds"

# NTP
NTP_SERVER_PRE="time-a-g.nist.gov"  # NTP server to be used during PRE chroot preparation, src/PRE/INIT.sh

