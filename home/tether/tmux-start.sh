#!/bin/bash

tmux ls
if [ $? = 0 ]; then 
	#echo done; 
	exit 0
fi

tmux new-session -s 'boot-session' -n 'win1' -d
tmux split-window -v
tmux select-pane -U
tmux resize-pane -D 10
tmux send-keys -t boot-session:win1.0 './tether-loop.sh' C-j
tmux attach -t boot-session
