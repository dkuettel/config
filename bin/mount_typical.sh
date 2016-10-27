#!/bin/bash -eux
set -o pipefail
sudo mount /dev/xvdf /data/xps/metric/dev
sudo mount /dev/xvdg /data/sets
sudo mount /dev/xvdh1 ~/old_root
