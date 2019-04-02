# 解决IE6兼容性问题的十大技巧
### 1.使用声明
你必须经常在html网页头部放置一个声明，推荐使用严格的标准。例如

		<!DOCTYPEHTMLPUBLIC“-//W3C//DTDHTML4.01//EN”   "http://www.w3.org/TR/html4/strict.dtd”> or,forXHTML:  <!DOCTYPEhtmlPUBLIC“-//W3C//DTDXHTML1.0Strict//EN”   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd”>

最后你需要是IE6进入兼容模式，这已经足够兼容了。

### 2.使用position:relative
IE6兼容性问题解决方案二：使用position:relative。设置一个标签position:relative可以解决很多问题，特别是曾经有过看不见的经历或者奇怪布局的框架。明显的，你需要小心，绝对位置放置的子元素是否都参照找到新位置。

### 3.为浮动元素使用display:inline
浮动元素会有一个著名的IE6双边距marginbug。假如你设置了左边距5px但实际上得到了10px左边距。display:inline可以解决这个问题，尽管它不是必需的，但是css仍然有效。

### 4.设置元素启动hasLayout
大部分IE6（IE7）的渲染问题都可以通过起来元素的hasLayout属性来兼容。这是IE内置的设定，确定一个内容块相对其它内容块是有界限和位置的。当你需要设置一个行内元素例如一个连接变成块状元素或者是透明效果，设置hasLayout也是必须的。

### 5.修复重复字符的bug
复杂的布局会触发一个bug：浮动对象的最后字符会出现在已经清除浮动的元素后面。这里有几种解决的办法，部分是理想的，并且一些测试和出错是必须的。

+ 确保浮动元素都使用：display:inline；
+ 最后一个浮动元素使用margin-right:-3px;
+ 在浮动对象最后一个元素后使用一个条件注释。例如`<!—>这里输入注释…>![endif]`
+ 在容器内的最后使用一个div空标签（它也必须设置90%宽度甚至更小）

### 6.使用a标签完成可点击和hover原理
IE6只支持a标签的css定义hover效果
你可以使用它去控制javascript启动的widgets，使得他们仍然保持键盘操作。这里有个二择一的问题，但是a标签是所有解决方案中最可靠的。

### 7.使用!important，或是高级选择符替代IE特定代码
使用!important。在外置的css文件里，放弃凭借传统的hacks和条件判断，使用有效的css代码去针对IE6仍然是有可能的。例如：最小高度可以使用一下定义。（在IE6中无法识别！important优先级别标签，所以一般用法为：

		{margin-top:20px !important; margin-top:0px;}
		#element{  min-height:20em;  height:auto!important;  height:20em;  }


### 8.早点和经常测试
在你的网站和应用程序完成之前，不要放弃IE6的测试。问题将会更加严重并且需要很长时间去修复。如果你的网站可以运行于firefox和IE6，它将差不多肯定可以在其它浏览器下运行。

### 9.重构你的代码
重构代码。经常的，修复会比重新考虑布局问题更加花费时间。Html细微的修改和更加简单的css经常是最有效的。这意味着你要放弃完美的合法的代码，但是将会更少的问题出现，并且你知道怎样处理将要出现的情况。
 `#element[id]{  height:auto;  }`

### 10.注意事项
`*margin-top:10px;` 属性前加`*`,这个只有IE6/IE7才能识别。
例如:

		div{
			margin-top:10px;
			*margin-top:0px;
		}

+ `*`或`+`或`_` + 属性，这个只有IE6和IE7才支持此种标签。
+ `*margin-top:10px \9;` 属性值的后面加`\9`,这个只有IE才能识别。
+ 以上两种方法结合起来可以区分IE6、IE7、IE8+、非IE内核浏览器。
