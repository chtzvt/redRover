# redRover Kobo Picture Frame

## About

This was an experiment to try and breathe new life into an old e-reader that had been gathering dust in my drawer, perfect for space lovers & those who like poking around embedded Linux devices.

Thankfully, there's a fairly active group of hackers that have repurposed their Kobos for similar projects, namely weather displays. Building on their work, I was able to use my very old [Kobo WiFi](http://www.kobobooks.com/wifi) 
(though newer models should work just as well) as a display for images taken by the mars rover. At 12:00 EST each day, the system retrieves the latest rover photo from NASA's Open API then crops and displays it. 

**Some of the answers to my problems were scraped from defunct internet forums. If you see some of your code in this repo, let me know!*

## Installation

Setting up the kobo is incredibly easy: 

Before starting:

  - Make sure your Kobo is configured to join your local WiFi network.
  - [Make a backup of your Kobo's SD card](http://blog.ringerc.id.au/2011/01/taking-disk-image-of-kobo-wifi-without.html)
  - Plug in your Kobo to prevent power loss.

Setup:

1. Root your Kobo using [this guide](http://wiki.mobileread.com/wiki/Kobo_WiFi_Hacking).

2. Attach your Kobo to your PC and copy the redRover folder of this repo to the internal storage, which should mount as removable storage.
  - Do not change the name of the folder.
  - Do not move or modify the contents of the folder (yet).

3. Telnet into your Kobo, and do the following: 
  - `cd` to `/mnt/onboard/redRover/`. 
  - Run `./setup.sh`
  - `reboot` the system for changes to take effect.

And you're done!

## Server setup.

By default, mars.sh will download an image from [my server](https://www.ctis.me/mars/), with no additional configuration needed. However, if you'd like to process your own images, the well-commented server-side 
code is available in the Server directory. It's written for use on Linux, with a web root of `/var/www/`, but changing this is a ctrl-F away. 

*Note: The script depends on PIL for working with images.

Those wishing to self-host might also want to review [NASA's Mars Rover Photos API Documentation](https://api.nasa.gov/api.html#MarsPhotos).

## Caveats and Potential Improvements

  - Power management is somewhat iffy, there is a patched version of rtcwake included with redRover but suspension seems to save less battery than expected.
  - There are 3 versions of busybox on the system in total: the system's version, the vanilla version compiled for ARMv6, and the version with the rtcwake patch.
  - Fetching and cropping the image could be handled on the device if the appropriate libraries (esp. PIL) could be cross-compiled for the platform. 
  - The entire system could be bundled into a KoboRoot.tgz file. I may do this at some point. 
