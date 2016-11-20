#!/bin/bash -eux
set -o pipefail

echo 'assumes headless already setup'

# todo keyboard layout
# todo xmoand
# todo spotify and shortcuts
# todo dropbox?

./fonts.sh
./gnome-terminal.sh
./chrome.sh
