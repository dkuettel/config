#!/bin/bash -eux
set -o pipefail

if which google-chrome; then
	echo 'google-chrome already installed'
else
	wget https://dl-ssl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome.deb
	sudo apt-get -fyq install libindicator7 libappindicator1 libpango1.0-0 libpangox-1.0-0
	sudo dpkg -i google-chrome.deb
	rm google-chrome.deb
fi

# todo how to automatically configure "use system title bar and borders"? it works better with xmonad
