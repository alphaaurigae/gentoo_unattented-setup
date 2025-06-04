# variables defined in: gentoo_unattented-setup/var/1_PRE_main.sh && gentoo_unattented-setup/var/var_main.sh unless noted otherwise behind the var line / func

	# STAGE3 TARBALL - HTTPS:// ?
	STAGE3 () {  # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Choosing_a_stage_tarball && # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Unpacking_the_stage_tarball
	NOTICE_START
		STAGE3_FETCH () {
		NOTICE_START
			SET_VAR_STAGE3_FETCH (){
			NOTICE_START
				#STAGE3_FILEPATH="$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/$STAGE3DEFAULT.txt | sed '/^#/ d' | awk '{print $1}' | sed -r 's/\.tar\.xz//g' )"
				STAGE3_FILEPATH="$(curl -s "http://distfiles.gentoo.org/releases/amd64/autobuilds/$STAGE3DEFAULT.txt" \
				| grep -v '^#' \
				| grep -E '^[0-9]{8}T[0-9]{6}Z/stage3.*\.tar\.xz' \
				| cut -d' ' -f1 \
				| sed -r 's/\.tar\.xz$//')"

				printf '%s\n' "$STAGE3_FILEPATH"

				LIST="$STAGE3_FILEPATH.tar.xz
				$STAGE3_FILEPATH.tar.xz.CONTENTS.gz
				$STAGE3_FILEPATH.tar.xz.DIGESTS
				$STAGE3_FILEPATH.tar.xz.asc"
			NOTICE_END
			}
			FETCH_STAGE3_FETCH () {
			NOTICE_START
				for i in $LIST; do
					printf '%s\n' "$GENTOO_RELEASE_URL/$i"
					wget -P $CHROOTX/ $GENTOO_RELEASE_URL/"$i"  # stage3.tar.xz (!NOTE: main stage3 archive) # OLD single: wget -P $CHROOTX/ http://distfiles.gentoo.org/releases/amd64/autobuilds/"$STAGE3_FILENAME"  # stage3.tar.xz (!NOTE: main stage3 archive)

					if [ -f "$CHROOTX/$(printf '%s' "$i" | rev | cut -d'/' -f-1 | rev)" ]; then
						printf '%s\n' "$CHROOTX/$(printf '%s\n' "$i" | rev | cut -d'/' -f-1 | rev) found - OK"
					else
						printf '%s\n' "ERROR: $CHROOTX/$(printf '%s\n' "$i" | rev | cut -d'/' -f-1 | rev) not found!"
					fi
				done
			NOTICE_END
			}
			SET_VAR_STAGE3_FETCH
			FETCH_STAGE3_FETCH
		NOTICE_END
		}
		STAGE3_VERIFY () {
		NOTICE_START
			SET_VAR_STAGE3_VERIFY (){
			NOTICE_START
				STAGE3_FILENAME="$(cd $CHROOTX/ && ls stage3-* | awk '{ print $1 }' | awk 'FNR == 1 {print}' | sed -r 's/\.tar\.xz//g' )"  # | rev | cut -d'/' -f-1 | rev
				printf '%s\n' "$STAGE3_FILENAME"
			NOTICE_END
			}
			RECEIVE_GPGKEYS () {  # Which key is actually needed? for i in
			NOTICE_START
				GENTOOKEYS="
					$GENTOO_EBUILD_KEYFINGERPRINT1
					$GENTOO_EBUILD_KEYFINGERPRINT2
					$GENTOO_EBUILD_KEYFINGERPRINT3
					$GENTOO_EBUILD_KEYFINGERPRINT4
				"
				for i in $GENTOOKEYS ; do
					printf '%s\n' "${bold}$i=$i ....${normal}"
					printf '%s\n' "${bold}gpg --keyserver $KEYSERVER --recv-keys $i ....${normal}"
					gpg --keyserver $GPG_KEYSERV --recv-keys "$i"  # Fetch the key https://www.gentoo.org/downloads/signatures/
				done
				# gpg --list-keys
			NOTICE_END
			}
			VERIFY_UNPACK () {
			NOTICE_START
				if gpg  --verify "$CHROOTX/$STAGE3_FILENAME.tar.xz.asc" ; then 
					printf '%s\n' "gpg  --verify $CHROOTX/$STAGE3_FILENAME.tar.xz.asc - OK"
					# unfinished https://forums.gentoo.org/viewtopic-t-1044026-start-0.html			
					grep -A 1 -i sha512 $CHROOTX/$STAGE3_FILENAME.tar.xz.asc  # With the cryptographic signature validated, next verify the checksum to make sure the downloaded ISO file is not corrupted. The .DIGESTS.asc file contains multiple hashing algorithms, so one of the methods to validate the right one is to first look at the checksum registered in the .DIGESTS.asc file. For instance, to get the SHA512 checksum:  In the above output, two SHA512 checksums are shown - one for the install-amd64-minimal-20141204.iso file and one for its accompanying .CONTENTS file. Only the first checksum is of interest, as it needs to be compared with the calculated SHA512 checksum which can be generated as follows: 
						#printf '%s\n' "grep -A 1 -i sha512 $CHROOTX/$STAGE3_FILENAME.tar.xz.asc - OK"
						printf '%s\n' "STAGE3_UNPACK ...."
						tar xvJpf $CHROOTX/$STAGE3_FILENAME.tar.xz --xattrs-include='*.*' --numeric-owner -C $CHROOTX
				else 
					printf '%s\n' "SIGNATURE ALERT!"
				fi
			NOTICE_END
			}
			SET_VAR_STAGE3_VERIFY
			RECEIVE_GPGKEYS
			VERIFY_UNPACK
		NOTICE_END
		}
		STAGE3_FETCH
		STAGE3_VERIFY
	NOTICE_END
	}