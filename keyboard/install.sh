#!/bin/bash

sudo ln -s --backup ~/config/keyboard/evdev.xml /usr/share/X11/xkb/rules/evdev.xml
sudo ln -s --backup ~/config/keyboard/sf /usr/share/X11/xkb/symbols/sf
sudo dpkg-reconfigure xkb-data
