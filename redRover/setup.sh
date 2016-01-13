# This script installs the root crontab and the call to bootstrap.sh
# in /etc/init.d/rcS2.

echo "Installing crontab..."
# Copy the root crontab to /var/spool/cron/crontabs/.
mkdir -p /var/spool/cron/crontabs/
cat >/var/spool/cron/crontabs/root <<EOL
# redRover crontab
# Note that all times are set for UTC.
# Activity takes place from 11:58 - 12:00 EST

# Bring up Wi-Fi in preparation for download.
58 16 * * * /bin/sh /mnt/onboard/redRover/wifi/up.sh >/dev/null 2>&1
# Download and show the latest rover image, then disable wi-fi and suspend the system until we need cron to run again. 
0 17 * * * /bin/sh /mnt/onboard/redRover/mars.sh ; /bin/sh /mnt/onboard/redRover/wifi/down.sh ; /mnt/onboard/redRover/wake/suspend_until.sh 16:57 >/dev/null 2>&1 
EOL

echo "Configuring /etc/init.d/rcS2..."
# Delete last line from /etc/init.d/rcS2 (the call to getIP)
sed -i '$ d' /etc/init.d/rcS2
# Installs call to bootstrap.sh, which prepares the system to boot. 
cat >/etc/init.d/rcS2 <<EOL
# redRover bootstrap - starts crond, displays latest image (after 30s), and disables wi-fi (after 2 minutes)
/bin/sh /mnt/onboard/redRover/bootstrap.sh  
EOL

echo "All done! Reboot your Kobo for changes to take effect."
