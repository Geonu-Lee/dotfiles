#!/bin/bash
# Claude Code statusline — Catppuccin Mocha
# stdin으로 세션 JSON을 받아 한 줄 상태줄을 출력한다.

input=$(cat)

MAUVE='\033[38;2;203;166;247m'
BLUE='\033[38;2;137;180;250m'
GREEN='\033[38;2;166;227;161m'
YELLOW='\033[38;2;249;226;175m'
RED='\033[38;2;243;139;168m'
PEACH='\033[38;2;250;179;135m'
GRAY='\033[38;2;108;112;134m'
TEAL='\033[38;2;148;226;213m'
RESET='\033[0m'

model=$(echo "$input" | jq -r '.model.display_name // "?"')
ctx=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')
cwd=$(echo "$input" | jq -r '.cwd // "~"')
five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty | floor' 2>/dev/null)
seven_d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty | floor' 2>/dev/null)

# 컨텍스트 게이지 (10칸)
filled=$((ctx / 10))
bar=""
for ((i = 0; i < 10; i++)); do
  if ((i < filled)); then bar+="█"; else bar+="░"; fi
done
if ((ctx >= 80)); then ctx_color=$RED; elif ((ctx >= 50)); then ctx_color=$YELLOW; else ctx_color=$GREEN; fi

# git 브랜치
branch=$(git -C "$cwd" branch --show-current 2>/dev/null)

line="${MAUVE}${model}${RESET} ${GRAY}|${RESET} ${ctx_color}${bar} ${ctx}%${RESET}"
[ -n "$branch" ] && line+=" ${GRAY}|${RESET} ${TEAL} ${branch}${RESET}"
if [ -n "$five_h" ] || [ -n "$seven_d" ]; then
  line+=" ${GRAY}|${RESET} ${PEACH}5h ${five_h:-0}% · 7d ${seven_d:-0}%${RESET}"
fi
line+=" ${GRAY}|${RESET} ${BLUE}${cwd/#$HOME/~}${RESET}"

echo -e "$line"
