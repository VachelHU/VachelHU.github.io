# JS阻止对象的修改
### 概述
最近在项目过程中，遇到了对特定参数的对象要常量化的问题，查阅了《[Principles of Object-Oriented JavaScript](http://book.douban.com/subject/25831404/)》一书，总结了如下几个方法

### 数据属性
+ [[Configurable]]: 表示是否可以通过delete删除属性从而重新定义属性，能否修改属性的特性，或者能否把属性修改为访问器属性。默认值为true
+ [[Enumerable]]: 表示能否通过for - in 循环返回属性。默认值为true
+ [[Writable]]: 表示是否可以修改属性值。默认值为true
+ [[Value]]: 包含这个属性的数据值。默认为undefined

访问器属性多了（ES6）
+ [[Get]]在读取属性值调用的函数
+ [[Set]]在写入属性时调用的函数

### 阻止扩展
通过使用`Object.preventExtensions()`方法创建一个不可扩展的对象，这个方法接收参数为一个对象

代码如下：

    var person1 = {
           name: "Nicholas"
    };
    console.log(Object.isExtensible(person1));
    Object.preventExtensions(person1);
    console.log(Object.isExtensible(person1));
    person1.sayName = function() { console.log(this.name);
    };
    console.log("sayName" in person1);
    console.log(Object.getOwnPropertyDescriptor(person1, "name");
    // true
    // false
    // false
    // Object {value: "Nicholas", writable: true, enumerable: true, configurable: true}

不能添加键，但可以对原来的键进行其属性范围内的操作

### 封闭
通过使用`Object.seal()`方法创建一个不可扩展的对象，这个方法接收参数为一个对象

    var person1 = {
           name: "Nicholas"
       };
    console.log(Object.isExtensible(person1));
    console.log(Object.isSealed(person1));

    Object.seal(person1);
    console.log(Object.isExtensible(person1));
    console.log(Object.isSealed(person1));

    person1.sayName = function() { console.log(this.name);
    };
    console.log("sayName" in person1);

    person1.name = "Greg";
    console.log(person1.name);

    delete person1.name;
    console.log("name" in person1);
    console.log(person1.name);

    var descriptor = Object.getOwnPropertyDescriptor(person1, "name");
    console.log(descriptor);
    // true
    // false
    // false
    // true
    // false
    // "Greg"
    // true
    // "Greg"
     // Object {value: "Greg", writable: true, enumerable: true, configurable: false}

不能添加，delete创建新键，可以支持修改，循环往返属性

### 冻结
通过使用`Object.freeze()`方法创建一个不可扩展的对象，这个方法接收参数为一个对象

    var person1 = {
           name: "Nicholas"
    };
       console.log(Object.isExtensible(person1));
       console.log(Object.isSealed(person1));
       console.log(Object.isFrozen(person1));

       Object.freeze(person1);
       console.log(Object.isExtensible(person1));
       console.log(Object.isSealed(person1));

    console.log(Object.isFrozen(person1));
    person1.sayName = function() {
        console.log(this.name);
    };
    console.log("sayName" in person1);
    person1.name = "Greg";
    console.log(person1.name);

    delete person1.name;
    console.log("name" in person1);
    console.log(person1.name);

    var descriptor = Object.getOwnPropertyDescriptor(person1, "name");
    console.log(descriptor);

    // true
    // false
    // false
    // false
    // true
    // true
    // false
    // "Nicholas"
    // true
    // "Nicholas"
    // Object {value: "Nicholas", writable: false, enumerable: true, configurable: false}

不可修改读写
