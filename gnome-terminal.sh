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
	./install.sh -s dark -p :b1dcc9dd-5262-4d8d-a863-c897e6d979b9 --skip-dircolors
fi

# todo how to configure gnome-terminal by CLI not to startup help on F1
# todo how to automatically set the powerline font as a default?
# todo how to automatically switch of the use of bold in config, that's not right for solarized
# todo auto config to not show menu bar
