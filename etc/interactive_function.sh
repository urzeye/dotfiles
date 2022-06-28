# 本脚本中定义 交互式模式才可以使用的方法

# 对于高频使用的方法，提取成独立的文件，放在环境变量目录中，便于自动补全

function calc {
	if [ -n $1 ]; then
		# 计算方式
		rule=$1
		case $rule in
		# 求和
		sum) shift && echo $* | xargs -n1 | awk '{s+=$1} END {printf"%.0f\n", s}' ;;
		*) echo "暂不支持该计算方式" ;;
		esac
	else
		echo "参数缺失"
	fi
}
