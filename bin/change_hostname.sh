#!/bin/bash -xeu
# set hostname to $1

# add to routing so sudo does not complain
echo 127.0.0.1 $1 | sudo tee -a /etc/hosts
# set it for the running session
sudo hostname $i
# set it for later
echo $i | sudo tee /etc/hostname
