#!/bin/bash
#
# 注意事项：
# 在 bootstrap.sh 中使用 . ./check_glibc_version.sh 的方式，将本脚本中的 check_glibc_version 方法共享到了 bootstrap.sh 中
# 然后在 bootstrap.sh 中调用其他脚本，其他脚本（子shell）就继承了 check_glibc_version 方法
# 在 子shell 中调用此方法，注意到此方法有一个外部传参，是在 子shell 中调用时传的
# 所以在脚本里，不要把 获取外部传参的指令写到 function 外面
# 那么写的话，在 bootstrap.sh 中加载方法时就执行了获取 $1 参数的指令，相当于传了一个空值，子shell再调用方法就不能给方法传参了

function check_glibc_version {
	print "当前应用依赖于glibc，进行glibc版本检查"
	need_version=$1
	current_version=$(ldd --version | head -n1 | awk '{print $4}')
	if [ 1 -ne "$(echo "${current_version} < ${need_version}" | bc)" ]; then
		print "当前 glibc 版本为${current_version}，无需更新"
	else
		warn "当前 glibc 版本为${current_version}，小于需要版本 ${need_version}，请更新glibc"
	fi
}

export -f check_glibc_version
