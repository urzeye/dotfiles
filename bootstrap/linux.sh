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

mkdir -p "$HOME/.local/bin"

if ! command -v chezmoi >/dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

if ! command -v mise >/dev/null 2>&1; then
  curl https://mise.run | sh
fi

if command -v zsh >/dev/null 2>&1 && command -v chsh >/dev/null 2>&1; then
  cat <<EOF
Run this once if you want zsh as the default login shell:
  chsh -s "$(command -v zsh)"
EOF
fi

cat <<'EOF'
Linux bootstrap complete.

Next:
  export PATH="$HOME/.local/bin:$PATH"
  chezmoi init --apply https://github.com/urzeye/dotfiles.git
  cd ~/.config/mise
  mise run -o keep-order setup
  exec zsh
EOF
