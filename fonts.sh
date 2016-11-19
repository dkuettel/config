#!/bin/bash -eux
set -o pipefail

if [[ -d ~/plugins/fonts ]]
then
	echo 'fonts already installed'
	cd ~/plugins/fonts
	git pull
else
	git clone https://github.com/powerline/fonts.git ~/plugins/fonts
	cd ~/plugins/fonts
	./install.sh
fi

echo 'remember to select a patched font in your terminal'
