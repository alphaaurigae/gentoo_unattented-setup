SWAPFILE() {
	NOTICE_START
	DEBUG_SWAPFILE() {
		NOTICE_START
		swapon -s
		ls -lh "$SWAPFD/${SWAPFILE}_${SWAPSIZE}"
		NOTICE_END
	}
	CREATE_FILE() {
		NOTICE_START
		mkdir -p $SWAPFD
		#fallocate -l $SWAPSIZE "$SWAPFD/${SWAPFILE}_${SWAPSIZE}"
		local SIZE_GB=${SWAPSIZE%G}
		local COUNT=$((SIZE_GB * 1024))
		dd if=/dev/urandom of="$SWAPFD/${SWAPFILE}_${SWAPSIZE}" bs=1M count=$COUNT status=progress conv=fsync
		chmod 600 "$SWAPFD/${SWAPFILE}_${SWAPSIZE}"
		mkswap "$SWAPFD/${SWAPFILE}_${SWAPSIZE}"
		NOTICE_END
	}
	CREATE_SWAP() {
		NOTICE_START
		swapon "$SWAPFD/${SWAPFILE}_${SWAPSIZE}"
		NOTICE_END
	}
	PERMANENT_SWAP() {
		NOTICE_START
		printf '%s\n' "$SWAPFD/${SWAPFILE}_${SWAPSIZE} none swap sw 0 0" >>/etc/fstab
		cat /etc/fstab
		NOTICE_END
	}
	CREATE_FILE
	CREATE_SWAP
	DEBUG_SWAPFILE
	# PERMANENT_SWAP
	df -h
	NOTICE_END
}
