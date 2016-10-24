#!/bin/bash -eux
set -o pipefail
sudo mount /dev/xvdf /data/xps/metric/dev
# todo how to find out if we are on a machine with /mnt as ephemeral?
#sudo mkdir /mnt/sets
#sudo chown kuettel:kuettel /mnt/sets
