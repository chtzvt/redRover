# Download the latest photo of martian rocks from my server.
wget -O /mnt/onboard/redRover/rocks.raw -U "Red Rover 1.0" http://mars.ctis.me/rocks.raw

# Write the contents of the raw image file to the framebuffer.
cat /mnt/onboard/redRover/rocks.raw | /usr/local/Kobo/pickel showpic
# Writing to the framebuffer turns the blinkenlights on. This turns them back off.
/usr/local/Kobo/pickel blinkoff

# Keep wireless alive by offering nickel as a blood sacrifice.
killall nickel
# No idea what this is, either.
killall hindenburg
