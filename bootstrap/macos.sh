#!/usr/bin/env bash
set -euo pipefail

find_brew_bin() {
  if [ -x /opt/homebrew/bin/brew ]; then
    printf '/opt/homebrew/bin/brew\n'
    return 0
  fi

  if [ -x /usr/local/bin/brew ]; then
    printf '/usr/local/bin/brew\n'
    return 0
  fi

  return 1
}

if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install >/dev/null 2>&1 || true
  cat <<'EOF'
Command Line Tools installer has been opened.
Finish it, then rerun:
  bash <(curl -fsSL https://raw.githubusercontent.com/urzeye/dotfiles/main/bootstrap/macos.sh)
EOF
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  /bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
fi

BREW_BIN="$(find_brew_bin)"
if [ -z "$BREW_BIN" ]; then
  echo "Homebrew install succeeded but brew was not found in /opt/homebrew/bin or /usr/local/bin." >&2
  exit 1
fi

BIN_DIR="$(dirname "$BREW_BIN")"

"$BREW_BIN" install git chezmoi mise

"$BIN_DIR/chezmoi" init --apply https://github.com/urzeye/dotfiles.git
cd "$HOME/.config/mise"
"$BIN_DIR/mise" run -o keep-order setup:full

cat <<'EOF'
macOS bootstrap complete.

Now:
  exec zsh
EOF
