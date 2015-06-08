#!/bin/bash
set -ex

# sudo apt-get install -y python-pip python-setuptools # by now anaconda should be installed
pip install --user powerline-status

mkdir -p ~/.config
if [[ $(realpath ~/config/powerline) != $(realpath ~/.config/powerline) ]]
then
	ln -s ~/config/powerline ~/.config/powerline
fi
