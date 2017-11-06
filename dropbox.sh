#!/bin/zsh -eux
set -o pipefail

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

# copy the command line helper to ~/bin, not in the ~/.dropbox-dist folder, because that one gets whiped on updates
mkdir -p ~/bin
wget 'https://www.dropbox.com/download?dl=packages/dropbox.py' -O ~/bin/dropbox.py
chmod +x ~/bin/dropbox.py

# manually run ~/.dropbox-dist/dropboxd to start the daemon
# or just use dbox start and other dbox commands
# note: better start it with DISPLAY= so that it asks on the terminal about the login (at least on a headless machine)
# note: the ./bin/dbox by default unsets DISPLAY because it works more reliably on the cloud
