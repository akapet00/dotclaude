#!/bin/bash
# Read all of stdin into a variable
input=$(cat)

# Extract fields with jq
MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
TOTAL_TOKENS=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
USED_TOKENS=$((PCT * TOTAL_TOKENS / 100))

# Format token count (e.g., 100k, 1.2m)
fmt_tokens() {
    local n=$1
    if [ "$n" -ge 1000000 ]; then
        local m=$((n / 100000))
        local whole=$((m / 10))
        local frac=$((m % 10))
        if [ "$frac" -eq 0 ]; then
            echo "${whole}m"
        else
            echo "${whole}.${frac}m"
        fi
    elif [ "$n" -ge 1000 ]; then
        local k=$((n / 100))
        local whole=$((k / 10))
        local frac=$((k % 10))
        if [ "$frac" -eq 0 ]; then
            echo "${whole}k"
        else
            echo "${whole}.${frac}k"
        fi
    else
        echo "${n}"
    fi
}

USED_FMT=$(fmt_tokens "$USED_TOKENS")
TOTAL_FMT=$(fmt_tokens "$TOTAL_TOKENS")

# Build progress bar
BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && BAR=$(printf "%${FILLED}s" | tr ' ' '▓')
[ "$EMPTY" -gt 0 ] && BAR="${BAR}$(printf "%${EMPTY}s" | tr ' ' '░')"

GREEN='\033[32m'
YELLOW='\033[33m'
RESET='\033[0m'

if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

    GIT_STATUS=""
    [ "$STAGED" -gt 0 ] && GIT_STATUS=" ${GREEN}+${STAGED}${RESET}"
    [ "$MODIFIED" -gt 0 ] && GIT_STATUS="${GIT_STATUS} ${YELLOW}~${MODIFIED}${RESET}"

    echo -e "$MODEL $BAR ${USED_FMT} / ${TOTAL_FMT} | ${PCT}% | 📁 ${DIR##*/} | 🌿 $BRANCH$GIT_STATUS"
else
    echo "$MODEL $BAR ${USED_FMT} / ${TOTAL_FMT} | ${PCT}% | 📁 ${DIR##*/}"
fi
