CHROOT_run_step() {
	__shared_run_step 1 "$@"
}

PRE_run_step() {
	__shared_run_step 2 "$@"
}

__shared_run_step() {
	local setup_id=$1
	local step_map_or_stage=$2
	local step_key=$3
	local step_name=$4

	if [[ "$setup_id" == "1" ]]; then
		if declare -p "$step_name" 2>/dev/null | grep -q 'declare -A'; then
			CHROOT_select_steps "$step_name"
		elif [[ "$(type -t "$step_name")" == "function" ]]; then
			"$step_name"
		else
			printf "%s%s%s\n" "${BOLD}${MAGENTA}" "WARNING:" "${RESET}" " Invalid step: $step_name — not a function or associative array"
			return 1
		fi
	else
		"$step_name"
	fi
}

CHROOT_run_multistep_group() {
	__shared_run_multistep_group "$1" "$2" "1"
}

PRE_run_multistep_group() {
	__shared_run_multistep_group "$1" "$2" "2"
}

__shared_run_multistep_group() {
	local ref=$1 group_id=$2 setup_id=$3
	local stage_id
	local -n group_map
	local -n step_map

	if [[ "$setup_id" == "1" ]]; then
		stage_id="${ref%%_*_*}"
		group_map="${stage_id}_GROUPS"
		step_map="$ref"
	else
		stage_id="$ref"
		group_map="${stage_id}_GROUPS"
		step_map="${stage_id}_STEPS"
	fi

	local steps_csv=${group_map[$group_id]}
	IFS=',' read -ra step_list <<<"$steps_csv"
	for step in "${step_list[@]}"; do
		if [[ "$setup_id" == "1" ]]; then
			[[ -n "${step_map[$step]:-}" ]] && CHROOT_run_step "$ref" "$step" "${step_map[$step]}"
		else
			[[ -n "${step_map[$step]:-}" ]] && PRE_run_step "$ref" "$step" "${step_map[$step]}"
		fi
	done
}

CHROOT_select_steps() {
	__shared_menu_select_steps "$1" "1"
}

PRE_select_steps() {
	__shared_menu_select_steps "$1" "2"
}

__shared_menu_select_steps() {
	local step_map_name=$1
	local setup_id=$2
	local stage_id

	if [[ "$setup_id" == "1" ]]; then
		stage_id="${step_map_name%%_*_*}"
	else
		stage_id="${step_map_name%%_*}"
	fi

	declare -n steps="$step_map_name"
	declare -n groups="${stage_id}_GROUPS"

	while :; do
		printf "%s%s%s\n" "${BOLD}${WHITE}" "Stage:" "${RESET}" "  $stage_id — Choose steps (e.g. 1,2-4), 'all', 'groups', 'menu', 'back':"
		printf '%s%s%s\n' "${BOLD}${WHITE}" "Individual Steps:" "${RESET}"
		for k in $(printf '%s\n' "${!steps[@]}" | sort -n); do
			printf ' [%s] --> %s\n' "$k" "${steps[$k]}"
		done

		if ((${#groups[@]} > 0)); then
			printf '%s%s%s\n' "${BOLD}${WHITE}" "Groups:" "${RESET}"
			for gid in $(printf '%s\n' "${!groups[@]}" | sort -n); do
				step_nums="[${groups[$gid]//,/],[}]"
				printf ' [%s] --> %s\n' "$gid" "${step_nums%[,]}"
			done
		else
			printf '%s\n' "No groups available."
		fi

		read -rp "> " input
		case $input in
			back) break ;;
			menu) continue ;;
			all)

				for k in $(printf '%s\n' "${!steps[@]}" | sort -n); do
					printf '%s\n' "[$k] --> ${steps[$k]} [$k]"
				done

				;;
			groups)
				read -rp "Group IDs> " gids
				IFS=',' read -ra gids_arr <<<"$gids"

				for gid in "${gids_arr[@]}"; do
					if [[ "$setup_id" == "1" ]]; then
						[[ -n "${groups[$gid]:-}" ]] && CHROOT_run_multistep_group "$step_map_name" "$gid"
					else
						[[ -n "${groups[$gid]:-}" ]] && PRE_run_multistep_group "$stage_id" "$gid"
					fi
				done

				;;
			*)
				IFS=',' read -ra parts <<<"$input"

				for part in "${parts[@]}"; do
					if [[ $part =~ ^([0-9]+)-([0-9]+)$ ]]; then
						for ((i = ${BASH_REMATCH[1]}; i <= ${BASH_REMATCH[2]}; i++)); do
							if [[ "$setup_id" == "1" ]]; then
								[[ -n "${steps[$i]:-}" ]] && CHROOT_run_step "$step_map_name" "$i" "${steps[$i]}"
							else
								[[ -n "${steps[$i]:-}" ]] && PRE_run_step "$stage_id" "$i" "${steps[$i]}"
							fi
						done
					elif [[ -n "${groups[$part]:-}" ]]; then
						if [[ "$setup_id" == "1" ]]; then
							CHROOT_run_multistep_group "$step_map_name" "$part"
						else
							PRE_run_multistep_group "$stage_id" "$part"
						fi
					elif [[ -n "${steps[$part]:-}" ]]; then
						if [[ "$setup_id" == "1" ]]; then
							CHROOT_run_step "$step_map_name" "$part" "${steps[$part]}"
						else
							PRE_run_step "$stage_id" "$part" "${steps[$part]}"
						fi
					else
						printf '%s\n' "Invalid selection: $part"
					fi
				done
				;;
		esac
	done
}
