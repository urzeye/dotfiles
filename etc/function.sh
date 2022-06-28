# 非交互式也能使用的方法

########## 终端输出颜色设置 ##########
export RED='\033[31m'
export GREEN='\033[32m'
export YELLOW='\033[33m'
export BLUE='\033[34m'
export PLAIN='\033[0m'
export BOLD='\033[1m'
export SUCCESS='[\033[32mOK\033[0m]'
export COMPLETE='[\033[32mDONE\033[0m]'
export WARN='[\033[33mWARN\033[0m]'
export ERROR='[\033[31mERROR\033[0m]'
export WORKING='[\033[34m*\033[0m]'

########## 需要在 非交互模式中使用的函数 ##########
# 判断当前shell
function getShell {
	ps -p $$ -o cmd=,comm=,fname= 2>/dev/null | sed 's/^-//' | grep -oE '\w+' | head -n1
}

# 获取当前时间
function getTime {
	echo $(date "+%Y-%m-%d %H:%M:%S.%N" | cut -c 1-23)
}

# 格式输出，info
function print {
	echo -e "$GREEN[$(getTime)] : $*$PLAIN"
}

# 格式输出，warn
function warn {
	echo -e "$YELLOW[$(getTime)] : $*$PLAIN"
}

# 格式输出，error
function error {
	echo -e "$RED[$(getTime)] : $*$PLAIN"
}

# 最常见的 sh demo.sh，是 非交互模式 且 没有 --login 参数，脚本中只能读取 系统环境变量，即 env
# 设置为环境变量
export -f getShell getTime print warn error
