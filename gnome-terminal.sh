#!/bin/bash
mkdir -p ~/plugins
cd ~/plugins
git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git
cd gnome-terminal-colors-solarized
sudo apt-get install dconf-cli
./install.sh
