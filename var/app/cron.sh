## CRON - https://wiki.gentoo.org/wiki/Cron#Which_cron_is_right_for_the_job.3F
# BCRON # http://untroubled.org/bcron
BCRON_CRON_SYSTEMD="placeholder"
BCRON_CRON_OPENRC="placeholder"
BCRON_CRON_EMERGE="sys-process/bcron"
# FCRON # http://www.linuxfromscratch.org/blfs/view/systemd/general/fcron.html
FCRON_CRON_SYSTEMD="fcron"
FCRON_CRON_OPENRC="fcron"
FCRON_CRON_EMERGE="sys-process/fcron"
# DCRON # http://www.linuxfromscratch.org/hints/downloads/files/dcron.txt
DCRON_CRON_SYSTEMD="razor-session"
DCRON_CRON_OPENRC="razor-session"
DCRON_CRON_EMERGE="sys-process/dcron"
# CRONIE
CRONIE_CRON_SYSTEMD="cronie"
CRONIE_CRON_OPENRC="cronie"
CRONIE_CRON_EMERGE="sys-process/cronie"
# VIXICRON
VIXICRON_CRON_SYSTEMD="vixi"
VIXICRON_CRON_OPENRC="vixi"
VIXICRON_CRON_EMERGE="sys-process/vixie-cron"
