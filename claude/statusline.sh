#!/bin/bash
# Claude Code statusline — Catppuccin Latte (밝은 배경용)
# stdin으로 세션 JSON을 받아 한 줄 상태줄을 출력한다.

input=$(cat)

MAUVE='\033[38;2;136;57;239m'   # #8839ef
BLUE='\033[38;2;30;102;245m'    # #1e66f5
GREEN='\033[38;2;64;160;43m'    # #40a02b
YELLOW='\033[38;2;223;142;29m'  # #df8e1d
RED='\033[38;2;210;15;57m'      # #d20f39
PEACH='\033[38;2;254;100;11m'   # #fe640b
GRAY='\033[38;2;140;143;161m'   # #8c8fa1
TEAL='\033[38;2;23;146;153m'    # #179299
RESET='\033[0m'

# 다크 테마(Catppuccin Mocha)로 되돌릴 때 쓸 값:
#   MAUVE 203;166;247  BLUE 137;180;250  GREEN 166;227;161  YELLOW 249;226;175
#   RED   243;139;168  PEACH 250;179;135  GRAY  108;112;134  TEAL   148;226;213

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
