NETWORK_FIREWALL() {
	NOTICE_START

	INSTALL_FIREWALL() {
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

		validate_rule_format() {
			[[ "$1" =~ ^[0-9]+/(tcp|udp)$ ]] || {
				echo "Invalid rule format: $1" >&2
				exit 1
			}
		}

		case "${FIREWALL}" in
			UFW)
				UFW_CONFIG() { # https://wiki.gentoo.org/wiki/Ufw
					NOTICE_START

					ufw status | grep -q inactive && ufw --force enable
					ufw --force reset
					ufw default deny incoming
					ufw default deny outgoing

					if [ -n "${ALLOW_PORT_OUT}" ]; then
						for rule in ${ALLOW_PORT_OUT}; do
							validate_rule_format "$rule"
							port="${rule%/*}"
							proto="${rule#*/}"
							ufw allow out on "$NIC1" to any port "${port}" proto "${proto}" comment "ALLOW_PORT_OUT ${proto}/${port}"
						done
					fi

					if [ -n "${ALLOW_PORT_IN}" ]; then
						for rule in ${ALLOW_PORT_IN}; do
							validate_rule_format "$rule"
							port="${rule%/*}"
							proto="${rule#*/}"
							ufw allow in on "$NIC1" from any to any port "${port}" proto "${proto}" comment "ALLOW_PORT_IN ${proto}/${port}"
						done
					fi

					ufw reload

					NOTICE_END
				}
				UFW_CONFIG
				;;

			IPTABLES)
				IPTABLES_CONFIG() { # https://wiki.gentoo.org/wiki/Iptables

					NOTICE_START

					mkdir -p /etc/iptables

					rules_NIC1() {
						NOTICE_START

						for proto in v4 v6; do
							rules_file="/etc/iptables/rules.${proto}"

							if [ "$proto" = "v6" ] && [ "$(sysctl -n net.ipv6.conf.all.disable_ipv6 2>/dev/null)" != "0" ]; then
								continue
							fi

							cat <<-EOF >"${rules_file}"
								*filter
								:INPUT DROP [0:0]
								:FORWARD DROP [0:0]
								:OUTPUT DROP [0:0]

								-A INPUT -i lo -j ACCEPT
								-A OUTPUT -o lo -j ACCEPT

								-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
								-A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
							EOF

							if [ "$proto" = "v4" ]; then
								echo "-A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/second --limit-burst 3 -j ACCEPT" >>"${rules_file}"
								echo "-A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT" >>"${rules_file}"
								echo "-A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT" >>"${rules_file}"
								echo "-A OUTPUT -p icmp --icmp-type echo-request -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
							else
								echo "-A INPUT -p ipv6-icmp --icmpv6-type echo-request -m limit --limit 1/second --limit-burst 3 -j ACCEPT" >>"${rules_file}"
								echo "-A INPUT -p ipv6-icmp --icmpv6-type destination-unreachable -j ACCEPT" >>"${rules_file}"
								echo "-A INPUT -p ipv6-icmp --icmpv6-type packet-too-big -j ACCEPT" >>"${rules_file}"
								echo "-A INPUT -p ipv6-icmp --icmpv6-type time-exceeded -j ACCEPT" >>"${rules_file}"
								echo "-A INPUT -p ipv6-icmp --icmpv6-type neighbor-solicitation -j ACCEPT" >>"${rules_file}"
								echo "-A INPUT -p ipv6-icmp --icmpv6-type neighbor-advertisement -j ACCEPT" >>"${rules_file}"
								echo "-A INPUT -p ipv6-icmp --icmpv6-type router-advertisement -j ACCEPT" >>"${rules_file}"
								echo "-A INPUT -p ipv6-icmp --icmpv6-type router-solicitation -j ACCEPT" >>"${rules_file}"
								echo "-A OUTPUT -p ipv6-icmp --icmpv6-type echo-request -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
							fi

							echo "-A INPUT -p tcp --syn -m limit --limit 15/minute --limit-burst 20 -j ACCEPT" >>"${rules_file}"




							# PORT RULES OUT #########################################

							# GENERIC PORT RULES OUT

							if [ -n "${ALLOW_PORT_OUT}" ]; then
								for rule in ${ALLOW_PORT_OUT}; do
									validate_rule_format "$rule"
									port="${rule%/*}"
									proto_rule="${rule#*/}"
									echo "-A OUTPUT -o ${NIC1} -p ${proto_rule} --dport ${port} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
								done
							fi


							# SPECIFIC PORT RULES OUT

							# DNS
							if [ "${DNS_ALLOW_OUT}" = "YES" ]; then
								if [ "${USE_DNSMASQ}" = "YES" ]; then
									[ -n "${NAMESERVER1_IPV4}" ] && echo "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER1_IPV4} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
									[ -n "${NAMESERVER2_IPV4}" ] && echo "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER2_IPV4} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
									[ -n "${NAMESERVER1_IPV6}" ] && echo "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER1_IPV6} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
									[ -n "${NAMESERVER2_IPV6}" ] && echo "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER2_IPV6} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
									echo "-A OUTPUT -o lo -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
									echo "-A OUTPUT -o ${NIC1} -p udp --dport 53 -j DROP" >>"${rules_file}"
								else
									[ -n "${NAMESERVER1_IPV4}" ] && echo "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER1_IPV4} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
									[ -n "${NAMESERVER2_IPV4}" ] && echo "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER2_IPV4} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
									[ -n "${NAMESERVER1_IPV6}" ] && echo "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER1_IPV6} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
									[ -n "${NAMESERVER2_IPV6}" ] && echo "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER2_IPV6} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
								fi
							fi
							# DNS END




							# PORT RULES IN #########################################

							# GENERIC PORT RULES IN

							if [ -n "${ALLOW_PORT_IN}" ]; then
								for rule in ${ALLOW_PORT_IN}; do
									validate_rule_format "$rule"
									port="${rule%/*}"
									proto_rule="${rule#*/}"
									echo "-A INPUT -i ${NIC1} -p ${proto_rule} --dport ${port} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
								done
							fi


							# SPECIFIC PORT RULES IN

							# SSH START
							echo "-N SSH_IN" >>"${rules_file}"
							echo "-A INPUT -j SSH_IN" >>"${rules_file}"

							if [ "${SSH_IN}" = "YES" ]; then
								ssh_rule="22/tcp"
								validate_rule_format "$ssh_rule"
								port="${ssh_rule%/*}"
								proto_rule="${ssh_rule#*/}"

								if [ -n "${ALLOW_SSH_LOCAL_IN}" ]; then
									for src in ${ALLOW_SSH_LOCAL_IN}; do
										echo "-A SSH_IN -i ${NIC1} -p ${proto_rule} --dport ${port} -s ${src} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
									done
								fi

								if [ -n "${ALLOW_SSH_REMOTE_IN}" ]; then
									for src in ${ALLOW_SSH_REMOTE_IN}; do
										echo "-A SSH_IN -i ${NIC1} -p ${proto_rule} --dport ${port} -s ${src} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
									done
								fi
							fi

							echo "-A SSH_IN -j RETURN" >>"${rules_file}"

							# SSH END

							echo "-A INPUT -j LOG --log-prefix \"DROP_INPUT: \" --log-level 4" >>"${rules_file}"
							echo "-A OUTPUT -j LOG --log-prefix \"DROP_OUTPUT: \" --log-level 4" >>"${rules_file}"
							echo "COMMIT" >>"${rules_file}"
						done

						NOTICE_END
					}

					install_once_runner_SYSTEMD() {
						NOTICE_START

						cat <<-'EOF' >/usr/local/sbin/iptables-once.sh
							#!/bin/bash

							modprobe ip_tables
							modprobe iptable_filter
							modprobe nf_conntrack

							[ -f /etc/iptables/.once_applied ] && exit 0
							[ -x /usr/sbin/iptables-restore ] && /usr/sbin/iptables-restore < /etc/iptables/rules.v4
							if [ -x /usr/sbin/ip6tables-restore ] && [ "$(sysctl -n net.ipv6.conf.all.disable_ipv6)" -eq 0 ]; then
								/usr/sbin/ip6tables-restore < /etc/iptables/rules.v6
							fi
							touch /etc/iptables/.once_applied
						EOF
						chmod +x /usr/local/sbin/iptables-once.sh

						cat <<-'EOF' >/etc/systemd/system/iptables-once.service
							[Unit]
							Description=One-time IPTables Rule Setup
							After=network.target

							[Service]
							Type=oneshot
							ExecStart=/usr/local/sbin/iptables-once.sh
							RemainAfterExit=true

							[Install]
							WantedBy=multi-user.target
						EOF

						systemctl enable iptables-once.service

						NOTICE_END
					}

					install_once_runner_OPENRC() {
						NOTICE_START

						cat <<-'EOF' >/etc/local.d/10-iptables-once.start
							#!/bin/bash

							modprobe ip_tables
							modprobe iptable_filter
							modprobe nf_conntrack
							[ -f /etc/iptables/.once_applied ] && exit 0
							[ -x /sbin/iptables-restore ] && /sbin/iptables-restore < /etc/iptables/rules.v4
							if [ -x /sbin/ip6tables-restore ] && [ "$(sysctl -n net.ipv6.conf.all.disable_ipv6)" -eq 0 ]; then
								/sbin/ip6tables-restore < /etc/iptables/rules.v6
							fi
							touch /etc/iptables/.once_applied
						EOF
						chmod +x /etc/local.d/10-iptables-once.start
						rc-update add local default

						NOTICE_END
					}

					rules_NIC1
					install_once_runner_$SYSINITVAR

					NOTICE_END
				}
				IPTABLES_CONFIG
				;;
		esac

		NOTICE_END
	}

	DEBUG_FIREWALL() {
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
