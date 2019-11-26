# Sync system + hardware clock, set both to current time UTC
ntpd -d -q -p pool.ntp.org
hwclock -w -u
