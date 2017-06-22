#!/bin/bash -xeu
set -o pipefail

sudo apt-get install -yq python python-pip build-essential
sudo -H pip install --upgrade pip

sudo apt-get install -yq ipython
ipython profile create # todo doesn't work the second time, not quite idempotent
# todo this way I will never see if there is a new default config file (new options)
ln -sb ~/config/python/ipython_config.py ~/.ipython/profile_default/ipython_config.py
