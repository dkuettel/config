#!/bin/zsh
set -eux -o pipefail

pci=$(lspci -m | grep 'Ethernet controller' | awk '// { print $1 }')
pcipath=$(find /sys -name '*'$pci | egrep '*pci0000*')
echo 1 > $pcipath/reset
