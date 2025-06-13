# Variables defined in: var/1_PRE_main.sh && var/var_main.sh unless noted otherwise behind the var line / func

STAGE3() {
	# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Choosing_a_stage_tarball
	# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage#Unpacking_the_stage_tarball
	NOTICE_START
	STAGE3_FETCH() {
		NOTICE_START
		SET_VAR_STAGE3_FETCH() {
			NOTICE_START
			STAGE3_FILEPATH="$(curl -s "https://distfiles.gentoo.org/releases/amd64/autobuilds/$STAGE3DEFAULT.txt" |
				grep -v '^#' |
				grep -E '^[0-9]{8}T[0-9]{6}Z/stage3.*\.tar\.xz' |
				cut -d' ' -f1 |
				sed -r 's/\.tar\.xz$//')"

			printf '%s\n' "$STAGE3_FILEPATH"

			LIST="$STAGE3_FILEPATH.tar.xz
			$STAGE3_FILEPATH.tar.xz.CONTENTS.gz
			$STAGE3_FILEPATH.tar.xz.DIGESTS
			$STAGE3_FILEPATH.tar.xz.asc"
			NOTICE_END
		}
		FETCH_STAGE3_FETCH() {
			NOTICE_START
			for i in $LIST; do
				printf '%s\n' "$GENTOO_RELEASE_URL/$i"
				wget -P $CHROOTX/ $GENTOO_RELEASE_URL/"$i" # http://distfiles.gentoo.org/releases/amd64/autobuilds/"$STAGE3_FILENAME"

				if [ -f "$CHROOTX/$(printf '%s' "$i" | rev | cut -d'/' -f-1 | rev)" ]; then
					printf '%s\n' "$CHROOTX/$(printf '%s\n' "$i" | rev | cut -d'/' -f-1 | rev) found - OK"
				else
					printf '%s\n' "ERROR: $CHROOTX/$(printf '%s\n' "$i" | rev | cut -d'/' -f-1 | rev) not found!"
					exit 1
				fi
			done
			NOTICE_END
		}
		SET_VAR_STAGE3_FETCH
		FETCH_STAGE3_FETCH
		NOTICE_END
	}
	STAGE3_VERIFY() {
		NOTICE_START
		SET_VAR_STAGE3_VERIFY() {
			NOTICE_START
			STAGE3_FILENAME="$(find "$CHROOTX" -maxdepth 1 -type f -name 'stage3-*.tar.xz' | sort | head -n1 | sed -r 's|.*/||; s/\.tar\.xz$//')"
			[ -z "$STAGE3_FILENAME" ] && printf '%s\n' "ERROR: STAGE3_FILENAME empty"
			printf '%s\n' "$STAGE3_FILENAME"
			NOTICE_END
		}
		#		SET_VAR_STAGE3_VERIFY () { # somehow fails ... leaving commented for further testing
		#			NOTICE_START
		#
		#			echo "CHROOTX: $CHROOTX" >&2
		#
		#			STAGE3_FILENAME="$(find "$CHROOTX" -maxdepth 1 -type f -name 'stage3-*.tar.xz' | sort | head -n1 | sed -r 's|.*/||; s/\.tar\.xz$//')"
		#
		#			if [ -z "$STAGE3_FILENAME" ]; then
		#				echo ">> No stage3 file found in: $CHROOTX" >&2
		#				ls -la "$CHROOTX" >&2 || echo ">> Failed to list: $CHROOTX" >&2
		#				printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " '\$STAGE3_FILENAME' is empty"
		#				exit 1
		#			fi
		#
		#			printf '%s\n' "$STAGE3_FILENAME"
		#
		#			NOTICE_END
		#		}
		RECEIVE_GPGKEYS() {
			NOTICE_START

			local KEYSERVERS=(
				"hkps://keys.openpgp.org"
				"hkps://keys.gentoo.org"
			)

			local GENTOOKEYS=(
				"$GENTOO_EBUILD_KEYFINGERPRINT1"
				"$GENTOO_EBUILD_KEYFINGERPRINT2"
				"$GENTOO_EBUILD_KEYFINGERPRINT3"
				"$GENTOO_EBUILD_KEYFINGERPRINT4"
			)

			in_array() {
				local needle=$1
				shift
				local item
				for item; do
					[[ $item == "$needle" ]] && return 0
				done
				return 1
			}

			fetch_key() {
				local key=$1
				local ks
				for ks in "${KEYSERVERS[@]}"; do
					printf '%s\n' "${BOLD}gpg --keyserver $ks --recv-keys $key ....${RESET}"
					if gpg --keyserver "$ks" --recv-keys "$key"; then
						gpg --keyserver "$ks" --refresh-keys "$key"
						printf "%s\n" "${BOLD}${GREEN}SUCCESS: fetched and validated key $key from gpg --keyserver $ks --recv-keys $key ....${RESET}"
						return 0
					else
						printf "%s%s%s%s\n" "${BOLD}${MAGENTA}" "WARNING:" "${RESET}" " Failed to fetch key $key from $ks"
					fi
				done
				return 1
			}

			validate_fingerprints() {
				local key=$1
				mapfile -t fetched_fps < <(gpg --with-colons --fingerprint "$key" | awk -F: '/^fpr:/ {print $10}')

				# Separate primary and subkeys explicitly
				mapfile -t primary_fps < <(gpg --with-colons --list-keys --fingerprint --keyid-format long "$key" | awk -F: '
				/^pub:/ { primary=$10 }
				/^fpr:/ && $1=="pub" { primary=$10 }
				/^fpr:/ && $1=="sub" { print $10 }
				END { print primary }
			    ' | sort -u)

				# Check if key is in fetched_fps (all fingerprints) or in primary keys
				if ! in_array "$key" "${fetched_fps[@]}"; then
					printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " Key $key does not match any fetched fingerprint(s): ${fetched_fps[*]}"
					exit 1
				fi

				if in_array "$key" "${primary_fps[@]}"; then
					printf "%s%s%s%s\n" "${BOLD}${YELLOW}" "NOTICE:" "${RESET}" " Key $key is a primary key — treating as valid"
				else
					# Key is not primary, so treat as subkey with notice
					printf "%s%s%s%s\n" "${BOLD}${YELLOW}" "NOTICE:" "${RESET}" " Key $key appears to be a subkey — treating as valid"
				fi

				return 0
			}

			check_revocation_and_expiry() {
				local key=$1
				if gpg --list-keys --with-colons "$key" | grep -q '^rev'; then
					printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " Key $key is revoked"
					exit 1
				fi

				local expiry
				expiry=$(gpg --list-keys --with-colons "$key" | awk -F: '$1=="pub" {print $7; exit}')
				if [[ -n "$expiry" && "$expiry" -lt $(date +%s) ]]; then
					printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " Key $key is expired"
					exit 1
				fi

				return 0
			}

			check_signatures() {
				local key=$1
				# Allow keys that are either:
				# - The main trusted key or subkey thereof
				# - Or standalone trusted keys without signature by main key

				if [[ "$key" == "$GENTOO_EBUILD_KEYFINGERPRINT1" ]]; then
					return 0
				fi

				if [[ "$key" == "$GENTOO_EBUILD_KEYFINGERPRINT2" || "$key" == "$GENTOO_EBUILD_KEYFINGERPRINT4" ]]; then
					return 0
				fi

				if [[ "$key" == "$GENTOO_EBUILD_KEYFINGERPRINT3" ]]; then
					if ! gpg --trust-model always --check-sigs "$key" | grep -q "$GENTOO_EBUILD_KEYFINGERPRINT1"; then
						printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " Key $key is not signed by trusted key $GENTOO_EBUILD_KEYFINGERPRINT1"
						exit 1
					fi
					if ! gpg --check-sigs "$key" | grep -q "$GENTOO_EBUILD_KEYFINGERPRINT1"; then
						printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " Key $key is not signed by trusted key $GENTOO_EBUILD_KEYFINGERPRINT1"
						exit 1
					fi
					return 0
				fi

				# If key is not recognized, treat as fatal error
				printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " Key $key is not recognized as trusted or signed properly"
				return 1
			}

			for key in "${GENTOOKEYS[@]}"; do
				printf '%s\n' "${BOLD}$key=$key ....${RESET}"
				local got_key=0

				if fetch_key "$key"; then
					if ! validate_fingerprints "$key"; then return 1; fi
					if ! check_revocation_and_expiry "$key"; then return 1; fi
					if ! check_signatures "$key"; then return 1; fi
					got_key=1
				fi

				if [[ $got_key -ne 1 ]]; then
					printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " Could not fetch valid key $key from any configured keyserver"
					exit 1
				fi
			done

			NOTICE_END
		}

		VERIFY_UNPACK() {
			NOTICE_START
			if gpg --verify "$CHROOTX/$STAGE3_FILENAME.tar.xz.asc"; then
				printf "%s%s%s%s\n" "${BOLD}${GREEN}" "SUCCESS:" "${RESET}" " gpg  --verify $CHROOTX/$STAGE3_FILENAME.tar.xz.asc - OK"
				# unfinished https://forums.gentoo.org/viewtopic-t-1044026-start-0.html
				grep -A 1 -i sha512 $CHROOTX/$STAGE3_FILENAME.tar.xz.asc
				# With the cryptographic signature validated, next verify the checksum to make sure the downloaded ISO file is not corrupted.
				# The .DIGESTS.asc file contains multiple hashing algorithms, so one of the methods to validate the right one is to first look at the checksum registered in the .DIGESTS.asc file.
				# For instance, to get the SHA512 checksum:  In the above output, two SHA512 checksums are shown - one for the install-amd64-minimal-20141204.iso file and one for its accompanying .CONTENTS file.
				# Only the first checksum is of interest, as it needs to be compared with the calculated SHA512 checksum which can be generated as follows:
				# printf '%s\n' "grep -A 1 -i sha512 $CHROOTX/$STAGE3_FILENAME.tar.xz.asc - OK"
				printf '%s\n' "STAGE3_UNPACK ...."
				if tar xvJpf "$CHROOTX/$STAGE3_FILENAME.tar.xz" --xattrs-include='*.*' --numeric-owner -C "$CHROOTX"; then
					printf "%s%s%s%s\n" "${BOLD}${GREEN}" "SUCCESS:" "${RESET}" " Unpack - OK!"
				else
					printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " Failed to unpack stage3 tarball"
					exit 1
				fi
			else
				printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " Signature verification failed!"
				exit 1
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
