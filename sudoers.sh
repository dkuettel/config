#!/bin/bash -xeu
# copy the sudoers file over to be in effect (symlink not possible)

sudo cp sudoers /etc/sudoers.d/kuettel

echo 'dont forget sudoers needs to include the sudoers.d folder'
