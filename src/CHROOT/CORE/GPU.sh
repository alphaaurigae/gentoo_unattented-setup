#	GPU () {  # (!todo)
#	NOTICE_START
#		SET_NONE () {
#		NOTICE_START
#			NOTICE_PLACEHOLDER
#		
#		}
#		SET_NVIDIA () {  # (!todo)
#			NOTICE_PLACEHOLDER
#		} 
#		SET_AMD () {  # (!todo)
#			RADEON () {  # (!todo)
#				APPAPP_EMERGE=" "
#				EMERGE_USERAPP_DEF
#			}
#			AMDGPUDEF () {  # (!todo)
#				APPAPP_EMERGE=" "
#				EMERGE_USERAPP_DEF
#				# radeon-ucode
#			}
#			AMDGPUPRO () {  # (!todo)
#				APPAPP_EMERGE="dev-libs/amdgpu-pro-opencl "
#				EMERGE_USERAPP_DEF
#			}
#			# RADEON
#			# AMDGPUDEF
#			AMDGPUPRO
#		}
#		$GPU_SET
#	}