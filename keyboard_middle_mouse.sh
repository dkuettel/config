#!/bin/bash -xeu
set -o pipefail
echo 'not completely automatic, better run it manually for now'
# see http://linuxaleph.blogspot.ch/2008/11/mapping-middle-click-to-keyboard-key.html
sudo apt-get install xkbset
xkbset m # enable mouse actions
xmodmap -e 'keycode 169 = Pointer_Button2' # map to mouse action, use xev for keycodes
