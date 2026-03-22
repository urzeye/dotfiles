# Shell aliases managed by chezmoi.

# Better defaults for everyday terminal commands.
alias ls='eza --icons --git --group-directories-first'
alias ll='eza -lh --icons --git --group-directories-first'
alias la='eza -a --icons --git'
alias lt='eza --tree --icons --level=2'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias du='du -h'
alias df='df -h'
alias jqp='jq -C -S'
alias jb='open -a "JetBrains Toolbox"'

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
