#!/bin/bash -x
# note: lightdm by default does not use .xsession
# setup also the desktop file for it
# in /usr/share/xsessions/xsession.desktop
xsetroot -solid '#073642' # solarized base02 (dark)
xset r rate 250 60 # repeat rate (keyboard "speed")
setxkbmap sf # keyboard layout
# note: for some reason setxkmap in lightdm+xmonad dit not have an effect until I set 'use system keyboard layout' in ibus-setup executable
# very specific for my setup, nvidia-settings seem to be forgotten every time
xrandr --output DVI-I-3 --pos 2560x180
# possibility: make both displays the same in terms of resolution -> no window size changes, but looks ugly
#xrandr --output DVI-I-3 --scale 1.33333x1.3333
xmonad
