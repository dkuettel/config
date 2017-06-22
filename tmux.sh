#!/bin/bash -eux

# last I checked: ubuntu 16.04 has 2.1, 2.1 is too old
#sudo apt-get install -yq tmux

# build latest version of tmux
sudo apt-get -yq install automake libevent1-dev libncurses5-dev
if [[ ! -d ~/tmux ]]; then
	sudo apt-get install -yq automake libevent-dev
	git clone https://github.com/tmux/tmux.git ~/tmux
	cd ~/tmux
	sh autogen.sh
	./configure
	make -j$(nproc)
else
	cd ~/tmux
	git pull
	make
fi

if [[ $(realpath ~/config/tmux.conf) != $(realpath ~/.tmux.conf) ]]; then
	ln -s --backup ~/config/tmux.conf ~/.tmux.conf
fi

sudo -H pip install powerline-status

