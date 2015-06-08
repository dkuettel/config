#!/bin/bash
set -e

if [[ $(realpath ~/.toprc) != $(realpath ~/config/toprc) ]]
then
	ln -s --backup ~/config/toprc ~/.toprc
fi
