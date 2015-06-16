#!/bin/bash
set -ex

# assuming anaconda is installed now
pip install --user powerline-status

[[ -d ~/config ]] || mkdir -p ~/.config
if [[ $(realpath ~/config/powerline) != $(realpath ~/.config/powerline) ]]
then
	ln -s ~/config/powerline ~/.config/powerline
fi
