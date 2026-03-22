# dotfiles

## 全新 macOS

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/urzeye/dotfiles/main/bootstrap/macos.sh)
if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi
chezmoi init --apply https://github.com/urzeye/dotfiles.git
cd ~/.config/mise
mise run -o keep-order setup:full
exec zsh
```

验证：

```bash
mise ls --current
chezmoi managed
ghostty +validate-config
brew bundle check --file="$HOME/.Brewfile" --no-upgrade
```

## 全新 Linux

支持：

- Debian / Ubuntu
- Fedora

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/urzeye/dotfiles/main/bootstrap/linux.sh)
exec zsh
```

按需补装：

```bash
mise run setup:java
mise run setup:rust
mise run setup:ai
```

验证：

```bash
mise ls --current
chezmoi managed
lazygit --version
tldr git
```

## 已有机器更新

```bash
chezmoi update
cd ~/.config/mise
mise run setup:cleanup
mise run -o keep-order setup
source ~/.zshrc
```

只同步配置文件：

```bash
chezmoi apply
source ~/.zshrc
```

## 离线安装

本地 git 仓库目录：

```bash
chezmoi init --apply --guess-repo-url=false /path/to/dotfiles
```

解压后的普通目录：

```bash
mkdir -p ~/.local/share/chezmoi
rsync -a /path/to/unzipped-dotfiles/ ~/.local/share/chezmoi/
chezmoi init
chezmoi apply
```

完整 setup 仍需网络：

- macOS: `bootstrap/macos.sh`, `brew bundle install`, `mise install`, `pnpm add -g ...`
- Linux: `bootstrap/linux.sh`, `mise install`, `pnpm add -g ...`

## 日常命令

Setup：

```bash
mise run setup
mise run setup:cleanup
mise run setup:java
mise run setup:rust
mise run setup:ai
mise run setup:full
```

编辑：

```bash
chezmoi edit ~/.zshrc
chezmoi edit ~/.vimrc
chezmoi edit ~/.config/mise/config.toml
chezmoi edit ~/.config/zsh/shell.zsh
chezmoi edit ~/.config/zsh/common.zsh
chezmoi edit ~/.config/zsh/platform/darwin.zsh
chezmoi edit ~/.config/zsh/platform/linux.zsh
chezmoi edit ~/.config/starship.toml
chezmoi edit ~/.config/ghostty/config
```

进入源目录：

```bash
chezmoi cd
```

预览改动：

```bash
chezmoi diff
```

应用改动：

```bash
chezmoi apply
```

查看受管文件：

```bash
chezmoi managed
```

纳入新文件：

```bash
chezmoi add ~/.some/file
```

强制覆盖本地目标文件：

```bash
cd ~/.config/mise
mise run setup:config:force
```

推送：

```bash
chezmoi cd
git status
git add .
git commit -m "chore: update dotfiles"
git push
```

## 常用工具

### `mas`

先在 Mac App Store 登录 Apple ID。

```bash
mas search Amphetamine
mas list
mas get 937984704
mas upgrade
```

默认受管应用：

```bash
mas "Amphetamine", id: 937984704
```

### `atuin`

首次启用：

```bash
source ~/.zshrc
atuin import auto
```

最常用：

```bash
atuin search -i
atuin search docker
atuin search --cwd
atuin stats
```

日常使用：

- 在终端里按 `Ctrl-r`
- 输入关键词后回车，直接把历史命令填回当前命令行
- 不想跨项目串历史时，用 `atuin search --cwd`

只导入 zsh 历史：

```bash
atuin import zsh
```

非交互搜索：

```bash
atuin search pnpm
atuin search git --cmd-only
atuin search --cwd npm
```

多机同步，可选：

```bash
atuin register
atuin login
atuin sync
atuin key
atuin status
```

## 受管文件

- `~/.gitconfig`
- `~/.vimrc`
- `~/.zshrc`
- `~/.config/mise/config.toml`
- `~/.config/zsh/shell.zsh`
- `~/.config/zsh/common.zsh`
- `~/.config/zsh/platform/darwin.zsh`
- `~/.config/zsh/platform/linux.zsh`
- `~/.config/starship.toml`
- macOS: `~/.Brewfile`
- macOS: `~/.config/ghostty/config`
- macOS: `~/Library/Application Support/lazygit/config.yml`
- Linux: `~/.config/lazygit/config.yml`

## 关键入口

### `~/.config/mise/config.toml`

运行时、CLI 工具、环境变量、显式 setup 任务。

公开入口：

- `mise run setup`
- `mise run setup:cleanup`
- `mise run setup:java`
- `mise run setup:rust`
- `mise run setup:ai`
- `mise run setup:full`

### `~/.zshrc`

只保留 PATH 引导、`mise` 激活和 `shell.zsh` 入口。

### `~/.vimrc`

Vim 基础编辑体验、搜索、缩进、持久化 undo 与内置暗色主题。

### `~/.config/zsh/shell.zsh`

Zsh 总入口，负责加载 `common.zsh` 和当前平台文件。

### `~/.config/zsh/common.zsh`

macOS / Linux 共享的环境变量、alias、function。

### `~/.config/zsh/platform/darwin.zsh`

macOS 专属 shell 配置。

### `~/.config/zsh/platform/linux.zsh`

Linux 专属 shell 配置。

## FAQ

### 进入 `chezmoi` 源目录时，`mise` 提示 trust

```bash
mise trust ~/.local/share/chezmoi/private_dot_config/mise/config.toml
```

### 安装完 `mise` 后，不往 `.zshrc` 里写 `eval "$(mise activate zsh)"` 行不行

`mise` 命令通常还能用。

不会自动生效的部分：

- 进入目录自动切换工具版本
- `mise` 管理的环境变量注入
- 当前交互式 shell 的 PATH 上下文

本仓库的 `~/.zshrc` 已经包含这行。
