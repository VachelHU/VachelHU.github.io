# 网页中嵌入字体的解决方案
### 概述
字体使用是网页设计中不可或缺的一部分。经常地，我们希望在网页中使用某一特定字体，但是该字体并非主流操作系统的内置字体，这样用户在浏览页面的时候就有可能看不到真实的设计。美工设计师最常做的办法是把想要的文字做成图片，这样做有几个明显缺陷：

1. 不可能大范围的使用该字体；
2. 图片内容相对使用文字不易修改；
3. 不利于网站SEO（主流搜索引擎不会将图片alt内容作为判断网页内容相关性的有效因素）。网络上有一些使用sIFR技术、或javascript/flash hack的方法，但实现起来或繁琐，或有缺陷。下面要讲的是如何只通过CSS的@font-face属性来实现在网页中嵌入任意字体。

### 第一步
获取要使用字体的三种文件格式，确保能在主流浏览器中都能正常显示该字体。

+ .TTF或.OTF，适用于Firefox 3.5、Safari、Opera
+ .EOT，适用于Internet Explorer 4.0+
+ .SVG，适用于Chrome、IPhone

下面要解决的是如何获取到某种字体的这三种格式文件。一般地，我们在手头上（或在设计资源站点已经找到）有该字体的某种格式文件，最常见的是.TTF文件，我们需要通过这种文件格式转换为其余两种文件格式。字体文件格式的转换可以通过网站[FontsQuirrel](http://www.fontsquirrel.com)或[onlinefontconverter](http://www.onlinefontconverter.com)提供的在线字体转换服务获取。这里推荐第一个站点，它允许我们选择需要的字符生成字体文件（在服务的最后一个选项），这样就大大缩减了字体文件的大小，使得本方案更具实用性。

### 第二步
获取到三种格式的字体文件后，下一步要在样式表中声明该字体，并在需要的地方使用该字体。

字体声明如下：

    @font-face {
     font-family: 'fontNameRegular';
     src: url('fontName.eot');
     src: local('fontName Regular'),
                  local('fontName'),
                  url('fontName.eot?#iefix') format('embedded-opentype'),
                  url('fontName.woff') format('woff'),
                  url('fontName.ttf') format('truetype'),
                  url('fontName.svg#fontName') format('svg');
    }  
/*其中fontName替换为你的字体名称*/

在页面中需要的地方使用该字体：

  	p { font: 13px fontNameRegular, Arial, sans-serif; }
  	h1{font-family: fontNameRegular}

或者

	 <p style="font-family: fontNameRegular">掬水月在手，落花香满衣</p>

### #iefix兼容处理
#### 1、@font-face与EOT格式
之所以把它们放到一起是因为首个实现 @font-face 和 EOT 的是同一家公司 - 微软。

早在九十年代 CSS 就有了自定义字体的语法，IE4是首个实现此语法的浏览器，没错，就是IE。不过，字体格式只能是微软自己开发的 EOT(Embedded Open Type) 格式。

EOT 允许字体的作者保护字体不被非法复制，微软不允许其他浏览器厂商使用该格式，因此它只能在 IE 下使用。

这对当时来说太超前了。还记得在 windows XP 下看使用了『微软雅黑』的网页吗？当时的系统用一种简单的灰阶反锯齿技术，对于系统的字体这足够了，但对于其他字体，由于缺少人工的优化，字体会变得很虚。因此，本来想改进网页的排版效果，结果却使文字都无法阅读。

于是，CSS2.1 中彻底去掉了 @font-face 语法也不足为奇了。

#### ２、Safari 的一小步，浏览器的一大步
大约十年后，在2008年，Safari 3.1 重新支持了 @font-face , 并且可以使用最普遍的字体格式 ttf 以及 otf。其实这得益于液晶显示器（LCD）的普及，LCD 提供了更高的分辨率以及通过亚像素渲染(subpixel rending)的反锯齿(anti-aliasing)技术。这样，即使字体很小，也能看得很清楚。

微软称这种技术为 ClearType。在 Mac OS X 平台上 subpixel rending 是默认开启的，但在 windows 平台上只有 windows vista 以及之后的版本才会默认开启。因此回到上面的问题，由于『微软雅黑』不是 XP 的系统字体，XP 默认没有开启 ClearType，因此当在装有『微软雅黑』字体的 XP 上访问将字体设为『微软雅黑』的网页时，看起来会很模糊。不过，手动开启 ClearType 后便可以解决此问题。

一年后，Firefox Opera Chrome 等主流浏览器都开始支持 @font-face。

又过了一年，2010年，几乎所有主流浏览器都支持了 @font-face , 甚至是 IE，从 IE9 开始微软摒弃了自己的 EOT 字体开始支持 ttf otf 等主流字体格式。在移动端，iOS 从4.2开始也支持这些字体格式。
自此，@font-face 死而复生。 web字体时代来临。

#### 3、truetype woff 以及 svg
上面 CSS 声明中使用了 4 种字体格式，其中 EOT 格式前面已经提过，它是 IE 的专有格式，下面看一下余下的 3 种格式。

先说 svg 格式，iOS 在 4.2 之前仅支持 svg 格式的字体，由于 svg 格式不能压缩，通常会比较大。鉴于 iOS 老版本渐渐被淘汰，因此可以考虑去掉此格式。

truetype(.ttf) 是目前最普遍的字体格式，早在八十年代就被苹果开发出来，当时它作为一种可伸缩的字体格式用来代替位图字体在屏幕上显示，不久微软也接受了这个格式，由于该格式可以针对特定大小做精准的微调，渐渐地成为系统字体的标准。

说到 truetype 不得不提一下 opentype，它在 CSS 中的出镜率也很高。opentype 可以看作是 truetype 的升级版，由微软和 Adobe 联合开发。opentype 采用不同于 truetype 的算法存储路径，单从这点来讲 opentype 有两个主要优势：

1. 平均比 truetype 小 20% 到 50%。
2. 需要较少的用于反锯齿的微调信息（详见下面的参考链接）。

除此之外，opentype 除基本字符集外还提供了别的扩展，比如小号大写字符，老式的数字，以及其他一些图形。

既然 opentype 有这么多优点，那为什么我们上面的代码中没用使用 opentype 呢？首先，微软建议如果只需要在屏幕上显示文字推荐用 truetype 格式。如果需要更大的字符集和更好的打印效果才推荐 opentype 。其次，支持 opentype 的浏览器都支持 truetype。
最后，也是最新出现的是 woff (web open type format)。woff 属于 W3C 的推荐标准。

由两名字体设计师和两位 Mozilla 的开发者设计。最早在 firefox 3.6 上实现。事实上，woff 并不是一种新的字体格式，它只是包装 truetype 和 opentype 并进行压缩，压缩后可以使 truetype 减少 40% 。除此之外，它还允许添加元信息，比如字体作者的许可证，不过浏览器并不对这些许可做任何验证。

### #iefix有何作用？
IE9 之前的版本没有按照标准解析字体声明，当 src 属性包含多个 url 时，它无法正确的解析而返回 404 错误，而其他浏览器会自动采用自己适用的 url。因此把仅 IE9 之前支持的 EOT 格式放在第一位，然后在 url 后加上 ?，这样 IE9 之前的版本会把问号之后的内容当作 url 的参数。

至于 #iefix 的作用，一是起到了注释的作用，二是可以将 url 参数变为锚点，减少发送给服务器的字符。

### 为何有两个src？
绝大多数情况下，第一个 src 是可以去掉的，除非需要支持 IE9 下的兼容模式。在 IE9 中可以使用 IE7 和 IE8 的模式渲染页面，微软修改了在兼容模式下的 CSS 解析器，导致使用 ? 的方案失效。

由于 CSS 解释器是从下往上解析的，所以在上面添加一个不带问号的 src 属性便可以解决此问题。
