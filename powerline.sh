#!/bin/bash

sudo apt-get install python-pip python-setuptools
pip install --user powerline-status

mkdir -p ~/.config
ln -s ~/config/powerline ~/.config/powerline
