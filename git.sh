#!/bin/bash -xeu

sudo apt-get install -y git
git config --global user.email "dkuettel@ptc.com"
git config --global user.name "Daniel Kuettel"
git config --global push.default simple
git config --global core.editor "vim"

cd ~/config
git config user.email 'dkuettel@gmail.com'
