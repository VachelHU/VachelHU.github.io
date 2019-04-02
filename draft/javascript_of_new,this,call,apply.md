# Javascript技术难点之new,this,call,apply
### 1. this指向的作用域
javascript里的this指针却比java里的this难以理解的多，究其根本原因我个人觉得有三个原因：

1. 原因一：javascript是一个函数编程语言，怪就怪在它也有this指针，说明这个函数编程语言也是面向对象的语言，说的具体点，javascript里的函数是一个高阶函数，编程语言里的高阶函数是可以作为对象传递的，同时javascript里的函数还有可以作为构造函数，这个构造函数可以创建实例化对象，结果导致方法执行时候this指针的指向会不断发生变化，很难控制。
2. 原因二：javascript里的全局作用域对this指针有很大的影响，javascript里的this在没有进行new操作也会生效，这时候this往往会指向全局对象window。
3. 原因三：javascript里call和apply操作符可以随意改变this指向，这看起来很灵活，但是这种不合常理的做法破坏了我们理解this指针的本意，同时也让写代码时候很难理解this的真正指向

我们先看看下面的代码：

    <script type="text/javascript">
        this.a = "aaa";
        console.log(a);//aaa
        console.log(this.a);//aaa
        console.log(window.a);//aaa
        console.log(this);// window
        console.log(window);// window
        console.log(this == window);// true
        console.log(this === window);// true
    </script>

在script标签里我们可以直接使用this指针，this指针就是window对象，我们看到即使使用三等号它们也是相等的。全局作用域常常会干扰我们很好的理解javascript语言的特性，这种干扰的本质就是：在javascript语言里全局作用域可以理解为window对象，记住window是对象而不是类，也就是说window是被实例化的对象，这个实例化的过程是在页面加载时候由javascript引擎完成的，整个页面里的要素都被浓缩到这个window对象，因为程序员无法通过编程语言来控制和操作这个实例化过程，所以开发时候我们就没有构建这个this指针的感觉，常常会忽视它，这就是干扰我们在代码里理解this指针指向window的情形。

干扰的本质还和function的使用有关，我们看看下面的代码：

    <script type="text/javascript">
        console.log(ftn01);//ftn01()  注意：在firebug下这个打印结果是可以点击，点击后会显示函数的定义
        console.log(ftn02);// undefined
        function ftn01(){
           console.log("I am ftn01!");
        }
        var ftn02 = function(){
            console.log("I am ftn02!");
        }
    </script>

上面是我们经常使用的两种定义函数的方式,

第一种定义函数的方式在javascript语言称作声明函数，第二种定义函数的方式叫做函数表达式，

这两种方式我们通常认为是等价的，但是它们其实是有区别的，而这个区别常常会让我们混淆this指针的使用.在javascript语言通过声明函数方式定义函数，javascript引擎在预处理过程里就把函数定义和赋值操作都完成了，但是在全局作用域构造或者说全局变量预处理时候对于声明函数有些不同，声明函数会将变量定义和赋值操作同时完成，因此我们看到上面代码的运行结果。由于声明函数都会在全局作用域构造时候完成,因此声明函数都是window对象的属性

### 2. new改变this的指向
this都是指向实例化对象，前面讲到那么多情况this都指向window，就是因为这些时候只做了一次实例化操作，而这个实例化都是在实例化window对象，所以this都是指向window。我们要把this从window变成别的对象，就得要让function被实例化，那如何让javascript的function实例化呢？答案就是使用new操作符。我们看看下面的代码：

    <script type="text/javascript">
        var obj = {
            name:"sharpxiajun",
            job:"Software",
            show:function(){
                console.log("Name:" + this.name + ";Job:" + this.job);
                console.log(this);// Object { name="sharpxiajun", job="Software", show=function()}
            }
        };
        var otherObj = new Object();
        otherObj.name = "xtq";
        otherObj.job = "good";
        otherObj.show = function(){
            console.log("Name:" + this.name + ";Job:" + this.job);
            console.log(this);// Object { name="xtq", job="good", show=function()}
        };
        obj.show();//Name:sharpxiajun;Job:Software
        otherObj.show();//Name:xtq;Job:good
    <script>

对新对象里面赋值进去要布置到this里面去`this.`

    <script type="text/javascript">
        function Person(name,sex,age,job){
            this.name = name;
            this.sex = sex;
            this.age = age;
            this.job = job;
            this.showPerson = function(){
                console.log("姓名:" + this.name);
                console.log("性别:" + this.sex);
                console.log("年龄:" + this.age);
                console.log("工作:" + this.job);
                console.log(this);// Person { name="马云", sex="男", age=46, 更多...}
            }
        }
        var person = new Person("马云", "男", 46, "董事长");
        person.showPerson();
    </script>

new操作符会让构造函数产生如下变化：

1. 创建一个新对象；
2. 将构造函数的作用域赋给新对象（因此this就指向了这个新对象）；
3. 执行构造函数中的代码（为这个新对象添加属性）；
4. 返回新对象

关于第二点其实很容易让人迷惑，这个过程可以这么理解，在全局执行环境里window就是上下文对象，那么在obj里局部作用域通过obj来代表了，这个window的理解是一致的。

第四点也要着重讲下，记住构造函数被new操作，要让new正常作用最好不能在构造函数里写return，没有return的构造函数都是按上面四点执行，有了return情况就复杂了，这个知识请关注prototype。

见如下代码变能知道为什么这样输出了

    var foo = 1;
    function main(){
       console.log(foo);
       var foo = 2;
       console.log(this.foo)
       this.foo = 3;
    }
    var m1 = main();
    var m2 = new main();
    //undefined 1
    //undefined undefined

### 3. call与apply与bind
Javascript还有一种方式可以改变this指针，这就是call方法和apply方法，call和apply方法的作用相同，就是参数不同，call和apply的第一个参数都是一样的，但是后面参数不同，apply第二个参数是个数组，call从第二个参数开始后面有许多参数。Call和apply的作用是什么，这个很重要，重点描述如下：

1. Call和apply是改变函数的作用域（有些书里叫做改变函数的上下文）
2. 这个说明我们参见上面new操作符第二条：
3. 将构造函数的作用域赋给新对象（因此this就指向了这个新对象）；
4. Call和apply是将this指针指向方法的第一个参数。

　　我们看看下面的代码：

    <script type="text/javascript">
        var name = "sharpxiajun";
        function ftn(name){
            console.log(name);
            console.log(this.name);
            console.log(this);
        }
        ftn("101");
        var obj = {
          name:"xtq"
        };
        ftn.call(obj,"102");
        /
         结果如下所示：
         101
         sharpxiajun
         Window
         102
         xtq
         Object { name="xtq"}
         /
    </script>

bind的用法如下

    function sayNameForAll(label) {
           console.log(label + ":" + this.name);
    }
       var person1 = {
           name: "Nicholas"
    };
       var person2 = {
           name: "Greg"
    };
       // create a function just for person1
    var sayNameForPerson1 = sayNameForAll.bind(person1); sayNameForPerson1("person1"); // outputs "person1:Nicholas"
       // create a function just for person2
    var sayNameForPerson2 = sayNameForAll.bind(person2, "person2"); sayNameForPerson2(); // outputs "person2:Greg"
       // attaching a method to an object doesn't change 'this'
    wperson2.sayName = sayNameForPerson1;
    person2.sayName("person2"); // outputs "person2:Nicholas"

### 4. 总结一下
1. 情形一：传入的参数是函数的别名，那么函数的this就是指向window；
2. 情形二：传入的参数是被new过的构造函数，那么this就是指向实例化的对象本身；
3. 情形三：如果我们想把被传入的函数对象里this的指针指向外部字面量定义的对象，那么我们就是用apply和call

如果在javascript语言里没有通过new（包括对象字面量定义）、call和apply改变函数的this指针，函数的this指针都是指向window的。
