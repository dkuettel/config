#!/bin/bash
set -ex

if [[ $(realpath ~/config/bin) == $(realpath ~/bin) ]]
then
	echo 'bin already installed'
else
	ln -s --backup ~/config/bin ~/bin
fi
