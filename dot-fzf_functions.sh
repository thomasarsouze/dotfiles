# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# autocompletion with fzf configuration
zstyle ':completion:*:git:*' group-order 'main commands' 'alias commands' 'external commands'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with ls when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# fuzzy explorer
# extending Phantas0's work (https://thevaluable.dev/practical-guide-fzf-example/)
function fex() {
  export selection=$(find . -type d | fzf --multi --border=sharp \
  --preview='tree -C {}' --preview-window='45%,border-sharp' \
  --prompt='Dirs > ' \
  --bind='del:execute(rm -ri {+})' \
  --bind='ctrl-p:toggle-preview' \
  --bind='ctrl-d:change-prompt(Dirs > )' \
  --bind='ctrl-d:+reload(find . -type d)' \
  --bind='ctrl-d:+change-preview(tree -C {})' \
  --bind='ctrl-d:+refresh-preview' \
  --bind='ctrl-f:change-prompt(Files > )' \
  --bind='ctrl-f:+reload(find . -type f)' \
  --bind='ctrl-f:+change-preview(bat --style numbers,changes --color=always {} | head -500)' \
  --bind='ctrl-f:+refresh-preview' \
  --bind='ctrl-a:select-all' \
  --bind='ctrl-x:deselect-all' \
  --border-label ' fzf Explorer ' \
  --header ' CTRL-D (directories) CTRL-F (files)
 CTRL-A (select all) CTRL-X (deselect)
 CTRL-P (toggle preview) DEL (delete)'
  )

  # if no selection made do nothing
  if [ -z "$selection" ]; then
    return 0
  fi

  local EDITOR=zed
  # if selection is a folder (with multiples go to the first)
  if [ -d $selection ]; then
    cd "$selection" || exit
  else
    # supports multiple selections
    echo $(echo $selection) | xargs $EDITOR
  fi
}

# ripgrep->fzf->zed [QUERY]
grepex() (
  RELOAD='reload:rg --column --line-number --no-heading --color=always --smart-case {q} || :'
  OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            zed {1} #+{2}     # No selection. Open the current line in zed.
          else
            cat {+f} | sed "s/\(:.*\)//" | xargs zed # Build quickfix list for the selected items.
          fi'
  fzf --disabled --ansi --highlight-line --multi \
      --bind "start:$RELOAD" --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --bind='ctrl-a:select-all' \
      --bind='ctrl-x:deselect-all' \
      --bind='ctrl-p:toggle-preview' \
      --delimiter : \
      --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
      --preview-window '~4,+{2}+4/3,<80(up)' \
      --header 'CTRL-A (select all) CTRL-X (deselect)
TAB (select file) CTRL-P (toggle preview) ENTER (Open File-s)' \
      --query "$*"
)

# fancy multilines ripgrep + fzf
function grepm {
  rg --column --line-number --no-heading --color=always --smart-case -- $1 |
    perl -pe 's/\n/\0/; s/^([^:]+:){3}/$&\n  /' |
    fzf --read0 --ansi --highlight-line --multi --delimiter : \
      --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
      --preview-window '+{2}/4' --gap |
    perl -ne '/^([^:]+:){3}/ and print'
}


# conda env selector
mamba-envs () {
    choice=(
        $(
            mamba env list |
            sed 's/\*/ /;1,2d' |
            xargs -S350 -I {} bash -c '
                name_path=( {} );
                py_version=( $(${name_path[1]}/bin/python --version) );
                echo ${name_path[0]} ${py_version[1]} ${name_path[1]}
            ' |
            column -t |
            fzf --layout=reverse \
                --info=inline \
                --border=rounded \
                --height=40 \
                --preview-window="right:30%" \
                --preview-label=" conda tree leaves " \
                --preview=$'
                    conda tree -p {3} leaves |
                    perl -F\'[^\\w-_]\' -lae \'print for grep /./, @F;\' |
                    sort
                '
        )
    )
    [[ -n "$choice" ]] && mamba activate "$choice[3]"
}


# autojump with fzf
j() {
    local preview_cmd="ls {2..}"
    if command -v exa &> /dev/null; then
        preview_cmd="exa -l {2}"
    fi

    if [[ $# -eq 0 ]]; then
                 cd "$(autojump -s | sort -k1gr | awk -F : '$1 ~ /[0-9]/ && $2 ~ /^\s*\// {print $1 $2}' | fzf --height 40% --reverse --inline-info --preview "$preview_cmd" --preview-window down:50% | cut -d$'\t' -f2- | sed 's/^\s*//')"
    else
        cd $(autojump $@)
    fi
}

#!/usr/bin/env bash

function fgb() {
	local -r git_branches="git branch --all --color --format=$'%(HEAD) %(color:yellow)%(refname:short)\t%(color:green)%(committerdate:short)\t%(color:blue)%(subject)' | column -t -s=$'\t'"
	local -r get_selected_branch='echo {} | sed "s/^[* ]*//" | awk "{print \$1}"'
	local -r git_log="git log \$($get_selected_branch) --graph --color --format='%C(white)%h - %C(green)%cs - %C(blue)%s%C(red)%d'"
	local -r git_diff='git diff --color $(git branch --show-current)..$(echo {} | sed "s/^[* ]*//" | awk "{print \$1}")'
	local -r git_show_subshell=$(cat <<-EOF
		[[ \$($get_selected_branch) != '' ]] && sh -c "git show --color \$($get_selected_branch) | less -R"
	EOF
	)
	local -r header=$(cat <<-EOF
> CTRL-M to merge with current * branch
> CTRL-R to rebase with current * branch
> CTRL-E to checkout the branch
> CTRL-D to delete the merged local branch
> CTRL-X to force delete the local branch
> ENTER to open the diff with less
	EOF
	)

	eval "$git_branches" \
	| fzf \
		--ansi \
		--reverse \
		--no-sort \
		--preview-label '[ Commits ]' \
		--preview "$git_log" \
		--header-first \
		--header="$header" \
		--bind="ctrl-e:execute(git checkout \$($get_selected_branch))" \
		--bind="ctrl-c:+reload($git_branches)" \
		--bind="ctrl-m:execute(git merge \$($get_selected_branch))" \
		--bind="ctrl-r:execute(git rebase \$($get_selected_branch))" \
		--bind="ctrl-d:execute(git branch --delete \$($get_selected_branch))" \
		--bind="ctrl-d:+reload($git_branches)" \
		--bind="ctrl-x:execute(git branch --delete --force \$($get_selected_branch))" \
		--bind="ctrl-x:+reload($git_branches)" \
		--bind="enter:execute($git_show_subshell)" \
		--bind='ctrl-f:change-preview-label([ Diff ])' \
		--bind="ctrl-f:+change-preview($git_diff)" \
		--bind='ctrl-i:change-preview-label([ Commits ])' \
		--bind="ctrl-i:+change-preview($git_log)" \
		--bind='f1:toggle-header' \
		--bind='f2:toggle-preview' \
		--bind='ctrl-y:preview-up' \
		--bind='ctrl-e:preview-down' \
		--bind='ctrl-u:preview-half-page-up' \
		--bind='ctrl-d:preview-half-page-down'
}
