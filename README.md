# dotfiles

## 全新 macOS

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/urzeye/dotfiles/main/bootstrap/macos.sh)
exec zsh
```

首次如果弹出 `Command Line Tools` 安装器，装完后再执行一次同一条命令。

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

## 日常流程

本机改完后推到 GitHub：

```bash
chezmoi edit ~/.config/mise/config.toml
chezmoi diff
chezmoi cd
git status
git add .
git commit -m "chore: update dotfiles"
git push
```

其他机器同步：

macOS：

```bash
chezmoi update
cd ~/.config/mise
mise run -o keep-order setup:full
source ~/.zshrc
```

Linux：

```bash
chezmoi update
cd ~/.config/mise
mise run -o keep-order setup
source ~/.zshrc
```

只同步配置文件：

```bash
chezmoi apply
source ~/.zshrc
```

按需补装：

```bash
mise run setup:java
mise run setup:rust
mise run setup:ai
mise run setup:full
```

常用维护命令：

```bash
chezmoi edit ~/.zshrc
chezmoi edit ~/.config/ghostty/config
chezmoi cd
chezmoi managed
chezmoi add ~/.some/file
cd ~/.config/mise
mise run setup:config:force
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

## SSH

生成密钥：

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
ssh-keygen -t ed25519 -a 64 -f ~/.ssh/id_ed25519 -C "$(whoami)@$(hostname)-$(date +%F)"
```

查看公钥：

```bash
cat ~/.ssh/id_ed25519.pub
```

macOS 追加到 Keychain：

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

在远程服务器添加公钥：

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo '把你的公钥整行粘贴到这里' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

本仓库只管理 SSH 骨架，不保存真实服务器：

```bash
cp ~/.ssh/config.local.example ~/.ssh/config.local
vim ~/.ssh/config.local
```

示例：

```sshconfig
Host my-server
  HostName 1.2.3.4
  User root
  Port 22
  IdentityFile ~/.ssh/id_ed25519
```

连接：

```bash
ssh my-server
```

## 受管文件

- `~/.gitconfig`
- `~/.ssh/config`
- `~/.ssh/config.d/00-defaults.conf`
- `~/.ssh/config.local.example`
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
