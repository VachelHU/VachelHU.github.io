# 使用python创建简单的HTTP和FTP服务
### 1. Python版HTTP服务器
闲话少说，首先确保装了Python，我装的是2.x版本，对了，我的操作系统是WIN7，其实对于Python来说，什么操作系统并不重要。Python内置了一个简单的HTTP服务器，只需要在命令行下面敲一行命令，一个HTTP服务器就起来了：

    python -m SimpleHTTPServer 80

后面的80端口是可选的，不填会采用缺省端口8000。注意，这会将当前所在的文件夹设置为默认的Web目录，试着在浏览器敲入本机地址：

    http://localhost:80

如果当前文件夹有index.html文件，会默认显示该文件，否则，会以文件列表的形式显示目录下所有文件。这样已经实现了最基本的文件分享的目的，你可以做成一个脚本，再建立一个快捷方式，就可以很方便的启动文件分享了。如果有更多需求，完全可以根据自己需要定制，具体的请参见官方文档[SimpleHTTPServer](http://docs.python.org/2/library/simplehttpserver.html)，或者直接看源码。我拷贝一段，方便参考：

    import SimpleHTTPServer
    import SocketServer

    PORT = 8000

    Handler = SimpleHTTPServer.SimpleHTTPRequestHandler

    httpd = SocketServer.TCPServer(("", PORT), Handler)

    print "serving at port", PORT
    httpd.serve_forever()

php5.4同样也提供了内置的web服务
如

    php -S localhost:8000

### 2. Python版FTP服务器
看到这里，默认你已经安装了Python，不过你还需要安装另外一个好用的工具。你知道，当需要找Chrome插件的时候，会去Google的WebStore；当需要找Firefox应用的时候，会去Mozilla的Add-ons；当你需要找Python组件的时候，你需要[pip:A tool for installing and managing Python packages](https://pypi.python.org/pypi/pip)，安装方法就不介绍了。

Python没有内置一个直接可以用的FTP服务器，所以需要第三方组件的支持，我找到的这个组件叫pyftpdlib，首先安装：

    pip install pyftpdlib

安装完后，和HTTP服器类似，执行以下命令就可以启动一个FTP服务器了：

    python -m pyftpdlib -p 21

后面的21端口依然是可选的，不填会随机一个，被占用的端口将跳过。在浏览器敲入本机地址：

    ftp://localhost:21

这时候，是匿名访问，也就是用户名是anonymous，密码为空，如果想要控制访问权限，你需要自己定制服务器，具体的可以参看[pyftpdlib Tutorial](https://code.google.com/p/pyftpdlib/wiki/Tutorial)，我这里拷贝过来一段作为介绍：

    from pyftpdlib.authorizers import DummyAuthorizer
    from pyftpdlib.handlers import FTPHandler
    from pyftpdlib.servers import FTPServer

    def main():
        # Instantiate a dummy authorizer for managing 'virtual' users
        authorizer = DummyAuthorizer()

        # Define a new user having full r/w permissions and a read-only
        # anonymous user
        authorizer.add_user('user', '12345', '.', perm='elradfmwM')
        authorizer.add_anonymous(os.getcwd())

        # Instantiate FTP handler class
        handler = FTPHandler
        handler.authorizer = authorizer

        # Define a customized banner (string returned when client connects)
        handler.banner = "pyftpdlib based ftpd ready."

        # Specify a masquerade address and the range of ports to use for
        # passive connections.  Decomment in case you're behind a NAT.
        #handler.masquerade_address = '151.25.42.11'
        #handler.passive_ports = range(60000, 65535)

        # Instantiate FTP server class and listen on 0.0.0.0:2121
        address = ('', 2121)
        server = FTPServer(address, handler)

        # set a limit for connections
        server.max_cons = 256
        server.max_cons_per_ip = 5

        # start ftp server
        server.serve_forever()

    if __name__ == '__main__':
        main()
        
cd 只看代码应该基本知道该怎么用了，add_user显然是添加用户，2121是指定端口，当然也可以随机，还有最大连接数max_cons，每个ip最大连接限制，更多的接口建议直接看docstrings。
