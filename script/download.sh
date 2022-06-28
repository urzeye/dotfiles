#!/bin/bash

export TMP=$HOME/.local/.tmp
export DOWNLOAD=$HOME/.local/download
export BIN=$HOME/.local/bin

PLAIN='\033[0m'
BOLD='\033[1m'

# 获取当前时间
function getTime {
	echo $(date "+%Y-%m-%d %H:%M:%S.%N" | cut -c 1-23)
}

function print {
	echo -e "\033[32m[$(getTime)] : $1\033[0m"
}
export -f getTime print

trap 'echo "子shell脚本执行异常，中途退出了"' ERR

clear
CHOICE=$(echo -e "\n${BOLD}=>请选择并输入你想下载的系统架构：${PLAIN}")
echo -e ' ❖   x86_64           1)'
echo -e ' ❖   arm              2)'
read -p $CHOICE -t 20 INPUT
case $INPUT in
1) export DOWNLOAD_ARCH=x86_64 ;;
2) export DOWNLOAD_ARCH=arm ;;
*) echo "输入有误" && exit 1 ;;
esac

# 切换工作目录
cd $TMP && print "切换工作目录到 $TMP"
# 循环下载
cp -f ~/.local/bin/configure_* .
for script in ./configure_*; do
	fileName=$(basename $script)
	print "即将下载 ${BOLD} ${fileName/configure_/} ${PLAIN}"
	./${fileName}
done

rm -rf $TMP/*
unset DOWNLOAD_ARCH
