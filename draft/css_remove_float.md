# CSS清除浮动
### 1. 浮动产生的原因
一般浮动是什么情况呢？一般是一个盒子里使用了CSS float浮动属性，导致父级对象盒子不能被撑开，这样CSS float浮动就产生了。
![](http://www.divcss5.com/uploads/allimg/130214/1_130214135727_1.png)

简单地说，浮动是因为使用了float:left或float:right或两者都是有了而产生的浮动。

### 2. 浮动产生的负作用
1. 背景不能显示
  + 由于浮动产生，如果对父级设置了（CSS background背景）CSS背景颜色或CSS背景图片，而父级不能被撑开，所以导致CSS背景不能显示。
2. 边框不能撑开
  + 如上图中，如果父级设置了CSS边框属性（css border），由于子级里使用了float属性，产生浮动，父级不能被撑开，导致边框不能随内容而被撑开。
3. margin padding设置值不能正确显示
  + 由于浮动导致父级子级之间设置了css padding、css margin属性的值不能正确表达。特别是上下边的padding和margin不能正确显示。

### 3. css解决浮动，清除浮动方法
假设了有三个盒子对象，一个父级里包含了两个子级，子级一个使用了float:left属性，另外一个子级使用float:right属性。同时设置div css border，父级css边框颜色为红色，两个子级边框颜色为蓝色；父级CSS背景样式为黄色，两个子级背景为白色；父级css width宽度为400px，两个子级css宽度均为180px，两个子级再设置相同高度100px，父级css height高度暂不设置（通常为实际css布局时候这样父级都不设置高度，而高度是随内容增加自适应高度）。

父级CSS命名为“.divcss5”对应html标签使用`<div class="divcss5">`
两个子级CSS命名分别为“.divcss5-left”“.divcss5-right”

    .divcss5{ width:400px; border:1px solid #F00; background:#FF0}
    .divcss5-left,.divcss5-right{ width:180px; height:100px;
     border:1px solid #00F; background:#FFF}
    .divcss5-left{ float:left}
    .divcss5-right{ float:right}

对应的HTML

    <div class="divcss5">
        <div class="divcss5-left">left浮动</div>
        <div class="divcss5-right">right浮动</div>
    </div>

![](http://www.divcss5.com/uploads/allimg/130214/1_130214135824_1.png)

清除方法如下：

1. **对父级设置适合CSS高度**
对父级设置适合高度样式清除浮动，这里对“.divcss5”设置一定高度即可，一般设置高度需要能确定内容高度才能设置。这里我们知道内容高度是100PX+上下边框为2px，这样具体父级高度为102px ![](http://www.divcss5.com/uploads/allimg/130214/1_130214135937_1.png)小结，使用设置高度样式，清除浮动产生，前提是对象内容高度要能确定并能计算好。
2. **clear:both清除浮动**
  + 为了统一样式，我们新建一个样式选择器CSS命名为“.clear”，并且对应选择器样式为“clear:both”，然后我们在父级“</div>”结束前加此div引入“class="clear"”样式。这样即可清除浮动。![](http://www.divcss5.com/uploads/allimg/130214/1_130214140203_1.png)这个css clear清除float产生浮动，可以不用对父级设置高度 也无需技术父级高度，方便适用，但会多加CSS和HTML标签。
3. **父级div定义 overflow:hidden**
  + 对父级CSS选择器加overflow:hidden样式，可以清除父级内使用float产生浮动。优点是可以很少CSS代码即可解决浮动产生。![](http://www.divcss5.com/uploads/allimg/130214/1_130214140301_1.png)为什么加入overflow:hidden即可清除浮动呢？那是因为overflow:hidden属性相当于是让父级紧贴内容，这样即可紧贴其对象内内容（包括使用float的div盒子），从而实现了清除浮动。
