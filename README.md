# dotfiles

这是我的个人 dotfiles 仓库，使用 `chezmoi` 管理配置文件，使用 `mise`
管理运行时、命令行工具和一键 setup 流程，目前主要面向 macOS。

这套方案的目标很明确：

1. 用 `chezmoi` 管文件
2. 用 `git` 管历史和同步
3. 用 `mise` 管工具安装和初始化流程

也就是说，这个仓库不是单纯“备份几个配置文件”，而是一套可以在新机器上快速落地的个人开发环境。

远程仓库地址：

```text
https://github.com/urzeye/dotfiles.git
```

## 整体设计

### `chezmoi` 负责什么

`chezmoi` 是这套方案里的“配置文件管理器”。

它负责把仓库中的源文件同步到真实系统路径，例如：

- `~/.zshrc`
- `~/.config/mise/config.toml`
- `~/.config/zsh/shell.zsh`
- `~/.config/starship.toml`
- `~/.config/ghostty/config`
- `~/Library/Application Support/lazygit/config.yml`

你可以把它理解为：

- `git` 负责版本历史
- `chezmoi` 负责“这些文件最终应该落到系统哪里”

### `mise` 负责什么

`mise` 在这里不再负责生成一大堆配置文件，而是专注做两件事：

- 安装运行时和命令行工具
- 提供统一的 setup 编排入口

当前主入口命令是：

```bash
mise run -o keep-order setup
```

这个 setup 会依次完成：

- 安装 `mise` 工具链
- 安装 Homebrew 应用、字体和 Zsh 插件
- 应用 `chezmoi` 管理的 dotfiles
- 校验 Ghostty 配置
- 安装 AI CLI 工具链
- 刷新 `.zshrc` 中由 `mise` 托管的初始化区块

### `git` 负责什么

`git` 只负责版本管理和远程同步。

也就是说：

- `chezmoi` 解决“文件怎么部署”
- `mise` 解决“工具怎么安装”
- `git` 解决“配置怎么追踪和同步”

这三者职责分离后，长期维护会轻松很多。

## 当前管理范围

目前这个仓库主要覆盖 macOS 下的终端和开发环境配置。

已经纳入管理的内容包括：

- Zsh 启动与 shell 增强
- `mise` 运行时和 setup 流程
- Starship prompt
- Ghostty 配置
- Lazygit 配置

目前还没有完全迁入的内容包括：

- Windows 专属配置
- Linux 专属配置
- Vim / Neovim 配置
- 更多编辑器配置
- 更多 AI 工具配置

## 仓库结构说明

### 为什么目录里会出现 `private_dot_config`、`private_Library`

`chezmoi` 的源目录不是简单地 1:1 映射你的家目录，而是使用一套“编码后的源文件名”来表示：

- 目标路径
- 文件属性

例如当前仓库里这些文件：

- `private_dot_zshrc`
- `private_dot_config/mise/config.toml`
- `private_dot_config/zsh/shell.zsh`
- `private_dot_config/starship.toml`
- `private_dot_config/ghostty/config`
- `private_Library/private_Application Support/lazygit/config.yml`

它们分别对应真实系统路径：

- `~/.zshrc`
- `~/.config/mise/config.toml`
- `~/.config/zsh/shell.zsh`
- `~/.config/starship.toml`
- `~/.config/ghostty/config`
- `~/Library/Application Support/lazygit/config.yml`

这套命名的核心规则是：

- `dot_`：表示目标路径名以 `.` 开头
- `private_`：表示目标文件/目录应按私有权限处理

所以：

- `dot_config` 表示 `.config`
- `private_dot_config` 表示“私有的 `.config`”
- `private_dot_zshrc` 表示“私有的 `.zshrc`”

这不是额外多包了一层目录，而是 `chezmoi` 的源状态命名规则。

### 平时如何避免被这些名字干扰

最推荐的做法不是直接记住这些编码名，而是始终按“真实路径”去操作：

```bash
chezmoi edit ~/.zshrc
chezmoi edit ~/.config/mise/config.toml
chezmoi edit ~/.config/zsh/shell.zsh
chezmoi edit ~/.config/starship.toml
```

或者直接进入源目录：

```bash
chezmoi cd
```

## 首次初始化

### macOS

先安装最基础的引导工具：

```bash
brew install chezmoi mise
```

然后从远程仓库初始化并应用配置：

```bash
chezmoi init --apply https://github.com/urzeye/dotfiles.git
```

接着执行完整 setup：

```bash
cd ~/.config/mise
mise run -o keep-order setup
```

如果当前终端没有立刻加载新配置，再执行：

```bash
source ~/.zshrc
```

### 当前 setup 的假设前提

当前仓库的 `setup` 主要面向 macOS，因此默认假设：

- 系统已经安装 Homebrew
- 可以使用 `brew install` 和 `brew install --cask`
- 允许安装 Ghostty、VS Code、字体和 Zsh 插件

## 日常使用

### 查看 `chezmoi` 当前管理了哪些文件

```bash
chezmoi managed
```

### 编辑受管文件

推荐使用：

```bash
chezmoi edit ~/.zshrc
chezmoi edit ~/.config/mise/config.toml
chezmoi edit ~/.config/zsh/shell.zsh
chezmoi edit ~/.config/starship.toml
chezmoi edit ~/.config/ghostty/config
```

### 预览变更

```bash
chezmoi diff
```

### 应用变更

```bash
chezmoi apply
```

### 把一个现有文件加入 `chezmoi`

```bash
chezmoi add ~/.some/file
```

### 进入 `chezmoi` 源目录

```bash
chezmoi cd
```

## 更新已有机器

如果已经在另一台机器上初始化过这个仓库，日常同步通常是：

```bash
chezmoi update
cd ~/.config/mise
mise run -o keep-order setup
source ~/.zshrc
```

如果你只是改了几个配置文件，并没有新增工具安装需求，通常直接：

```bash
chezmoi apply
source ~/.zshrc
```

就够了。

## Shell 配置设计

### `~/.zshrc`

`~/.zshrc` 现在刻意保持很薄，只负责初始化流程，不承载大量 alias 和函数。

当前它主要负责：

- `mise activate zsh`
- 加载 `~/.config/zsh/shell.zsh`
- 初始化 `zoxide`
- 初始化 `starship`
- 加载 `zsh-autosuggestions`
- 加载 `zsh-syntax-highlighting`

这样做的好处是：

- `.zshrc` 结构稳定
- 复杂 shell 逻辑集中在单独文件里
- 迁移和维护更容易

### `~/.config/zsh/shell.zsh`

这是当前 shell 的主配置文件，内部按区块组织为三部分：

1. 环境变量
2. alias
3. function

其中包含一些高频工具和函数，例如：

- `mr`：更适合阅读的 `mise run`
- `lg`：打开 Lazygit
- `fe`：模糊搜索文件并打开
- `fcd`：模糊搜索目录并进入
- `fkill`：模糊选择进程后结束
- `fgh`：预览并查看 Git 提交
- `fco`：模糊搜索并切换 Git 分支
- `wx`：文件变化时自动重跑命令
- `wxe`：按扩展名监听并自动重跑命令

同时，FZF 的默认行为也在这里统一配置，避免在大型仓库里因为 `node_modules`、`dist`、`.venv` 等目录导致搜索过慢。

## Prompt / 终端 / Git UI 配置

### Starship

文件：

```text
~/.config/starship.toml
```

当前 Starship 的设计重点是：

- 两行式 prompt
- 显示目录、Git 状态
- 显示 Python / Node.js / Go / Java / Rust / package 版本
- 显示命令耗时

整体目标是：信息密度高，但不挤。

### Ghostty

文件：

```text
~/.config/ghostty/config
```

当前配置包括：

- `JetBrainsMono Nerd Font`
- `Catppuccin Mocha` 主题
- 半透明背景
- 背景模糊
- block cursor
- split 快捷键和 split 导航快捷键

在 setup 阶段会自动校验配置：

```bash
ghostty +validate-config
```

### Lazygit

文件：

```text
~/Library/Application Support/lazygit/config.yml
```

当前配置重点包括：

- 图标显示
- 圆角边框
- 使用 `delta` 作为 pager
- 使用 VS Code 打开文件

## `mise` 配置设计

核心文件：

```text
~/.config/mise/config.toml
```

当前它主要承担以下职责：

- 管理 Go / Java / Node.js / Python / Rust 等运行时
- 管理 `fd`、`fzf`、`ripgrep`、`bat`、`eza`、`jq`、`gh`、`delta`、`watchexec` 等 CLI 工具
- 设置常用镜像源和环境变量
- 提供统一 setup 流程

当前 setup 子任务包括：

- `setup:tools`
- `setup:apps`
- `setup:git`
- `setup:config`
- `setup:ghostty`
- `setup:ai`
- `setup:shell`

这样拆分的好处是：

- 保持 `mise run setup` 这个统一入口
- 每个任务职责更清晰
- 出问题时更容易定位

## 为什么 `mise` 和 `chezmoi` 要同时存在

因为它们解决的是不同层面的问题。

### `chezmoi` 擅长

- 管“文件内容”
- 管“文件应该落到哪里”
- 管“文件权限和模板化”

### `mise` 擅长

- 管“运行时版本”
- 管“CLI 工具安装”
- 管“任务编排”
- 管“环境变量”

如果只用其中一个去做全部事情，通常会越来越混乱。

当前这套分工的核心思想是：

- 配置文件尽量是正常文件，交给 `chezmoi`
- 安装逻辑和 setup 流程交给 `mise`
- 历史和同步交给 `git`

## 关于 trust

因为这个仓库里也包含一份受 `chezmoi` 管理的 `mise` 配置：

```text
~/.config/mise/config.toml
```

所以当你进入 `chezmoi` 源目录时，`mise` 有时会把源目录中的那份配置也识别为配置来源，并要求信任。

如果遇到这种情况，可以执行一次：

```bash
mise trust ~/.local/share/chezmoi/private_dot_config/mise/config.toml
```

信任一次之后，后续在源目录里工作通常就不会再报这个错误。

## 常用命令备忘

### 首次部署

```bash
chezmoi init --apply https://github.com/urzeye/dotfiles.git
cd ~/.config/mise
mise run -o keep-order setup
source ~/.zshrc
```

### 日常修改配置

```bash
chezmoi edit ~/.config/zsh/shell.zsh
chezmoi apply
source ~/.zshrc
```

### 推送到远程仓库

```bash
chezmoi cd
git status
git add .
git commit -m "chore: update dotfiles"
git push
```

## 后续计划

后续大概率会继续做这些事情：

- 增加 Windows 平台隔离配置
- 把更多编辑器配置迁入 `chezmoi`
- 把更多 AI 工具配置迁入 `chezmoi`
- 对机器差异引入模板变量或外部数据
- 补一个更顺手的一键 bootstrap 脚本

## License

这是个人 dotfiles 仓库。

如果你想复用，请优先修改其中与机器、账号、镜像源、字体、终端偏好相关的配置，再应用到自己的环境里。
