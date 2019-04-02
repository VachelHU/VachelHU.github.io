# 你可能不知道的javascript奇淫技巧
这里记录一下以前学习各种书籍和文章里边出现的JS的小技巧，分享给大家，也供自己查阅，同时感谢那些发现创造和分享这些技巧的前辈和大牛们。

### 1. 遍历一个obj的属性到数组

		var a=[];
		for(a[a.length] in obj);
		return a;

乍一看可能比较蒙，不过仔细分析还是不难理解的。常见用法是for(var key in obj)，这里key初始也是undefined的，a[a.length]整体也是undefined，所以二者其实是等价的。在for循环中，obj 的属性会依次赋值给key，同样，也依次赋值给a[a.length]，这里length一直在变，就巧妙地挨个赋值给数组的每一个元素了。

### 2. 重复字符串(如abc=>abcabc)

		function repeat(target,n){
			return (new Array(n+1).join(target));
		 }

 改良版本：

		 function repeat(target,n){
			return Array.prototype.join.call(
		 		{length:n+1},target);//之所以要创建带length属性的对象，是因为调用数组原型方法时，必须是一个类数组对象，而类数组对象的条件就是length为非负整数
		  }

  不新建数组，而是用拥有length属性的对象替代，然后调用数组的join方法,性能提升很大

再改进：

		var repeat=(function(){
		 	join=Array.prototype.join,obj={};
			return function(target,n){
			obj.length=n+1;
			return join.call(obj,target);
			}
		})();

利用闭包将对象和join方法缓存起来，不用每次都新建对象和寻找方法

### 3. for循环中，当第二项为false时会终止循环，这里并不一定存在比较，可以直接赋值，如果赋值为undefined之类的值时，转成bool值也为假，因此也会终止，比如遍历数组可以写成：

		for(var i=arr.length,element;element=arr[—-i];){…}

这里，第二项一定是arr[—-i]而非arr[i--],如果是后者的话，上来就是undefined，就不会执行循环体，或者for(var i=0,element;element=arr[i++];){…}

### 4. NaN是JS中唯一不等于自己的值，因此可以用来判断一个变量是否真的为NaN：a!==a

### 5. “<”，”+”等运算符会强制符号两边的表达式执行valueOf然后比较，所以如果两边是函数或者对象，而又重写了该对象的valueOf方法，就会自动执行两边的方法。如：

		var a={valueOf:function(){
			console.log(“aaa”);
			}
		},b={valueOf:function(){
			console.log(“bbb”);
			}
		};
		a < b;//会输出：aaa;bbb;false;

### 6. JS具备自动插入分号的能力，但是自动插入分号并不是万能的，其有三条规则：

1. 只在”}”标记之前、一个或多个换行之后以及程序输入的结尾被插入；
2. 分号只在随后的输入标记不能被解析时插入；

   这一点很重要，比如：

	 	a=b
		(f());

是不会在a=b之后自动插入分号的，因为a=b(f())是可以被解析的，因此像”(“,”[“,”+”,”-“,”/“开头的时候，需要特别注意上一行可能不会自动插入。
还有一些情况，尽管不会出现解析错误，JS仍然会强制插入分号，这就是所谓的JS语法限制产生式。它不允许在两个字符间出现换行，最危险的就是return语句，如

		return
		{};

会被强制插入而成为

		return;
		{};

类似的还有：throw语句、带有显示标签的break活着continue语句、后置自增或自减运算符
3. 分号不会作为分隔符在for循环空语句的头部被自动插入
因此，最好的办法是在自己的js文件的最开始防御性地插入”;”，这样在合并js文件的时候就不会出问题了。

### 7. 闭包。理解闭包需学会三个基本事实：
1. JS允许你引用在当前函数之外定义的变量
2. 即使外部函数已经返回，当前函数仍然可以引用在外部函数所定义的变量。这是因为JS的函数值包含有 比调用它们时执行所需要的代码更多的信息
3. 闭包可以更新外部变量的值。这是因为闭包存储的是外部变量的引用而非值副本。如：

		function box(){
			var val=undefined;
			return {
				set:function(x){val=x;},
				get:function(){return val;}
			};
		}
		var b=box();
		b.get();//“undefined”
		b.set(5);
		b.get();//5

### 8. JS没有块级作用域，因此通常情况下函数内部的所有变量都是绑定到函数作用域的，也就是说相当于都在函数一开始就声明了的，一个例外就是try/catch中的变量是块级的，只属于try/catch块。

### 9. 众所周知，在函数内部声明函数是可以的，但是在在函数内的局部块里声明，可能会出现问题：

		function f(){
			return “global”;
		}
		function test(x){
			function f(){
				return “local”
				}
			var result=[];
			if(x){
				result.push(f());
			}
			result.push(f());
			return result;
		}
		test(true);//[“local”,”local”]
		test(false);//[“local”]

将函数声明到if块中：

		function f(){return “global”;}
		function test(x){
			var result=[];
			if(x){
			function f(){return “local”}
			result.push(f());
			}
			result.push(f());
			return result;
		}
		test(true);//?
		test(false);//?

结果会如何呢？理论上讲，JS没有块级作用域，因此f()的作用域是整个test函数，因此合理猜测应该是与上一次输出相同，全部 为”local”，可是并不是所有的JS执行环境都如此行事，有的会根据是否执行包含f的代码块来有条件地绑定函数f（绑定即意味着将该变量绑定到其最近 的作用域，而赋值是发生在代码实际执行到赋值那一步的时候进行的）。

因此最好的办法是如果要声明嵌套函数，都在其富函数的最外层声明，要么就不要声明函数，而是使用var声明和函数表达式来实现：

		function f(){return “global”;}
		function test(x){
			var result=[];
			if(x){
				var g=function(){return “local”}
				result.push(g());
			}
			result.push(f());
			return result;
		}

### 10. js创建字典
用js创建字典的时候，如果是利用对象的方式（因为JS对象的核心是一个字符串属性名称和属性值的映射表），会遇到一个问题就是原型污染，因为获取字典属性值的时候用hasOwnProperty还好，如果用for in遍历的话，不仅会遍历对象本身，包括它的原型，因此如果在其他地方污染了Object的原型，那么for in就会产生非预期的结果，这时可能会用hasOwnProperty来先检测该对象本身是否含有属性来避免原型污染，然而更极端的情况是连 hasOwnProperty这个原型方法都有可能被污染。

避免原型污染的方法是在创建字典对象的时候用Object.create(null)来创建一 个完全空对象，这个对象没有原型，这个方法是ES5的,在没有这个方法可用的时候，最好是创建字典类，然后在字典类里用数组来存储有序集合，自己维护这个 集合。

### 11. 数组的原型方法
JS中的类数组对象可以享用数组的大部分原型方法如map等，类数组对象是指满足两个条件的对象：一是具备合理范围值内的length属性， 二是length属性大于该对象的最大索引，索引是一个合理范围的证书，它的字符串表示的是对象的一个key；但是数组的一个原型方法contact是不 能被类数组对象调用的，因此需要先用[].slice.call把类数组对象转换为真正的数组比如[].slice.call(arguments)。

### 12. 结构类型
并不是所有时候都需要继承，继承也不是完美的，有时候会创造比他能解决的更多的问题，特别是当层次关系没那么明显的时候，这时候应该多用结构 类型(又叫鸭子类型，如果它看起来像鸭子、游泳像鸭子并且叫声像鸭子，那么它就是鸭子)，用结构类型设计灵活的对象接口的时候，不需要创建类工厂来返回类 的实例，而是直接返回对象，对象具备预期的方法和属性，比如：

		SomeObj.someWidget=function(opts){
			return {
				a:blabla,
				b:function(){...},
				c:blabla
			}
		}
