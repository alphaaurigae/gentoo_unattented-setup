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


