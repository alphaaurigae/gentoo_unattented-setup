	RELOADING_SYS () {
	NOTICE_START
		RELOAD_OPENRC () {
			NOTICE_PLACEHOLDER
		}
		RELOAD_SYSTEMD () {
		NOTICE_START
			systemctl preset-all
			systemctl daemon-reload
			ENVUD
		NOTICE_END
		}
		RELOAD_$SYSINITVAR
	NOTICE_END
	}