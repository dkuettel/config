#!/bin/bash -xeu
set -o pipefail

sudo apt-get install -yq python python-pip build-essential
sudo -H pip install --upgrade pip

sudo apt-get install -yq ipython
ipython profile create
sed -i 's/# c.TerminalInteractiveShell.confirm_exit = True/c.TerminalInteractiveShell.confirm_exit = False/' ~/.ipython/profile_default/ipython_config.py
