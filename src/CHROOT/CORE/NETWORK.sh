	NETWORK () {  # (!todo)
	NOTICE_START
		NET_SYS () {
		NOTICE_START
			HOSTSFILE () {  # (! default)
				echo "$HOSTNAME" > /etc/hostname
				echo "127.0.0.1	localhost
				::1		localhost
				127.0.1.1	$HOSTNAME.$DOMAIN	$HOSTNAME" > /etc/hosts
				cat /etc/hosts
			}
			HOSTSFILE
		}
		NET_MGMT () {
		NOTICE_START
			GENTOO_DEFAULT () {
			NOTICE_START
				NETIFRC () {  # (! default)
				NOTICE_START
					APPAPP_EMERGE="net-misc/netifrc "
					VAR_EMERGE=" --noreplace net-misc/netifrc " 
					AUTOSTART_NAME_OPENRC="net.$NETIFACE_MAIN "
					AUTOSTART_NAME_SYSTEMD="net@$NETIFACE_MAIN"
					CONF_NETIFRC () {
					NOTICE_START
						cat <<- EOF > /etc/conf.d/net  # Please read /usr/share/doc/netifrc-*/net.example.bz2 for a list of all available options. DHCP client man page if specific DHCP options need to be set.
						config_$NETIFACE_MAIN="dhcp"
						EOF
						cat /etc/conf.d/net
					NOTICE_END
					}
					EMERGE_USERAPP_DEF
					CONF_NETIFRC
					AUTOSTART_DEFAULT_$SYSINITVAR
				NOTICE_END
				}
				NETIFRC
			NOTICE_END
			}
			OPENRC_DEFAULT () {
			NOTICE_START
				NOTICE_PLACEHOLDER
			NOTICE_END
			}
			SYSTEMD_DEFAULT () {
			NOTICE_START
				NETWORKD () {  # https://wiki.archlinux.org/index.php/Systemd-networkd
				NOTICE_START
					systemctl enable systemd-networkd.service
					REPLACE_RESOLVECONF () {  # (! default)
						ln -snf /run/systemd/resolved.conf /etc/resolv.conf
						systemctl enable systemd-resolved.service
					NOTICE_END
					}
					WIRED_DHCPD () {  # (! default)
					NOTICE_START
						cat <<- 'EOF' > /etc/systemd/network/20-wired.network
						[ Match ]
						Name=enp0s3
						[ Network ]
						DHCP=ipv4
						EOF
					NOTICE_END
					}
					WIRED_STATIC () {
					NOTICE_START
						cat <<- 'EOF' > /etc/systemd/network/20-wired.network
						[ Match ]
						Name=enp0s3
						[ Network ]
						Address=10.1.10.9/24
						Gateway=10.1.10.1
						DNS=10.1.10.1
						# DNS=8.8.8.8
						EOF
					NOTICE_END
					}
					REPLACE_RESOLVECONF
					WIRED_$NETWORK_NET
				NOTICE_END
				}
				NETWORKD
			NOTICE_END
			}
			DHCCLIENT () {
			NOTICE_START
				DHCPCD () {  # https://wiki.gentoo.org/wiki/Dhcpcd
				NOTICE_START
					APPAPP_EMERGE="net-misc/dhcpcd "
					AUTOSTART_NAME_OPENRC="dhcpcd"
					AUTOSTART_NAME_SYSTEMD="dhcpcd"
					EMERGE_USERAPP_DEF
					AUTOSTART_DEFAULT_$SYSINITVAR
				NOTICE_END
				}
				DHCPCD
			NOTICE_END
			}
			NETWORKMANAGER () {
			NOTICE_START
				EMERGE_NETWORKMANAGER () {
				NOTICE_START
					APPAPP_EMERGE="net-misc/networkmanager "
					AUTOSTART_NAME_OPENRC="NetworkManager"
					AUTOSTART_NAME_SYSTEMD="NetworkManager"
					PACKAGE_USE
					ACC_KEYWORDS_USERAPP
					EMERGE_ATWORLD_A
					EMERGE_USERAPP_DEF
					AUTOSTART_DEFAULT_$SYSINITVAR
				NOTICE_END
				}
				EMERGE_NETWORKMANAGER
				AUTOSTART_DEFAULT_$SYSINITVAR
			NOTICE_END
			}
			DHCCLIENT
			$NETWMGR
		NOTICE_END
		}
		NET_FIREWALL () {
		NOTICE_START
			#UFW () {  # https://wiki.gentoo.org/wiki/Ufw
			#NOTICE_START
			#	
			#	APPAPP_EMERGE="net-firewall/ufw"
			#	AUTOSTART_NAME_OPENRC="ufw"
			#	AUTOSTART_NAME_SYSTEMD="ufw"
			#	PACKAGE_USE
			#	ACC_KEYWORDS_USERAPP
			#	EMERGE_USERAPP_DEF
			#	AUTOSTART_DEFAULT_$SYSINITVAR							
			#}
			IPTABLES () {  # https://wiki.gentoo.org/wiki/Iptables
			NOTICE_START
				APPAPP_EMERGE="net-firewall/iptables"
				AUTOSTART_NAME_OPENRC="iptables"
				AUTOSTART_NAME_SYSTEMD="iptables"
				PACKAGE_USE
				ACC_KEYWORDS_USERAPP
				EMERGE_USERAPP_DEF
				AUTOSTART_DEFAULT_$SYSINITVAR
			NOTICE_END						
			}
			#UFW
			IPTABLES
		NOTICE_END
		}
		#NET_FTP () {
		#NOTICE_START
		#	CLIENT () {
		#	NOTICE_START
		#		FTP () {
		#		NOTICE_START
		#			APPAPP_EMERGE="net-ftp/ftp"
		#			# PACKAGE_USE
		#			ACC_KEYWORDS_USERAPP
		#			EMERGE_USERAPP_DEF
		#			AUTOSTART_DEFAULT_$SYSINITVAR
		#		NOTICE_END
		#		}
		#		#FILEZILLA () {  (# build fail # dep x11?)
		#		#	APPAPP_EMERGE="net-ftp/filezilla"
		#		#	# PACKAGE_USE
		#		#	ACC_KEYWORDS_USERAPP
		#		#	EMERGE_USERAPP_DEF
		#		#	AUTOSTART_DEFAULT_$SYSINITVAR
		#		#NOTICE_END
		#		#}
		#		FTP
		#		#FILEZILLA
		#	NOTICE_END
		#	}
		#	CLIENT
		#NOTICE_END
		#}
		NET_SYS
		NET_MGMT
		NET_FIREWALL
		##NET_FTP
		NOTICE_END
	}