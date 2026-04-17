#!/bin/bash
session=$1
if /opt/homebrew/bin/tmux has-session -t "$session" 2>/dev/null; then
    /opt/homebrew/bin/tmux switch-client -t "$session"
elif /opt/homebrew/bin/tmuxinator list -n 2>/dev/null | tail -n +2 | tr ' ' '\n' | grep -q "^$session\$"; then
    TMUX='' /opt/homebrew/bin/tmuxinator start "$session" --no-attach
    /opt/homebrew/bin/tmux switch-client -t "$session"
fi
