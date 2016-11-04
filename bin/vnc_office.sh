#!/bin/bash -xeu
vncserver -kill :1 -clean || echo 'there was no previous x'
#vncserver -geometry 1920x1080 # desktop
vncserver -geometry 1900x1060 # desktop, a bit of slack on the sides to fit with window borders
