#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Notes
# @raycast.mode fullOutput
# @raycast.keyEquivalent ctrl+shift+n

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Open notes in tmux / kitty / nvim
# @raycast.author Thomas Arsouze

SCRIPT="$HOME/dotfiles/dot-local/scripts/notes.sh"
SESSION="notes"

tmux has-session -t "$SESSION" 2>/dev/null
if [ $? != 0 ]; then
  tmux new-session -d -s "$SESSION" -c ~/test_notes "nvim"
else
  tmux new-window -t "$SESSION" -c ~/test_notes "nvim"
fi

tmux switch-client -t "$SESSION" 2>/dev/null

open -a "Ghostty"
