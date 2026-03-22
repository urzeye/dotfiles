# dotfiles

## 从零装机（macOS）

按顺序执行下面几段命令即可。

### 1. 安装 Homebrew

Homebrew 官方当前安装命令：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

推送到远程仓库：

```bash
chezmoi cd
git status
git add .
git commit -m "chore: update dotfiles"
git push
```

## 当前管理内容

- `~/.zshrc`
- `~/.config/mise/config.toml`
- `~/.config/zsh/shell.zsh`
- `~/.config/starship.toml`
- `~/.config/ghostty/config`
- `~/Library/Application Support/lazygit/config.yml`

## 关键文件

### `~/.config/mise/config.toml`

负责：

- 运行时和 CLI 工具安装
- 镜像源和环境变量
- setup 子任务编排

当前 setup 子任务：

- `setup:tools`
- `setup:apps`
- `setup:git`
- `setup:config`
- `setup:ghostty`
- `setup:ai`
- `setup:shell`

### `~/.zshrc`

只负责初始化：

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
