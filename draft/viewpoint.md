# viewpoint和他的朋友们
### 概论
我相信很多人一开始对 viewport 的概念都是很模糊的，大部分 viewport meta tag 的文章，看下来也只知道如何使用 viewport，仍旧不知道 viewport 是什么，希望这篇文章能给你答案

在说 viewport 之前，先来了解一些术语
#### 1. Physical pixels or Device pixels or Hardware pixels
虽然叫法不同，但是这三个都是描述设备的物理分辨率而使用的单位，比如 iphone 4为640*960px
#### 2. Pixels Per Inch or PPI in short
PPI 即每英寸像素数，描述像素密度的一种方式，类似的还有 DPI、PPCM 等，描述单位和适用场景不同。以 iphone4 为例，其物理分辨率为 640*960px，尺寸为3.54，PPI 为 326（√(640×640 + 960×960) / 3.54）
#### 3. CSS pixels
在浏览器中，这个值用来描述 CSS 基本单位的大小，与设备的物理尺寸无关，例如我们在浏览器中对一个 320px 宽的元素进行缩放（zoom-in），虽然这个元素在屏幕上占据的尺寸变小，但是他的宽度仍然是 320px，只不过此时 CSS pixels 的尺寸变小（一个物理像素容纳更多的 CSS pixel，浏览器会计算这个物理像素应该显示的颜色），CSS pixels 更应该理解为一种逻辑上的单位
![](/images/blog/css-pixels.png)
#### 4. Density Independent pixels or dips in short
dips 即设备独立像素，由 Google 引入，作为一种与设备无关的度量单位，用来解决 android 上杂乱的分辨率和尺寸下的应用布局问题

在移动浏览器上，通过 viewport 设置的网页宽度与设备物理尺寸不同时（通常我们将 viewport 宽度设置为 device-width），dips 作为抽象层来描述设备宽度，即：dips-viewport

[PPK](http://www.quirksmode.org/about/) 提供了各浏览器默认的 [dips 速查表](http://www.quirksmode.org/mobile/metaviewport/notes.html)
#### 5. devicePixelRatio or dpr in short
devicePixelRatio 即设备像素比，其计算公式为：Physical pixels / dips（这里的 dips 为浏览器默认的 device-width），以 iphone 4 为例，其 devicePixelRatio 为 2（640 / 320）；普通桌面浏览器一般为1；Google 推出的 Nexus One 虽然分辨率有 480*800，但浏览器在竖屏下 dips 为 320，因此 Nexus One 的 devicePixelRatio 为 1.5（480 / 320）

可以使用脚本获取这个值：`window.devicePixelRatio;`

### 常见设备的分辨率、PPI、dpr
请参考：[screen siz.es](http://screensiz.es/phone)

### 320 & @2x
apple 发布的第一代 iphone， 包括早期的 android 设备，屏幕分辨率 320*480px，当时有大量的网站直接采用了 320px 来设计，iphone 4 更新 retina 后，宽度变成了640，但为了兼容已有的为 320 设计的网站，device-width 仍然为 320

传统的 web 设计，一个物理像素对应一个 CSS pixel，目前 PC 还是这种现状（rmpb 不算 pc）

随着移动设备的 PPI 越来越高，如果一个物理像素仍然对应一个 CSS pixel，浏览器上一个 12px 的文字基本上就没法看了

因此，虽然 iphone4 更新了 retina 屏幕，当我们设置 viewport 宽度为 device-width 时，浏览器在竖屏下返回的 viewport 宽高仍为 320*480（全屏模式），这样一来，iphone4 会用4个像素来显示一个 CSS pixel，CSS 中定义的 320px 宽的图看起来就非常模糊

既然4个物理像素显示一个 CSS pixel，如果用2倍大小的图来填充 320px 的 CSS 区域，这样的图看上去就会非常清晰，因此有了@2x 这种图片命名方式

以上只是针对达到 retina 显示级别的 ios 设备，这些设备的 devicePixelRatio 为2，所以需要两倍大小的图来填充 CSS 区域；但并不是所有设备的 devicePixelRatio 都是2，前面提到的 Nexus One 的 devicePixelRatio 为 1.5，使用两倍大小的图片本身没有问题，但是浪费了用户流量

### Media Query for devicePixelRatio（dpr）or responsive image
1. 根据不同的 dpr 加载不同的样式表：

    <!-- for those normal display -->
    <link rel="stylesheet" href="normal-display.css" media="(-webkit-min-device-pixel-ratio: 1)" />
    <!-- for those retina display -->
    <link rel="stylesheet" href="retina-display.css" media="(-webkit-min-device-pixel-ratio: 2)" />

2. 在一个样式表内 为不同的 dpr 设置不同的样式：

    #header {
        width: 320px;
        background-repeat: no-repeat;
    }
    @media
    (-webkit-min-device-pixel-ratio: 2),
    (min-resolution: 192dpi) {
        #header {
            background-image: url(image@2x.png);
            background-size: 50%;
        }
    }
    @media
    (-webkit-min-device-pixel-ratio: 1.5),
    (min-resolution: 144dpi) {
        /* ... */
    }

其他常见的 dpr 和 分辨率见：[Retina Display Media Query](http://css-tricks.com/snippets/css/retina-display-media-query/)

### 以上方案针对 CSS 中定义的背景图，我们还有标准的 inline img 需要支持

1. 检查 dpr，修改图片宽度：

    function getDpr() {
        return typeof window.devicePixelRatio === 'undefined' ? 1 : window.devicePixelRatio;
    }
    function setImgForHighDpr(selector) {
        if(getDpr() > 1) {
            [].forEach.call(document.querySelectorAll(selector), function(img) {
                img.width = img.width / 2;
            });
        }
    }

2. 检查dpr，加载对应的图片：

    function getDpr() {
        return typeof window.devicePixelRatio === 'undefined' ? 1 : window.devicePixelRatio;
    }
    function setImgForHighDpr(selector) {
        if(getDpr() > 1) {
            [].forEach.call(document.querySelectorAll(selector), function(img) {
                // 最好增加图片 load 检查
                img.src = img.src.replace(/(\.\w+)$/, '@2x$1');
            });
        }
    }

我们也可以使用这个很受欢迎的库：[retina.js](https://github.com/imulus/retinajs/blob/master/src/retina.js)

### 标准界目前仍在讨论的方案：
1. 为现有的 img 标签增加 src-n 或 srcset 属性：

    <img src="logo.png" srcset="logo.png 1x logo@2x.png 2x" alt="logo" width="100" height="50" />

2. 使用新的 picture 标签，不过这个标签似乎并不受浏览器厂商的待见

    <picture alt="angry pirate">
        <source src=hires.png media="min-width:800px">
        <source src=midres.png media="network-speed:3g">
        <source src=lores.png>

        <!-- fallback for browsers without support -->
        <img src=midres.png alt="angry pirate">
    </picture>

关于这几个方案目前的状态，可以参考这篇文章：[Responsive images – end of year report](http://html5doctor.com/responsive-images-end-of-year-report/)，目前这些草案中的标准无法在产品中使用，并且用法也很杂，这里不深入

## viewport
### 桌面浏览器
所有块级元素的宽度都从父级继承，并且初始值为 100%，body 的父级为 html，那 html 的宽度来自哪里呢？

viewport 的作用就是来约束 html 元素的显示范围，简单的说，html 再宽都不会宽过 viewport 的宽度，由于 viewport 并不存在于 html 结构中，所以不能通过样式表来控制

桌面浏览器上的 viewport 简单很多，就是浏览器的可视区域：

+ `window.innerWidth / -Height` 带滚动条的视窗宽高
+ `document.documentElement.clientWidth / -Height` 不带滚动条的视窗宽高

这两个值均以 CSS pixels 度量，因此缩放的操作会影响到这个窗口的大小，一个1366的窗口缩放至110%，这个值会变成1241（1366 / 1.1）

由于 html 是可以附加样式的，如果我们给这个元素设定一个具体的宽度，上面的两个值是否会有变化？

答案是：no，因此在桌面浏览器，要获取 viewport，使用 `document.documentElement.clientWidth / -Height` 就可以了（IE < 9 不支持 window.innerWidth）

如果想要获取 html 这个元素的实际宽高，应该使用 `document.documentElement.offsetWidth / -Height`

在普通的桌面浏览器，如果要实现响应式的设计，可以使用 media query 配合 width 实现

### 移动设备
在移动设备上，viewport 有很大的不同，移动设备上的 viewport 包含两层概念：layout viewport 和 visual viewport

layout viewport 类似一个背景，而 visual viewport 就像一个可以看到背景的透明相框，只有在相框足够大（full zoom-out）的情况下才能看到整个背景（此时相框和背景在大小上重合），否则只能看到背景的局部
![](/images/blog/viewport.png)
不论是 layout viewport 还是 visual viewport 都以 CSS pixels 度量。但在缩放的时候，为了避免频繁的 reflow，layout viewport 不会变化，影响只是 visual viewport 的大小

大部分浏览器在打开网页的时候会自动缩放以尽可能显示宽度完整的网页（此时 layout viewport 和 visual viewport 重合），在旋屏时，浏览器会对 layout viewport 做轻微的缩放，使 layout viewport 宽度始终与 visual viewport 保持一致

html 元素从 layout viewport 获取初始宽度，layout viewport 可以通过 `document.documentElement.clientWidth / -Height` 获取，常见 layout viewport 宽度：

+ Safari iPhone 980px
+ Android Webkit 800px
+ IE 974px

visual viewport 可以通过 `window.innerWidth / -Height` 获取，并会受到 zoom 的影响

media query 和桌面浏览器类似，width / height 匹配 layout viewport 宽高，device-width / -height 匹配屏幕物理分辨率（screen.width / -height）

由于移动设备的 PPI 越来越高，device-width 如果直接使用 screen.width 这些超高的数值意义不大，因此，iphone 4 虽然更新了 retina，但是在浏览器中通过 screen.width 返回的值仍为 320，device-width 也始终保持 320，chrome for android 也采取了类似的做法，以C2为例，在物理尺寸1080px，screen.width 返回360

需要注意的是，虽然部分 android 自带浏览器 screen.width 直接返回设备的物理分辨率，但 device-width 仍旧不会直接使用这个值，我们可以放心的使用 meta tag 修改 layout viewport 宽度为 device-width：

    <meta name="viewport" content="width=device-width" />

你也通过这个 meta tag 控制缩放：

    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

### screen.width
screen.width 这个值应该返回 viewport 宽度、还是实际物理分辨率并没有规范可遵循，现实的情况是，浏览器厂商也有各自的实现
