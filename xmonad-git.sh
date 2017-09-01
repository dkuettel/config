#!/bin/zsh -eux
set -o pipefail

false # todo not finished

mkdir ~/xmonad
cd ~/xmonad
git clone https://github.com/xmonad/xmonad.git
sudo apt install ghc
sudo apt install libx11-dev libxinerama-dev libxext-dev

