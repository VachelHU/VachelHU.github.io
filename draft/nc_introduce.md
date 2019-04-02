# nc命令详解
### 概述
NetCat，在网络工具中有“瑞士军刀”美誉，其有Windows和Linux的版本。因为它短小精悍（1.84版本也不过25k，旧版本或缩减版甚至更小）、功能实用，被设计为一个简单、可靠的网络工具，可通过TCP或UDP协议传输读写数据。同时，它还是一个网络应用Debug分析器，因为它可以根据需要创建各种不同类型的网络连接。

### 常见使用
#### 1、远程拷贝文件
从server1拷贝文件到server2上。需要先在server2上，用nc激活监听，server2上运行：

引用

    [root@hatest2 tmp]# nc -lp 1234 > install.log

server1上运行：

引用

    [root@hatest1 ~]# ll install.log
    -rw-r--r--   1 root root 39693 12月 20   2007 install.log
    [root@hatest1 ~]# nc -w 1 192.168.228.222 1234 < install.log

#### 2、克隆硬盘或分区
操作与上面的拷贝是雷同的，只需要由dd获得硬盘或分区的数据，然后传输即可。
克隆硬盘或分区的操作，不应在已经mount的的系统上进行。所以，需要使用安装光盘引导后，进入拯救模式（或使用Knoppix工具光盘）启动系统后，在server2上进行类似的监听动作：


    # nc -l -p 1234 | dd of=/dev/sda

server1上执行传输，即可完成从server1克隆sda硬盘到server2的任务：


    # dd if=/dev/sda | nc 192.168.228.222 1234

#### 3、端口扫描
可以执行：

    # nc -v -w 1 192.168.228.222 -z 1-1000
    hatest2 [192.168.228.222] 22 (ssh) open

#### 4、保存Web页面

    # while true；
    # do nc -l -p 80 -q 1 < somepage.html; done

#### 5、模拟HTTP Headers

    [root@hatest1 ~]# nc www.linuxfly.org 80
    GET / HTTP/1.1
    Host: ispconfig.org
    Referrer: mypage.com
    User-Agent: my-browser

两次回车，可从对方获得HTTP Headers内容

    HTTP/1.1 200 OK
    Date: Tue, 16 Dec 2008 07:23:24 GMT
    Server: Apache/2.2.6 (Unix) DAV/2 mod_mono/1.2.1 mod_python/3.2.8 Python/2.4.3 mod_perl/2.0.2 Perl/v5.8.8
    Set-Cookie: PHPSESSID=bbadorbvie1gn037iih6lrdg50; path=/
    Expires: 0
    Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0
    Pragma: no-cache
    Cache-Control: private, post-check=0, pre-check=0, max-age=0
    Set-Cookie: oWn_sid=xRutAY; expires=Tue, 23-Dec-2008 07:23:24 GMT; path=/
    Vary: Accept-Encoding
    Transfer-Encoding: chunked
    Content-Type: text/html
    [......]

#### 6、聊天
nc还可以作为简单的字符下聊天工具使用，同样的，server2上需要启动监听：

    [root@hatest2 tmp]# nc -lp 1234

server1上传输：

    [root@hatest1 ~]# nc 192.168.228.222 1234

这样，双方就可以相互交流了。使用Ctrl+D正常退出。

#### 7、传输目录
从server1拷贝nginx-0.6.34目录内容到server2上。需要先在server2上，用nc激活监听，server2上运行：

    [root@hatest2 tmp]# nc -l 1234 |tar xzvf -

server1上运行：

    [root@hatest1 ~]# ll -d nginx-0.6.34
    drwxr-xr-x 8 1000 1000 4096 12-23 17:25 nginx-0.6.34
    [root@hatest1 ~]# tar czvf - nginx-0.6.34|nc 192.168.228.222 1234

### 参数简介
具体参照 `man nc` 中的说明
不同版本差异较大
