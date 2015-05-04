#!/bin/bash

sudo apt-get install tmux
ln -s --backup ~/config/tmux.conf ~/.tmux.conf

mkdir -p ~/plugins/tmux

cd ~/plugins/tmux
git clone git@github.com:dkuettel/tmux-colors-solarized.git
cd tmux-colors-solarized
git config user.email 'dkuettel@gmail.com'
git remote add upstream https://github.com/seebi/tmux-colors-solarized.git
git checkout daniel

sudo apt-get install g++ cmake
cd ~/plugins/tmux
git clone git@github.com:dkuettel/tmux-mem-cpu-load.git
cd tmux-mem-cpu-load
git config user.email 'dkuettel@gmail.com'
git remote add upstream https://github.com/thewtex/tmux-mem-cpu-load.git
# git checkout mine # no own changes yet
cmake .
make
