## 特性

### 自动分页

`bat`会在一般情况下将大于屏幕可显示范围的内容输出到分页器(pager, e.g. `less`)。

你可以在调用时添加`--paging=never`参数来使`bat`不使用分页器（就像`cat`一样）。如果你想要用为`cat`使用`bat`别名，可以在 shell 配置文件（shell configuration）中添加`alias cat='bat --paging=never'`。

#### 智能输出

`bat`能够在设置了分页器选项的同时进行管道:wink:。
当`bat`检测到当前环境为非可交互终端或管道时（例如使用`bat`并将内容用管道输出到文件），`bat`会像`cat`一样，一次输出文件内容为纯文本且无视`--paging`参数。

## 如何使用

在终端中查看一个文件

```bash
> bat README.md
```

一次性展示多个文件

```bash
> bat src/*.rs
```

从`stdin`读入流，自动为内容添加语法高亮（前提是输入内容的语言可以被正确识别，通常根据内容第一行的 shebang 标记，形如`#!bin/sh`）

```bash
> curl -s https://sh.rustup.rs | bat
```

显式指定`stdin`输入的语言

```bash
> yaml2json .travis.yml | json_pp | bat -l json
```

显示不可打印字符

```bash
> bat -A /etc/hosts
```

与`cat`的兼容性

```bash
bat > note.md  # 创建一个空文件

bat header.md content.md footer.md > document.md

bat -n main.rs  # 只显示行号

bat f - g  # 输出 f，接着是标准输入流，最后 g
```

### 第三方工具交互

#### `fzf`

你可以使用`bat`作为`fzf`的预览器。这需要在`bat`后添加`--color=always`选项，以及`--line-range` 选项来限制大文件的加载次数。

```bash
fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'
```

更多信息请参阅[`fzf`的说明](https://github.com/junegunn/fzf#preview-window)。

#### `find` 或 `fd`

你可以使用`find`的`-exec`选项来用`bat`预览搜索结果：

```bash
find … -exec bat {} +
```

亦或者在用`fd`时添加`-X`/`--exec-batch`选项：

```bash
fd … -X bat
```

#### `ripgrep`

`bat`也能用`batgrep`来显示`ripgrep`的搜索结果。

```bash
batgrep needle src/
```

#### `tail -f`

当与`tail -f`一起使用，`bat`可以持续监视文件内容并为其添加语法高亮。

```bash
tail -f /var/log/pacman.log | bat --paging=never -l log
```

注意：这项功能需要在关闭分页时使用，同时要手动指定输入的内容语法（通过`-l log`）。

#### `git`

`bat`也能直接接受来自`git show`的输出并为其添加语法高亮（当然也需要手动指定语法）：

```bash
git show v0.6.0:src/main.rs | bat -l rs
```

#### `git diff`

`bat`也可以和`git diff`一起使用：

```bash
batdiff() {
    git diff --name-only --diff-filter=d | xargs bat --diff
}
```

该功能也作为一个独立工具提供，你可以在[`bat-extras`](https://github.com/eth-p/bat-extras)中找到`batdiff`。

如果你想了解更多 git 和 diff 的信息，参阅[`delta`](https://github.com/dandavison/delta)。

#### `xclip`

当需要拷贝文件内容时，行号以及 git 标记会影响输出，此时可以使用`-p`/`--plain`参数来把纯文本传递给`xclip`。

```bash
bat main.cpp | xclip
```

`bat`会检测输出是否是管道重定向来决定是否使用纯文本输出。

#### `man`

`bat`也能给`man`的输出上色。这需要设置`MANPAGER`环境变量：

```bash
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
man 2 select
```

（如果你使用的是 Debian 或者 Ubuntu，使用`batcat`替换`bat`）

如果你遇到格式化问题，设置`MANROFFOPT="-c"`也许会有帮助。

`batman`能提供类似功能——作为一个独立的命令。

注意：[man page 语法](assets/syntaxes/02_Extra/Manpage.sublime-syntax) 还需要完善。在使用特定的`man`实现时该功能[无法正常工作](https://github.com/sharkdp/bat/issues/1145)。

#### `prettier` / `shfmt` / `rustfmt`

`prettybat`脚本能够格式化代码并用`bat`输出
