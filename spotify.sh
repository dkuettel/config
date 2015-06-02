#!/bin/bash

if [[ ! -f /usr/bin/spotify ]]
then
	echo 'deb http://repository.spotify.com stable non-free' | sudo tee -a /etc/apt/sources.list
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 94558F59
	sudo apt-get update
	sudo apt-get install -y spotify-client
	echo 'ui.track_notifications_enabled=false' | tee -a /home/kuettel/.config/spotify/Users/118264891-user/prefs
fi

mkdir ~/plugins

cd ~/plugins
if [[ ! -d playerctl ]]
then
	git clone https://github.com/acrisci/playerctl.git
fi
cd playerctl
git pull

sudo apt-get install -y gtk-doc-tools gobject-introspection
./autogen.sh
make
