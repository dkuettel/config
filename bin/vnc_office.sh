#!/bin/bash -xeu
vncserver -kill :1 -clean || echo 'there was no previous x'
vncserver -geometry 2540x1420
