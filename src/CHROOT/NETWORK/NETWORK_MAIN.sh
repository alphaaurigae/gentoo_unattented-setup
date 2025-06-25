get_all_nics # in var/chroot_variables.sh
NUM_NICS=$?
[ -z "$NIC1" ] && { echo "FATAL: NIC1 not set"; env | grep NIC; exit 1; }


netmask_to_prefix() {
	local mask="$1"
	printf "DEBUG: netmask_to_prefix input: %s\n" "$mask" >&2

	[[ "$mask" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || {
		printf "DEBUG: netmask_to_prefix failed regex check\n" >&2
		return 1
	}

	set -- ${mask//./ }
	[ $# -eq 4 ] || {
		printf "DEBUG: netmask_to_prefix split into wrong number of parts: %d\n" "$#" >&2
		return 1
	}

	local mask_bin="" bin
	for octet; do
		[[ "$octet" =~ ^[0-9]+$ ]] || {
			printf "DEBUG: netmask_to_prefix invalid numeric: %s\n" "$octet" >&2
			return 1
		}
		(( octet >= 0 && octet <= 255 )) || {
			printf "DEBUG: netmask_to_prefix octet out of range: %s\n" "$octet" >&2
			return 1
		}
		bin=$(printf "%08d" "$(bc <<< "obase=2;$octet")")
		mask_bin+="$bin"
	done

	printf "DEBUG: netmask_to_prefix binary mask: %s\n" "$mask_bin" >&2

	[[ "$mask_bin" =~ ^1*0*$ ]] || {
		printf "DEBUG: netmask_to_prefix non-contiguous mask bits: %s\n" "$mask_bin" >&2
		return 1
	}

	local prefix_len
	prefix_len=$(echo "$mask_bin" | tr -cd '1' | wc -c)

	printf "%d\n" "$prefix_len"
}
# --------------------------------------------------------------------------------------------------------------------------

NET_SYS() {
	NOTICE_START
	HOSTSFILE() {
		[ "$HOSTNAME" = "gentoo" ] && printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} HOSTNAME is set to default '${BOLD}gentoo${RESET}' — may conflict with package defaults or create ambiguity in logs" >&2
		[ "$DOMAIN" = "gentoo" ] && printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} DOMAIN is set to default '${BOLD}gentoo${RESET}' — may conflict with local DNS or hostname resolution" >&2
		[ "$HOSTNAME" = "$DOMAIN" ] && printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} HOSTNAME and DOMAIN are identical — can confuse service discovery, DNS resolution, and fqdn parsing" >&2
		[ -z "$HOSTNAME" ] && printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} HOSTNAME is empty — /etc/hostname and /etc/hosts may be invalid" >&2
		[ -z "$DOMAIN" ] && printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} DOMAIN is empty — FQDN in /etc/hosts may be invalid" >&2
		[[ "$HOSTNAME" =~ [^a-zA-Z0-9.-] ]] && printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} HOSTNAME contains invalid characters — allowed: a–z, A–Z, 0–9, ., -" >&2
		[[ "$DOMAIN" =~ [^a-zA-Z0-9.-] ]] && printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} DOMAIN contains invalid characters — allowed: a–z, A–Z, 0–9, ., -" >&2
		[[ "$HOSTNAME" =~ ^[-.] || "$HOSTNAME" =~ [-.]$ ]] && printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} HOSTNAME end with a hyphen or dot" >&2
		[[ "$DOMAIN" =~ ^[-.] || "$DOMAIN" =~ [-.]$ ]] && printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} DOMAIN end with a hyphen or dot" >&2
		[ $((${#HOSTNAME} + 1 + ${#DOMAIN})) -gt 253 ] && printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} FQDN exceeds 253 characters — may break DNS or system services" >&2


		printf '%s\n' "$HOSTNAME" >/etc/hostname
		cat <<-EOF >/etc/hosts
		127.0.0.1	localhost	localhost.localdomain
		::1	localhost	localhost.localdomain
		127.0.1.1	${HOSTNAME}.${DOMAIN}	${HOSTNAME}
		EOF
		cat /etc/hosts
	}
	HOSTSFILE
}

# --------------------------------------------------------------------------------------------------------------------------

EMERGE_DHCPCD() {  # https://wiki.gentoo.org/wiki/Dhcpcd
	NOTICE_START
	APPAPP_EMERGE="net-misc/dhcpcd "
	AUTOSTART_NAME_OPENRC="dhcpcd"
	AUTOSTART_NAME_SYSTEMD="dhcpcd"
	EMERGE_USERAPP_DEF
	AUTOSTART_DEFAULT_$SYSINITVAR
	NOTICE_END
}

# --------------------------------------------------------------------------------------------------------------------------

EMERGE_NETIFRC() {  # https://wiki.gentoo.org/wiki/Netifrc
	NOTICE_START
	APPAPP_EMERGE="net-misc/netifrc "
	VAR_EMERGE=" --noreplace net-misc/netifrc "
	AUTOSTART_NAME_OPENRC="net.$NIC1 "
	AUTOSTART_NAME_SYSTEMD="net@$NIC1"
	EMERGE_USERAPP_DEF
	AUTOSTART_DEFAULT_$SYSINITVAR
	NOTICE_END
}
# BLUEPRINT FOR TESTING - USE NETWORKMANAGER OR COMPLETE
CONF_NETIFRC_DHCP() {
	NOTICE_START
	case "$DNS_PROVIDER" in
		CUSTOM)
			dns_list="${NAMESERVER1_IPV4},${NAMESERVER2_IPV4},${NAMESERVER1_IPV6},${NAMESERVER2_IPV6}"
			;;
		DEFAULT|*)
			dns_list=""
			;;
	esac

	local conf=""

	for i in $(seq 1 "$NUM_NICS"); do
		nic_var="NIC${i}"
		nic="${!nic_var}"
		[ -n "$nic" ] || continue

		local mtu_var="MTU_NIC${i}"
		local mtu="${!mtu_var}"

		[ -n "$nic" ] || continue

		conf+="config_$nic=\"dhcp\"\n"
		conf+="dhcpv6_$nic=\"yes\"\n"
		[ -n "$dns_list" ] && conf+="dns_servers_$nic=\"$dns_list\"\n"
		[ -n "$mtu" ] && conf+="mtu_$nic=\"$mtu\"\n"
	done
	printf "%b" "$conf" > /etc/conf.d/net
	cat /etc/conf.d/net
	NOTICE_END
}
# BLUEPRINT FOR TESTING - USE NETWORKMANAGER OR COMPLETE
CONF_NETIFRC_STATIC() {
	NOTICE_START
	case "$DNS_PROVIDER" in
		CUSTOM) dns_list="${NAMESERVER1_IPV4},${NAMESERVER2_IPV4},${NAMESERVER1_IPV6},${NAMESERVER2_IPV6}" ;;
		*) dns_list="" ;;
	esac

	local conf=""

	for i in $(seq 1 "$NUM_NICS"); do
		nic_var="NIC${i}"
		nic="${!nic_var}"
		[ -n "$nic" ] || continue

		local ipv4_var="IPV4_${nic_var}_STATIC"
		local ipv6_var="IPV6_${nic_var}_STATIC"
		local ipv6_prefix_var="IPV6_PREFIX_${nic_var}_STATIC"
		local netmask_var="NETMASK_${nic_var}_STATIC"
		local mtu_var="MTU_${nic_var}"

		local ipv4="${!ipv4_var}"
		local ipv6="${!ipv6_var}"
		local ipv6_prefix="${!ipv6_prefix_var}"
		local netmask="${!netmask_var}"
		local mtu="${!mtu_var}"

		local config_line=()
		[ -n "$ipv4" ] && config_line+=("$ipv4 netmask $netmask")
		[ -n "$ipv6" ] && [ -n "$ipv6_prefix" ] && config_line+=("$ipv6/$ipv6_prefix")
		conf+="config_$nic=(${config_line[*]})\n"

		[ -n "$IPV4_GATEWAY_STATIC" ] && conf+="routes_$nic=\"default via $IPV4_GATEWAY_STATIC\"\n"
		[ -n "$GATEWAY_IPV6_STATIC" ] && conf+="routes_$nic=\"\$routes_$nic default via $GATEWAY_IPV6_STATIC\"\n"
		[ -n "$dns_list" ] && conf+="dns_servers_$nic=\"$dns_list\"\n"
		[ -n "$mtu" ] && conf+="mtu_$nic=\"$mtu\"\n"
	done

	printf "%b" "$conf" > /etc/conf.d/net
	cat /etc/conf.d/net
	NOTICE_END
}
# BLUEPRINT FOR TESTING - USE NETWORKMANAGER OR COMPLETE
DEBUG_NETIFRC() {
	NOTICE_START

	if [ ! -s /etc/conf.d/net ]; then
		printf '%s\n' 'ERROR: /etc/conf.d/net is missing or empty'
		return
	fi

	printf '%s\n' '--- CONTENTS OF /etc/conf.d/net ---'
	cat /etc/conf.d/net

	local config_content
	config_content="$(< /etc/conf.d/net)"

	validate_dhcp() {
		local nic="$1" mtu="$2"
		printf '%s\n' 'MODE: DHCP'

		printf '%s\n' "$config_content" | grep -q "dhcpv6_${nic}=" || printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} MISSING: dhcpv6_%s entry" "$nic"
		[ -n "$mtu" ] && printf '%s\n' "$config_content" | grep -q "mtu_${nic}=\"${mtu}\"" || printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} MISSING: MTU for %s" "$nic"
		printf '%s\n' "$config_content" | grep -q "^dns_servers_${nic}=" || printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} No static DNS for DHCP on %s" "$nic"
	}

	validate_static() {
		local nic="$1" mtu="$2"
		local nic_var="NIC${nic#NIC}"
		local ipv4="${!IPV4_${nic_var}_STATIC}"
		local netmask="${!NETMASK_${nic_var}_STATIC}"
		local ipv6="${!IPV6_${nic_var}_STATIC}"
		local ipv6_prefix="${!IPV6_PREFIX_${nic_var}_STATIC}"

		printf '%s\n' 'MODE: STATIC'

		[ -n "$ipv4" ] && [ -n "$netmask" ] && printf '%s\n' "$config_content" | grep -q "${ipv4} netmask ${netmask}" || printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} MISSING: IPv4 + netmask for %s" "$nic"
		[ -n "$ipv6" ] && [ -n "$ipv6_prefix" ] && printf '%s\n' "$config_content" | grep -q "${ipv6}/${ipv6_prefix}" || printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} MISSING: IPv6/prefix for %s" "$nic"
		[ -n "$mtu" ] && printf '%s\n' "$config_content" | grep -q "mtu_${nic}=\"${mtu}\"" || printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} MISSING: MTU for %s" "$nic"
		printf '%s\n' "$config_content" | grep -q "^routes_${nic}=" || printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} No routes defined for %s" "$nic"
		printf '%s\n' "$config_content" | grep -q "^dns_servers_${nic}=" || printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} No static DNS for %s" "$nic"
	}

	for i in 1 2; do
		local nic_var="NIC${i}"
		local nic="${!nic_var}"
		[ -n "$nic" ] || continue

		printf '\n--- VERIFY CONFIG FOR NIC: %s ---\n' "$nic"

		local mtu_var="MTU_${nic_var}"
		local mtu="${!mtu_var}"

		grep -q "^config_${nic}=" <<< "$config_content" || {
			printf "%s\n" "${BOLD}${MAGENTA}WARNING:${RESET} MISSING:config_%s entry $nic"
			continue
		}

		case "$config_content" in
			*config_${nic}=\"dhcp\"*)
				validate_dhcp "$nic" "$mtu"
				;;
			*)
				validate_static "$nic" "$mtu"
				;;
		esac
	done

	NOTICE_END
}
# --------------------------------------------------------------------------------------------------------------------------


EMERGE_NETWORKMANAGER() {  # https://wiki.gentoo.org/wiki/NetworkManager
	NOTICE_START
	APPAPP_EMERGE="net-misc/networkmanager "
	AUTOSTART_NAME_OPENRC="NetworkManager"
	AUTOSTART_NAME_SYSTEMD="NetworkManager"
	PACKAGE_USE
	ACC_KEYWORDS_USERAPP
	EMERGE_ATWORLD
	EMERGE_USERAPP_DEF
	AUTOSTART_DEFAULT_$SYSINITVAR
	NOTICE_END
}

CONFIGURE_NETWORKMANAGER_STATIC() {
	NOTICE_START
	printf "%s\n" "${NAMESERVER1_IPV4},${NAMESERVER2_IPV4} ${NAMESERVER1_IPV6},${NAMESERVER2_IPV6}"

	dhcpcd_conf () {
		printf "%s\n" "Removing or adding 'nohook resolv.conf' in /etc/dhcpcd.conf"
		if [ "$1" = "remove_nohook" ]; then
			sed -i '/^nohook resolv.conf$/d' /etc/dhcpcd.conf
			printf "%s\n" "Removed 'nohook resolv.conf' from /etc/dhcpcd.conf"
		else
			if grep -qxF 'nohook resolv.conf' /etc/dhcpcd.conf; then
				printf "%s\n" "nohook resolv.conf already present in /etc/dhcpcd.conf"
			else
				printf "%s\n" "nohook resolv.conf" >> /etc/dhcpcd.conf
				printf "%s\n" "Added 'nohook resolv.conf' to /etc/dhcpcd.conf"
			fi
		fi
	}

	networkmanager_conf () {
		mkdir -p /etc/NetworkManager
		cat <<-EOF > /etc/NetworkManager/NetworkManager.conf
		[main]
		dns=default
		[ifupdown]
		managed=true
		EOF
		printf "%s\n" "Wrote /etc/NetworkManager/NetworkManager.conf"
	}

	resolv_conf () {
		ln -sfT /run/NetworkManager/resolv.conf /etc/resolv.conf
		printf "%s\n" "Linked /etc/resolv.conf to /run/NetworkManager/resolv.conf"
	}

	write_connection_static() {
		for i in $(seq 1 "$NUM_NICS"); do
			nic_var="NIC${i}"
			nic="${!nic_var}"
			[ -n "$nic" ] || continue

			ipv4_var="IPV4_${nic_var}_STATIC"
			netmask_var="NETMASK_${nic_var}_STATIC"
			ipv6_var="IPV6_${nic_var}_STATIC"
			ipv6_prefix_var="IPV6_PREFIX_${nic_var}_STATIC"
			mtu_var="MTU_${nic_var}"

			ipv4="${!ipv4_var}"
			netmask="${!netmask_var}"
			ipv6="${!ipv6_var}"
			ipv6_prefix="${!ipv6_prefix_var}"
			mtu="${!mtu_var}"

			address_line_ipv4=""
			if [ -n "$ipv4" ]; then
				if [ -n "$netmask" ]; then
					prefix_len=$(netmask_to_prefix "$netmask" 2>/dev/null) || {
						printf >&2 "ERROR: Invalid IPv4 netmask for %s: %s\n" "$nic" "$netmask"
						continue
					}
					address_line_ipv4="${ipv4}/${prefix_len}"
				else
					printf >&2 "ERROR: Missing IPv4 netmask for %s\n" "$nic"
					continue
				fi
			fi

			address_line_ipv6=""
			if [ -n "$ipv6" ]; then
				if [ -n "$ipv6_prefix" ]; then
					address_line_ipv6="${ipv6}/${ipv6_prefix}"
				else
					printf >&2 "ERROR: Missing IPv6 prefix for %s\n" "$nic"
					continue
				fi
			fi

			conn_name="Wired_connection_$i"
			uuid=$(uuidgen)
			mtu_val=${mtu:-1500}

			mkdir -p /etc/NetworkManager/system-connections
			file="/etc/NetworkManager/system-connections/${conn_name}.nmconnection"
			rm -rf /etc/NetworkManager/system-connections/*
			cat <<-EOF > "$file"
			[connection]
			id=${conn_name}
			uuid=${uuid}
			type=ethernet
			interface-name=${nic}
			autoconnect=true

			[ethernet]
			mtu=${mtu_val}

			[ipv4]
			method=manual
			addresses=${address_line_ipv4}
			gateway=${IPV4_GATEWAY_STATIC}
			$(if [ "$DNS_PROVIDER" = "CUSTOM" ]; then
				printf "ignore-auto-dns=true\ndns=%s;%s\n" "$NAMESERVER1_IPV4" "$NAMESERVER2_IPV4"
			else
				printf "ignore-auto-dns=false\n"
			fi)
			EOF

			if [ -n "$ipv6" ] && [ -n "$ipv6_prefix" ]; then
			    cat >> "$file" <<-EOF
			    [ipv6]
			    method=manual
			    addresses=${ipv6}/${ipv6_prefix}
			    gateway=${GATEWAY_IPV6_STATIC}
			    $(if [ "$DNS_PROVIDER" = "CUSTOM" ]; then
				printf "ignore-auto-dns=true\ndns=%s;%s\n" "$NAMESERVER1_IPV6" "$NAMESERVER2_IPV6"
			    else
				printf "ignore-auto-dns=false\n"
			    fi)
			EOF
			else
			    cat >> "$file" <<-EOF
			    [ipv6]
			    method=disabled
			EOF
			fi

			chmod 600 "$file"
			chown root:root "$file"
			cat "$file"
		done
	}
	dhcpcd_conf
	networkmanager_conf
	resolv_conf

	rm -rf /var/lib/NetworkManager/*leases
	if [ -x /etc/init.d/NetworkManager ]; then
		/etc/init.d/NetworkManager restart
	else
		systemctl restart NetworkManager
	fi
	printf "DEBUG: NIC1=%s\n" "$NIC1"
	write_connection_static

	if [ -x /etc/init.d/NetworkManager ]; then
		/etc/init.d/NetworkManager restart
	else
		systemctl restart NetworkManager
	fi
	printf "%s\n" "NetworkManager restarted"

	NOTICE_END
}

CONFIGURE_NETWORKMANAGER_DHCP() {
	NOTICE_START
	printf "%s\n" "${NAMESERVER1_IPV4},${NAMESERVER2_IPV4} ${NAMESERVER1_IPV6},${NAMESERVER2_IPV6}"

	dhcpcd_conf () {
		printf "%s\n" "Removing or adding 'nohook resolv.conf' in /etc/dhcpcd.conf"
		if [ "$1" = "remove_nohook" ]; then
			sed -i '/^nohook resolv.conf$/d' /etc/dhcpcd.conf
			printf "%s\n" "Removed 'nohook resolv.conf' from /etc/dhcpcd.conf"
		else
			if grep -qxF 'nohook resolv.conf' /etc/dhcpcd.conf; then
				printf "%s\n" "nohook resolv.conf already present in /etc/dhcpcd.conf"
			else
				printf "%s\n" "nohook resolv.conf" >> /etc/dhcpcd.conf
				printf "%s\n" "Added 'nohook resolv.conf' to /etc/dhcpcd.conf"
			fi
		fi
	}
	networkmanager_conf () {
		mkdir -p /etc/NetworkManager
		cat <<-EOF > /etc/NetworkManager/NetworkManager.conf
		[main]
		dns=default
		[ifupdown]
		managed=true
		EOF
		printf "%s\n" "Wrote /etc/NetworkManager/NetworkManager.conf"
	}
	resolv_conf () {
		ln -sfT /run/NetworkManager/resolv.conf /etc/resolv.conf
		printf "%s\n" "Linked /etc/resolv.conf to /run/NetworkManager/resolv.conf"
	}

	write_connection_dhcp () {

		printf "DEBUG: NUM_NICS=%s\n" "$NUM_NICS"
		for i in $(seq 1 "$NUM_NICS"); do
			nic_var="NIC${i}"
			nic="${!nic_var}"
			[ -n "$nic" ] || continue
			echo "$nic_var" 
			conn_name="Wired_connection_$i"
			uuid=$(uuidgen)
			mtu_val=${MTU_NIC1:-1500}

			mkdir -p /etc/NetworkManager/system-connections
			file="/etc/NetworkManager/system-connections/${conn_name}.nmconnection"

			cat <<-EOF > "$file"
			[connection]
			id=${conn_name}
			uuid=${uuid}
			type=ethernet
			interface-name=${nic}
			autoconnect=true

			[ethernet]
			mtu=${mtu_val}

			[ipv4]
			method=auto
			$(if [ "$DNS_PROVIDER" = "CUSTOM" ]; then
				printf "ignore-auto-dns=true\ndns=${NAMESERVER1_IPV4};${NAMESERVER2_IPV4};"
			else
				printf "ignore-auto-dns=false"
			fi)

			[ipv6]
			method=auto
			$(if [ "$DNS_PROVIDER" = "CUSTOM" ]; then
				printf "ignore-auto-dns=true\ndns=${NAMESERVER1_IPV6};${NAMESERVER2_IPV6};"
			else
				printf "ignore-auto-dns=false"
			fi)
			EOF
			chmod 600 "$file"
			chown root:root "$file"
			printf "%s\n" "Wrote $file"
			cat "$file"
		done
	}

	dhcpcd_conf
	networkmanager_conf
	resolv_conf

	rm -rf /var/lib/NetworkManager/*leases

	if [ -x /etc/init.d/NetworkManager ]; then
		/etc/init.d/NetworkManager restart
	else
		systemctl restart NetworkManager
	fi
	printf "%s\n" "NetworkManager restarted"


	printf "DEBUG: NIC1=%s\n" "$NIC1"
	write_connection_dhcp
	if [ -x /etc/init.d/NetworkManager ]; then
		/etc/init.d/NetworkManager restart
	else
		systemctl restart NetworkManager
	fi
	printf "%s\n" "NetworkManager restarted"
	NOTICE_END
}
DEBUG_NETWORKMANAGER() {
	NOTICE_START

	printf "DEBUG: Listing /etc/NetworkManager/system-connections/\n"
	ls -l /etc/NetworkManager/system-connections/

	for i in $(seq 1 "$NUM_NICS"); do
		nic_var="NIC${i}"
		nic="${!nic_var}"
		[ -n "$nic" ] || continue

		conn_name="Wired_connection_$i"
		file="/etc/NetworkManager/system-connections/${conn_name}.nmconnection"

		printf "DEBUG: Connection file for %s: %s\n" "$nic" "$file"

		if [ -f "$file" ]; then
			printf "DEBUG: Content of %s:\n" "$file"
			cat "$file"

			ipv4_method=$(awk -F= '/^\[ipv4\]/{f=1} f && /^method=/{print $2; exit}' "$file")
			ipv6_method=$(awk -F= '/^\[ipv6\]/{f=1} f && /^method=/{print $2; exit}' "$file")
			custom_dns_ipv4=$(awk -F= '/^\[ipv4\]/{f=1} f && /^dns=/{print $2; exit}' "$file")
			custom_dns_ipv6=$(awk -F= '/^\[ipv6\]/{f=1} f && /^dns=/{print $2; exit}' "$file")
			addresses_ipv4=$(awk -F= '/^\[ipv4\]/{f=1} f && /^addresses=/{print $2; exit}' "$file")
			addresses_ipv6=$(awk -F= '/^\[ipv6\]/{f=1} f && /^addresses=/{print $2; exit}' "$file")
			mtu=$(awk -F= '/^\[ethernet\]/{f=1} f && /^mtu=/{print $2; exit}' "$file")

			printf "DEBUG: NIC%d %s Setup Summary:\n" "$i" "$nic"
			printf "       IPv4 method: %s\n" "${ipv4_method:-missing}"
			printf "       IPv6 method: %s\n" "${ipv6_method:-missing}"
			printf "       IPv4 static address: %s\n" "${addresses_ipv4:-none}"
			printf "       IPv6 static address: %s\n" "${addresses_ipv6:-none}"
			printf "       Custom DNS IPv4: %s\n" "${custom_dns_ipv4:-none}"
			printf "       Custom DNS IPv6: %s\n" "${custom_dns_ipv6:-none}"
			printf "       MTU: %s\n" "${mtu:-default}"

			if [ "$ipv4_method" = "manual" ] || [ "$ipv6_method" = "manual" ]; then
				printf "INFO: NIC%d %s configured as STATIC\n" "$i" "$nic"
			elif [ "$ipv4_method" = "auto" ] || [ "$ipv6_method" = "auto" ]; then
				printf "INFO: NIC%d %s configured as DHCP\n" "$i" "$nic"
			else
				printf "WARNING: NIC%d %s has unknown IP method configuration\n" "$i" "$nic"
			fi

		else
			printf "DEBUG: File %s does not exist\n" "$file"
		fi

		ipv4_var="IPV4_NIC${i}_STATIC"
		ipv6_var="IPV6_NIC${i}_STATIC"
		mtu_var="MTU_NIC${i}"

		printf "DEBUG: Variables for NIC%d: IPv4=%s, IPv6=%s, MTU=%s\n" "$i" "${!ipv4_var}" "${!ipv6_var}" "${!mtu_var}"
	done

	#printf "DEBUG: /etc/dhcpcd.conf existence and contents\n"
	#if [ -f /etc/dhcpcd.conf ]; then
#		head -40 /etc/dhcpcd.conf
#	else
#		printf "DEBUG: /etc/dhcpcd.conf not found\n"
#	fi
#
#	printf "DEBUG: /etc/NetworkManager/NetworkManager.conf contents\n"
#	if [ -f /etc/NetworkManager/NetworkManager.conf ]; then
#		cat /etc/NetworkManager/NetworkManager.conf
##	else
#		printf "DEBUG: /etc/NetworkManager/NetworkManager.conf not found\n"
#	fi
#
#	printf "DEBUG: /etc/resolv.conf symlink target\n"
#	readlink -f /etc/resolv.conf
#
#	printf "DEBUG: NetworkManager service status\n"
#	if command -v systemctl &>/dev/null; then
#		systemctl status NetworkManager --no-pager | head -20
#	elif [ -x /etc/init.d/NetworkManager ]; then
#		/etc/init.d/NetworkManager status
#	else
#		printf "DEBUG: NetworkManager service status command not found\n"
#	fi

	NOTICE_END
}
# --------------------------------------------------------------------------------------------------------------------------

# For later systemd addition
#NETWORKD() { # https://wiki.archlinux.org/index.php/Systemd-networkd
#	NOTICE_START
#	systemctl enable systemd-networkd.service
#	REPLACE_RESOLVECONF() { # (! default)
#		ln -snf /run/systemd/resolved.conf /etc/resolv.conf
#		systemctl enable systemd-resolved.service
#		NOTICE_END
#	}
#	WIRED_DHCPD() { # (! default)
#		NOTICE_START
#		cat <<-'EOF' >/etc/systemd/network/20-wired.network
#			[ Match ]
#			Name=enp0s3
#			[ Network ]
#			DHCP=ipv4
#		EOF
#		NOTICE_END
#	}
#	WIRED_STATIC() {
#		NOTICE_START
#		cat <<-EOF >/etc/systemd/network/20-wired.network
#			[ Match ]
#			Name=enp0s3
#			[ Network ]
#			Address=$IPV4_NIC1_STATIC/24
#			Gateway=$IPV4_GATEWAY_STATIC
#			DNS=$NAMESERVER1_IPV4,$NAMESERVER2_IPV4,$NAMESERVER1_IPV6,$NAMESERVER2_IPV6
#		EOF
#		NOTICE_END
#	}
#	REPLACE_RESOLVECONF
#	WIRED_$NETWORK_NET
#	NOTICE_END
#}

# --------------------------------------------------------------------------------------------------------------------------




# Network setup
NETWORK_MAIN() {
	NOTICE_START
	SWITCHFOR_DHCP_OR_STATIC () {
		NETWORK_DHCP() {
			NOTICE_START
			case "$NETWORK_CHOICE" in
				NETIFRC)
					printf "%s\n" "NETIFRC placeholder - choose a network manager setup or complete the function"
					#EMERGE_DHCPCD
					#EMERGE_NETIFRC
					#CONF_NETIFRC_DHCP
					#DEBUG_NETIFRC
					;;
				NETWORKMANAGER)
					EMERGE_DHCPCD
					EMERGE_NETWORKMANAGER
					CONFIGURE_NETWORKMANAGER_DHCP
					DEBUG_NETWORKMANAGER
					;;
			esac
			NOTICE_END
		}
		NETWORK_STATIC() {
			NOTICE_START
			case "$NETWORK_CHOICE" in
				NETIFRC)
					printf "%s\n" "NETIFRC placeholder - choose a network manager setup or complete the function"
					#EMERGE_NETIFRC
					#CONF_NETIFRC_STATIC
					#DEBUG_NETIFRC
					;;
				NETWORKMANAGER)
					EMERGE_NETWORKMANAGER
					CONFIGURE_NETWORKMANAGER_STATIC
					DEBUG_NETWORKMANAGER
					;;
			esac
			NOTICE_END
		}
		NETWORK_$NETWORK_NET
	}

	NET_SYS  # First network base settings / config e.g hostname & hosts
	SWITCHFOR_DHCP_OR_STATIC # Second network DHCP OR STATIC with NETWORKMANAGER alternatively IFRC

	NOTICE_END
}

