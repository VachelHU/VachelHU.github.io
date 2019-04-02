# 快捷操作大全
### windows
1. hosts
  + 首先你要用管理员身份打开文本编辑器, 方法是在编辑器的图标上右click, 然后选用administrator(管理员)身份打开
  + 在文本编辑器上打开windows 目录下的 system32/drivers/etc/hosts 文件, 修改后储存就可以
2. Ctrl快捷组合键
  + ctrl+A 全选
  + ctrl+F 查询
  + ctrl+O 打开
  + ctrl+W 关闭
  + mac中用command
3. 分区合并
  + 打开cmd
  + 输入 `dispart`，回车，进入dispart交互环境
  + 输入 `lis dis`，显示所有磁盘
  + 输入 `sel dis 1`，选择磁盘1
  + 输入 `clean`，删除所有分区
  + 输入 `create partition primary`，创建分区
  + 输入 `active`，激活
  + 输入 `format fs=fat32 quick`，格式化成Fat32格式，当然可以选择其他格式
  + 输入 `exit`，退出


### mac
1. iterm
  + command+D 竖分屏
  + command+shift+D 横分屏
2. hosts
  + 在/private/etc目录下，用sudo vim修改
  + 或者在Finder中前往这个目录，修改（要权限）
3. 截屏
  + 用shift+command+3/4 全截屏/部分截屏
  + 修改截图的存放位置
    + defaults write com.apple.screencapture location /path/（**/path/** 为你想保存的路径）
    + killall SystemUIServer
    + 修改截图的格式：
      + defaults write com.apple.screencapture type jpg
4. 命令行命令工具
  + 打开 ~/.bash_profie,里面的export目录下的路径，将启动文件放入对应的目录下即可
  + 如，将subl放入：`ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /user/local/bin`
5. 编辑器组合键
  + command+x 删除整行
  + shift+ctrl+m Atom运行markdown preview
  + shift+tab 删除缩进
6. chrome
  + command+shift+N 打开隐藏窗口
7. unix 网络命令
  + nc
  + netstat
  + curl
  + nmap
