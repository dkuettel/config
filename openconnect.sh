#!/bin/zsh
set -eux -o pipefail

sudo apt-get -yqq install openconnect stoken

# note
# import the token file with
# > stoken import --file=x.sdtid
# easiest (...) with no password and
# > stoken setpin
# (ours doesnt have a pin, so use 0000)
