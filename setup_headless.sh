#!/bin/bash -eux

./zsh.sh
./apt.sh
# todo for now assuming no anaconda anymore
sudo apt-get install -yq python python-pip build-essential
sudo pip -H install --upgrade pip
./bin.sh
./git.sh
./ssh.sh
./tmux.sh
./vim.sh
./powerline.sh
./toprc.sh
