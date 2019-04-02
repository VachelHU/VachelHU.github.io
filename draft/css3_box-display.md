# CSS3盒模型display:box详解
### 1. 概述
`display:box;box-flex`是css3新添加的盒子模型属性，它的出现可以解决我们通过N多结构、css实现的布局方式。经典的一个布局应用就是布局的垂直等高、水平均分、按比例划分。

目前box-flex属性还没有得到firefox、Opera、chrome浏览器的完全支持，但可以使用它们的私有属性定义firefox(-moz-)、opera(-o-)、chrome/safari（-webkit-)。

### 2. box-flex属性
box-flex主要让子容器针对父容器的宽度按一定规则进行划分

html代码：

    <article>;
        <section>01</section>
        <section>02</section>
        <section>03</section>
    </article>

CSS代码：

    .wrap{
        width:600px;
        height:200px;
        display:-moz-box;
        display:-webkit-box;
        display:box;
    }
    .sectionOne{
        background:orange;
        -moz-box-flex:3;
        -webkit-box-flex:3;
        box-flex:3;
    }
    .sectionTwo{
        background:purple;
        -moz-box-flex:2;
        -webkit-box-flex:2;
        box-flex:2;
    }
    .sectionThree{
        -moz-box-flex:1;
        -webkit-box-flex:1;
        box-flex:1;
        background:green;
    }

展示效果：
![](http://img.warting.com/allimg/2014/0225/1503325J8-0.jpg)
说明：

必须给父容器wrap定义css属性`display:box`其子容器才可以进行划分(如果定了display:box则该容器则定义为了内联元素，**使用margin:0px auto让其居中是无效的，要想使其居中只能通过它的父容器的text-align:center**);

分别给sectionOne、sectionTwo、sectionThree的box-flex设置了3、2、1，也就是说这三个子容器将父容器wrap的宽度600px分为6份，sectionOne占居父结构宽度的3/6即300px，sectionOne占居父结构宽度的2/6即200px，sectionThree占居父结构宽度的1/6即100px。

以上是按比例数进行划分分配的，如果其中一个子容器或多个子容器设置了固定宽度又会怎样划分那？

如果其中一个子容器或多个子容器设置了固定宽度，其它子容器没有设置，其计算方式是这样的：子容器如果设置了固定宽度值，该子容器则直接应用设置的宽度值，其它没有设置的则再父容器的宽度基础上减去子容器设置的固定宽度，在剩下的宽度基础上按一定比例进行划分分配。请看下面代码:

    .wrap{
        width:600px;
        height:200px;
        display:-moz-box;
        display:-webkit-box;
        display:box;
    }
    .sectionOne{
        background:orange;
        -moz-box-flex:3;
        -webkit-box-flex:3;
        box-flex:3;
    }
    .sectionTwo{
        background:purple;
        -moz-box-flex:1;
        -webkit-box-flex:1;
        box-flex:1;
    }
    .sectionThree{
        width:200px;//设置固定宽度
        background:green;
    }

展示效果：
![](http://img.warting.com/allimg/2014/0225/150332D00-1.jpg)
说明：

sectionThree设置了固定宽度为200px，父容器的宽度600px减去改子容器的200px还剩下400px，这400px宽度值则按box-flex设置的值进行划分，sectionOne占居3/4即300px,sectionTwo占居1/4即100px。

在以上代码的基础上给sectionTwo子容器添加margin:0px 50px使子容器之间产生一定的间隔其宽度又如何进行分配划分的那？接着看

    .wrap{
        width:600px;
        height:200px;
        display:-moz-box;
        display:-webkit-box;
        display:box;
    }
    .sectionOne{
        background:orange;
        -moz-box-flex:3;
        -webkit-box-flex:3;
        box-flex:3;
    }
    .sectionTwo{
        background:purple;
        -moz-box-flex:1;
        -webkit-box-flex:1;
        box-flex:1;
            margin:0px 50px;//添加margin属性
    }
    .sectionThree{
        width:200px;
        background:green;
    }

展示效果：
![](http://img.warting.com/allimg/2014/0225/1503323214-2.jpg)
说明：

父容器的宽度600px减去设置了子容器的200px基础上再减去100px(2×50)剩下300px，这300px宽度值则按box-flex设置的值进行划分，sectionOne占居3/4即225px,sectionTwo占居1/4即75px。

### 3. box属性
上面”css3弹性盒子模型之box-flex”将box-flex如何对父容器的宽度进行划分分配讲解完毕，下面在看一下父容器里面的box属性包括哪些box属性，具体属性如下代码所示：
`box-orient | box-direction | box-align | box-pack | box-lines`

**1、box-orient**

box-orient(orient译为排列更准确)用来确定父容器里子容器的排列方式，是水平还是垂直。可选属性如下所示：

`horizontal | vertical | inline-axis | block-axis | inherit`

horizontal、inline-axis说明：

>给box设置horizontal或inline-axis属性其效果似乎表现一致，都可将子容器水平排列，具体两者有什么实质差别暂时还没有搞清楚。如果父容器选择horizontal或inline-axis属性对子容器进行水平排列，其是对父容器的宽度进行分配划分。**此时如果父容器定义了高度值，其子容器的高度值设置则无效状态，所有子容器的高度等于父容器的高度值；如果父容器不设置高度值，其子容器的高度值才有效并且取最大高度值的子容器的高度。**


    .wrap{
    	width:600px;
    	height:200px;
    	display:-moz-box;
    	display:-webkit-box;
    	display:box;
    	-moz-box-orient:horizontal;
    	-webkit-box-orient:horizontal;
    	box-orient:horizontal;//水平排列
    }
    .sectionOne{
    	background:orange;
    	-moz-box-flex:1;
    	-webkit-box-flex:1;
    	box-flex:1;
    }
    .sectionTwo{
    	background:purple;
    	-moz-box-flex:2;
    	-webkit-box-flex:2;
    	box-flex:2;
    }
    .sectionThree{
    	width:100px;
    	background:green;
    }

![](http://img.warting.com/allimg/2014/0225/1503324118-3.jpg)
vertical、block-axis说明：

>给box设置vertical或block-axis属性(此属性是默认值)其效果似乎表现一致，都可将子容器垂直排列，具体两者有什么实质差别暂时还没有搞清楚。如果父容器选择vertical或block-axis属性对子容器进行垂直排列，其是对父容器的高度进行分配划分。**此时如果父容器定义了宽度值，其子容器的宽度值设置则无效状态；如果父容器不设置宽度值，其子容器的宽度值才有效并且取最大宽度值的子容器的宽度。**


    .wrap{
    	width:600px;
    	height:200px;
    	display:-moz-box;
    	display:-webkit-box;
    	display:box;
    	-moz-box-orient:vertical;
    	-webkit-box-orient:vertical;
    	box-orient:vertical;//垂直排列
    }
    .sectionOne{
    	background:orange;
    	-moz-box-flex:1;
    	-webkit-box-flex:1;
    	box-flex:1;
    }
    .sectionTwo{
    	background:purple;
    	-moz-box-flex:2;
    	-webkit-box-flex:2;
    	box-flex:2;
    }
    .sectionThree{
    	height:100px;
    	background:green;
    }

展示效果
![](http://img.warting.com/allimg/2014/0225/1503323b3-4.jpg)
inherit说明：

inherit属性则是让子容器继承父容器的相关属性。

**2、box-direction**

box-direction用来确定父容器里的子容器排列顺序，具体属性如下代码所示：
`normal | reverse | inherit`

normal是默认值

按照HTML文档里结构的先后顺序依次展示。如下代码，如果box-direction设置为normal，则结构依次展示sectionOne、sectionTwo、sectionThree.

    .wrap{
    	width:600px;
    	height:200px;
    	display:-moz-box;
    	display:-webkit-box;
    	display:box;
    	-moz-box-direction:normal;//设置mormal默认值
    	-webkit-box-direction:normal;//设置mormal默认值
    	box-direction:normal;//设置mormal默认值
    }
    .sectionOne{
    	background:orange;
    	-moz-box-flex:1;
    	-webkit-box-flex:1;
    	box-flex:1;
    }
    .sectionTwo{
    	background:purple;
    	-moz-box-flex:2;
    	-webkit-box-flex:2;
    	box-flex:2;
    }
    .sectionThree{
    	width:100px;
    	background:green;
    }

![](http://img.warting.com/allimg/2014/0225/150332B63-5.jpg)
reverse表示反转:

如上面所示设置nomal其结构的排列顺序为sectionOne、sectionTwo、sectionThree；如果设置reverse反转，其结构的排列顺序为sectionThree、sectionTwo、sectionOne.

    .wrap{
    	width:600px;
    	height:200px;
    	display:-moz-box;
    	display:-webkit-box;
    	display:box;
    	-moz-box-direction:reverse;//设置为反转
    	-webkit-box-direction:reverse;//设置为反转
    	box-direction:reverse;//设置为反转
    }
    .sectionOne{
    	background:orange;
    	-moz-box-flex:1;
    	-webkit-box-flex:1;
    	box-flex:1;
    }
    .sectionTwo{
    	background:purple;
    	-moz-box-flex:2;
    	-webkit-box-flex:2;
    	box-flex:2;
    }
    .sectionThree{
    	width:100px;
    	background:green;
    }

![](http://img.warting.com/allimg/2014/0225/1503321461-6.jpg)

**3、box-align**

box-align表示父容器里面子容器的垂直对齐方式，可选参数如下所示：
`start | end | center | baseline | stretch`

    .wrap{
    	width:600px;
    	height:108px;
    	display:-moz-box;
    	display:-webkit-box;
    	display:box;
    	-moz-box-align:stretch;
    	-webkit-box-align:stretch;
    	-o-box-align:stretch;
    	box-align:stretch;
    }
    .wrap section{
    	height:80px;
    }
    .wrap .sectionOne{
    	background:orange;
    	-moz-box-flex:1;
    	-webkit-box-flex:1;
    	box-flex:1;
    }
    .wrap .sectionTwo{
    	background:purple;
    	-moz-box-flex:2;
    	-webkit-box-flex:2;
    	box-flex:2;
    	height:108px;
    }
    .wrap .sectionThree{
    	width:100px;
    	background:green;
    }

start

在box-align表示居顶对齐，如下图所示
![](http://img.warting.com/allimg/2014/0225/1503322427-7.jpg)
end

在box-align表示居底对齐，如下图所示
![](http://img.warting.com/allimg/2014/0225/15033264H-8.jpg)
center

在box-align表示居中对齐，如下图所示
![](http://img.warting.com/allimg/2014/0225/150332C20-9.jpg)
stretch

在box-align表示拉伸，拉伸到与父容器等高
![](http://img.warting.com/allimg/2014/0225/150332F92-10.jpg)

**4、box-pack**

box-pack表示父容器里面子容器的水平对齐方式，可选参数如下所示：
`start | end | center | justify`

    .wrap{
    	width:600px;
    	height:108px;
    	border:1px solid red;
    	display:-moz-box;
    	display:-webkit-box;
    	display:box;
    	-moz-box-pack:end;
    	-webkit-box-pack:end;
    	-o-box-pack:end;
    	box-pack:end;
    }
    .wrap section{
    	width:100px;
    }
    .wrap .sectionOne{
    	background:orange;
    }
    .wrap .sectionTwo{
    	background:purple;
    }
    .wrap .sectionThree{
    	background:green;
    }

start

在box-pack表示水平居左对齐，如下图所示
![](http://img.warting.com/allimg/2014/0225/1503325a7-11.jpg)
end

在box-pack表示水平居右对齐，如下图所示
![](http://img.warting.com/allimg/2014/0225/1503322O9-12.jpg)
center

在box-pack表示水平居中对齐，如下图所示
![](http://img.warting.com/allimg/2014/0225/1503322127-13.jpg)
justify

在box-pack表示水平等分父容器宽度（唯一遗憾的是，firefox与opera暂时不支持，只有safari、chrome支持）
![](http://img.warting.com/allimg/2014/0225/1503324L0-14.jpg)
