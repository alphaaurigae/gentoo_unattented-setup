#!/bin/bash

# USE WITH CARE - MAY UNINTENTIONALLY DELETE FILES. BACKUP WORK DIR AND TEST E.G MELD

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

# Ensure we are in the root of the Git repository
repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

# Check if the script is running inside a Git repository and in the root directory
if [ -z "$repo_root" ]; then
	printf "%s%s%s%s\n" "${BOLD}${YELLOW}" "NOTICE:" "${RESET}" " This script must be run inside a Git repository."

	exit 1
elif [ "$(pwd)" != "$repo_root" ]; then
	printf "%s%s%s%s\n" "${BOLD}${YELLOW}" "FATAL ERROR:" "${RESET}" " This script must be run from the root of the Git repository."
	exit 1
fi

# Option to backup files before modifying them (to ensure no loss of data)
BACKUP_DIR="./backup_$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"

LOG="./formatting_errors.log"
>"$LOG"

find . \
	-type f \
	-name "*.sh" \
	! -path "./.git/*" \
	! -path "./backup_*/*" \
	! -path "./README.md" \
	! -path "./LICENSE" \
	! -path "./**/README.md" \
	! -path "./**/LICENSE" |
	while read -r file; do
		if [ ! -r "$file" ]; then
			printf "%s%s%s%s\n" "${BOLD}${MAGENTA}" "WARNING:" "${RESET}" " Skipping unreadable file: $file" >>"$LOG"
			continue
		fi

		# Preserve relative path and create backup
		relative_path="${file#./}"
		backup_path="$BACKUP_DIR/$relative_path"
		mkdir -p "$(dirname "$backup_path")"
		cp "$file" "$backup_path"
		if [ $? -ne 0 ]; then
			printf "%s%s%s%s\n" "${BOLD}${RED}" "FATAL ERROR:" "${RESET}" " Failed to backup $file" >>"$LOG"
			exit 1
		fi

		# Apply shfmt to the file in place
		shfmt -i 0 -ci -ln bash -w "$file"
		if [ $? -ne 0 ]; then
			printf "%s%s%s%s\n" "${BOLD}${MAGENTA}" "WARNING:" "${RESET}" " Failed to format $file with shfmt" >>"$LOG"
			# Restore from backup if shfmt fails
			cp "$backup_path" "$file"
			continue
		fi

		# Compare original and modified file
		if ! diff "$file" "$backup_path" >/dev/null; then
			printf "%s%s%s%s\n" "${BOLD}${GREEN}" "SUCCESS:" "${RESET}" " File $file was modified. Backed up copy saved in $BACKUP_DIR"
		else
			printf "%s%s%s%s\n" "${BOLD}${YELLOW}" "NOTICE:" "${RESET}" " No changes made to $file"
		fi
	done

if [ -s "$LOG" ]; then
	printf "%s%s%s%s\n" "${BOLD}${YELLOW}" "NOTICE:" "${RESET}" " Some errors or warnings were encountered during formatting. Check the error log at $LOG"
else
	printf "%s%s%s%s\n" "${BOLD}${YELLOW}" "NOTICE:" "${RESET}" " All Bash files have been formatted using shfmt and backups are saved!"
fi
