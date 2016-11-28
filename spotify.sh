#!/bin/bash -eux
set -o pipefail

if [ ! -e /usr/bin/spotify ]; then
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
	echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt update
	sudo apt install -y spotify-client
	echo 'ui.track_notifications_enabled=false' | tee -a /home/kuettel/.config/spotify/Users/118264891-user/prefs
fi

[ -d ~/plugins ] || mkdir ~/plugins

# playerctl
cd ~/plugins
[ -d playerctl ] || git clone https://github.com/acrisci/playerctl.git
cd playerctl
git pull
sudo apt install -y gtk-doc-tools gobject-introspection
./autogen.sh
make
