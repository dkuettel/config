#!/bin/bash
# assuming on /mnt, for amazon ubuntu that's usually the local (ephemeral) ssd
cd /mnt
sudo dd if=/dev/zero of=swapfile bs=1G count=4
sudo chmod 600 swapfile
sudo mkswap swapfile
sudo swapon swapfile
swapon -s
