#!/bin/bash -xeu
# set hostname to $1

h=${1-staging}

# add to routing so sudo does not complain
echo 127.0.0.1 $h | sudo tee -a /etc/hosts
# set it for the running session
sudo hostname $h
# set it for later
echo $h | sudo tee /etc/hostname
