# dotfiles

## 从零装机（macOS）

按顺序执行下面几段命令即可。

### 0. 安装 Xcode Command Line Tools

先执行：

```bash
xcode-select --install
```

说明：

- 这一步放在 Homebrew 前面执行
- 如果系统已经装过，会提示已安装，直接继续下一步
- 如果弹出安装窗口，等安装完成后再继续

### 1. 安装 Homebrew

按当前仓库约定，使用下面这条：

```bash
/bin/zsh -c "$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)"
```

让当前 shell 立刻能用 `brew`：

```bash
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
```

### 2. 安装基础工具

```bash
brew install git chezmoi mise
```

### 3. 拉取并应用 dotfiles

```bash
chezmoi init --apply https://github.com/urzeye/dotfiles.git
```

### 4. 执行完整 setup

```bash
cd ~/.config/mise
mise run -o keep-order setup
```

### 5. 让当前终端生效

```bash
source ~/.zshrc
```

### 6. 可选验证

```bash
mise ls --current
chezmoi managed
ghostty +validate-config
brew bundle check --file="$HOME/.Brewfile" --no-upgrade
```

## 已有机器更新

```bash
chezmoi update
cd ~/.config/mise
mise run -o keep-order setup
source ~/.zshrc
```

如果只是改了配置文件，没有新增工具安装需求，通常这样就够了：

```bash
chezmoi apply
source ~/.zshrc
```

## 离线安装

### 仅离线应用配置文件

可以，但前提是目标机器上已经有可用的 `chezmoi`。

如果你手里是一个本地 git 仓库目录：

```bash
chezmoi init --apply --guess-repo-url=false /path/to/dotfiles
```

如果你手里只是一个解压后的目录，没有 `.git`：

```bash
mkdir -p ~/.local/share/chezmoi
rsync -a /path/to/unzipped-dotfiles/ ~/.local/share/chezmoi/
chezmoi init
chezmoi apply
```

### 完整离线装环境要注意什么

只离线应用 dotfiles 没问题。

但如果你想在完全无网的新机器上把整套环境都装齐，还需要提前准备这些内容：

- Homebrew 本体
- Homebrew formula / cask 缓存
- `mise` 本体
- `mise install` 需要的运行时缓存
- `pnpm add -g` 相关包缓存

也就是说：

- `chezmoi` 可以离线铺配置
- `brew bundle install`
- `mise install`
- `pnpm add -g ...`

这些默认都还是要网络，除非你提前做了离线缓存。

## 日常修改配置

### 推荐编辑方式

```bash
chezmoi edit ~/.zshrc
chezmoi edit ~/.config/mise/config.toml
chezmoi edit ~/.config/zsh/shell.zsh
chezmoi edit ~/.config/starship.toml
chezmoi edit ~/.config/ghostty/config
```

或者：

```bash
chezmoi cd
```

### 常用命令

预览改动：

```bash
chezmoi diff
```

应用改动：

```bash
chezmoi apply
```

查看当前受管文件：

```bash
chezmoi managed
```

把一个现有文件纳入管理：

```bash
chezmoi add ~/.some/file
```

强制以仓库内容覆盖本地目标文件：

```bash
cd ~/.config/mise
mise run setup:config:force
```

推送到远程仓库：

```bash
chezmoi cd
git status
git add .
git commit -m "chore: update dotfiles"
git push
```

## 当前管理内容

- `~/.Brewfile`
- `~/.gitconfig`
- `~/.zshrc`
- `~/.config/mise/config.toml`
- `~/.config/zsh/shell.zsh`
- `~/.config/starship.toml`
- `~/.config/ghostty/config`
- `~/Library/Application Support/lazygit/config.yml`

## 关键文件

### `~/.Brewfile`

负责 Homebrew 侧的公式、GUI 应用、字体和插件安装。

当前包含：

- `chezmoi`
- `mole`
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- `ghostty`
- `visual-studio-code`
- `karabiner-elements`
- `jordanbaird-ice`
- `flykey`
- `font-jetbrains-mono-nerd-font`

### `~/.gitconfig`

负责 Git 全局行为：

- `delta` 作为 pager
- `interactive.diffFilter`
- `merge.conflictStyle = zdiff3`
- `user.name`
- `user.email`

### `~/.config/mise/config.toml`

负责：

- 运行时和 CLI 工具安装
- 镜像源和环境变量
- `chezmoi` / Homebrew / AI 工具的 setup 编排

当前 setup 子任务：

- `setup:tools`
- `setup:apps`
- `setup:git`
- `setup:config`
- `setup:config:force`
- `setup:ghostty`
- `setup:ai`
- `setup:shell`

### `~/.zshrc`

只负责初始化，不再由 `setup` 任务重写：

- `mise`
- `~/.config/zsh/shell.zsh`
- `zoxide`
- `starship`
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`

### `~/.config/zsh/shell.zsh`

主 shell 配置，分成三块：

1. 环境变量
2. alias
3. function

高频命令：

- `mr`
- `lg`
- `fe`
- `fcd`
- `fkill`
- `fgh`
- `fco`
- `wx`
- `wxe`

### `~/.config/starship.toml`

负责 prompt 显示：

- 目录
- Git 分支和状态
- Python / Node.js / Go / Java / Rust / package 版本
- 命令耗时

### `~/.config/ghostty/config`

负责 Ghostty：

- `JetBrainsMono Nerd Font`
- `Catppuccin Mocha`
- 半透明背景
- 背景模糊
- split 快捷键

### `~/Library/Application Support/lazygit/config.yml`

负责 Lazygit：

- 图标显示
- 圆角边框
- `delta` pager
- VS Code 编辑器

## 这套方案怎么分工

- `chezmoi`：管配置文件
- `mise`：管工具安装和 setup
- `git`：管历史和同步

统一入口：

```bash
mise run -o keep-order setup
```

## 常见问题

### 进入 `chezmoi` 源目录时，`mise` 提示 trust

执行一次：

```bash
mise trust ~/.local/share/chezmoi/private_dot_config/mise/config.toml
```

### 安装完 `mise` 后，如果不写 `eval "$(mise activate zsh)"` 会怎样

分两种情况：

- `mise` 命令本身通常仍然可以用
- 但交互式 shell 里不会自动加载 `mise` 的 PATH 和环境变量

这会影响：

- 进入项目目录后自动切换工具版本
- 自动注入 `mise` 管理的环境变量
- 直接在 shell 里无感使用 `mise` 提供的工具上下文

本仓库已经把这一行写进了 `~/.zshrc`，所以用：

```bash
chezmoi init --apply https://github.com/urzeye/dotfiles.git
```

或者：

```bash
chezmoi apply
```

之后，不需要再手动执行：

```bash
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
```

### Homebrew 相关内容现在放在哪里

统一放在：

```text
~/.Brewfile
```

`setup:apps` 会执行：

```bash
brew bundle install --file="$HOME/.Brewfile" --no-upgrade
```

### 为什么源目录里有 `private_dot_config`、`private_Library`

这是 `chezmoi` 的命名规则：

- `dot_` 表示目标路径名以 `.` 开头
- `private_` 表示按私有权限处理

对应关系：

- `private_dot_zshrc` -> `~/.zshrc`
- `private_dot_config` -> `~/.config`
- `private_Library` -> `~/Library`

平时优先用真实路径操作：

```bash
chezmoi edit ~/.zshrc
chezmoi edit ~/.config/mise/config.toml
```

## 后续计划

- Windows 平台隔离配置
- 更多编辑器配置
- 更多 AI 工具配置
- 机器差异模板化
