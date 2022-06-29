# 设置默认编辑器
if command -v nvim >/dev/null 2>&1; then
	alias vim=nvim
	export VISUAL=nvim
else
	export VISUAL=vim
fi
export EDITOR="$VISUAL"

# 设置时区
if [ -w /etc/localtime ]; then
	export TZ="Asia/Shanghai"
	echo "Asia/Shanghai" >/etc/timezone
	ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
fi

# 设置github代理
export GITHUB_PROXY=https://ghproxy.com/
export proxy=$GITHUB_PROXY

# for http proxy
export http_proxy=
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy
export ALL_PROXY=$http_proxy

alias proxyon="setproxy on; git config --global https.proxy $https_proxy; . ~/.local/etc/config.sh"
alias proxyoff="setproxy off; git config --global --unset https.proxy; . ~/.local/etc/config.sh"

# Alias for tree view of commit history.
if command -v git >/dev/null 2>&1; then
	git config --global alias.tree "log --all --graph --decorate=short --color --format=format:'%C(bold blue)%h%C(reset) %C(auto)%d%C(reset)\n         %C(blink yellow)[%cr]%C(reset)  %x09%C(white)%an: %s %C(reset)'"
fi

# 为 cp 加动画和时间
if [ -f ~/.local/bin/spiner ]; then
	alias cp='spiner cp'
fi

# 给 man 增加漂亮的色彩高亮
export LESS_TERMCAP_mb=$'\E[1m\E[32m'
export LESS_TERMCAP_mh=$'\E[2m'
export LESS_TERMCAP_mr=$'\E[7m'
export LESS_TERMCAP_md=$'\E[1m\E[36m'
export LESS_TERMCAP_ZW=""
export LESS_TERMCAP_us=$'\E[4m\E[1m\E[37m'
export LESS_TERMCAP_me=$'\E(B\E[m'
export LESS_TERMCAP_ue=$'\E[24m\E(B\E[m'
export LESS_TERMCAP_ZO=""
export LESS_TERMCAP_ZN=""
export LESS_TERMCAP_se=$'\E[27m\E(B\E[m'
export LESS_TERMCAP_ZV=""
export LESS_TERMCAP_so=$'\E[1m\E[33m\E[44m'
