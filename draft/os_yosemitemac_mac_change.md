# OS X 10.10 Yosemite 修改网卡 Mac 地址的方法
### 1.终端方式:
运行这个生成一个新的Mac 网卡地址
然后执行

`openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'`

断开Airport 无线网卡连接.

    sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -z

输入修改mac地址的命令

    sudo ifconfig en0 ether d4:33:a3:ed:f2:12

然后重连网卡即可.

    networksetup -detectnewhardware

### 2.wifi spoof软件
[下载地址](http://www.hackhome.com/XiaZai/SoftView_149182.html)
![](http://img2.hackhome.com/img2014//20149/2014091835239281.png)
