#!/bin/bash -eux
set -o pipefail

keyboard/install.sh

# in case we are running in an X right now set it for the current session
keyboard/use_layout.sh
keyboard/set_rate.sh
