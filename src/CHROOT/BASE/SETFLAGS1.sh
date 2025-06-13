SETFLAGS1() { # set custom flags (!NOTE: disabled by default) (!NOTE; was systemd specific, systemd not compete yet 05.11.2020)
	NOTICE_START
	SETFLAGSS1_OPENRC() {
		# rust was only for testing, for suspected bug but turned out to be make.con features force mirror issue
		#touch /etc/portage/package.use/rust
		#sed -ie '#dev-lang/rust-bin abi_x86_64 abi_x86_32#d'
		#printf '%s\n' "dev-lang/rust-bin abi_x86_64 abi_x86_32" >> /etc/portage/package.use/rust
		#emerge -v1 dev-lang/rust-bin
		NOTICE_PLACEHOLDER
	}
	SETFLAGSS1_SYSTEMD() { #(!todo)
		# old, systemd todo anyways
		#APPAPP_EMERGE="virtual/libudev "  # ! If your system set provides sys-fs/eudev, virtual/udev and virtual/libudev may be preventing systemd.  https://wiki.gentoo.org/wiki/Systemd
		#EMERGE_USERAPP_DEF
		#sed -ie '#printf '%s\n' "sys-apps/systemd cryptsetup#d'
		#printf '%s %s\n' '/etc/portage/package.use/systemd' 'sys-apps/systemd cryptsetup' >> /etc/portage/package.use/systemd
		NOTICE_PLACEHOLDER
	}
	SETFLAGSS1_$SYSINITVAR
	NOTICE_END
}
