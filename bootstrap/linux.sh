#!/usr/bin/env bash
set -euo pipefail

if command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
else
  SUDO=""
fi

install_with_apt() {
  $SUDO apt-get update
  $SUDO apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    jq \
    tar \
    unzip \
    xz-utils \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting
}

install_with_dnf() {
  $SUDO dnf install -y \
    ca-certificates \
    curl \
    gcc \
    gcc-c++ \
    git \
    jq \
    make \
    tar \
    unzip \
    xz \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting
}

if command -v apt-get >/dev/null 2>&1; then
  install_with_apt
elif command -v dnf >/dev/null 2>&1; then
  install_with_dnf
else
  echo "Unsupported Linux package manager. Install git, curl, zsh, chezmoi, and mise manually."
  exit 1
fi

upsert_block() {
  local file="$1"
  local begin="$2"
  local end="$3"
  local block="$4"
  local tmp

  mkdir -p "$(dirname "$file")"
  [ -f "$file" ] || : > "$file"

  if grep -Fq "$begin" "$file"; then
    tmp="$(mktemp)"
    awk -v begin="$begin" -v end="$end" -v block="$block" '
      $0 == begin {
        print block
        skip = 1
        next
      }
      $0 == end {
        skip = 0
        next
      }
      !skip { print }
    ' "$file" > "$tmp"
    mv "$tmp" "$file"
  else
    printf '\n%s\n' "$block" >> "$file"
  fi
}

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

if [ ! -x "$HOME/.local/bin/chezmoi" ]; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

if [ ! -x "$HOME/.local/bin/mise" ]; then
  curl https://mise.run | sh >/dev/null
fi

BASH_BOOTSTRAP_BEGIN="# >>> dotfiles bootstrap >>>"
BASH_BOOTSTRAP_END="# <<< dotfiles bootstrap <<<"
BASH_BOOTSTRAP_BLOCK="$(cat <<'EOF'
# >>> dotfiles bootstrap >>>
export PATH="$HOME/.local/bin:$PATH"
command -v mise >/dev/null 2>&1 && eval "$(mise activate bash)"
# <<< dotfiles bootstrap <<<
EOF
)"

upsert_block "$HOME/.bashrc" "$BASH_BOOTSTRAP_BEGIN" "$BASH_BOOTSTRAP_END" "$BASH_BOOTSTRAP_BLOCK"

if [ -f "$HOME/.bash_profile" ]; then
  upsert_block "$HOME/.bash_profile" "$BASH_BOOTSTRAP_BEGIN" "$BASH_BOOTSTRAP_END" "$BASH_BOOTSTRAP_BLOCK"
elif [ -f "$HOME/.profile" ]; then
  upsert_block "$HOME/.profile" "$BASH_BOOTSTRAP_BEGIN" "$BASH_BOOTSTRAP_END" "$BASH_BOOTSTRAP_BLOCK"
fi

if command -v zsh >/dev/null 2>&1 && command -v chsh >/dev/null 2>&1; then
  cat <<EOF
Run this once if you want zsh as the default login shell:
  chsh -s "$(command -v zsh)"
EOF
fi

"$HOME/.local/bin/chezmoi" init --apply https://github.com/urzeye/dotfiles.git
cd "$HOME/.config/mise"
"$HOME/.local/bin/mise" run -o keep-order setup:base

cat <<'EOF'
Linux bootstrap complete.

Now:
  exec zsh

Optional after entering zsh:
  mise run setup:ai
EOF
