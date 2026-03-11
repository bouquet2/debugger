#!/usr/bin/env bash

TMUX_SESSION="debug"

if ! tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
    tmux new-session -d -s "$TMUX_SESSION"
fi

exec tmux attach -t "$TMUX_SESSION"
