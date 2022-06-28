#!/bin/bash
# 升级 glibc 版本
# 升级有风险，请做好备份
# 查看glibc版本：ldd --version | head -n1 | awk '{print $4}'
# ll /lib64/libc.so.6，升级后应该链接到 libc-2.18.so 上
# 失败后可利用下面命令恢复: ldconfig -lv /lib64/libc-2.17.so

set -e

# 官网：http://ftp.gnu.org/gnu/glibc/
# 直接科学上网下载更快
version=2.18
# wget -O http://ftp.gnu.org/gnu/glibc/glibc-${version}.tar.gz | tar zxf -

# bc执行的结果：1表示判断条件成立，0表示判断条件不成立
current_version=$(ldd --version | head -n1 | awk '{print $4}')
if [ 1 -ne "$(echo "${current_version} < ${version}" | bc)" ]; then
	print "当前 glibc 版本为${current_version}，无需更新"
	exit 0
fi

warn "开始更新 glibc，危险操作！"
url=https://github.com/urzeye/files/raw/main/lib/glibc-2.18.tar.gz
wget -O ${GITHUB_PROXY}${url} | tar zxf -
print "下载解压完成"
cd glibc-*/ && mkdir build && cd build
../configure --prefix=/usr
print "开始编译 glibc v${version}"
make -j2
make install
cd ../.. && rm -rf glibc-*
print "glibc 成功升级为 v${version}"
