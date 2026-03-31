#!/usr/bin/env bash
# # I tried replacing BetterTouchTool with this, never worked, so fuck it
main_note_dir=~/test_notes
daily_dir="$main_note_dir/daily"

mode="$1" # can be "daily" (default) or "notes"

# Default to daily mode
if [ -z "$mode" ]; then
  mode="daily"
fi

if [ "$mode" = "notes" ]; then
  session_name="notes"

  # Create session if it doesn't exist
  if ! tmux has-session -t="$session_name" 2>/dev/null; then
    tmux new-session -d -s "$session_name" -c "$main_note_dir" "nvim"
  fi

else
  # Get current date components
  current_year=$(date +"%Y")
  current_month_num=$(date +"%m")
  current_month_abbr=$(date +"%b")
  current_day=$(date +"%d")
  current_weekday=$(date +"%A")

  # Construct the directory structure and filename
  note_dir=${main_note_dir}/${current_year}/${current_month_num}-${current_month_abbr}
  note_name=${current_year}-${current_month_num}-${current_day}-${current_weekday}
  full_path=${note_dir}/${note_name}.md
  # Use note name as the session name
  session_name=${note_name}

  # Check if the directory exists, if not, create it
  if [ ! -d "$note_dir" ]; then
    mkdir -p "$note_dir"
  fi

  # Create the daily note if it does not already exist
  if [ ! -f "$full_path" ]; then
    cat <<EOF >"$full_path"
# ${current_year}-${current_month_num}-${current_day}-${current_weekday}
EOF
  fi

  # Check if a tmux session with the note name already exists
  if ! tmux has-session -t="$session_name" 2>/dev/null; then
    # Create a new tmux session with the note name in detached mode and start
    # neovim with the daily note, cursor at the last line
    # + tells neovim to execute a command after opening and G goes to last line
    # Otherwise the instance that was opened always had plugin updates, even though it was neobean
    # tmux new-session -d -s "$tmux_session_name" -c "$note_dir" "NVIM_APPNAME=neobean nvim +norm\ Go +startinsert $full_path"
    tmux new-session -d -s "$session_name" -c "$note_dir" "nvim +norm\ G $full_path"
    # tmux new-session -d -s "$tmux_session_name" "nvim +norm\ G $full_path"
    # Create a new tmux session with the note name in detached mode and start neovim with the daily note
    # tmux new-session -d -s "$tmux_session_name" "nvim $full_path"
  fi
fi

# Check if neovim is running, if not open it
if ! tmux list-panes -t "$session_name" -F "#{pane_current_command}" | grep -q "nvim"; then
  tmux send-keys -t "$session_name" "nvim" C-m
  tmux send-keys -t "$session_name" "s"
fi

# Attach/switch
if [ -n "$TMUX" ]; then
  tmux switch-client -t "$session_name"
else
  tmux attach-session -t "$session_name"
fi
