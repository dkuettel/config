#!/bin/bash -xeu
# copy the sudoers file over to be in effect (symlink not possible)
# see http://askubuntu.com/questions/159007/how-do-i-run-specific-sudo-commands-without-a-password

sudo cp sudoers /etc/sudoers.d/kuettel

echo 'dont forget sudoers needs to include the sudoers.d folder, edit with visudo'
