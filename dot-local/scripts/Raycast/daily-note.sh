#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Daily Note
# @raycast.mode silent
# @raycast.keyEquivalent ctrl+shift+d

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Open daily note in tmux / kitty / nvim
# @raycast.author Thomas Arsouze

SCRIPT="$HOME/dotfiles/dot-local/scripts/notes.sh"
SESSION=$(date +"%Y-%m-%d-%A")

# 1. Ensure tmux session exists (NO attach)
tmux has-session -t "$SESSION" 2>/dev/null
if [ $? != 0 ]; then
  tmux new-session -d -s "$SESSION" "$SCRIPT daily"
else
  tmux new-window -t "$SESSION" "$SCRIPT daily"
fi

# 2. Open Ghostty (user will see tmux there)
open -a "Ghostty"

