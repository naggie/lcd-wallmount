#!/bin/bash
set -e

apt-get -y update
apt-get -y install libnss3-tools chromium-browser

cat <<EOF > /etc/chromium-browser/policies/managed/autocert.json
{
    "AutoSelectCertificateForUrls": ["{\"pattern\":\"https://<domain>\",\"filter\":{\"ISSUER\":{\"CN\":\"<issuer>\"}}}"]
}
EOF

# initialise database
chromium-browser --headless chrome://quit

# add client cert to database (note will prompt for password)
# see also: certutil
pk12util -d sql:$HOME/.pki/nssdb -i cert.pfx

# Note embedded password has to be URL-escaped (eg, space = %20)
#DISPLAY=:0 chromium-browser \
#    --disable-blink-features=BlockCredentialedSubresources \
#    --disable-infobars --kiosk --remote-debugging-port=7000 \
#    --remote-debugging-port=9222 \
#    '<address>'

# for remote screen
# DISPLAY=:0 x11vnc -usepw -forever

