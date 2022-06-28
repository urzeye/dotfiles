# 执行本脚本，使用 source 方式，以使执行完后可以退出终端
sed -i "\:$ETC/init.sh:d" $HOME/.bashrc && rm -rf ~/.local/{bin,etc,dotfiles,download,man,script,tmp}
# find ~/.local/bin ! -name z.lua -type f -exec rm -f {} \;
rm -rf ~/.vim*
echo "清除配置完成"
exit
