# js中的top、parent、frame
### 引用方法top：
该变量永远指分割窗口最高层次的浏览器窗口。如果计划从分割窗口的最高层次开始执行命令，就可以用top变量。

分割窗口指:frameset或者iframe中。

### opener
opener用于在window.open的页面引用执行该window.open方法的的页面的对象。

例如：A页面通过window.open()方法弹出了B页面，在B页面中就可以通过opener来引用A页面，这样就可以通过这个对象来对A页面进行操作。

### parent：
   该变量指的是包含当前分割窗口的父窗口。如果在一个窗口内有分割窗口，而在其中一个分割窗口中又包含着分割窗口，则第2层的分割窗口可以用parent变量引用包含它的父分割窗口。

附：Window对象、Parent对象、Frame对象、Document对象和Form对象的阶层关系
`Windwo对象→Parent对象→Frame对象→Document对象→Form对象`

如下：

    parent.frame1.document.forms[0].elements[0].value;


在JS中：
`window.location(window.location.href)`和`window.top.location(window.top.location.href)`是一样的意思

可以通过top来调用任何一个frame,因为top指的是最外层的frameset，可以调用它里面的任何一个子元素frame。

如：top.outterFrame1.location和top.innerFrame2.location等。

parent指的是当前窗口（frame）的父窗口(frameset)可以调用它里面的任何一个子元素frame。

如：parent.innerFrame1.location和parent.innerFrame2.location等。

     <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>无标题文档</title>
    <script type="text/javascript">
    window.location="http://www.baidu.com";
    </script>
    </head>
    <frameset rows="150,*,150" cols="*">
    <frame src="a.html" id="outerFrame1"/>
    <frameset cols="150,*" cols="*">
    <frame src="a.html" id="innerFrame1"/>
    <frame src="a.html" id="innerFrame2"/>
    </frameset><noframes></noframes>
    <frame  src="a.html" id="outerFrame2"/>
    </frameset>
    <body>
    </body>
    </html>

假设在上面例子中在a.html页面中使用以下两种方式都可以去除框架重新转向页面.

    window.top.location='http://www.xhtdo.com'; //去除框架重新转向页面
    window.parent.location='http://www.xhtdo.com' //指定当前页面的父页面的专项路径.

在a.html页面中也可以用top或parent来控制其他frame的页面转向如:

    window.top.outerFrame1.location='http://www.xhtdo.com';
    window.parent.outerFrame1.location='http://www.xhtdo.com';

### self
指的是当前窗口

### parent与opener的区别：
1. parent指父窗口，在FRAMESET中，FRAME的PARENT就是FRAMESET窗口。
2. opener指用WINDOW.OPEN等方式创建的新窗口对应的原窗口。
3. parent是相对于框架来说父窗口对象
4. opener是针对于用window.open打开的窗口来说的父窗口，前提是window.open打开的才有
5. document.parentWindow.menthod()調用父頁面的方法
