#!/bin/bash -xeu
set -o pipefail
sudo mount /dev/xvdf /data/xps/metric/dev
sudo mount /dev/xvdg /home/kuettel/web
sudo mkdir /mnt/sets
sudo chown kuettel:kuettel /mnt/sets
