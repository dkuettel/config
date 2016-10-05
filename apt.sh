#!/bin/bash -eux

sudo apt-get update
sudo apt-get upgrade -yq
sudo apt-get install -yq $(cat apt.list)
