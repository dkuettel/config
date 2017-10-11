#!/bin/zsh -eux
set -o pipefail

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
wget 'https://www.dropbox.com/download?dl=packages/dropbox.py' -O ~/.dropbox-dist/dropbox.py
chmod +x ~/.dropbox-dist/dropbox.py

# run ~/.dropbox-dist/dropboxd to start the daemon
# use dbox to start the python tool
