# CSS3 Grid布局：网格布局让内容优先
### 1. 概论
CSS3网格布局目的是让开发人员设计一个网格并将内容放在这些网格内。而不是使用浮动制作一个网格，实际上你将一个元素声明为一个网格容器，并把元素内容置于网格中。最重要的是文档流的源顺序并不重要。

### 2. 声明网格
我们声明一个网格是使用“display”的新属性值：“display:grid”。由于我们这里需要在IE10中实现，所以我们需要加上前缀：“display:-ms-grid;”。
一旦我们声明了网格，就可以使用“grid-columns”和“grid-rows”属性来设置列与行。

	.wrapper {
		display: -ms-grid;
		-ms-grid-columns: 200px 20px auto 20px 200px;
		-ms-grid-rows: auto 1fr;
		}

在上面的示例中，把“.wrapper”元素声明成一个网格。我使用“grid-columns”属性创建了一个200像素宽度的列，一个20像素的间距，一个根据可用空间的弹性列，另一个20像素的间距和200像素的侧边栏：一个灵活的布局有两个固定宽度的侧边栏。

使用“grid-rows”属性我创建了两行：第一行设置了“auto”，不管是否入内容他都将延伸填允；第二行设置了“1fr”，**一个用于网格的新单位值，剩余空间分配数，他意味着一个分数单位**。在这种情况之下，一个分数单位的可用空间，不管空间是否存在都是有效的。

### 3. 网格项目的定位
现在有一个简单的网格，我需要把内容放上去。假如我有一个类名叫“.mian”的div，我想把他放在网格的第二行和设置了auto值的列，我可以使用下面的样式：

	.main {
		-ms-grid-column: 3;
		-ms-grid-row: 2;
		-ms-grid-row-span: 1;
		}

如果你是一个老的开发人员，你可能已经意识到，我们其实是使用CSS创建了一个类似于HTML的表格布局。如果你想尝试找到对应的元素，你可以把网格布局当作一个表格的概念，这是最有益的方法。

### 4. 创建网格系统
当我们开始玩CSS3网格布局时，我想看看我能否用它来复制一个类似于960流体16列网格系统这样的一个灵活的网格系统。
我先把容器wrapper元素定义成一个网格容器，使用分数让这个网格变成流体网格。

		.wrapper {
			width: 90%;
			margin: 0 auto 0 auto;
			display: -ms-grid;
			-ms-grid-columns: 1fr (4.25fr 1fr)[16];
			-ms-grid-rows: (auto 20px)[24];
			}

我举的实例类似于960网格系统。网格每一列前后有一个间距，然后按这样的方式重复16次。这就意味着，如果我想要跨越两列，在网格布局模块中而言，实际上是跨越了三个列：两个单元格再加上一个间距。所在在项目定位时要明确指定。
我为每个定位选项创建了一个类名：列、行和间距，例如：

		.grid1 {-ms-grid-column: 2;}
		.grid2 {-ms-grid-column: 4;}
		.grid3 {-ms-grid-column: 6;}
		.row1 {-ms-grid-row:1;}
		.row2 {-ms-grid-row:3;}
		.row3 {-ms-grid-row:5;}
		.colspan1 {-ms-grid-column-span:1;}
		.colspan2 {-ms-grid-column-span:3;}
		.colspan3 {-ms-grid-column-span:5;}

![](http://www.alixixi.com/web/UploadPic/2013-6/2013628105848994.jpg)
以上只有在IE10下可以看出效果
