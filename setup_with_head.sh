#!/bin/bash -eux
set -o pipefail

echo 'assumes headless already setup'

./fonts.sh
./gnome-terminal.sh
./chrome.sh
