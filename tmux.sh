#!/bin/bash

sudo apt-get install -y tmux

if [[ $(realpath ~/config/tmux.conf) != $(realpath ~/.tmux.conf) ]]
then
	ln -s --backup ~/config/tmux.conf ~/.tmux.conf
fi

mkdir -p ~/plugins/tmux

cd ~/plugins/tmux
if [[ ! -d tmux-colors-solarized ]]
then
	git clone git@github.com:dkuettel/tmux-colors-solarized.git
	cd tmux-colors-solarized
	git config user.email 'dkuettel@gmail.com'
	git remote add upstream https://github.com/seebi/tmux-colors-solarized.git
	git checkout daniel
fi

cd ~/plugins/tmux
if [[ ! -d tmux-mem-cpu-load ]]
then
	sudo apt-get install -y g++ cmake
	git clone git@github.com:dkuettel/tmux-mem-cpu-load.git
	cd tmux-mem-cpu-load
	git config user.email 'dkuettel@gmail.com'
	git remote add upstream https://github.com/thewtex/tmux-mem-cpu-load.git
	# git checkout mine # no own changes yet
	cmake .
	make
fi
