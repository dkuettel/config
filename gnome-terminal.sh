#!/bin/bash

# gnome terminal solarized theme
mkdir -p ~/plugins
cd ~/plugins
git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git
cd gnome-terminal-colors-solarized
sudo apt-get install dconf-cli
./install.sh
# or maybe set_light.sh ?

# ls colors
mkdir -p ~/plugins
cd ~/plugins
git clone git@github.com:dkuettel/dircolors-solarized.git
cd dircolors-solarized
git config user.email 'dkuettel@gmail.com'
git remote add upstream https://github.com/seebi/dircolors-solarized.git
git checkout mine
