	SYSFS () {
	NOTICE_START
		SYSFS_DMCRYPT () {  # https://wiki.gentoo.org/wiki/Dm-crypt
		NOTICE_START
			APPAPP_EMERGE="sys-fs/cryptsetup "
			AUTOSTART_NAME_OPENRC="dmcrypt"
			AUTOSTART_NAME_SYSTEMD="systemd-cryptsetup"
			PACKAGE_USE
			ACC_KEYWORDS_USERAPP
			EMERGE_ATWORLD_A
			EMERGE_USERAPP_DEF
			etc-update --automode -3  # (automode -3 = merge all)
			AUTOSTART_BOOT_$SYSINITVAR
		NOTICE_END
		}
		SYSFS_LVM2 () {  # https://wiki.gentoo.org/wiki/LVM/de
		NOTICE_START
			APPAPP_EMERGE="sys-fs/lvm2"
			AUTOSTART_NAME_OPENRC="lvm"  # (!important: "lvm" instead of "lvm2" as label)
			AUTOSTART_NAME_SYSTEMD="$APPAPP_NAME_SIMPLE-monitor"
			CONFIG_LVM2 () {
			NOTICE_START
				echo just a placeholder
				# sed -e 's/# issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf > /tmp/lvm.conf  # new line, probably not needed bec it worked well for boot anyways, leaving commented
				# sed -e 's/issue_discards = 0/issue_discards = 1/g' /etc/lvm/lvm.conf > /tmp/lvm.conf  # old line, didnt uncomment issue discard, probably not needed bec it worked well for boot anyways
				mv /tmp/lvm.conf /etc/lvm/lvm.conf
			NOTICE_END
			}
			EMERGE_USERAPP_DEF
			AUTOSTART_BOOT_$SYSINITVAR
			CONFIG_LVM2
		NOTICE_END
		}
		SYSAPP_MULTIPATH () {  # https://wiki.gentoo.org/wiki/Multipath
		NOTICE_START
			APPAPP_EMERGE="sys-fs/multipath-tools "
			EMERGE_USERAPP_DEF
		NOTICE_END
		}
		SYSFS_FSTOOLS () {  # (! e2fsprogs # Ext2, 3, and 4) # optional, add to variables at time.
		NOTICE_START
			## (note!: this is a little workaround to make sure FS support is installed.  This is missing a routine to avoid double emerges as of 16 01 2021)
			## FSTOOLS
			FST_EMERGE_EXT=sys-fs/e2fsprogs
			FST_EMERGE_XFS=sys-fs/xfsprogs
			FST_EMERGE_REISER=sys-fs/reiserfsprogs
			FST_EMERGE_JFS=sys-fs/jfsutils
			FST_EMERGE_VFAT=sys-fs/dosfstools # (FAT32, ...) 
			FST_EMERGE_BTRFS=sys-fs/btrfs-progs
			MAIN () {
			NOTICE_START
				ALL_YES_FSTOOLS () {
				NOTICE_START
					for i in  ${!FSTOOLS_*}
					do
						if [ $(printf '%s\n' "${!i}") == "YES" ]; then
							APPAPP_EMERGE=$(printf '%s\n' "$i" | sed -e s'/FSTOOLS_/FST_EMERGE_/g')
							EMERGE_USERAPP_RD1
						else 
							APPAPP_EMERGE=$(printf '%s\n' "$i" | sed -e s'/FSTOOLS_/FST_EMERGE_/g' )
							MATCHFS="$(printf '%s\n' "$i" | sed -e s'/FSTOOLS_/FST_EMERGE_/g' )"
							LDGFSE="$(printf '%s\n' "${!MATCHFS}" |   sed -e 's/-progs//g' | sed -e 's/progs//g' | sed -e 's#sys-fs/##g')"
							printf '%s\n' "$APPAPP_EMERGE  is set to NO, test for boot fs ..."
							for i in  ${!FILESYSTEM_*}
							do
								if [ "${!i}" == "$LDGFSE" ]; then
									echo "system / boot FS ${!i} = $LDGFSE pattern in search string for fstools repo variables $i "
									echo "emerging ${!APPAPP_EMERGE}"
									#EMERGE_USERAPP_RD1
								else
									#printf '%s\n' "${!MATCHFS}"
									#printf '%s\n' "${!i}"
									echo "system / boot FS ${!i} != $LDGFSE pattern in search string for fstools repo variables $i "
								fi
							done
						fi
					done
				NOTICE_END
				}
				FILTER_YES () {
				NOTICE_START
					for i in ${!FILESYSTEM_*}
					do
						if [[ "${!i}" == "msdos" || "${!FILESYSTEM_*}" == "vfat" || "${!FILESYSTEM_*}" == "fat" ]]; then
							echo "${!i} IS BINGO dos fs"
							APPAPP_EMERGE="$(printf '%s\n' "$FST_EMERGE_VFAT")"
							echo "emerging ${!APPAPP_EMERGE}"
							EMERGE_USERAPP_DEF
						else
							#printf '%s\n' "${!MATCHFS}"
							#printf '%s\n' "${!i}"
							echo "${!i} is not dos fs"
						fi
						if [[ "${!i}" == *"ext"* ]]; then
							echo "${!i} IS BINGO ext fs"
							APPAPP_EMERGE="$(printf '%s\n' "$FST_EMERGE_EXT")"
							echo "emerging $APPAPP_EMERGE "
							EMERGE_USERAPP_DEF
						else
							#printf '%s\n' "${!MATCHFS}"
							#printf '%s\n' "${!i}"
							echo "${!i} is not ext fs"
						fi
					done
				NOTICE_END
				}
				ALL_YES_FSTOOLS
				FILTER_YES
			NOTICE_END
			}
			MAIN
		NOTICE_END
		}
		SYSFS_DMCRYPT
		SYSFS_LVM2
		SYSAPP_MULTIPATH
		SYSFS_FSTOOLS
	NOTICE_END
	}