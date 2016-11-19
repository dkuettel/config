#!/bin/bash -eux
set -o pipefail

# assumes headless already setup

./fonts.sh
./gnome-terminal.sh
./chrome.sh
