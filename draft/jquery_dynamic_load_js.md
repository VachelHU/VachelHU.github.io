# 使用jQuery动态加载js脚本文件的方法
### 1. 概论
动态加载Javascript是一项非常强大且有用的技术。这方面的主题在网上已经讨论了不少，我也经常会在一些个人项目上使用RequireJS和seajs加载js

它们很强大，但有时候也会得不偿失。如果你使用的是jQuery，它里面有一个内置的方法可以用来加载单个js文件。当你需要延迟加载一些js插件或其它类型的文件时，可以使用这个方法。下面就介绍一下如何使用它

### 2. jQuery getScript()方法加载JavaScript
jQuery内置了一个方法可以加载单一的js文件；当加载完成后你可以在回调函数里执行后续操作。最基本的使用jQuery.getScript的方法是这样：

    jQuery.getScript("/path/to/myscript.js", function(data, status, jqxhr) {
     /*
      做一些加载完成后需要执行的事情
     */
    });

这个getScript方法返回一个jqxhr，你可以像下面这样用它：

    jQuery.getScript("/path/to/myscript.js")
     .done(function() {
      /* 耶，没有问题，这里可以干点什么 */
     })
     .fail(function() {
      /* 靠，马上执行挽救操作 */
    });

最常见的使用jQuery.getScript的地方是延迟加载一个js插件，而且在加载完成时执行它：

    jQuery.getScript("jquery.cookie.js")
     .done(function() {
      jQuery.cookie("cookie_name", "value", { expires: 7 });
    });

### 3. 缓存问题
有一个非常重要的问题，使用jQuery.getScript时，你需要用一个时间戳字符串跟在需要加载的js地址后面，防止它被缓存。但是，如果你希望这个脚本被缓存，你需要设置全局缓存变量，像下面这样：

    jQuery.ajaxSetup({
      cache: true
    });

例子：

    jQuery.ajax({
          url: "jquery.cookie.js",
          dataType: "script",
          cache: true
    }).done(function() {
      jQuery.cookie("cookie_name", "value", { expires: 7 });
    });
