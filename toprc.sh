#!/bin/bash
set -e

if [[ ( -f ~/.toprc ) || ( $(realpath ~/.toprc) != $(realpath ~/config/toprc) ) ]]
then
	ln -s --backup ~/config/toprc ~/.toprc
fi
