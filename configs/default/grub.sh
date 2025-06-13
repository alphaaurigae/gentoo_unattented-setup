# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'
GRUB_DEFAULT=0
GRUB_TIMEOUT_STYLE=countdown
GRUB_TIMEOUT=2
#GRUB_FONT=/boot/grub/fonts/unicode.pf2
#GRUB_DISTRIBUTOR=``
GRUB_CMDLINE_LINUX_DEFAULT=""
GRUB_CMDLINE_LINUX=""
# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"
# Uncomment to disable graphical terminal (grub-pc only)
#GRUB_TERMINAL=console
# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command vbeinfo
#GRUB_GFXMODE=640x480

# ############################################################################################################################################################################
# https://www.gnu.org/software/grub/manual/grub/html_node/Root-Identifcation-Heuristics.html              #
#													  #
# Initrd-detected| GRUB_DISABLE_LINUX_PARTUUID |GRUB_DISABLE_LINUX_UUID	| Linux Root ID Method  	  #
# false			false			false			part UUID			  #
# false			false			true			part UUID			  #
# false			true			false			dev name			  #
# false			true			true			dev name			  #
# true			false			false			fs UUID				  #
# true			false			true			part UUID				  #
# true			true			false			fs UUID				  #
# true			true			true			dev name				  #
#														  #
# Remember, ‘GRUB_DISABLE_LINUX_PARTUUID’ and ‘GRUB_DISABLE_LINUX_UUID’ are also considered to be set to  #
# ... ‘false’ when they are unset. 									  #
# ############################################################################################################################################################################
# Uncomment if you don't want GRUB to pass "root=UUID=xxx" parameter to Linux
GRUB_DISABLE_LINUX_UUID=false

# Since version 2.04. If false, and if there is either no initramfs or GRUB_DISABLE_LINUX_UUID is set to true, ${GRUB_DEVICE_PARTUUID} is passed in the root parameter on the kernel command line. See Root identification Heuristics
GRUB_DISABLE_LINUX_PARTUUID=false
# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY="true"
# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE="480 440 1"
GRUB_ENABLE_CRYPTODISK=y
GRUB_PRELOAD_MODULES="lvm luks cryptodisk crypto ext2 part_gpt part_msdos gettext gzio"
GRUB_DISABLE_OS_PROBER=false
