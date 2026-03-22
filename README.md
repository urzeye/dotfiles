# dotfiles

我的个人开发环境配置仓库，当前主要面向 macOS。

远程仓库：

```text
https://github.com/urzeye/dotfiles.git
```

## 新机器安装

这是最重要的部分。

### 前提

- 系统：macOS
- 已安装 Homebrew

如果机器上还没有 Homebrew，先按 Homebrew 官网步骤安装。

### 1. 安装最基础的引导工具

```bash
brew install git chezmoi mise
```

### 2. 拉取 dotfiles 并应用配置文件

```bash
chezmoi init --apply https://github.com/urzeye/dotfiles.git
```

这一步会先把受管文件放到对应位置，例如：

- `~/.zshrc`
- `~/.config/mise/config.toml`
- `~/.config/zsh/shell.zsh`
- `~/.config/starship.toml`
- `~/.config/ghostty/config`
- `~/Library/Application Support/lazygit/config.yml`

### 3. 执行完整 setup

```bash
cd ~/.config/mise
mise run -o keep-order setup
```

这个命令会完成：

- 安装 `mise` 中声明的运行时和 CLI 工具
- 安装 Homebrew 应用、字体和 Zsh 插件
- 应用 `chezmoi` 管理的配置
- 校验 Ghostty 配置
- 安装 AI CLI 工具链
- 更新 `.zshrc` 中由 `mise` 托管的初始化区块

### 4. 让当前终端立即生效

```bash
source ~/.zshrc
```

### 5. 可选验证

```bash
mise ls --current
chezmoi managed
ghostty +validate-config
```

## 已有机器更新

如果这台机器已经初始化过，只需要同步最新配置：

```bash
chezmoi update
cd ~/.config/mise
mise run -o keep-order setup
source ~/.zshrc
```

如果你只是改了配置文件，没有新增工具安装需求，通常用这组命令就够了：

```bash
chezmoi apply
source ~/.zshrc
```

## 日常修改配置

### 推荐编辑方式

优先用 `chezmoi edit`，直接按真实路径改：

```bash
chezmoi edit ~/.zshrc
chezmoi edit ~/.config/mise/config.toml
chezmoi edit ~/.config/zsh/shell.zsh
chezmoi edit ~/.config/starship.toml
chezmoi edit ~/.config/ghostty/config
```

或者直接进入源目录：

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

### 推送到远程仓库

```bash
chezmoi cd
git status
git add .
git commit -m "chore: update dotfiles"
git push
```

## 这套仓库当前管什么

当前已纳入管理的内容包括：

- `~/.zshrc`
- `~/.config/mise/config.toml`
- `~/.config/zsh/shell.zsh`
- `~/.config/starship.toml`
- `~/.config/ghostty/config`
- `~/Library/Application Support/lazygit/config.yml`

重点覆盖：

- shell 启动和增强
- 运行时和常用 CLI 工具
- prompt
- 终端配置
- Git TUI 配置

## 关键文件说明

### `~/.config/mise/config.toml`

这是整套环境的工具和 setup 中心，负责：

- Go / Java / Node.js / Python / Rust 等运行时
- `fd`、`fzf`、`ripgrep`、`bat`、`eza`、`jq`、`gh`、`delta` 等工具
- 镜像源和环境变量
- setup 子任务编排

当前 setup 子任务包括：

- `setup:tools`
- `setup:apps`
- `setup:git`
- `setup:config`
- `setup:ghostty`
- `setup:ai`
- `setup:shell`

### `~/.zshrc`

这个文件保持很薄，只负责初始化：

- `mise`
- `~/.config/zsh/shell.zsh`
- `zoxide`
- `starship`
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`

### `~/.config/zsh/shell.zsh`

这是主要的 shell 自定义文件，分为三块：

1. 环境变量
2. alias
3. function

里面包含一些高频命令，例如：

- `mr`：更适合阅读的 `mise run`
- `lg`：打开 Lazygit
- `fe`：模糊搜索文件并打开
- `fcd`：模糊搜索目录并进入
- `fkill`：模糊选择进程后结束
- `fgh`：预览并查看 Git 提交
- `fco`：模糊选择并切换 Git 分支
- `wx`：文件变化时自动重跑命令
- `wxe`：按扩展名监听并自动重跑命令

### `~/.config/starship.toml`

当前 Starship 配置主要显示：

- 目录
- Git 分支和状态
- Python / Node.js / Go / Java / Rust / package 版本
- 命令耗时

### `~/.config/ghostty/config`

当前 Ghostty 配置包括：

- `JetBrainsMono Nerd Font`
- `Catppuccin Mocha`
- 半透明背景
- 背景模糊
- split 快捷键

### `~/Library/Application Support/lazygit/config.yml`

当前 Lazygit 配置包括：

- 图标显示
- 圆角边框
- `delta` 作为 pager
- VS Code 作为编辑器

## 这套方案的分工

这里只说结论：

- `chezmoi`：管理配置文件
- `mise`：管理工具安装和 setup 流程
- `git`：管理版本历史和远程同步

这样拆开之后，配置文件是正常文件，setup 还是保留一个统一入口：

```bash
mise run -o keep-order setup
```

## 常见问题

### 进入 `chezmoi` 源目录时，为什么 `mise` 可能提示 trust

因为仓库里也管理了这份文件：

```text
~/.config/mise/config.toml
```

当你进入 `chezmoi` 源目录时，`mise` 有时会把源目录中的那份配置也识别出来，因此要求信任。

如果遇到这个问题，执行一次：

```bash
mise trust ~/.local/share/chezmoi/private_dot_config/mise/config.toml
```

通常信任一次之后就不会再报错。

### 为什么源目录里会看到 `private_dot_config`、`private_Library`

这是 `chezmoi` 的源文件命名规则，不是额外多套了一层目录。

只要记住两点就够了：

- `dot_` 表示目标路径名以 `.` 开头
- `private_` 表示该目标按私有权限处理

所以：

- `private_dot_zshrc` 对应 `~/.zshrc`
- `private_dot_config` 对应 `~/.config`
- `private_Library` 对应 `~/Library`

平时不用刻意记这些名字，优先使用：

```bash
chezmoi edit ~/.zshrc
chezmoi edit ~/.config/mise/config.toml
```

## 后续计划

后续可能会继续做这些事情：

- 增加 Windows 平台隔离配置
- 迁入更多编辑器配置
- 迁入更多 AI 工具配置
- 对机器差异引入模板变量

## License

这是个人 dotfiles 仓库。

如果你要复用，请先调整其中与账号、镜像源、字体、终端偏好相关的配置。
