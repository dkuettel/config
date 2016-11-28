#!/bin/bash -eux
set -o pipefail

echo 'assumes headless already setup'

# todo dropbox?

./keyboard.sh
./xmonad.sh
./fonts.sh
./gnome-terminal.sh
./chrome.sh
./spotify.sh
