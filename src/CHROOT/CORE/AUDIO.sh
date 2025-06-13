AUDIO() { # (!todo)
	NOTICE_START
	SOUND_API() {
		NOTICE_START
		LIBSNDFILE() {
			NOTICE_START
			USE="minimal" emerge -q media-libs/libsndfile
			NOTICE_END
		}
		ALSA() { # https://wiki.gentoo.org/wiki/ALSA
			NOTICE_START
			USEFLAGS_ALSA
			APPAPP_EMERGE="media-sound/alsa-utils"
			AUTOSTART_NAME_OPENRC="alsasound"
			AUTOSTART_NAME_SYSTEMD="alsa-restore"
			EMERGE_ATWORLD_B
			EMERGE_USERAPP_DEF
			APPAPP_EMERGE="media-plugins/alsa-plugins "
			# USE="ffmpeg" emerge -q media-plugins/alsa-plugins
			EMERGE_USERAPP_DEF
			AUTOSTART_DEFAULT_$SYSINITVAR
			NOTICE_END
		}
		LIBSNDFILE
		ALSA
		NOTICE_END
	}
	SOUND_SERVER() {
		NOTICE_START
		JACK() {
			NOTICE_START
			APPAPP_EMERGE="media-sound/jack2 "
			PACKAGE_USE
			EMERGE_USERAPP_DEF
			ENVUD
			NOTICE_END
		}
		PULSEAUDIO() {
			NOTICE_START
			APPAPP_EMERGE="media-sound/pulseaudio "
			PACKAGE_USE
			EMERGE_USERAPP_DEF
			ENVUD
			NOTICE_END
		}
		JACK
		PULSEAUDIO
		NOTICE_END
	}
	SOUND_MIXER() {
		NOTICE_START
		PAVUCONTROL() {
			NOTICE_START
			APPAPP_EMERGE="media-sound/pavucontrol "
			EMERGE_USERAPP_DEF
			NOTICE_END
		}
		PAVUCONTROL
		NOTICE_END
	}
	SOUND_API
	SOUND_SERVER
	SOUND_MIXER
	NOTICE_END
}
