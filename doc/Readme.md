# Usage

## Note:
> If run on virtualbox KVM ```march="native"``` does not work - at least with ```VIDEODRIVER="virtualbox"``` on ```etc/portage/make.conf```. CPU specific ```march=``` (PRESET_MARCH=) setting for ```etc/portage/make.conf``` (```var/var_main.sh``` variables) e.g ```march="znver1"``` required.

> Script with default setting both ```LVM root``` and ```LVM on cryptsetup root``` work to boot as well as build chroot without error for the complete set of the script.

> Default ```cryptsetup``` without ```argon2``` on ```bios``` due to lack of ```grub2``` support for ```argon2```. 

> All functions print a start and end notice as defined through the ```NOTICE_START``` and ```NOTICE_END``` functions in func/func_main.sh. E.g  ```SWAPFILE ... START ... ``` as debug helper on the terminal output to locate errors and warnings.


## Testing

> Step functions for the chroot preparation and chroot parts are designed to be able to run multiple times to correct mistakes / changes (
- It seems to work fine, but for a clean workflow it may be advantagous to use a clean safe state on the VM for VM setup & testing.)


### Sample VM
1. Config variables - default settings should do for a testrun (except for march= variable depending on CPU arch to be set in var/var_main.sh
2. Deploy virtualbox gentoo minimal ISO with sample setup of doc/VM_default_set.md


### Sample workflow for VM testing / dev.

1. Adjust variables in var/* , for a sample run only necessary to change "PRESET_MARCH=" in var/var_main.sh
2. Start ssh on guest VM, passwd root && ifconfig (get vm ip).
3. Open a terminal for the rsync script --> Adjust rsync ip script/copy_files_rsync.sh --> ./copy_files_rsync.sh
4. ssh root@192.168.178.99 && VM && cd gentoo_unattented-setup && ./run.sh -m
5. Run steps (Or with the new VM --> Save the VM state --> Clone the VM --> Start the cloned VM to run the next step(s).
6. Save the VM after the next step is completed --> Delete the old state VM --> Clone the VM with the completed step
.... repeat 1-6 as needed.



### Variables for chroot setup var/*:

```
https://github.com/alphaaurigae/gentoo_unattented-setup/var
```

- Variables for "modular" easy change of functionality.


### Functions 
```
https://github.com/alphaaurigae/gentoo_unattented-setup/func/
```
- func/* shared functions for scriptwide shared use. E.g menu funcitonality, functions for emerge, terminal colors etc.

- src/* scripts for the chroot preparation and chroot steps.

### Configs in configs/* 
-  Mostly predefined config files, mostly as template placeholders for src/* functions to work with a predictive environment e.g file editing.


## Tree ... 19.06.2025

### run.sh is the "main" script as parent for all functions. Run ./run.sh reporoot on the target chroot machine.
```
07:06 $ tree
.
├── banner
│   ├── BANNER_GENTOOUNATTENDED_TOPLEVEL.sh
│   ├── BANNER_SETUP_MAIN.sh
│   ├── CHROOT
│   │   ├── BANNER_CHROOT_STEPS.sh
│   │   ├── BASE
│   │   │   └── BANNER_CHROOT_BASE.sh
│   │   ├── CORE
│   │   │   └── BANNER_CHROOT_CORE.sh
│   │   ├── FINISH
│   │   │   └── BANNER_CHROOT_FINISH.sh
│   │   ├── SCREENDSP
│   │   │   └── BANNER_CHROOT_SCREENDSP.sh
│   │   ├── USERAPP
│   │   │   └── BANNER_CHROOT_USERAPP.sh
│   │   └── USERS
│   │       └── BANNER_CHROOT_USERS.sh
│   └── PRE
│       └── BANNER_PRE_STEPS.sh
├── configs
│   ├── default
│   │   └── grub.sh
│   ├── optional
│   │   ├── genkernel.conf
│   │   ├── lilo.conf
│   │   └── readme.md
│   └── required
│       └── Readme.md
├── doc
│   ├── Readme.md
│   ├── TODO
│   │   └── Readme.md
│   └── VM_default_set.md
├── func
│   ├── func_chroot_main.sh
│   ├── func_main.sh
│   └── func_menu.sh
├── img
│   └── screenshots
│       ├── console_menu
│       │   ├── Screenshot_2025-06-15_05-15-14.png
│       │   └── Screenshot_2025-06-15_05-16-08.png
│       └── virtual_machine
│           └── virtualbox
│               ├── 1_virtualbox_general_basic.png
│               ├── 2_virtualbox_motherboard.png
│               ├── 3_virtualbox_system_processor.png
│               ├── 4_virtualbox_system_acceleration.png
│               ├── 5_virtualbox_display_screen.png
│               ├── 6_virtualbox_storage_storage.png
│               ├── 7_virtualbox_network_adapter1.png
│               ├── Readme.md
│               ├── Screenshot_2023-06-09_14-38-39.png
│               └── Screenshot_2025-06-03_09-25-38.png
├── LICENSE
├── README.md
├── run.sh
├── script
│   ├── copy_files_rsync.sh
│   ├── find_variable-usage.sh
│   ├── shfmt_lint.sh
│   └── VM_nmcli_bridge_sample.sh
├── src
│   ├── CHROOT
│   │   ├── BASE
│   │   │   ├── CONF_LOCALES.sh
│   │   │   ├── CP_BASHRC.sh
│   │   │   ├── EMERGE_SYNC.sh
│   │   │   ├── ESELECT_PROFILE.sh
│   │   │   ├── FIRMWARE.sh
│   │   │   ├── KEYMAP_CONSOLEFONT.sh
│   │   │   ├── MISC1_CHROOT.sh
│   │   │   ├── PORTAGE.sh
│   │   │   ├── RELOADING_SYS.sh
│   │   │   ├── SETFLAGS1.sh
│   │   │   ├── SWAPFILE.sh
│   │   │   └── SYSTEMTIME.sh
│   │   ├── CORE
│   │   │   ├── APPADMIN.sh
│   │   │   ├── APPEMULATION.sh
│   │   │   ├── APP.sh
│   │   │   ├── AUDIO.sh
│   │   │   ├── GPU.sh
│   │   │   ├── INITRAM.sh
│   │   │   ├── KERNEL.sh
│   │   │   ├── MODPROBE_CHROOT.sh
│   │   │   ├── NETWORK.sh
│   │   │   ├── SYSAPP.sh
│   │   │   ├── SYSBOOT.sh
│   │   │   ├── SYSCONFIG_CORE.sh
│   │   │   ├── SYSFS.sh
│   │   │   └── SYSPROCESS.sh
│   │   ├── DEBUG.sh
│   │   ├── FINISH
│   │   │   └── TIDY_STAGE3.sh
│   │   ├── Readme.md
│   │   ├── SCREENDSP
│   │   │   ├── DESKTOP.sh
│   │   │   └── WINDOWSYS.sh
│   │   ├── USERAPP
│   │   │   ├── USERAPP_GIT.sh
│   │   │   └── WEBBROWSER.sh
│   │   └── USERS
│   │       ├── ADMIN.sh
│   │       └── ROOT.sh
│   └── PRE
│       ├── COPY_CONFIGS.sh
│       ├── CRYPTSETUP.sh
│       ├── INIT.sh
│       ├── LVMSETUP.sh
│       ├── MAKECONF.sh
│       ├── MNTFS.sh
│       ├── PARTITIONING.sh
│       ├── Readme.md
│       └── STAGE3.sh
└── var
    ├── app
    │   ├── cron.sh
    │   └── syslog.sh
    ├── chroot_variables.sh
    ├── pre_variables.sh
    └── var_main.sh

34 directories, 89 files
```s