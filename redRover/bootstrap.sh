# This script is called from /etc/init.d/rcS2 at boot time.
# It provides the following services: 
# 	- Starting crond
# 	- Displaying the latest image of mars (with 30 second delay for wpa_supplicant to connect)
# 	- Syncing the system and hardware clocks
# Once the above is complete, the script disables Wi-Fi and suspends teh system to save power.

# Start crond with the correct working directory and logfile.   
/mnt/onboard/redRover/busybox crond -b -L /mnt/onboard/redRover/cron/cronlog -c /var/spool/cron/crontabs/
 
# Immediately display a rover image once boot is completed.
cat /mnt/onboard/redRover/rocks.raw | /usr/local/Kobo/pickel showpic
# Stop Nickel, thus preserving the image we are displaying.
killall nickel
 
sleep 30  

# Call mars.sh, killing nickel/hindenburg and displaying the latest rover image at boot time. 
/bin/sh /mnt/onboard/redRover/mars.sh  

# Sync system + hardware clock, set both to current time UTC
ntpd -d -q -p pool.ntp.org
hwclock -w -u

# 2 minute grace period after boot for maintenance purposes.
sleep 120
 
# Disable wifi after boot process is complete. Cron will manage wifi going forward (see crontab for details).     
/bin/sh /mnt/onboard/redRover/wifi/down.sh

# Suspend the system until it is time for cron to run.
/mnt/onboard/redRover/wake/suspend_until.sh 16:57
