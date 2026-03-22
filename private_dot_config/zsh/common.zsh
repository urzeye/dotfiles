# Shared shell configuration for macOS and Linux.

# --- Environment ---
# FZF intentionally skips large/generated directories to keep searches fast in
# monorepos and full-stack projects.
export FZF_FD_EXCLUDES='--exclude .git --exclude node_modules --exclude .venv --exclude venv --exclude dist --exclude build --exclude target --exclude coverage --exclude .idea --exclude .next --exclude .nuxt --exclude .turbo --exclude .gradle'
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow $FZF_FD_EXCLUDES"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow $FZF_FD_EXCLUDES"

# Keep the global layout generic; file previews are enabled only in file-picking
# commands so branch/history/process pickers stay clean.
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}' --preview-window=right:60%"

# --- Aliases ---
# Better defaults for everyday terminal commands.
alias ls='eza --icons --git --group-directories-first'
alias ll='eza -lh --icons --git --group-directories-first'
alias la='eza -a --icons --git'
alias lt='eza --tree --icons --level=2'
alias cat='bat'
alias grep='rg --smart-case'  # 小写关键词时忽略大小写，输入大写时恢复严格匹配
alias find='fd'
alias du='du -h'
alias df='df -h'
alias jqp='jq -C -S'

# High-frequency Git shortcuts that still make sense even with lazygit.
alias lg='lazygit'
alias gst='git status'        # gst = git status
alias gcm='git commit -m'     # gcm = git commit message
alias gp='git push'           # gp = git push
alias gl='git pull'           # gl = git pull
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Java / Maven workflow.
alias mc='mvn clean'
alias mi='mvn install'
alias mcp='mvn clean package -DskipTests'   # mcp = clean + package, skip tests
alias mdt='mvn dependency:tree'
alias mist='mvn install -DskipTests'        # mist = install skip tests

# Node / pnpm workflow.
alias ni='pnpm install'
alias ns='pnpm start'
alias nd='pnpm dev'
alias nb='pnpm build'

# Mise and navigation helpers.
alias m='mise'
alias mr='MISE_TASK_TIMINGS=0 mise run -o keep-order'  # mr = readable task output
alias v='mise ls --current'       # v = view current tools
alias mw='mise watch'
alias ..='z ..'
alias ...='z ../..'
alias fh='history | fzf'          # fh = fuzzy history

# --- Functions ---
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
