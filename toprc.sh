#!/bin/bash -xeu

if [[ ! -f ~/.toprc ]]
then
	ln -s --backup ~/config/toprc ~/.toprc
else
	if [[ $(realpath ~/.toprc) != $(realpath ~/config/toprc) ]]
	then
		ln -s --backup ~/config/toprc ~/.toprc
	fi
fi
