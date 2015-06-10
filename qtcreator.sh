#!/bin/bash

if [[ -d ~/.config/QtProject/qtcreator ]]
then
	mkdir -p ~/.config/QtProject/qtcreator/styles
	wget 'https://raw.githubusercontent.com/curonian/qtcreator-solarized/master/solarized-dark.xml' -O ~/.config/QtProject/qtcreator/styles/solarized-dark.xml
	wget 'https://raw.githubusercontent.com/curonian/qtcreator-solarized/master/solarized-light.xml' -O ~/.config/QtProject/qtcreator/styles/solarized-light.xml
else
	echo 'not installing qt creator (for now), but adding extensions'
fi
