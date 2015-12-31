#!/bin/sh 
echo `date +"%d-%m-%y %T"` "Disabling Wi-Fi..."
killall wpa_supplicant 
/usr/local/Kobo/pickel wifioff
#wlarm_le -i eth0 down 
ifconfig eth0 down


