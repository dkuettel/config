#!/bin/zsh -eux
set -o pipefail

# see http://www.infradead.org/openconnect/building.html

cd ~
git clone git://git.infradead.org/users/dwmw2/openconnect.git openconnect
cd openconnect
sudo apt install -yqq libxml2-dev libssl-dev
./autogen.sh
./configure --without-openssl-version-check
make check
make
sudo make install

wget 'http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/HEAD:/vpnc-script'
chmod +x vpnc-script

# todo copy the script to /etc/vpnc/. or use --script? or need to provide in configure?
# use sudo LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH openconnect --juniper emea-portal.ptc.com
# won't return while connection is active
# route shows the routing, it only routes ptc stuff thru vpn
