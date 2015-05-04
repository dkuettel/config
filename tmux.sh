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
