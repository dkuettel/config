#!/bin/bash -xeu

cd /data/xps/metric/dev/nn
tmux new-session -s staging -d
./setup_tmux.sh
tmux split-window
tmux kill-pane -t :1.1
tmux attach-session
