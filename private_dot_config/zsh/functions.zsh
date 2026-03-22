# Shell functions managed by chezmoi.

# Search files with fd + fzf, then open the selected file in the current editor.
fe() {
  local file
  file=$(eval "$FZF_DEFAULT_COMMAND" | fzf --query="$1" --select-1 --exit-0 --preview 'bat --color=always --style=numbers --line-range=:500 {}' --preview-window=right:60%)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# Jump across large projects by fuzzy-selecting a directory.
fcd() {
  local dir
  dir=$(eval "$FZF_ALT_C_COMMAND" | fzf --query="$1" --select-1 --exit-0)
  [ -n "$dir" ] && cd "$dir"
}

# Interactively choose one or more processes and terminate them.
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  if [ -n "$pid" ]; then
    echo "$pid" | xargs kill -"${1:-9}"
  fi
}

# Preview git history, then open the full diff of the selected commit.
fgh() {
  git log --oneline --color=always | fzf --ansi --preview 'git show --color=always {1}' | awk '{print $1}' | xargs -I {} git show {}
}

# Pick a local or remote branch and switch to it with git switch.
fco() {
  local branch
  branch=$(git branch --all | grep -v "[*]" | fzf +m) &&
  git switch $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# wx = watch exec, rerun the full command whenever files change.
wx() {
  command -v watchexec >/dev/null 2>&1 || { echo 'watchexec is not installed'; return 1; }
  watchexec -r -- "$@"
}

# wxe = watch exec by extension, useful when only certain file types matter.
wxe() {
  command -v watchexec >/dev/null 2>&1 || { echo 'watchexec is not installed'; return 1; }
  local exts="$1"
  shift
  if [ -z "$exts" ] || [ $# -eq 0 ]; then echo 'usage: wxe <exts> <command...>'; return 1; fi
  watchexec -r -e "$exts" -- "$@"
}

# Enable fzf shell bindings only when fzf is available.
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)
