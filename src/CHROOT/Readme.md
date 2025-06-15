# Main scripts inside chroot

[15.06.2025]

 $ tree
.
├── BASE
│   ├── CONF_LOCALES.sh
│   ├── CP_BASHRC.sh
│   ├── EMERGE_SYNC.sh
│   ├── ESELECT_PROFILE.sh
│   ├── FIRMWARE.sh
│   ├── GCC.sh
│   ├── KEYMAP_CONSOLEFONT.sh
│   ├── MISC1_CHROOT.sh
│   ├── PORTAGE.sh
│   ├── RELOADING_SYS.sh
│   ├── SETFLAGS1.sh
│   ├── SWAPFILE.sh
│   └── SYSTEMTIME.sh
├── CORE
│   ├── APPADMIN.sh
│   ├── APPEMULATION.sh
│   ├── APP.sh
│   ├── AUDIO.sh
│   ├── GPU.sh
│   ├── INITRAM.sh
│   ├── KERNEL.sh
│   ├── MODPROBE_CHROOT.sh
│   ├── NETWORK.sh
│   ├── SYSAPP.sh
│   ├── SYSBOOT.sh
│   ├── SYSCONFIG_CORE.sh
│   ├── SYSFS.sh
│   └── SYSPROCESS.sh
├── DEBUG.sh
├── FINISH
│   └── TIDY_STAGE3.sh
├── Readme.md
├── SCREENDSP
│   ├── DESKTOP_ENV.sh
│   └── WINDOWSYS.sh
├── USERAPP
│   ├── USERAPP_GIT.sh
│   └── WEBBROWSER.sh
└── USERS
    ├── ADMIN.sh
    └── ROOT.sh

7 directories, 36 files
