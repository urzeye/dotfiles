#!/bin/bash

# 交互式模式的初始化脚本
# 如果是非交互式则退出，比如 bash test.sh 这种调用 bash 运行脚本时就不是交互式
# 只有直接敲 bash 进入的等待用户输入命令的那种模式才是交互式，才往下初始化
case "$-" in
*i*) ;;
*) return ;;
esac

# 防止被加载两次
if [ -z "$_INIT_SH_LOADED" ]; then
	_INIT_SH_LOADED=1
else
	return
fi

# 将个人 ~/.local/bin 目录加入 PATH
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

# 判断 ~/.local/etc/config.sh 存在的话，就执行
if [ -f "$HOME/.local/etc/config.sh" ]; then
	. "$HOME/.local/etc/config.sh"
fi

# 加载非交互模式下会使用的方法
if [ -f "$HOME/.local/etc/function.sh" ]; then
	. "$HOME/.local/etc/function.sh"
fi

# 如果是 bash/zsh 且为交互模式，执行interactive_function.sh
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
	# run script for interactive mode of bash/zsh
	if [[ $- == *i* ]]; then
		if [ -f "$HOME/.local/etc/interactive_function.sh" ]; then
			. "$HOME/.local/etc/interactive_function.sh"
		fi
	fi
fi

# 如果是登陆模式，执行login.sh
if [ -n "$BASH_VERSION" ]; then
	if shopt -q login_shell; then
		if [ -f "$HOME/.local/etc/login.sh" ]; then
			. "$HOME/.local/etc/login.sh"
		fi
	fi
fi

#### 第三方应用配置 ####
# 加载 bat 配置
if command -v bat >/dev/null 2>&1; then
	# 替换 cat 为 bat
	alias cat='bat --paging=never'
	if [ -n "$BASH_VERSION" ] && [ -f ~/.local/etc/.bat/bat.bash ]; then
		. ~/.local/etc/.bat/bat.bash
	elif [ -n "$ZSH_VERSION" ] && [ -f ~/.local/etc/.bat/bat.zsh ]; then
		. ~/.local/etc/.bat/bat.zsh
	elif [ -n "$FISH_VERSION" ] && [ -f ~/.local/etc/.bat/bat.fish ]; then
		. ~/.local/etc/.bat/bat.fish
	fi
fi

# 配置 diff-so-fancy
if command -v diff-so-fancy >/dev/null 2>&1; then
	git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
	git config --global interactive.diffFilter "diff-so-fancy --patch"

	git config --global color.ui true

	git config --global color.diff-highlight.oldNormal "red bold"
	git config --global color.diff-highlight.oldHighlight "red bold 52"
	git config --global color.diff-highlight.newNormal "green bold"
	git config --global color.diff-highlight.newHighlight "green bold 22"

	git config --global color.diff.meta "11"
	git config --global color.diff.frag "magenta bold"
	git config --global color.diff.func "146 bold"
	git config --global color.diff.commit "yellow bold"
	git config --global color.diff.old "red bold"
	git config --global color.diff.new "green bold"
	git config --global color.diff.whitespace "red reverse"

	# 和 diff 命令合用
	function d {
		diff -u $1 $2 | diff-so-fancy
	}
	export -f d
fi

# 加载 exa 配置
if command -v exa >/dev/null 2>&1; then
	if [ -n "$BASH_VERSION" ] && [ -f ~/.local/etc/.exa/exa.bash ]; then
		. ~/.local/etc/.exa/exa.bash
	elif [ -n "$ZSH_VERSION" ] && [ -f ~/.local/etc/.exa/exa.zsh ]; then
		. ~/.local/etc/.exa/exa.zsh
	elif [ -n "$FISH_VERSION" ] && [ -f ~/.local/etc/.exa/exa.fish ]; then
		. ~/.local/etc/.exa/exa.fish
	fi
fi

# 加载 fzf 配置
if command -v fzf >/dev/null 2>&1; then
	if [ -n "$BASH_VERSION" ] && [ -f ~/.local/etc/.fzf/fzf.bash ]; then
		. ~/.local/etc/.fzf/fzf.bash
	elif [ -n "$ZSH_VERSION" ] && [ -f ~/.local/etc/.fzf/fzf.zsh ]; then
		. ~/.local/etc/.fzf/fzf.zsh
	elif [ -n "$FISH_VERSION" ] && [ -f ~/.local/etc/.fzf/fzf.fish ]; then
		. ~/.local/etc/.fzf/fzf.fish
	fi
fi

# 启用 mcfly
if command -v mcfly >/dev/null 2>&1; then
	if [ -n "$BASH_VERSION" ]; then
		eval "$(mcfly init bash)"
	elif [ -n "$ZSH_VERSION" ]; then
		eval "$(mcfly init zsh)"
	elif [ -n "$FISH_VERSION" ]; then
		mcfly init fish | source
	fi
fi

# 加载 rg 配置
if command -v rg >/dev/null 2>&1; then
	if [ -n "$BASH_VERSION" ] && [ -f ~/.local/etc/.rg/rg.bash ]; then
		. ~/.local/etc/.rg/rg.bash
	elif [ -n "$FISH_VERSION" ] && [ -f ~/.local/etc/.rg/rg.fish ]; then
		. ~/.local/etc/.rg/rg.fish
	fi
fi

# z.lua
# 默认开启匹配增强模式
export _ZL_MATCH_MODE=1
if [ -n $BASH_VERSION ]; then
	eval "$(lua ~/.local/bin/z.lua --init bash echo fzf)"
elif [ -n $ZSH_VERSION ]; then
	eval "$(lua ~/.local/bin/z.lua --init zsh)"
elif [ "sh" == $(ps -p $$ -o cmd=,comm=,fname= 2>/dev/null | sed 's/^-//' | grep -oE '\w+' | head -n1)]; then
	eval "$(lua ~/.local/bin/z.lua --init posix echo fzf)"
fi

# 整理 PATH，删除重复路径
if [ -n "$PATH" ]; then
	old_PATH=$PATH:
	PATH=
	while [ -n "$old_PATH" ]; do
		x=${old_PATH%%:*}
		case $PATH: in
		*:"$x":*) ;;
		*) PATH=$PATH:$x ;;
		esac
		old_PATH=${old_PATH#*:}
	done
	PATH=${PATH#:}
	unset old_PATH x
fi
export PATH
