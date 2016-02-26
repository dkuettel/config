#!/bin/bash
set -ex

[[ -d ~/plugins ]] || mkdir ~/plugins

# gnome terminal solarized theme
cd ~/plugins
if [[ -d gnome-terminal-colors-solarized ]]
then
	echo 'gnome terimal colors solarized already installed'
else
	git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git
	cd gnome-terminal-colors-solarized
	sudo apt-get install dconf-cli
	./install.sh
	# or maybe set_light.sh ?
fi
