#!/bin/bash

mkdir ~/plugins

# gnome terminal solarized theme
cd ~/plugins
if [[ ! -d gnome-terminal-colors-solarized ]]
then
	git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git
	cd gnome-terminal-colors-solarized
	sudo apt-get install dconf-cli
	./install.sh
	# or maybe set_light.sh ?
fi

# ls colors
cd ~/plugins
if [[ ! -d dircolors-solarized ]]
	git clone git@github.com:dkuettel/dircolors-solarized.git
	cd dircolors-solarized
	git config user.email 'dkuettel@gmail.com'
	git remote add upstream https://github.com/seebi/dircolors-solarized.git
	git checkout mine
fi
