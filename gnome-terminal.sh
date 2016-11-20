#!/bin/bash -eux
set -o pipefail

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
	./install.sh -s light -p :b1dcc9dd-5262-4d8d-a863-c897e6d979b9 --skip-dircolors
fi
