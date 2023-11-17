#!/bin/bash

set -eE

#### 定义通用方法 ####
# 获取当前时间
function getTime {
	echo $(date "+%Y-%m-%d %H:%M:%S.%N" | cut -c 1-23)
}

# 格式化输出
function print {
	echo -e "\033[32m[$(getTime)] : $*\033[0m"
}

# 格式输出，warn
function warn {
	echo -e "\033[33m[$(getTime)] : $*\033[0m"
}

export -f getTime print warn

#### 定义仓库地址 ####
GITHUB_PROXY=https://mirror.ghproxy.com/
RESPOSITORY=https://github.com/urzeye/dotfiles.git

#### 定义目录 ####
# echo ~ 或 以 ~/ 开头的变量时，~会被直接替换成具体的 /home/user 或 /root
# 如果想输出 ~ 本身，需要使用 \ 转义
export BIN=$HOME/.local/bin
export ETC=$HOME/.local/etc
export MAN=$HOME/.local/man
export SCRIPT=$HOME/.local/script
export DOWNLOAD=$HOME/.local/download
export TMP=$HOME/.local/.tmp

# 异常退出则执行清理
# 子shell中的 异常退出 也会传递到父shell中
# 使用 ERR 时，source方式执行脚本（即相当于在当前shell中执行）返回的错误不会被捕获，只有子shell返回的错误会被捕获
# trap 'sed -i "\:$ETC/init.sh:d" $HOME/.bashrc && rm -rf {$ETC,$MAN,$SCRIPT,$DOWNLOAD,$TMP} && find $BIN ! -name z.lua -type f -exec rm -f {} \;' ERR
trap 'rv=$?; if [ "$rv" -ne 0 ]; then echo "发生错误，将执行清除指令"; source $SCRIPT/clear.sh || rm -rf {$ETC,$MAN,$SCRIPT,$DOWNLOAD,$TMP}; fi' EXIT

# 组合函数
function combine_function {
	configure_git
	create_dir
	clone_or_update
	operate_files
	append_to_bashrc
	load_env
	install_app
}

# git 配置
function configure_git {
	print "配置git信息"
	git config --global color.status auto
	git config --global color.diff auto
	git config --global color.branch auto
	git config --global color.interactive auto
	git config --global core.quotepath false
	git config --global core.autocrlf false
	git config --global https.proxy $GITHUB_PROXY
}

# 创建目录
function create_dir {
	print "创建目录"
	mkdir -p {$BIN,$DOWNLOAD,$ETC,$MAN,$SCRIPT,$TMP}
}

# 拉取仓库
function clone_or_update {
	print "拉取仓库"
	cd ~/.local/
	print "已切换到~/.local"

	# git clone respository
	if [ -d dotfiles ]; then
		print "~/.local/dotfiles目录存在，将直接更新"
		cd dotfiles
		# if git pull >/dev/null 2>&1; then
		# 	print "git pull 更新"
		# else
		# 	# 强制覆盖本地代码
		# 	git fetch && git reset --hard HEAD && git merge origin/main
		# 	print "git reset --hard 强制回退再更新"
		# fi
		git pull
	else
		print "~/.local/dotfiles目录不存在，将从${RESPOSITORY}拉取"
		git clone ${GITHUB_PROXY}${RESPOSITORY}
		cd dotfiles
	fi
}

# 处理文件
function operate_files {
	cd ~/.local/dotfiles
	print "当前工作目录：$PWD"
	# 转化为unix格式
	# find . -type f -name "*sh" -exec dos2unix -q {} \;
	find . -type f -exec sed -i 's/\r$//g' {} \;

	print "复制文件中..."
	cp -rf {bin,etc,man,script} $(dirname $BIN)
	cp -rf bootstrap.sh $BIN/
	print "复制完成"

	# 可执行文件赋权
	find {$BIN,$ETC,$SCRIPT} -type f -exec chmod +x {} \;
}

# 添加到bashrc后
function append_to_bashrc {
	[ -f ~/.bashrc ] || touch ~/.bashrc
	print "添加init.sh内容到~/.bashrc中"
	sed -i "\:$ETC/init.sh:d" ~/.bashrc
	echo ". $ETC/init.sh" >>~/.bashrc
	. ~/.bashrc
}

# 加载需要的环境变量（包括方法）
function load_env {
	print "加载环境变量和方法"
	cd $SCRIPT
	. ./check_glibc_version.sh
	cd $ETC
	. ./function.sh
}

# 安装应用
function install_app {
	cd $BIN && print "切换工作目录到 $BIN"
	# source vimrc.vim
	print "配置vim"
	cp -rf --remove-destination ~/.local/etc/.vim* ~/
	if ! command -v vim >/dev/null 2>&1; then
		print "vim未安装，将安装vim"
		source install_vim
	fi

	# 配置bat
	print "配置bat"
	if ! command -v bat >/dev/null 2>&1; then
		print "bat未安装，将安装bat"
		./configure_bat
	fi

	# 配置diff-so-fancy
	print "配置diff-so-fancy"
	if ! command -v diff-so-fancy >/dev/null 2>&1; then
		print "diff-so-fancy未安装，将安装diff-so-fancy"
		./configure_diff-so-fancy
	fi

	# 配置exa
	print "配置exa"
	if ! command -v exa >/dev/null 2>&1; then
		print "exa未安装，将安装exa"
		./configure_exa
	fi

	# 配置fd
	print "配置fd"
	if ! command -v fd >/dev/null 2>&1; then
		print "fd未安装，将安装fd"
		# 这里使用 ./子脚本 的方式执行，子shell共享父shell的环境变量，但子shell的环境变量不会影响到父shell
		# . ./子脚本，父子shell环境变量完全共享，父shell中可以获取到子shell的环境变量
		# exec ./子脚本，相当于将接下来要执行的进程下文进行了替换，直接用子脚本中的内容替换了原来的进程内容，同时会继承之前的环境变量，原来的执行内容相当于不存在了，直接执行完此子脚本，整个流程就结束了，父脚本剩余内容不会继续执行
		./configure_fd
	fi

	# 配置fzf
	print "配置fzf"
	if ! command -v fzf >/dev/null 2>&1; then
		print "fzf未安装，将安装fzf"
		./configure_fzf
	fi

	# 配置mcfly
	print "配置mcfly"
	if ! command -v mcfly >/dev/null 2>&1; then
		print "mcfly未安装，将安装mcfly"
		./configure_mcfly
	fi

	# 配置ripgrep
	print "配置ripgrep"
	if ! command -v rg >/dev/null 2>&1; then
		print "ripgrep未安装，将安装ripgrep"
		./configure_rg
	fi
}

combine_function
print "all over."
