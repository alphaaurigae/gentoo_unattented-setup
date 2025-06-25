NETWORK_FIREWALL() {
	NOTICE_START

	INSTALL_FIREWALL () {
		UFW_APPAPP_EMERGE="net-firewall/ufw"
		UFW_AUTOSTART_NAME_OPENRC="ufw"
		UFW_AUTOSTART_NAME_SYSTEMD="ufw"

		IPTABLES_APPAPP_EMERGE="net-firewall/iptables"
		IPTABLES_AUTOSTART_NAME_OPENRC="iptables"
		IPTABLES_AUTOSTART_NAME_SYSTEMD="iptables"

		APPAPP_EMERGE_VAR="${FIREWALL}_APPAPP_EMERGE"
		AUTOSTART_NAME_OPENRC_VAR="${FIREWALL}_AUTOSTART_NAME_OPENRC"
		AUTOSTART_NAME_SYSTEMD_VAR="${FIREWALL}_AUTOSTART_NAME_SYSTEMD"

		APPAPP_EMERGE="${!APPAPP_EMERGE_VAR}"
		AUTOSTART_NAME_OPENRC="${!AUTOSTART_NAME_OPENRC_VAR}"
		AUTOSTART_NAME_SYSTEMD="${!AUTOSTART_NAME_SYSTEMD_VAR}"

		PACKAGE_USE
		ACC_KEYWORDS_USERAPP
		EMERGE_USERAPP_DEF
		AUTOSTART_BOOT_$SYSINITVAR
	}
	CONFIG_FIREWALL() {
		NOTICE_START

		case "${FIREWALL}" in
			UFW)
				UFW_CONFIG () {  # https://wiki.gentoo.org/wiki/Ufw
					NOTICE_START
					ufw status | grep -q inactive && ufw --force enable
					ufw --force reset
					ufw default deny incoming
					ufw default deny outgoing

					for rule in ${ALLOW_OUT}; do
						port="${rule%/*}"
						proto="${rule#*/}"
						ufw allow out on "$NIC1" to any port "${port}" proto "${proto}" comment "ALLOW_OUT ${proto}/${port}"
					done

					for rule in ${ALLOW_IN}; do
						port="${rule%/*}"
						proto="${rule#*/}"
						ufw allow in on "$NIC1" from any to any port "${port}" proto "${proto}" comment "ALLOW_IN ${proto}/${port}"
					done

					ufw reload
					NOTICE_END
				}
				UFW_CONFIG
				;;

			IPTABLES)
				IPTABLES_CONFIG () {  # https://wiki.gentoo.org/wiki/Iptables
					NOTICE_START

					sysctl -w net.ipv4.ip_forward=0 >/dev/null 2>&1

					iptables -F
					iptables -X
					iptables -t nat -F
					iptables -t nat -X
					iptables -t mangle -F
					iptables -t mangle -X

					iptables -P INPUT DROP
					iptables -P OUTPUT DROP
					iptables -P FORWARD DROP

					iptables -A INPUT -i lo -j ACCEPT
					iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

					for rule in ${ALLOW_OUT}; do
						port="${rule%/*}"
						proto="${rule#*/}"
						iptables -A OUTPUT -o "$NIC1" -p "${proto}" --dport "${port}" -j ACCEPT
					done

					for rule in ${ALLOW_IN}; do
						port="${rule%/*}"
						proto="${rule#*/}"
						iptables -A INPUT -i "$NIC1" -p "${proto}" --dport "${port}" -j ACCEPT
					done



					if command -v ip6tables >/dev/null 2>&1 && sysctl net.ipv6.conf.all.disable_ipv6 | grep -q 0; then
						ip6tables -F
						ip6tables -X
						ip6tables -P INPUT DROP
						ip6tables -P OUTPUT DROP
						ip6tables -P FORWARD DROP

						ip6tables -A INPUT -i lo -j ACCEPT
						ip6tables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

						for rule in ${ALLOW_OUT}; do
							port="${rule%/*}"
							proto="${rule#*/}"
							ip6tables -A OUTPUT -o "$NIC1" -p "${proto}" --dport "${port}" -j ACCEPT
						done

						for rule in ${ALLOW_IN}; do
							port="${rule%/*}"
							proto="${rule#*/}"
							ip6tables -A INPUT -i "$NIC1" -p "${proto}" --dport "${port}" -j ACCEPT
						done


					fi

					NOTICE_END
				}
				SAVE_IPTABLES_RULES () {
					mkdir -p /etc/iptables

					if command -v iptables-save >/dev/null 2>&1; then
						iptables-save > /etc/iptables/rules.v4  || echo "iptables-save ipv4 failed"
					fi

					if command -v ip6tables >/dev/null 2>&1 && [ "$(sysctl -n net.ipv6.conf.all.disable_ipv6)" -eq 0 ]; then
						ip6tables-save > /etc/iptables/rules.v6  || echo "iptables-save ipv6 failed"
					fi

					if [ "$SYSINITVAR" = "OPENRC" ]; then
						rc-update add iptables default
					elif [ "$SYSINITVAR" = "SYSTEMD" ]; then
						systemctl enable iptables
					fi
				}
				IPTABLES_CONFIG
				SAVE_IPTABLES_RULES
				;;
		esac
	NOTICE_END
	}

	DEBUG_FIREWALL () {
		NOTICE_START

		case "${FIREWALL}" in
			UFW)
				printf "%s%s%s\n" "${BOLD}${WHITE}" "==> UFW Status:" "${RESET}"
				ufw status verbose

				printf "%s%s%s\n" "${BOLD}${WHITE}" "==> UFW IPv6 Enabled:" "${RESET}"
				grep -i "^IPV6=" /etc/default/ufw 2>/dev/null || echo "Unknown"

				printf "%s%s%s\n" "${BOLD}${WHITE}" "==> UFW Rules Summary:" "${RESET}"
				ufw show added || printf "%s\n" "No rules found"

				#printf "%s%s%s\n" "${BOLD}${WHITE}" "==> Raw IPv4 iptables rules for UFW:" "${RESET}"
				#iptables -S

				#printf "%s%s%s\n" "${BOLD}${WHITE}" "==> Raw IPv6 ip6tables rules for UFW:" "${RESET}"
				#ip6tables -S || echo "ip6tables command not found or IPv6 disabled"

				grep -i 'ufw' /etc/rc.conf /etc/conf.d/*
				ls /etc/ufw/
				;;

			IPTABLES)

				printf "%s%s%s\n" "${BOLD}${WHITE}" "==> Checking for Saved iptables Rules (IPv4):" "${RESET}"
				[ -f /etc/iptables/rules.v4 ] && cat /etc/iptables/rules.v4 || printf "%s\n" "No /etc/iptables/rules.v4 found"

				printf "%s%s%s\n" "${BOLD}${WHITE}" "==> Checking for Saved ip6tables Rules (IPv6):" "${RESET}"
				if [ -f /etc/iptables/rules.v6 ]; then
					cat /etc/iptables/rules.v6
				else
					printf "%s\n" "No /etc/iptables/rules.v6 found"
				fi

				printf "%s%s%s\n" "${BOLD}${WHITE}" "==> IPTABLES Boot Autostart Config:" "${RESET}"
				if [ "$SYSINITVAR" = "OPENRC" ]; then
					if ! rc-update show default | awk '$1=="iptables" { found=1 } END { exit !found }'; then
						printf "%s\n" "iptables not added to default"
					fi
				elif [ "$SYSINITVAR" = "SYSTEMD" ]; then
					systemctl is-enabled iptables 2>/dev/null || printf "%s\n" "iptables not enabled via systemd"
				else
					printf "%s\n" "Unknown init system"
				fi

				ls -l /etc/iptables/ || printf "%s\n" "/etc/iptables directory not found"
				;;

			*)
				printf "%s%s%s%s\n" "${BOLD}${RED}" "ERROR:" "${RESET}" " Invalid FIREWALL type in DEBUG_FIREWALL: ${FIREWALL}"
				;;
		esac

		NOTICE_END
	}
	INSTALL_FIREWALL
	CONFIG_FIREWALL
	DEBUG_FIREWALL
	NOTICE_END
}