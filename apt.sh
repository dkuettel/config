#!/bin/bash -eux

sudo apt-get update
sudo apt-get upgrade -yq
sudo apt-get install -yq $(cat apt.list)

# apt-get python instead of anaconda (doesn't work well with ubuntu 16.04)
sudo apt-get install -yq python python-pip build-essential
sudo -H pip install --upgrade pip
