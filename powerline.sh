#!/bin/bash

# sudo apt-get install -y python-pip python-setuptools # by now anaconda should be installed
pip install --user powerline-status

mkdir -p ~/.config
if [[ $(realpath ~/config/powerline) != $(realphat ~/.config/powerline) ]]
then
	ln -s ~/config/powerline ~/.config/powerline
fi
