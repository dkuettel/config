#!/bin/bash -xeu

cd /data/xps/metric/dev/nn
tmux new-session -s staging -d
./setup_tmux.sh
tmux attach-session
