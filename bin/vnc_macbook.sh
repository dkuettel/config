#!/bin/bash -xeu
vncserver -kill :1 -clean || echo 'there was not previous x'
vncserver -geometry 1170x730 # macbook
