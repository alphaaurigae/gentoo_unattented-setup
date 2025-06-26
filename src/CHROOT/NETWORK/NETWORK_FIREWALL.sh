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
			setup_ALL(){
				mkdir -p /etc/iptables

				cat <<-EOF > /etc/iptables/rules.v4
				*filter
				:INPUT DROP [0:0]
				:FORWARD DROP [0:0]
				:OUTPUT DROP [0:0]

				-A INPUT -i lo -j ACCEPT
				-A OUTPUT -o lo -j ACCEPT

				-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
				-A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

				-A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/second --limit-burst 3 -j ACCEPT
				-A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT
				-A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT
				-A OUTPUT -p icmp -j ACCEPT
				-A INPUT -s 127.0.0.0/8 ! -i lo -j DROP
				-A INPUT -s 169.254.0.0/16 -j DROP
				-A INPUT -s 10.0.0.0/8 -j DROP
				-A INPUT -s 172.16.0.0/12 -j DROP
				-A INPUT -s 192.168.0.0/16 -j DROP
				-A INPUT -s 224.0.0.0/4 -j DROP
				-A INPUT -s 240.0.0.0/5 -j DROP
				-A INPUT -s 0.0.0.0/8 -j DROP

				-A INPUT -p tcp --syn -m limit --limit 15/minute --limit-burst 20 -j ACCEPT
				-A INPUT -p tcp --syn -j DROP
				EOF

				for rule in ${ALLOW_OUT}; do
					port="${rule%/*}"
					proto="${rule#*/}"
					echo "-A OUTPUT -o ${NIC1} -p ${proto} --dport ${port} -m conntrack --ctstate NEW -j ACCEPT" >> /etc/iptables/rules.v4
				done

				for rule in ${ALLOW_IN}; do
					port="${rule%/*}"
					proto="${rule#*/}"
					echo "-A INPUT -i ${NIC1} -p ${proto} --dport ${port} -m conntrack --ctstate NEW -j ACCEPT" >> /etc/iptables/rules.v4
				done

				echo "COMMIT" >> /etc/iptables/rules.v4

				if [ "$(sysctl -n net.ipv6.conf.all.disable_ipv6 2>/dev/null)" = "0" ]; then
					cat <<-EOF > /etc/iptables/rules.v6
					*filter
					:INPUT DROP [0:0]
					:FORWARD DROP [0:0]
					:OUTPUT DROP [0:0]

					-A INPUT -i lo -j ACCEPT
					-A OUTPUT -o lo -j ACCEPT

					-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
					-A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

					-A INPUT -p ipv6-icmp --icmpv6-type echo-request -m limit --limit 1/second --limit-burst 3 -j ACCEPT
					-A INPUT -p ipv6-icmp --icmpv6-type destination-unreachable -j ACCEPT
					-A INPUT -p ipv6-icmp --icmpv6-type packet-too-big -j ACCEPT
					-A INPUT -p ipv6-icmp --icmpv6-type time-exceeded -j ACCEPT
					-A INPUT -p ipv6-icmp --icmpv6-type neighbor-solicitation -j ACCEPT
					-A INPUT -p ipv6-icmp --icmpv6-type neighbor-advertisement -j ACCEPT
					-A INPUT -p ipv6-icmp --icmpv6-type router-advertisement -j ACCEPT
					-A INPUT -p ipv6-icmp --icmpv6-type router-solicitation -j ACCEPT
					-A OUTPUT -p ipv6-icmp -j ACCEPT
					-A INPUT -s ::1/128 ! -i lo -j DROP
					-A INPUT -s fc00::/7 -j DROP
					-A INPUT -s ff00::/8 -j DROP

					-A INPUT -p tcp --syn -m limit --limit 15/minute --limit-burst 20 -j ACCEPT
					-A INPUT -p tcp --syn -j DROP
					EOF

					for rule in ${ALLOW_OUT}; do
						port="${rule%/*}"
						proto="${rule#*/}"
						echo "-A OUTPUT -o ${NIC1} -p ${proto} --dport ${port} -m conntrack --ctstate NEW -j ACCEPT" >> /etc/iptables/rules.v6
					done

					for rule in ${ALLOW_IN}; do
						port="${rule%/*}"
						proto="${rule#*/}"
						echo "-A INPUT -i ${NIC1} -p ${proto} --dport ${port} -m conntrack --ctstate NEW -j ACCEPT" >> /etc/iptables/rules.v6
					done

					echo "COMMIT" >> /etc/iptables/rules.v6
				fi
				NOTICE_END
			}
		}

				install_once_runner_SYSTEMD () {
					NOTICE_START
					cat <<-'EOF' > /usr/local/sbin/iptables-once.sh
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

					cat <<-'EOF' > /etc/systemd/system/iptables-once.service
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

				install_once_runner_OPENRC () {
					NOTICE_START
					cat <<-'EOF' > /etc/local.d/10-iptables-once.start
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

			setup_ALL
			install_once_runner_$SYSINITVAR
			NOTICE_END
	
		}
	IPTABLES_CONFIG
	;;
	esac
	
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