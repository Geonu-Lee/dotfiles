#!/bin/bash
host=$(grep -E '^Host ' ~/.ssh/config | awk '{print $2}' | grep -v '*' | /opt/homebrew/bin/fzf --prompt='SSH > ')
if [ -n "$host" ]; then
    # 팝업 닫힌 후 새 윈도우에서 SSH 접속
    /opt/homebrew/bin/tmux new-window -n "$host" "ssh $host"
fi
