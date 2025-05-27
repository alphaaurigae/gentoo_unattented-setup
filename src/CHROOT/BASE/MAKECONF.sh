	MAKECONF () {  # /etc/portage/make.conf # https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/USE
	NOTICE_START
		MAKECONF_VARIABLES () {
		NOTICE_START
			cat <<- EOF > /etc/portage/make.conf
			CC="$PRESET_CC"
			ACCEPT_KEYWORDS="$PRESET_ACCEPT_KEYWORDS"
			CHOST="$PRESET_CHOST_ARCH-$PRESET_CHOST_VENDOR-$PRESET_CHOST_OS-$PRESET_CHOST_LIBC"
			
			# (!NOTE) (!todo - not sure if this is "perfect" yet.. anyways, "it works". 
			CPU_FLAGS_X86="$PRESET_CPU_FLAGS_X86" # workaround to insert sse3 and sse4a - intentional, no idea if requ - testing ... .
			# CPU_FLAGS_X86="$(lscpu | grep Flags: | sed -e 's/Flags:               //g')" # lscpu hides sse3 and sse4a which are shown in cpuid.
			COMMON_FLAGS="$PRESET_COMMON_FLAGS"
			CONFIG_PROTECT="$PRESET_CONFIG_PROTECT"
			CFLAGS="${PRESET_COMMON_FLAGS}"
			CXXFLAGS="${PRESET_COMMON_FLAGS}"
			FCFLAGS="${PRESET_COMMON_FLAGS}"
			FFLAGS="${PRESET_COMMON_FLAGS}"
			LDFLAGS="$PRESET_LDFLAGS"
			RUSTFLAGS="$PRESET_RUSTFLAGS"
			MAKEOPTS="$PRESET_MAKE"
			EMERGE_DEFAULT_OPTS="$PRESET_EMERGE_DEFAULT_OPTS"
			INPUT_DEVICES="$PRESET_INPUTEVICE"
			VIDEO_CARDS="$PRESET_VIDEODRIVER"
			# Just a placeholder as sane setup sample on znver1 # VIDEO_CARDS="fbdev modesetting v4l vesa nvidia"
			ACCEPT_LICENSE="$PRESET_LICENCES"
			FEATURES="$PRESET_FEATURES"
			# Just a placeholder as sane setup sample on znver1 # FEATURES="candy binpkg-logs cgroup config-protect-if-modified nostrip distlocks downgrade-backup ebuild-locks fakeroot fixlafiles merge-sync noauto parallel-fetch parallel-install preserve-libs protect-owned sandbox sfperms suidctl split-elog split-log splitdebug test-fail-continue unknown-features-filter unknown-features-warn unmerge-backup unmerge-orphans userfetch userpriv usersandbox usersync xattr ipc-sandbox lmirror multilib-strict buildpkg  compress-index compressdebug" #collision-protect  compress-build-logs' #fail-clean # strict" # sign
			USE="PLACEHOLDER_USEFLAGS"
			GENTOO_MIRRORS="$PRESET_GENTOMIRRORS"
			PORTDIR="$PRESET_PORTDIR"
			DISTDIR="$PRESET_DISTDIR"
			PKGDIR="$PRESET_PKGDIR"
			PORTAGE_TMPDIR="$PRESET_PORTAGE_TMPDIR"
			PORTAGE_LOGDIR="$PRESET_PORTAGE_LOGDIR"
			PORTAGE_ELOG_CLASSES="$PRESET_PORTAGE_ELOG_CLASSES"
			PORTAGE_ELOG_SYSTEM="$PRESET_PORTAGE_ELOG_SYSTEM"
			LINGUAS="$PRESET_LINGUAS"
			L10N="$PRESET_L10N"  # IETF language tags
			LC_MESSAGES="$PRESET_LC_MESSAGES"
			# CURL_SSL="$PRESET_CURL_SSL"
			NOCOLOR="true"
			# just a placeholder as sane setup znver1 for later use # EMERGE_DEFAULT_OPTS="--autounmask=y --color=y --complete-graph=y --fail-clean=n --keep-going=y --misspell-suggestions=y --nospinner --package-moves=y --pkg-format=tar --quiet=n --quiet-build=y --quiet-fail=n --rebuild-if-new-slot=y --rebuild-if-unbuilt=y --search-index=n --tree --use-ebuild-visibility=y --verbose-slot-rebuilds=y  --verbose=y --depclean-lib-check=y --dynamic-deps=y --with-bdeps=y --jobs=15 --load-average=120" #--backtrack=10000000
			# just a placeholder as sane setup znver1 for later use # UWSGI_PLUGINS="geoip cache carbon corerouter fastrouter forkptyrouter http logfile rawrouter router_access router_basicauth router_cache router_memcached router_metrics router_redirect router_redis router_rewrite router_static router_uwsgi router_xmldir sslrouter transformation_chunked transformation_gzip"
			# just a placeholder as sane setup znver1 for later use # LLVM_TARGETS="X86 NVPTX"
			# just a placeholder as sane setup znver1 for later use # NGINX_MODULES_HTTP="access addition brotli charset fastcgi geoip2 gunzip gzip gzip_static headers_more javascript limit_conn limit_req memcached rewrite security slowfs_cache spdy upload_progress uwsgi"
			# just a placeholder as sane setup znver1 for later use # POSTGRES_TARGETS="postgres14"
			# just a placeholder as sane setup znver1 for later use # PYTHON_TARGETS="python3_10 python3_11"

			EOF
			
			#if [ $SYSAPP_DMCRYPT = "YES" ]; then
			#	echo "SYSAPP_DMCRYPT=YES"
			#	sed -ie "s/PLACEHOLDER_USEFLAGS/$PRESET_USEFLAG_CRYPTOPTANDCRYPTSETUP/g" /etc/portage/make.conf
			#else
			#	echo "SYSAPP_DMCRYPT=NO"
			#	sed -ie "s/PLACEHOLDER_USEFLAGS/$PRESET_USEFLAG_LVMROOTNOCRYPOPT/g" /etc/portage/make.conf
			#fi
			if [ "$SYSAPP_DMCRYPT" = "YES" ]; then
				echo "SYSAPP_DMCRYPT=YES"
				safe_use=$(printf '%s\n' "$PRESET_USEFLAG_CRYPTOPTANDCRYPTSETUP" | sed 's/[&|]/\\&/g')
				sed -i -e "s|PLACEHOLDER_USEFLAGS|$safe_use|" /etc/portage/make.conf
			else
				echo "SYSAPP_DMCRYPT=NO"
				safe_use=$(printf '%s\n' "$PRESET_USEFLAG_LVMROOTNOCRYPOPT" | sed 's/[&|]/\\&/g')
				sed -i -e "s|PLACEHOLDER_USEFLAGS|$safe_use|" /etc/portage/make.conf
			fi
		NOTICE_END
		}
		gcc -v
		cat /etc/portage/make.conf
		MAKECONF_VARIABLES
		cat /etc/portage/make.conf
		EMERGE_ATWORLD_B
	NOTICE_END
	}