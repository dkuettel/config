#!/bin/bash -xeu
set -o pipefail
vncserver -kill :1 -clean || echo 'there was no previous x'
vncserver -geometry 2510x1293
