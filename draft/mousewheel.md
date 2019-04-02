# js中鼠标滚轮事件详解
### 各浏览器下兼容对比
1. 其中经我测试，IE/Opera属于同一类型，使用attachEvent即可添加滚轮事件。

    /*IE注册事件*/
    if(document.attachEvent){
    document.attachEvent('onmousewheel',scrollFunc);
    }

2. Firefox使用addEventListener添加滚轮事件

    /*Firefox注册事件*/
    if(document.addEventListener){
    document.addEventListener('DOMMouseScroll',scrollFunc,false);
    }

3. Safari与Chrome属于同一类型，可使用HTML DOM方式添加事件
window.onmousewheel=document.onmousewheel=scrollFunc;//IE/Opera/Chrome
其中除Firefox外其余均可使用HTML DOM方式添加事件，因此添加事件使用以下方式

    /*注册事件*/
    if(document.addEventListener){
    document.addEventListener('DOMMouseScroll',scrollFunc,false);
    }//W3C
    window.onmousewheel=document.onmousewheel=scrollFunc;//IE/Opera/Chrome

### detail与wheelDelta
判断滚轮向上或向下在浏览器中也要考虑兼容性，现在五大浏览器（IE、Opera、Safari、Firefox、Chrome）中Firefox 使用detail，其余四类使用wheelDelta；两者只在取值上不一致，代表含义一致，detail与wheelDelta只各取两个 值，detail只取±3，wheelDelta只取±120，其中正数表示为向上，负数表示向下。

    <p><label for="wheelDelta"> 滚动值:</label>(IE/Opera)<input type="text" id="wheelDelta" /></p>
    <p><label for="detail"> 滚动值:(Firefox)</label><input type="text" id="detail" /></p>

    <script type="text/javascript">
    var oTxt=document.getElementById("txt");
    var scrollFunc=function(e){
    var direct=0;
    e=e || window.event;
    var t1=document.getElementById("wheelDelta");
    var t2=document.getElementById("detail");
    if(e.wheelDelta){//IE/Opera/Chrome
    t1.value=e.wheelDelta;
    }else if(e.detail){//Firefox
    t2.value=e.detail;
    }
    ScrollText(direct);
    }
    /*注册事件*/
    if(document.addEventListener){
    document.addEventListener('DOMMouseScroll',scrollFunc,false);
    }//W3C
    window.onmousewheel=document.onmousewheel=scrollFunc;//IE/Opera/Chrome/Safari </script>

chrome

![](http://files.jb51.net/upload/2010-2/20100204102005716.png)

Firefox

![](http://files.jb51.net/upload/2010-2/20100204102005359.png)

IE(8)

![](http://files.jb51.net/upload/2010-2/20100204102009378.png)

IE(6)

![](http://files.jb51.net/upload/2010-2/20100204102009619.png)

Safari

![](http://files.jb51.net/upload/2010-2/20100204102009231.png)
