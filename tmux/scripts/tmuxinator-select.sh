#!/bin/bash
project=$(/opt/homebrew/bin/tmuxinator list -n | tail -n +2 | tr ' ' '\n' | grep -v '^$' | /opt/homebrew/bin/fzf --prompt='Workspace > ')
if [ -n "$project" ]; then
    # 세션이 이미 있으면 전환만, 없으면 생성 후 전환
    if /opt/homebrew/bin/tmux has-session -t "$project" 2>/dev/null; then
        /opt/homebrew/bin/tmux switch-client -t "$project"
    else
        TMUX='' /opt/homebrew/bin/tmuxinator start "$project" --no-attach
        /opt/homebrew/bin/tmux switch-client -t "$project"
    fi
fi
