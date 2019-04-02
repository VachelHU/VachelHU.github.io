# CSS3之pointer-events属性值详解
### 1. 简要概述
在某个项目中，很多元素需要定位在一个地图层上面，这里就要用到很多绝对定位或者相对定位的元素，但是这样的话，这些浮在上面的div或者其它元素一般都会给个宽高，或者relative的元素可以不给宽高，这个时候，这些元素就会盖住下面的地图层，以至于地图层无法操作。。。

然后正好在Google map见到了类似的问题，拿来当例子来说：
![](http://www.poluoluo.com/jzxy/UploadFiles_335/201109/2011092213381240.jpg)

Google map中左上角的操作区域占位是挺大的，如红色框区域，然后在这个区域是无法操作地图层的。那么我们就可以给这个div设置 `pointer-events:none`，然后你就会发现下面的地图就可以拖动和点击了。
但是悲剧的是，操作区域本身却无法操作了，直接被无视掉了。不过不用担心，我们可以给里面的元素重新设置为 `pointer-events:auto`，当然，只给需要操作的元素区域设置。

貌似有点儿纠结，不过这样可以保证地图本身的可操作区域最大化。

上面只是个简单的例子，来看下具体用法：

    pointer-events:  auto | none | visiblePainted | visibleFill | visibleStroke | visible | painted | fill | stroke | all | inherit

pointer-events属性有很多值，但是对于浏览器来说，只有auto和non两个值可用，其它的几个是针对SVG的(本身这个属性就来自于SVG技术)。

### 2. pointer-events属性值详解
>auto——效果和没有定义pointer-events属性相同，鼠标不会穿透当前层。在SVG中，该值和visiblePainted的效果相同。

>none——元素不再是鼠标事件的目标，鼠标不再监听当前层而去监听下面的层中的元素。但是如果它的子元素设置了pointer-events为其它值，比如auto，鼠标还是会监听这个子元素的。

其它属性值为SVG专用，这里不再多介绍了。

### 3. 浏览器兼容性
+ Firefox 3.6+
+ chrome 2.0+
+ safari4.0+

IE6/7/8/9都不支持，Opera在SVG中支持该属性但是HTML中不支持。好吧，还是有点儿悲催～～
