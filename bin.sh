#!/bin/bash

if [[ $(realpath ~/config/bin) == $(realpath ~/bin) ]]
then
	echo 'bin already installed'
else
	ln -s --backup ~/config/bin ~/bin
fi
