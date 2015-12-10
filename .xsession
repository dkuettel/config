#!/bin/bash -x
# note: lightdm by default does not use .xsession
# setup also the desktop file for it
# in /usr/share/xsessions/xsession.desktop
xsetroot -solid '#073642' # solarized base02 (dark)
xset r rate 250 60 # repeat rate (keyboard "speed")
setxkbmap sf # keyboard layout
# note: for some reason setxkmap in lightdm+xmonad dit not have an effect until I set 'use system keyboard layout' in ibus-setup executable
xmonad
