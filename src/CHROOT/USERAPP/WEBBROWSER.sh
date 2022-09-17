	WEBBROWSER () {
	NOTICE_START
		USERAPP_FIREFOX () {
		NOTICE_START
			APPAPP_EMERGE="www-client/firefox"
			PACKAGE_USE
			ACC_KEYWORDS_USERAPP
			EMERGE_USERAPP_DEF
		NOTICE_END
		}
		USERAPP_CHROMIUM () {  # (!todo)
		NOTICE_START
			APPAPP_EMERGE="www-client/chromium"
			PACKAGE_USE
			EMERGE_USERAPP_DEF
			etc-update --automode -3
		NOTICE_END
		}
		USERAPP_MIDORI () {  # (!todo)
		NOTICE_START
			APPAPP_EMERGE="www-client/midori"
			PACKAGE_USE
			EMERGE_USERAPP_DEF
		NOTICE_END
		}
		RUN_ALLYES_USERAPP () {
		NOTICE_START
			for i in  ${!USERAPP_*}
			do
				if [ $(printf '%s\n' "${!i}") == "YES" ]; then
					$i
				else 
					printf '%s\n' "$i is set to ${!i}, test for boot fs ..." 
				fi
			done
		NOTICE_END
		}
		RUN_ALLYES_USERAPP
	NOTICE_END
	}