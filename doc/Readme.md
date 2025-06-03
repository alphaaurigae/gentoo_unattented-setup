# Sample useage


## IMPORTANT NOTE
> If run on virtualbox KVM ```march="native"``` does not work - at least with ```VIDEODRIVER="virtualbox"``` on ```etc/portage/make.conf```. CPU specific ```march=``` setting for ```etc/portage/make.conf``` (```var_main.sh``` variables) e.g ```march="znver1"``` required.

> Script with default setting both ```LVM root``` and ```LVM on cryptsetup root``` work to boot as well as build chroot without error for the complete set of the script.

> Default ```cryptsetup``` without ```argon2``` on ```bios``` due to lack of ```grub2``` support for ```argon2```. 

> Default setup with ```firefox``` requires ```> 92GB disk```.


## Example use VM ... or copy to minimal cs usb etc...:
1. Config variables - default settings should do for a testrun.
2. Deploy virtualbox gentoo minimal ISO
3. Start ssh on guest VM, passwd root && ifconfig (get vm ip).
4. Adjust rsync ip --> script/copy_files_rsync.sh
5. ssh root@192.168.178.99 && VM && cd gentoo_unattented-setup && ./run.sh -m


## Default 
- (below might be dated.)

### PRE
Variables for pre setup:
(Sourced in run.sh)
```
var/var_main.sh
var/pre_variables.sh
```

General functions for PRE setup:
(Sourced in run.sh below the PRE menu))
```
func/func_main.sh
src/PRE/*
```

#### PARTITIONING
> https://github.com/alphaaurigae/gentoo_unattented-setup/blob/master/src/PRE/PARTITIONING.sh
> Testing on ~95GB VM.
- sda single drive setup
- sda1 bios boot
- sda2 bios boot - fs ext2
- sda3 main part - fs ext4 - lvm on cryptsetup or alt lvm on root

#### STAGE3
> https://github.com/alphaaurigae/gentoo_unattented-setup/blob/master/src/PRE/STAGE3.sh
- Curl off http://distfiles.gentoo.org/releases/amd64/autobuilds/
- GPG verify and print err if. 
- Unpack to chroot

#### PREP CHROOT
> Bottom --> https://github.com/alphaaurigae/gentoo_unattented-setup/blob/master/run.sh
- copy files for chroot
- MAKECONF 

### CHROOT

Variables for chroot setup:
(Sourced in run.sh)
```
var/var_main.sh
var/chroot_variables.sh
```

General functions for chroot setup:
(Sourced in run.sh)
```
func/func_main.sh
func/func_chroot_main.sh
```

#### BASE
> https://github.com/alphaaurigae/gentoo_unattented-setup/tree/master/src/CHROOT/BASE
- SWAPFILE
- CONF_LOCALES
- PORTAGE
- ESELECT_PROFILE - profile 41 openrc hardened stable.
- EMERGE_ATWORLD
- SYSTEMTIME - openntpd
- KEYMAP_CONSOLEFONT - def /etc/conf.d/keymaps, /etc/conf.d/consolefont, x11 X11/xorg.conf.d/10-keyboard.conf - dracut load for cryptset.
- FIRMWARE - linux firware default gentoo
- CP_BASHRC

#### CORE
> https://github.com/alphaaurigae/gentoo_unattented-setup/tree/master/src/CHROOT/CORE
- FSTAB
- SYSFS = DMCRYPT, LVM, MULTIPATH
- FSTOOLS = ext2
- SUDO
- SYSLOG - syslogng
- SYSAPP - pciutils, mlocate
- APP - gnupg
- SYSPROCESS, CRON cronie (unfinished set, TOP
- KERNEL - gentoo-sources , premade config for vm cryptsetup
- INITRAM - dracut
- BOOTLOADER grub2 - osprober
- EMULATION - virtualbox guest add (test on virtualbox kvm setting)
- SOUND_API - alsa
- SOUND_SERVER jack2, pulseaudio
- SOUND_MIXER pavucontrol
- GPU - virtualbox guest
- NET_MGMT, netirfc, dhcpcd, networkmanager
- NET_FIREWALL - iptables

#### SCREENDSP
> https://github.com/alphaaurigae/gentoo_unattented-setup/tree/master/src/CHROOT/SCREENDSP
- WINDOWSYS - x11
- DESKTOP_ENV - xfce4
- MGR - LXDM

#### USERAPP - firefox
> https://github.com/alphaaurigae/gentoo_unattented-setup/tree/master/src/CHROOT/USERAPP
- Firefox and dep libwebp take DECENT CPU TIME!!!! and require space +15gb - more time than updateworld portage & kernel... but you get the full source compiled ^^...
- Chromium and oher alternatives not tested yet.

#### USERS
> https://github.com/alphaaurigae/gentoo_unattented-setup/tree/master/src/CHROOT/USERS
- Root pw
- Add groups
- Add admin, add admin to groups
- Add virtualbox vbox groups, add admin to vbox groups