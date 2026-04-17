#!/bin/bash
host=$(grep -E '^Host ' ~/.ssh/config | awk '{print $2}' | grep -v '*' | /opt/homebrew/bin/fzf \
  --prompt=' ❯ ' --pointer='▶' --marker='✓' \
  --border=none --height=100% --layout=reverse \
  --color='fg:#f8f8f2,bg:#282a36,hl:#8be9fd,fg+:#ffffff,bg+:#44475a,hl+:#ff79c6,info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6,marker:#50fa7b,header:#6272a4')
if [ -n "$host" ]; then
    # 팝업 닫힌 후 새 윈도우에서 SSH 접속
    /opt/homebrew/bin/tmux new-window -n "$host" "ssh $host"
fi
