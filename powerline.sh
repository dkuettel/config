#!/bin/bash -xeu

# assuming anaconda is installed now
# install latest git version (to work with latest tmux)
pip install --user git+git://github.com/powerline/powerline

[[ -d ~/.config ]] || mkdir -p ~/.config
if [[ $(realpath ~/config/powerline) != $(realpath ~/.config/powerline) ]]
then
	ln -s ~/config/powerline ~/.config/powerline
fi
