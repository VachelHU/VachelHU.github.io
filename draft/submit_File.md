# 文件提交方式总结
### 概论
最近在公司里面做一个图片上传的部分，涉及到多种提交文件到后台的方式，比较杂比较乱，总结一下多种提交文件的方式，方便学习。

### 一次性上传一个文件

### 一次性上传多个文件
input标签中使用multiples属性，可以让用户一次性选择多个文件上传，dom中的值的files属性下我们可以得到的是Filelist一个类数组，对其操作用`for...in...`不合适，会输出“0,1,2..length,..”,对于这个对象，可以被prototype增加属性进去，是极大的漏洞。所以好的方式如下：

    var files = ipt[0].files;
    var type = files[x].name.match(reg);
    var req = {
        obj: 1,
        mtl: 1,
        png: 1
    };

    var reg = /\.(png|obj|mtl)$/;

    [].forEach.call(files,function(file) {
        var type = file.name.match(reg);
        if(type && type[1]) {
            delete req[type[1]];
        }
    });

注

1. jquery[0]转换为原始的dom，用files属性获取到多个文件，注意，不能使用val，只获取到第一个值
2. `[].slice.call`的方式，将类数组强转成数组进行forEach处理
3. 多个匹配，用`|`来分割
4. `match()`方法用来正则匹配并输出匹配值，`test()`方法匹配只返回boolen值
5. req的定义，多个同文件的类型，数字依次减小，代表上传了一个文件，方便判断
