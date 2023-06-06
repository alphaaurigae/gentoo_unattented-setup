# variables defined in: gentoo_unattented-setup/var/1_PRE_main.sh && gentoo_unattented-setup/var/var_main.sh unless noted otherwise behind the var line / func

	MNTFS () {
	NOTICE_START
		MOUNT_BASESYS () {  # (!important) # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base#Mounting_the_necessary_filesystems
		NOTICE_START
			# Warning
			# When using non-Gentoo installation media, this might not be sufficient. 
			# Some distributions make /dev/shm a symbolic link to /run/shm/ which, after the chroot, becomes invalid. Making /dev/shm/ a proper tmpfs mount up front can fix this: 
			mount --types proc /proc $CHROOTX/proc
			mount --rbind /sys $CHROOTX/sys
			mount --make-rslave $CHROOTX/sys
			mount --rbind /dev $CHROOTX/dev
			mount --make-rslave $CHROOTX/dev
			mount --bind /run $CHROOTX/run
			mount --make-slave $CHROOTX/run
		NOTICE_END
		}	 
		SETMODE_DEVSHM () {
		NOTICE_START
			chmod 1777 /dev/shm  # (!todo) (note: Chmod 1777 (chmod a+rwx,ug+s,+t,u-s,g-s) sets permissions so that, (U)ser / owner can read, can write and can execute. (G)roup can read, can write and can execute. (O)thers can read, can write and can execute)
		NOTICE_END
		}
		MOUNT_BASESYS
		SETMODE_DEVSHM
	NOTICE_END
	}