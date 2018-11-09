#!/bin/zsh
set -eux -o pipefail

sudo ln -sf ~/config/keyboard/pointluck /usr/share/X11/xkb/symbols/pointluck
#sudo dpkg-reconfigure xkb-data # todo still necessary?
