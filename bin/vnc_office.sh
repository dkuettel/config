#!/bin/bash -xeu
vncserver -kill :1 -clean || echo 'there was no previous x'
vncserver -geometry 1920x1080 # desktop
