#!/bin/bash

if [ $(realpath ~/config/bin) != $(realpath ~/bin) ]]
then
	ln -s --backup ~/config/bin ~/bin
fi
