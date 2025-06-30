# THIS IS THE IPTABLES SETUP FOR LIVE CD TO COVER THE SETUP DURING CHROOT, NOT THE IPTABLES SETUP FOR THE SETUP SYSTEM --> See src/CHROOT/NETWORK/NETWORK_FIREWALL.sh for the firewall setup on the new seystem created by chroot!

IPTABLES () {
	get_all_nics() {
		local i=1
		for dev in $(ls -1d /sys/class/net/*/device 2>/dev/null | sort); do
			local nic
			nic="$(basename "$(dirname "$dev")")"
			[[ "$nic" == "lo" ]] && continue
			export NIC$i="$nic"
			((i++))
		done
		return $((i - 1))
	}
	get_all_nics
	NUM_NICS=$?
	[ -z "$NIC1" ] && { printf "%s\n" "${BOLD}${RED} FATAL Error:${RESET} NIC1 not set"; env | grep NIC; exit 1; }

	printf "%s\n" "${BOLD}NIC1 identified as:${GREEN} $NIC1 ${RESET}"


	RESOLV_CONF="/etc/resolv.conf"

	if [ ! -f "$RESOLV_CONF" ]; then
		printf "%s\n" "${BOLD}${RED} FATAL Error:${RESET} $RESOLV_CONF not found!"

		exit 1
	fi

	printf "%s\n" "Changing DNS servers in $RESOLV_CONF..."

	> "$RESOLV_CONF"

	for server in "$NAMESERVER1_IPV4" "$NAMESERVER2_IPV4"; do
		case "$server" in
		"")
			continue
			;;
		*)
			printf "%s\n" "nameserver $server" >> "$RESOLV_CONF"
			;;
		esac
	done

	for server in "$NAMESERVER1_IPV6" "$NAMESERVER2_IPV6"; do
	    case "$server" in
		"")
			continue
			;;
		*)
			printf "%s\n" "nameserver $server" >> "$RESOLV_CONF"
			;;
	    esac
	done


	printf "%s\n" "New DNS configuration set in resolv.conf:"
	cat "$RESOLV_CONF"

	################## IPTABLES START

	validate_rule_format() {
		[[ "$1" =~ ^[0-9]+/(tcp|udp)$ ]] || {
			printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} Invalid rule format: $1" >&2
			exit 1
		}
	}

	# GENERIC MAIN #######################
	# Flush existing rules
	iptables -F

	ip6tables -F

	# Set default policies to DROP
	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT DROP

	ip6tables -P INPUT DROP
	ip6tables -P FORWARD DROP
	ip6tables -P OUTPUT DROP

	# Allow loopback traffic
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A OUTPUT -o lo -j ACCEPT

	ip6tables -A INPUT -i lo -j ACCEPT
	ip6tables -A OUTPUT -o lo -j ACCEPT

	# Drop all incoming packets with INVALID connection state on eth0 and wlan0
	iptables -A INPUT -i ${NIC1} -m conntrack --ctstate INVALID -j DROP
	ip6tables -A INPUT -i ${NIC1} -m conntrack --ctstate INVALID -j DROP
	iptables -A INPUT -i ${NIC1} -m conntrack --ctstate INVALID -j DROP
	ip6tables -A INPUT -i ${NIC1} -m conntrack --ctstate INVALID -j DROP

	# Drop all outgoing packets with INVALID connection state on eth0 and wlan0
	iptables -A OUTPUT -o ${NIC1} -m conntrack --ctstate INVALID -j DROP
	ip6tables -A OUTPUT -o ${NIC1} -m conntrack --ctstate INVALID -j DROP
	iptables -A OUTPUT -o ${NIC1} -m conntrack --ctstate INVALID -j DROP
	ip6tables -A OUTPUT -o ${NIC1} -m conntrack --ctstate INVALID -j DROP

	# Allow established connections
	iptables -A INPUT -i ${NIC1} -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
	iptables -A OUTPUT -o ${NIC1} -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

	ip6tables -A INPUT -i ${NIC1} -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
	ip6tables -A OUTPUT -o ${NIC1} -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

	# Block internal traffic from other internal subnets
	iptables -A INPUT -i ${NIC1} -s 127.0.0.0/8 ! -d 127.0.0.1 -j DROP
	iptables -A INPUT -i ${NIC1} -s 10.0.0.0/8 ! -d 10.0.0.0/8 -j DROP
	iptables -A INPUT -i ${NIC1} -s 172.16.0.0/12 ! -d 172.16.0.0/12 -j DROP
	iptables -A INPUT -i ${NIC1} -s 192.168.0.0/16 ! -d 192.168.0.0/16 -j DROP

	ip6tables -A INPUT -i ${NIC1} -s ::1 -j DROP
	ip6tables -A INPUT -i ${NIC1} -s fc00::/7 ! -d fc00::/7 -j DROP
	ip6tables -A INPUT -i ${NIC1} -s fe80::/10 ! -d fe80::/10 -j DROP

	# Packet too big
	iptables -A INPUT -i ${NIC1} -p icmp --icmp-type 3 -j ACCEPT
	ip6tables -A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type packet-too-big -j ACCEPT

	# Rate-limit outbound TCP connections
	#iptables -A OUTPUT -o ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m limit --limit 100/sec --limit-burst 200 -j ACCEPT
	#iptables -A OUTPUT -o ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -j LOG --log-prefix 'OUTBOUND_CONN_LIMIT_DROP: ' --log-level 4
	#iptables -A OUTPUT -o ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -j DROP

	#ip6tables -A OUTPUT -o ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m limit --limit 100/sec --limit-burst 200 -j ACCEPT
	#ip6tables -A OUTPUT -o ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -j LOG --log-prefix 'OUTBOUND_CONN_LIMIT_DROP: ' --log-level 4
	#ip6tables -A OUTPUT -o ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -j DROP


	# Rate-limit new outbound TCP connections per destination IP 
	#iptables -A OUTPUT -o ${NIC1} -p tcp --syn -m hashlimit --hashlimit-name out_conn_limit --hashlimit-mode dstip --hashlimit-above 100/min --hashlimit-burst 200 -j LOG --log-prefix 'OUTBOUND_HASHLIMIT_DROP: ' --log-level 4
	#iptables -A OUTPUT -o ${NIC1} -p tcp --syn -m hashlimit --hashlimit-name out_conn_limit --hashlimit-mode dstip --hashlimit-above 100/min --hashlimit-burst 200 -j DROP

	#ip6tables -A OUTPUT -o ${NIC1} -p tcp --syn -m hashlimit --hashlimit-name out_conn_limit --hashlimit-mode dstip --hashlimit-above 100/min --hashlimit-burst 200 -j LOG --log-prefix 'OUTBOUND_HASHLIMIT_DROP: ' --log-level 4
	#ip6tables -A OUTPUT -o ${NIC1} -p tcp --syn -m hashlimit --hashlimit-name out_conn_limit --hashlimit-mode dstip --hashlimit-above 100/min --hashlimit-burst 200 -j DROP


	# Limit simultaneous inbound TCP connections per source IP
	iptables -A INPUT -i ${NIC1} -p tcp --syn -m connlimit --connlimit-above 2 --connlimit-mask 32 -j LOG --log-prefix 'INBOUND_CONN_LIMIT_DROP: ' --log-level 4
	iptables -A INPUT -i ${NIC1} -p tcp --syn -m connlimit --connlimit-above 2 --connlimit-mask 32 -j DROP

	ip6tables -A INPUT -i ${NIC1} -p tcp --syn -m connlimit --connlimit-above 2 --connlimit-mask 32 -j LOG --log-prefix 'INBOUND_CONN_LIMIT_DROP: ' --log-level 4
	ip6tables -A INPUT -i ${NIC1} -p tcp --syn -m connlimit --connlimit-above 2 --connlimit-mask 32 -j DROP


	# Rate-limit new inbound TCP connections per source IP
	iptables -A INPUT -i ${NIC1} -p tcp --syn -m hashlimit --hashlimit-name in_conn_limit --hashlimit-mode srcip --hashlimit-above 10/min --hashlimit-burst 5 -j LOG --log-prefix 'INBOUND_HASHLIMIT_DROP: ' --log-level 4
	iptables -A INPUT -i ${NIC1} -p tcp --syn -m hashlimit --hashlimit-name in_conn_limit --hashlimit-mode srcip --hashlimit-above 10/min --hashlimit-burst 5 -j DROP

	ip6tables -A INPUT -i ${NIC1} -p tcp --syn -m hashlimit --hashlimit-name in_conn_limit --hashlimit-mode srcip --hashlimit-above 10/min --hashlimit-burst 5 -j LOG --log-prefix 'INBOUND_HASHLIMIT_DROP: ' --log-level 4
	ip6tables -A INPUT -i ${NIC1} -p tcp --syn -m hashlimit --hashlimit-name in_conn_limit --hashlimit-mode srcip --hashlimit-above 10/min --hashlimit-burst 5 -j DROP


	# Per-IP SYN flood limit
	iptables -A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m recent --set --name syn_flood --rsource
	iptables -A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m recent --update --seconds 10 --hitcount 100 --name syn_flood --rsource -j DROP

	ip6tables -A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m recent --set --name syn_flood --rsource

	ip6tables -A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m recent --update --seconds 10 --hitcount 100 --name syn_flood --rsource -j DROP

	# Per-subnet limit
	iptables -A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m hashlimit --hashlimit-name syn_flood_subnet --hashlimit-above 300/min --hashlimit-burst 200 --hashlimit-mode srcip --hashlimit-srcmask 24 --hashlimit-htable-expire 600 -j DROP

	ip6tables -A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -m hashlimit --hashlimit-name syn_flood_subnet --hashlimit-above 300/min --hashlimit-burst 200 --hashlimit-mode srcip --hashlimit-srcmask 64 --hashlimit-htable-expire 600 -j DROP

	# Global SYN rate limit
	iptables -A INPUT -i ${NIC1} -p tcp --syn -m limit --limit 100/sec --limit-burst 1000 -j ACCEPT

	ip6tables -A INPUT -i ${NIC1} -p tcp --syn -m limit --limit 100/sec --limit-burst 1000 -j ACCEPT

	# Drop everything else new TCP SYN
	iptables -A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -j DROP

	ip6tables -A INPUT -i ${NIC1} -p tcp --syn -m conntrack --ctstate NEW -j DROP

	# ICMP rate-limited pings
	iptables -A INPUT -i ${NIC1} -p icmp --icmp-type echo-request -m limit --limit 1/second --limit-burst 3 -j ACCEPT
	iptables -A INPUT -i ${NIC1} -p icmp --icmp-type destination-unreachable -j ACCEPT
	iptables -A INPUT -i ${NIC1} -p icmp --icmp-type time-exceeded -j ACCEPT

	ip6tables -A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type echo-request -m limit --limit 1/second --limit-burst 3 -j ACCEPT
	ip6tables -A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type destination-unreachable -j ACCEPT
	ip6tables -A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type time-exceeded -j ACCEPT

	# Allow outgoing connections (especially for DNS if allowed)
	iptables -A OUTPUT -o ${NIC1} -p icmp --icmp-type echo-request -m conntrack --ctstate NEW -j ACCEPT

	ip6tables -A OUTPUT -o ${NIC1} -p ipv6-icmp --icmpv6-type echo-request -m conntrack --ctstate NEW -j ACCEPT

	# Advertisement
	iptables -A INPUT -i ${NIC1} -p icmp --icmp-type echo-request -j ACCEPT
	iptables -A INPUT -i ${NIC1} -p icmp --icmp-type echo-reply -j ACCEPT
	iptables -A INPUT -i ${NIC1} -p icmp --icmp-type time-exceeded -j ACCEPT
	iptables -A INPUT -i ${NIC1} -p icmp --icmp-type destination-unreachable -j ACCEPT

	ip6tables -A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type neighbor-solicitation -j ACCEPT
	ip6tables -A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type neighbor-advertisement -j ACCEPT
	ip6tables -A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type router-advertisement -j ACCEPT
	ip6tables -A INPUT -i ${NIC1} -p ipv6-icmp --icmpv6-type router-solicitation -j ACCEPT
	# GENERIC MAIN END #######################

	# GENERIC PORTS out #######################
	if [ -n "${ALLOW_PORT_OUT}" ]; then
		for rule in ${ALLOW_PORT_OUT}; do
			validate_rule_format "$rule"
			port="${rule%/*}"
			proto_rule="${rule#*/}"
			iptables -A OUTPUT -o ${NIC1} -p ${proto_rule} --dport ${port} -m conntrack --ctstate NEW -j ACCEPT
			ip6tables -A OUTPUT -o ${NIC1} -p ${proto_rule} --dport ${port} -m conntrack --ctstate NEW -j ACCEPT
		done
	fi
	# GENERIC PORTS out END #######################

	# DNS #######################
	[ -n "${NAMESERVER1_IPV4}" ] && iptables -A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER1_IPV4} -m conntrack --ctstate NEW -j ACCEPT
	[ -n "${NAMESERVER2_IPV4}" ] && iptables -A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER2_IPV4} -m conntrack --ctstate NEW -j ACCEPT
	[ -n "${NAMESERVER1_IPV6}" ] && ip6tables -A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER1_IPV6} -m conntrack --ctstate NEW -j ACCEPT
	[ -n "${NAMESERVER2_IPV6}" ] && ip6tables -A OUTPUT -o ${NIC1} -p udp --dport 53 -d ${NAMESERVER2_IPV6} -m conntrack --ctstate NEW -j ACCEPT

	# Ratelimit DNS out
	#iptables -A OUTPUT -o ${NIC1} -p udp --dport 53 -m hashlimit --hashlimit-name DNS_QUERY_LIMIT --hashlimit-above 100/min --hashlimit-burst 200 --hashlimit-mode srcip -j LOG --log-prefix 'DNS_QUERY_RATE_LIMIT_DROP: ' --log-level 4
	#iptables -A OUTPUT -o ${NIC1} -p udp --dport 53 -m hashlimit --hashlimit-name DNS_QUERY_LIMIT --hashlimit-above 100/min --hashlimit-burst 200 --hashlimit-mode srcip -j DROP

	#ip6tables -A OUTPUT -o ${NIC1} -p udp --dport 53 -m hashlimit --hashlimit-name DNS_QUERY_LIMIT --hashlimit-above 100/min --hashlimit-burst 200 --hashlimit-mode srcip -j LOG --log-prefix 'DNS_QUERY_RATE_LIMIT_DROP: ' --log-level 4
	#ip6tables -A OUTPUT -o ${NIC1} -p udp --dport 53 -m hashlimit --hashlimit-name DNS_QUERY_LIMIT --hashlimit-above 100/min --hashlimit-burst 200 --hashlimit-mode srcip -j DROP
	# DNS END #######################

	# SSH #######################
	iptables -N SSH_IN
	iptables -A INPUT -j SSH_IN
	for src in ${ALLOW_SSH_LOCAL_IPV4_IN}; do
		iptables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -s $src -m conntrack --ctstate NEW -j ACCEPT
	done
	for src in ${ALLOW_SSH_REMOTE_IPV4_IN}; do
		iptables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -s $src -m conntrack --ctstate NEW -j ACCEPT
	done
	iptables -A SSH_IN -j RETURN

	ip6tables -N SSH_IN
	ip6tables -A INPUT -j SSH_IN
	for src in ${ALLOW_SSH_LOCAL_IPV6_IN}; do
		ip6tables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -s $src -m conntrack --ctstate NEW -j ACCEPT
	done

	for src in ${ALLOW_SSH_REMOTE_IPV6_IN}; do
		ip6tables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -s $src -m conntrack --ctstate NEW -j ACCEPT
	done
	ip6tables -A SSH_IN -j RETURN

	# Limit concurrent SSH connections per IP
	iptables -A SSH_IN -i ${NIC1} -p tcp --syn --dport 22 -m connlimit --connlimit-above 3 --connlimit-mask 32 -m limit --limit 5/min --limit-burst 3 -j LOG --log-prefix 'SSH_CONN_LIMIT: ' --log-level 4
	iptables -A SSH_IN -i ${NIC1} -p tcp --syn --dport 22 -m connlimit --connlimit-above 3 --connlimit-mask 32 -j DROP

	ip6tables -A SSH_IN -i ${NIC1} -p tcp --syn --dport 22 -m connlimit --connlimit-above 3 --connlimit-mask 128 -m limit --limit 5/min --limit-burst 3 -j LOG --log-prefix 'SSH_CONN_LIMIT: ' --log-level 4
	ip6tables -A SSH_IN -i ${NIC1} -p tcp --syn --dport 22 -m connlimit --connlimit-above 3 --connlimit-mask 128 -j DROP

	# Throttle new SSH connections from same IP over time
	iptables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -m hashlimit --hashlimit-above 4/min --hashlimit-burst 3 --hashlimit-mode srcip --hashlimit-name ssh_limit -m limit --limit 5/min --limit-burst 3 -j LOG --log-prefix 'SSH_HASH_LIMIT: ' --log-level 4
	iptables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -m hashlimit --hashlimit-above 4/min --hashlimit-burst 3 --hashlimit-mode srcip --hashlimit-name ssh_limit -j DROP

	ip6tables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -m hashlimit --hashlimit-above 4/min --hashlimit-burst 3 --hashlimit-mode srcip --hashlimit-name ssh_limit -m limit --limit 5/min --limit-burst 3 -j LOG --log-prefix "SSH_HASH_LIMIT: " --log-level 4
	ip6tables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -m hashlimit --hashlimit-above 4/min --hashlimit-burst 3 --hashlimit-mode srcip --hashlimit-name ssh_limit -j DROP


	# Rate-limit repeated new SSH connection attempts from the same source IP
	iptables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --set --name SSH
	iptables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --update --seconds 600 --hitcount 4 --rttl --name SSH -m limit --limit 5/min --limit-burst 3 -j LOG --log-prefix "SSH_RECENT: " --log-level 4
	iptables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --update --seconds 600 --hitcount 4 --rttl --name SSH -j DROP
 
	ip6tables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --set --name SSH
	ip6tables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --update --seconds 600 --hitcount 4 --rttl --name SSH -m limit --limit 5/min --limit-burst 3 -j LOG --log-prefix "SSH_RECENT: " --log-level 4
	ip6tables -A SSH_IN -i ${NIC1} -p tcp --dport 22 -m conntrack --ctstate NEW -m recent --update --seconds 600 --hitcount 4 --rttl --name SSH -j DROP

	# SSH END #######################



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
iptables -A OUTPUT -o ${NIC1} -p udp --dport 123  -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -i ${NIC1} -p udp --sport 123  -m conntrack --ctstate ESTABLISHED -j ACCEPT

ip6tables -A OUTPUT -o ${NIC1} -p udp --dport 123  -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
ip6tables -A INPUT -i ${NIC1} -p udp --sport 123  -m conntrack --ctstate ESTABLISHED -j ACCEPT


iptables -A INPUT -i lo -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -o lo -p udp --sport 123 -j ACCEPT

ip6tables -A INPUT -i lo -p udp --dport 123 -j ACCEPT
ip6tables -A OUTPUT -o lo -p udp --sport 123 -j ACCEPT
# Drop all other unsolicited NTP traffic
iptables -A INPUT -p udp --dport 123 -j DROP
ip6tables -A INPUT -p udp --dport 123 -j DROP
iptables -A INPUT -i lo -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -o lo -p udp --sport 123 -j ACCEPT

ip6tables -A INPUT -i lo -p udp --dport 123 -j ACCEPT
ip6tables -A OUTPUT -o lo -p udp --sport 123 -j ACCEPT
# Drop all other unsolicited NTP traffic
iptables -A INPUT -p udp --dport 123 -j DROP
ip6tables -A INPUT -p udp --dport 123 -j DROP

# NTP END

	# Logging rules
	#iptables -A INPUT -i ${NIC1} -m limit --limit 5/min --limit-burst 10 -j LOG --log-prefix 'DROP_INPUT: ' --log-level 4
	#iptables -A OUTPUT -o ${NIC1} -m limit --limit 5/min --limit-burst 10 -j LOG --log-prefix 'DROP_OUTPUT: ' --log-level 4

	#ip6tables -A INPUT -i ${NIC1} -m limit --limit 5/min --limit-burst 10 -j LOG --log-prefix 'DROP_INPUT: ' --log-level 4
	#ip6tables -A OUTPUT -o ${NIC1} -m limit --limit 5/min --limit-burst 10 -j LOG --log-prefix 'DROP_OUTPUT: ' --log-level 4
 

	printf "%s\n" "${BOLD}IPV4 IPTABLES rules set ... ${RESET}"
	iptables -L -v

	printf "%s\n" "${BOLD}IPV6 IPTABLES rules set ... ${RESET}"
	ip6tables -L -v

	printf "%s\n" "${BOLD}IPV4 IPTABLES iptables-save configuration: ${RESET}"
	iptables-save
	printf "%s\n" "${BOLD}IPV6 IPTABLES ip6tables-save configuration: ${RESET}"
	ip6tables-save

}


