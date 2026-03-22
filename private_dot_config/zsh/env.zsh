# Shared shell environment managed by chezmoi.

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
