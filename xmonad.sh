#!/bin/bash -eux
set -o pipefail

# apt install xmonad, at least on ubuntu, seems to add the correct xmonad.desktop in
# /usr/share/xsessions
# no need to configure more
# lightdm > greeter > xmonad (display manager > X > window manager)
# also that xmonad.desktop starts xmonad-session-rc on startup
sudo apt install -y xmonad

[ -d ~/.xmonad ] || mkdir ~/.xmonad
ln -sf ~/config/xmonad.hs ~/.xmonad/xmonad.hs
ln -sf ~/config/xmonad-session-rc ~/.xmonad/xmonad-session-rc
