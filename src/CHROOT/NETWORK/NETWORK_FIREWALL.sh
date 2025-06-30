# THIS IS THE IPTABLES SETUP FOR CHROOT SETUP SYSTEM , NOT THE IPTABLES SETUP FOR THE LIVE CD TO COVER THE SETUP DURING CHROOT --> See src/PRE/IPTABLES.sh for the firewall setup on the live CD to cover during chroot setup.

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
				printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} Invalid rule format: $1" >&2
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

					IPTABLES_rules_NIC1() {
						NOTICE_START

						for proto in v4 v6; do
							rules_file="/etc/iptables/rules.${proto}"

							case "$proto" in
								v6)
								case "$(sysctl -n net.ipv6.conf.all.disable_ipv6 2>/dev/null)" in
									0)
									;;
									*)
									continue
									;;
								esac
								;;
							esac

							# Set default policies to DROP
							# Allow loopback traffic
							# Allow established connections
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

							case "$proto" in
								v4)
									# Block internal traffic from other internal subnets
									printf "%s\n" "-A INPUT -i ${NIC1} -s 127.0.0.0/8 ! -d 127.0.0.1 -j DROP" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -s 10.0.0.0/8 ! -d 10.0.0.0/8 -j DROP" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -s 172.16.0.0/12 ! -d 172.16.0.0/12 -j DROP" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -s 192.168.0.0/16 ! -d 192.168.0.0/16 -j DROP" >>"${rules_file}"

									# Packet too big
									printf "%s\n" "-A INPUT -i ${NIC1} -p icmp --icmp-type 3 -j ACCEPT" >>"${rules_file}"

									# Per-subnet limit
									printf "%s\n" "-A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m hashlimit --hashlimit-name syn_flood_subnet --hashlimit-above 300/min --hashlimit-burst 200 --hashlimit-mode srcip --hashlimit-srcmask 24 --hashlimit-htable-expire 600 -j DROP" >>"${rules_file}"

									# ICMP rate-limited pings
									printf "%s\n" "-A INPUT -i ${NIC1} -p icmp --icmp-type echo-request -m limit --limit 1/second --limit-burst 3 -j ACCEPT" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -p icmp --icmp-type destination-unreachable -j ACCEPT" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -p icmp --icmp-type time-exceeded -j ACCEPT" >>"${rules_file}"

									# Allow outgoing connections
									printf "%s\n" "-A OUTPUT -o ${NIC1} -p icmp --icmp-type echo-request -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"

									# Advertisement
									printf "%s\n" "-A INPUT -i ${NIC1} -p icmp --icmp-type echo-request -j ACCEPT" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -p icmp --icmp-type echo-reply -j ACCEPT" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -p icmp --icmp-type time-exceeded -j ACCEPT" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -p icmp --icmp-type destination-unreachable -j ACCEPT" >>"${rules_file}"

								;;
								v6)
									# Block internal traffic from other internal subnets
									printf "%s\n" "-A INPUT -i ${NIC1} -s ::1 -j DROP" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -s fc00::/7 ! -d fc00::/7 -j DROP" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -s fe80::/10 ! -d fe80::/10 -j DROP" >>"${rules_file}"

									# Packet too big
									printf "%s\n" "-A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type packet-too-big -j ACCEPT" >>"${rules_file}"

									# Per-subnet limit
									printf "%s\n" "-A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m hashlimit --hashlimit-name syn_flood_subnet --hashlimit-above 300/min --hashlimit-burst 200 --hashlimit-mode srcip --hashlimit-srcmask 64 --hashlimit-htable-expire 600 -j DROP" >>"${rules_file}"

									# ICMP rate-limited pings
									printf "%s\n" "-A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type echo-request -m limit --limit 1/second --limit-burst 3 -j ACCEPT" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type destination-unreachable -j ACCEPT" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type time-exceeded -j ACCEPT" >>"${rules_file}"

									# Allow outgoing connections (especially for DNS if allowed)
									printf "%s\n" "-A OUTPUT -o ${NIC1} -p ipv6-icmp --icmpv6-type echo-request -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"

									# Advertisement
									printf "%s\n" "-A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type neighbor-solicitation -j ACCEPT" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type neighbor-advertisement -j ACCEPT" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type router-advertisement -j ACCEPT" >>"${rules_file}"
									printf "%s\n" "-A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type router-solicitation -j ACCEPT" >>"${rules_file}"

								;;
							esac

							# Drop all incoming packets with INVALID connection state on eth0 and wlan0
							printf "%s\n" "-A INPUT -i ${NIC1} -m conntrack --ctstate INVALID -j DROP" >>"${rules_file}"
							printf "%s\n" "-A INPUT -i ${NIC1} -m conntrack --ctstate INVALID -j DROP" >>"${rules_file}"

							# Drop all outgoing packets with INVALID connection state on eth0 and wlan0
							printf "%s\n" "-A OUTPUT -o ${NIC1} -m conntrack --ctstate INVALID -j DROP" >>"${rules_file}"
							printf "%s\n" "-A OUTPUT -o ${NIC1} -m conntrack --ctstate INVALID -j DROP" >>"${rules_file}"

							# Strict ratelimit out disabled - need testing.
							# Rate-limit outbound TCP connections
							#printf "%s\n" "-A OUTPUT -o ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m limit --limit 100/sec --limit-burst 200 -j ACCEPT" >>"${rules_file}"
							#printf "%s\n" "-A OUTPUT -o ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -j LOG --log-prefix 'OUTBOUND_CONN_LIMIT_DROP: ' --log-level 4" >>"${rules_file}"
							#printf "%s\n" "-A OUTPUT -o ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -j DROP" >>"${rules_file}"

							# Rate-limit new outbound TCP connections per destination IP 
							#printf "%s\n" "-A OUTPUT -o ${NIC1} -p tcp --syn -m hashlimit --hashlimit-name out_conn_limit --hashlimit-mode dstip --hashlimit-above 100/min --hashlimit-burst 200 -j LOG --log-prefix 'OUTBOUND_HASHLIMIT_DROP: ' --log-level 4" >>"${rules_file}"
							#printf "%s\n" "-A OUTPUT -o ${NIC1} -p tcp --syn -m hashlimit --hashlimit-name out_conn_limit --hashlimit-mode dstip --hashlimit-above 100/min --hashlimit-burst 200 -j DROP" >>"${rules_file}"

							# Limit simultaneous inbound TCP connections per source IP
							printf "%s\n" "-A INPUT -i ${NIC1} -p tcp --syn -m connlimit --connlimit-above 2 --connlimit-mask 32 -j LOG --log-prefix 'INBOUND_CONN_LIMIT_DROP: ' --log-level 4" >>"${rules_file}"
							printf "%s\n" "-A INPUT -i ${NIC1} -p tcp --syn -m connlimit --connlimit-above 2 --connlimit-mask 32 -j DROP" >>"${rules_file}"

							# Rate-limit new inbound TCP connections per source IP
							printf "%s\n" "-A INPUT -i ${NIC1} -p tcp --syn -m hashlimit --hashlimit-name in_conn_limit --hashlimit-mode srcip --hashlimit-above 10/min --hashlimit-burst 5 -j LOG --log-prefix 'INBOUND_HASHLIMIT_DROP: ' --log-level 4" >>"${rules_file}"
							printf "%s\n" "-A INPUT -i ${NIC1} -p tcp --syn -m hashlimit --hashlimit-name in_conn_limit --hashlimit-mode srcip --hashlimit-above 10/min --hashlimit-burst 5 -j DROP" >>"${rules_file}"

							# Per-IP SYN flood limit
							printf "%s\n" "-A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m recent --set --name syn_flood --rsource" >>"${rules_file}"
							printf "%s\n" "-A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m recent --update --seconds 10 --hitcount 100 --name syn_flood --rsource -j DROP" >>"${rules_file}"

							# Global SYN rate limit
							printf "%s\n" "-A INPUT -i ${NIC1} -p tcp --syn -m limit --limit 100/sec --limit-burst 1000 -j ACCEPT" >>"${rules_file}"

							# Drop everything else new TCP SYN (fail closed)
							printf "%s\n" "-A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -j DROP" >>"${rules_file}"


							# PORT RULES OUT #########################################

							# GENERIC PORT RULES OUT
							if [ -n "${ALLOW_PORT_OUT}" ]; then
								for rule in ${ALLOW_PORT_OUT}; do
									validate_rule_format "$rule"
									port="${rule%/*}"
									proto_rule="${rule#*/}"
									printf "%s\n" "-A OUTPUT -o ${NIC1} -p ${proto_rule} --dport ${port} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
								done
							fi
							# SPECIFIC PORT RULES OUT

							# DNS
							case "${DNS_ALLOW_OUT}" in
								YES)
									# USE_DNSMASQ no functionality, dnsmasq not integrated yet
									case "${USE_DNSMASQ}" in
									YES)
										case "$proto" in
											v4)
												[ -n "${NAMESERVER1_IPV4}" ] && printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER1_IPV4} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
												[ -n "${NAMESERVER2_IPV4}" ] && printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER2_IPV4} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
											;;
											v6)
												[ -n "${NAMESERVER1_IPV6}" ] && printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER1_IPV6} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
												[ -n "${NAMESERVER2_IPV6}" ] && printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER2_IPV6} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
										;;
										esac
										printf "%s\n" "-A OUTPUT -o lo -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
										# Strict ratelimit out disabled - need testing.
										#printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -m hashlimit --hashlimit-name DNS_QUERY_LIMIT --hashlimit-above 100/min --hashlimit-burst 200 --hashlimit-mode srcip -j LOG --log-prefix 'DNS_QUERY_RATE_LIMIT_DROP: ' --log-level 4" >>"${rules_file}"
										#printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -m hashlimit --hashlimit-name DNS_QUERY_LIMIT --hashlimit-above 100/min --hashlimit-burst 200 --hashlimit-mode srcip -j DROP" >>"${rules_file}"

										printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -j DROP" >>"${rules_file}"
									;;
									NO)
										case "$proto" in
											v4)
												[ -n "${NAMESERVER1_IPV4}" ] && printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER1_IPV4} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
												[ -n "${NAMESERVER2_IPV4}" ] && printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER2_IPV4} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
											;;
											v6)
												[ -n "${NAMESERVER1_IPV6}" ] && printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER1_IPV6} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
												[ -n "${NAMESERVER2_IPV6}" ] && printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER2_IPV6} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
										;;
										esac
										# Strict ratelimit out disabled - need testing.
										#printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -m hashlimit --hashlimit-name DNS_QUERY_LIMIT --hashlimit-above 100/min --hashlimit-burst 200 --hashlimit-mode srcip -j LOG --log-prefix 'DNS_QUERY_RATE_LIMIT_DROP: ' --log-level 4" >>"${rules_file}"
										#printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 53 -m hashlimit --hashlimit-name DNS_QUERY_LIMIT --hashlimit-above 100/min --hashlimit-burst 200 --hashlimit-mode srcip -j DROP" >>"${rules_file}"
										;;
									*)
									printf "%s\n" "Invalid USE_DNSMASQ='${USE_DNSMASQ}', expected yes or no" >&2
									;;
								esac
								;;
								NO)
								;;
								*)
								printf "%s\n" "Invalid DNS_ALLOW_OUT='${DNS_ALLOW_OUT}', expected yes or no" >&2
								;;
							esac
							# DNS END


							# PORT RULES IN #########################################

							# GENERIC PORT RULES IN

							if [ -n "${ALLOW_PORT_IN}" ]; then
								for rule in ${ALLOW_PORT_IN}; do
									validate_rule_format "$rule"
									port="${rule%/*}"
									proto_rule="${rule#*/}"
									printf "%s\n" "-A INPUT -i ${NIC1} -p ${proto_rule} --dport ${port} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
								done
							fi


							# SPECIFIC PORT RULES IN

							# SSH START
							printf "%s\n" "-N SSH_IN" >>"${rules_file}"
							printf "%s\n" "-A INPUT -j SSH_IN" >>"${rules_file}"


							case "${SSH_IN}" in
								YES)
								ssh_rule="22/tcp"
								validate_rule_format "$ssh_rule"
								port="${ssh_rule%/*}"
								proto_rule="${ssh_rule#*/}"
								case "$proto" in
									v4)
									if [ -n "${ALLOW_SSH_LOCAL_IPV4_IN}" ]; then
										for src in ${ALLOW_SSH_LOCAL_IPV4_IN}; do
											printf "%s\n" "-A SSH_IN -i ${NIC1} -p ${proto_rule} --dport ${port} -s ${src} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
										done
									fi

									if [ -n "${ALLOW_SSH_REMOTE_IPV4_IN}" ]; then
										for src in ${ALLOW_SSH_LOCAL_IPV4_IN}; do
											printf "%s\n" "-A SSH_IN -i ${NIC1} -p ${proto_rule} --dport ${port} -s ${src} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
										done
									fi
								;;
								v6)
									if [ -n "${ALLOW_SSH_LOCAL_IPV6_IN}" ]; then
										for src in ${ALLOW_SSH_LOCAL_IPV6_IN}; do
											printf "%s\n" "-A SSH_IN -i ${NIC1} -p ${proto_rule} --dport ${port} -s ${src} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
										done
									fi

									if [ -n "${ALLOW_SSH_REMOTE_IPV6_IN}" ]; then
										for src in ${ALLOW_SSH_LOCAL_IPV6_IN}; do
											printf "%s\n" "-A SSH_IN -i ${NIC1} -p ${proto_rule} --dport ${port} -s ${src} -m conntrack --ctstate NEW -j ACCEPT" >>"${rules_file}"
										done
									fi
									;;
								esac
								# Limit concurrent connections per IP
								printf "%s\n" "-A SSH_IN -i ${NIC1} -p ${proto_rule} --syn --dport ${port} -m connlimit --connlimit-above 3 --connlimit-mask 32 -m limit --limit 5/min --limit-burst 3 -j LOG --log-prefix \"SSH_CONN_LIMIT: \" --log-level 4" >>"${rules_file}"
								printf "%s\n" "-A SSH_IN -i ${NIC1} -p ${proto_rule} --syn --dport ${port} -m connlimit --connlimit-above 3 --connlimit-mask 32 -j DROP" >>"${rules_file}"

								# Throttle new connections from same IP over time
								printf "%s\n" "-A SSH_IN -i ${NIC1} -p ${proto_rule} --dport ${port} -m hashlimit --hashlimit-above 4/min --hashlimit-burst 3 --hashlimit-mode srcip --hashlimit-name ssh_limit -m limit --limit 5/min --limit-burst 3 -j LOG --log-prefix \"SSH_HASH_LIMIT: \" --log-level 4" >>"${rules_file}"
								printf "%s\n" "-A SSH_IN -i ${NIC1} -p ${proto_rule} --dport ${port} -m hashlimit --hashlimit-above 4/min --hashlimit-burst 3 --hashlimit-mode srcip --hashlimit-name ssh_limit -j DROP" >>"${rules_file}"
								# Rate-limit repeated new connection attempts from the same source IP
								printf "%s\n" "-A SSH_IN -i ${NIC1} -p ${proto_rule} --dport ${port} -m conntrack --ctstate NEW -m recent --set --name SSH" >>"${rules_file}"
								printf "%s\n" "-A SSH_IN -i ${NIC1} -p ${proto_rule} --dport ${port} -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 4 --rttl --name SSH -m limit --limit 5/min --limit-burst 3 -j LOG --log-prefix \"SSH_RECENT: \" --log-level 4" >>"${rules_file}"
								printf "%s\n" "-A SSH_IN -i ${NIC1} -p ${proto_rule} --dport ${port} -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 4 --rttl --name SSH -j DROP" >>"${rules_file}"


								;;
								NO)
								;;
								*)
									printf "%s\n" "Invalid SSH_IN='${SSH_IN}', expected yes or no" >&2
								;;
							esac

							printf "%s\n" "-A SSH_IN -j RETURN" >>"${rules_file}"
							# SSH END

							# NTP START


							# Doesent work by fetching the ip's and bind to the rules... 
							#ipv4_ntp1=$(curl -s -H "accept: application/dns-json" "https://cloudflare-dns.com/dns-query?name=time.cloudflare.com&type=A" | grep -oP '"data":\s*"\K[^"]+' | awk 'NR==1 {print; exit}')
							#ipv4_ntp2=$(curl -s -H "accept: application/dns-json" "https://cloudflare-dns.com/dns-query?name=time.cloudflare.com&type=A" | grep -oP '"data":\s*"\K[^"]+' | awk 'NR==2 {print; exit}')
							#
							#ipv6_ntp1=$(curl -s -H "accept: application/dns-json" "https://cloudflare-dns.com/dns-query?name=time.cloudflare.com&type=AAAA" | grep -oP '"data":\s*"\K[^"]+' | awk 'NR==1 {print; exit}')
							#ipv6_ntp2=$(curl -s -H "accept: application/dns-json" "https://cloudflare-dns.com/dns-query?name=time.cloudflare.com&type=AAAA" | grep -oP '"data":\s*"\K[^"]+' | awk 'NR==2 {print; exit}')
							#
							#
							#for ip in "${ipv4_ntp[@]}"; do
							#    echo "Applying rule for IPv4: $ip"
							#    iptables -A OUTPUT -o ${NIC1} -p udp --dport 123 -d $ip -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
							#    iptables -A INPUT -i ${NIC1} -p udp --sport 123 -s $ip -m conntrack --ctstate ESTABLISHED -j ACCEPT
							#done
							#
							#
							#for ip in "${ipv6_ntp[@]}"; do
							#    echo "Applying rule for IPv6: $ip"
							#    ip6tables -A OUTPUT -o ${NIC1} -p udp --dport 123 -d $ip -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
							#    ip6tables -A INPUT -i ${NIC1} -p udp --sport 123 -s $ip -m conntrack --ctstate ESTABLISHED -j ACCEPT
							#done

							# But works without binding ... (why ?)
							printf "%s\n" "-A OUTPUT -o ${NIC1} -p udp --dport 123  -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT" >>"${rules_file}"
							printf "%s\n" "-A INPUT -i ${NIC1} -p udp --sport 123  -m conntrack --ctstate ESTABLISHED -j ACCEPT" >>"${rules_file}"


							printf "%s\n" "-A INPUT -i lo -p udp --dport 123 -j ACCEPT" >>"${rules_file}"
							printf "%s\n" "-A OUTPUT -o lo -p udp --sport 123 -j ACCEPT" >>"${rules_file}"


							# Drop all other unsolicited NTP traffic
							printf "%s\n" "-A INPUT -p udp --dport 123 -j DROP" >>"${rules_file}"

							printf "%s\n" "-A INPUT -i lo -p udp --dport 123 -j ACCEPT" >>"${rules_file}"
							printf "%s\n" "-A OUTPUT -o lo -p udp --sport 123 -j ACCEPT" >>"${rules_file}"


							# Drop all other unsolicited NTP traffic
							printf "%s\n" "-A INPUT -p udp --dport 123 -j DROP" >>"${rules_file}"


							# NTP END

							# Logging for dropped packets at a reasonable rate
							printf "%s\n" "-A INPUT -i ${NIC1} -m limit --limit 5/min --limit-burst 10 -j LOG --log-prefix \"DROP_INPUT: \" --log-level 4" >>"${rules_file}"

							printf "%s\n" "-A OUTPUT -o ${NIC1} -m limit --limit 5/min --limit-burst 10 -j LOG --log-prefix \"DROP_INPUT: \" --log-level 4" >>"${rules_file}"

							#printf "%s\n" "-A INPUT -j LOG --log-prefix \"DROP_INPUT: \" --log-level 4" >>"${rules_file}"
							#printf "%s\n" "-A OUTPUT -j LOG --log-prefix \"DROP_OUTPUT: \" --log-level 4" >>"${rules_file}"
							printf "%s\n" "COMMIT" >>"${rules_file}"
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

					IPTABLES_rules_NIC1
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
				grep -i "^IPV6=" /etc/default/ufw 2>/dev/null || printf "%s\n" "Unknown"

				printf "%s%s%s\n" "${BOLD}${WHITE}" "==> UFW Rules Summary:" "${RESET}"
				ufw show added || printf "%s\n" "No rules found"

				#printf "%s%s%s\n" "${BOLD}${WHITE}" "==> Raw IPv4 iptables rules for UFW:" "${RESET}"
				#iptables -S

				#printf "%s%s%s\n" "${BOLD}${WHITE}" "==> Raw IPv6 ip6tables rules for UFW:" "${RESET}"
				#ip6tables -S || printf "%s\n" "ip6tables command not found or IPv6 disabled"

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
