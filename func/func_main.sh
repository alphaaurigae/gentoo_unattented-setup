# print function names
NOTICE_START () {
	printf '%s\n' "${bold} ${FUNCNAME[1]} ... START ... ${normal}"
}
NOTICE_END () {
	printf '%s\n' "${bold}${FUNCNAME[1]}  ... END ... ${normal}"
}

BOLD=$(tput bold)
RESET=$(tput sgr0)
# Regular colors
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)

# Bright colors
BRIGHT_BLACK=$(tput setaf 8)
BRIGHT_RED=$(tput setaf 9)
BRIGHT_GREEN=$(tput setaf 10)
BRIGHT_YELLOW=$(tput setaf 11)
BRIGHT_BLUE=$(tput setaf 12)
BRIGHT_MAGENTA=$(tput setaf 13)
BRIGHT_CYAN=$(tput setaf 14)
BRIGHT_WHITE=$(tput setaf 15)

VERIFY_COPY () {
NOTICE_START
	local SRC="$1"
	local DST="$2"
	local SRC_HASH=$(sha256sum < "$SRC") &&
	local DST_HASH=$(sha256sum < "$DST") &&
	[ "$SRC_HASH" = "$DST_HASH" ] &&
	printf '%s\n' "Copied and verified: $SRC -> $DST" || printf '%s\n' "Copy failed or mismatch: $SRC -> $DST"
NOTICE_END
}

