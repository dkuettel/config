#!/bin/zsh -eux
set -o pipefail

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
wget 'https://www.dropbox.com/download?dl=packages/dropbox.py' -O ~/.dropbox-dist/dropbox.py
chmod +x ~/.dropbox-dist/dropbox.py

# manually run ~/.dropbox-dist/dropboxd to start the daemon
# or just use dbox start and other dbox commands
# note: better start it with DISPLAY= so that it asks on the terminal about the login (at least on a headless machine)
# note: the ./bin/dbox by default unsets DISPLAY because it works more reliably on the cloud
