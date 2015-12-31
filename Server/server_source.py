import json, urllib2, os
# To satisfy this dependency, install the python-pil package with your system's package manager
# Alternatively, you can pip install Pillow.
from PIL import Image, ImageOps
from datetime import datetime, timedelta

# Which camera should we look at?
# See https://api.nasa.gov/api.html#MarsPhotos for available cameras.
CAM = "FHAZ"
# NASA api key (the demo key is fine for low traffic apps like this one).
API_KEY = "DEMO_KEY"

# Return the date 3 days ago
# Necessary to ensure that NASA has time to process the most recent images from the rover.
def getDate():
    return unicode(datetime.now().date() - timedelta(days=3))

# Queries the NASA mars photos API and stores the latest image (or a default, if a latest is not found) in JPEG format.
# The function also manages the file latest.jpg, which stores the most recent good image. 
def fetchImage():
    try: 
        api_data = urllib2.urlopen('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=' + getDate() + '&camera=' + CAM + '&api_key=' + API_KEY)
        data = json.loads(api_data.read());
    except: 
        data = json.loads('{"error": "failed to fetch images"}')

    # Check to see whether NASA's API returned an error response.
    if data.get('error') not in data:
	# Attempt to load the image, otherwise use default image.
        try:
            image = urllib2.urlopen(data['photos'][0]['img_src']);
	    print('Fetched ' + data['photos'][0]['img_src'] + ' successfully!')

	    # Save latest image for use as default later. 
            f=open('/var/www/mars/rocks_full.jpg','w')
            f.write(image.read())
            f.close()
        except Exception, e:
            print('No photo entries for ' + getDate() + ':')
	    print(e)
 	    print('Script will default to last good image.')
    else:
        # If we did get an error, log it and we'll load the default image later. 
        print('We got an error from the API while attempting to load data for ' + getDate())
	print('The script will load the last good image, instead.')

def cropImage():
    try:
        img = Image.open('/var/www/mars/rocks_full.jpg')
        cropped = img.crop((0, 0, 600, 800))
        cropped.save('/var/www/mars/rocks.jpg')    
    except Exception, e:
        print('An exception was thrown:')
	print(e)
	print('Cropping the photo FAILED.')

def convertToRaw():
    original = Image.open('/var/www/mars/rocks.jpg')
    original = ImageOps.grayscale(original)
    orig_data = list(original.getdata())
    raw_out = open('/var/www/mars/rocks.raw','wb')
    for x in orig_data:
        raw_out.write(chr(x))
    raw_out.close()

if __name__ == "__main__":
    print('Fetching https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=' + getDate() + '&camera=' + CAM + '&api_key=' + API_KEY + '...')
    fetchImage()
    print('Cropping the photo...')
    cropImage()
    print('Converting to raw...')
    convertToRaw()
