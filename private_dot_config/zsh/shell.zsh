# Shell entrypoint managed by chezmoi. ~/.zshrc only activates mise and then
# sources this file; the rest is split into common + platform layers.
ZSH_CONFIG_DIR="$HOME/.config/zsh"

_zsh_source_if_exists() {
  [ -f "$1" ] && source "$1"
}

# Search common share locations instead of hard-coding brew-specific paths so
# the same config works on macOS and Linux.
_zsh_source_share_plugin() {
  local plugin_dir="$1"
  local plugin_file="$2"
  local share_dir

  for share_dir in /opt/homebrew/share /usr/local/share /usr/share; do
    if [ -f "$share_dir/$plugin_dir/$plugin_file" ]; then
      source "$share_dir/$plugin_dir/$plugin_file"
      return 0
    fi
  done

  return 1
}

_zsh_source_if_exists "$ZSH_CONFIG_DIR/common.zsh"

case "$OSTYPE" in
  darwin*) _zsh_source_if_exists "$ZSH_CONFIG_DIR/platform/darwin.zsh" ;;
  linux*) _zsh_source_if_exists "$ZSH_CONFIG_DIR/platform/linux.zsh" ;;
esac

# Only load ZLE/TTY-focused integrations when the shell is attached to a real
# terminal. This keeps automation like `zsh -ic ...` from printing warnings.
if [[ -o interactive ]] && [[ -t 1 ]]; then
  command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
  command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
  command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
  command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)

  _zsh_source_share_plugin zsh-autosuggestions zsh-autosuggestions.zsh
  _zsh_source_share_plugin zsh-syntax-highlighting zsh-syntax-highlighting.zsh

  # Keep Ctrl-R for fzf history while still exposing Atuin's full-screen search.
  if (( ${+widgets[atuin-search]} )); then
    bindkey -M emacs '^G' atuin-search
    bindkey -M viins '^G' atuin-search-viins
    bindkey -M emacs '^[r' atuin-search
    bindkey -M viins '^[r' atuin-search-viins
  fi
fi

unfunction _zsh_source_if_exists
unfunction _zsh_source_share_plugin
unset ZSH_CONFIG_DIR
