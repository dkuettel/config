#!/bin/bash -eux
set -o pipefail

# todo not sure if that works, but might be more convenient instead of mounting and running install everytime vmware complains
sudo apt install open-vm-tools open-vm-tools-desktop
