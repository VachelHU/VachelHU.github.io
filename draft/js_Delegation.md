# Javascript事件代理和委托（Delegation）
### 1. 概述
在javasript中delegate这个词经常出现，看字面的意思，代理、委托。那么它究竟在什么样的情况下使用？它的原理又是什么？在各种框架中，也经常能看到delegate相关的接口。这些接口又有什么特殊的用法呢？这篇文章就主要介绍一下javascript delegate的用法和原理，以及Dojo，jQuery等框架中delegate的接口。

### 2. Javascript事件代理
首先介绍一下JavaScript的事件代理。事件代理在JS世界中一个非常有用也很有趣的功能。当我们需要对很多元素添加事件的时候，可以通过将事件添加到它们的父节点而将事件委托给父节点来触发处理函数。这主要得益于浏览器的事件冒泡机制。下面我们具体举个例子来解释如何使用这个特性

假如有一个UL的父节点，包含了多个Li的子结点：

    <ul id="parent-list">
      <li id="post-1">Item 1</li>
      <li id="post-2">Item 2</li>
      <li id="post-3">Item 3</li>
      <li id="post-4">Item 4</li>
      <li id="post-5">Item 5</li>
      <li id="post-6">Item 6</li>
    </ul>

当我们的鼠标移到Li上的时候，需要获取此Li的相关信息并飘出悬浮窗以显示详细信息，或者当某个Li被点击的时候需要触发相应的处理事件。我们通常的写法，是为每个Li都添加一些类似onMouseOver或者onClick之类的事件监听。

    function addListeners4Li(liNode){
        liNode.onclick = function clickHandler(){...};
        liNode.onmouseover = function mouseOverHandler(){...}
    }

    window.onload = function(){
        var ulNode = document.getElementById("parent-list");
        var liNodes = ulNode.getElementByTagName("Li");
        for(var i=0, l = liNodes.length; i < l; i++){
            addListeners4Li(liNodes[i]);
        }
    }

如果这个UL中的Li子元素会频繁地添加或者删除，我们就需要在每次添加Li的时候都调用这个addListeners4Li方法来为每个Li节点添加事件处理函数。这就添加的复杂度和出错的可能性。

更简单的方法是使用事件代理机制，当事件被抛到更上层的父节点的时候，我们通过检查事件的目标对象（target）来判断并获取事件源Li。下面的代码可以完成我们想要的效果：

    // 获取父节点，并为它添加一个click事件
    document.getElementById("parent-list").addEventListener("click",function(e) {
      // 检查事件源e.targe是否为Li
      if(e.target && e.target.nodeName.toUpperCase == "LI") {
        // 真正的处理过程在这里
        console.log("List item ",e.target.id.replace("post-")," was clicked!");
      }
    });

为父节点添加一个click事件，当子节点被点击的时候，click事件会从子节点开始向上冒泡。父节点捕获到事件之后，通过判断e.target.nodeName来判断是否为我们需要处理的节点。并且通过e.target拿到了被点击的Li节点。从而可以获取到相应的信息，并作处理。

### 3. 事件冒泡及捕获
之前的介绍中已经说到了浏览器的事件冒泡机制。这里再详细介绍一下浏览器处理DOM事件的过程。对于事件的捕获和处理，不同的浏览器厂商有不同的处理机制，这里我们主要介绍W3C对DOM2.0定义的标准事件。

DOM2.0模型将事件处理流程分为三个阶段：一、事件捕获阶段，二、事件目标阶段，三、事件起泡阶段。如图：
![](http://images.cnitblog.com/blog/477973/201302/18141423-8bd09a9c1e184df9a13b6e26b88348f3.jpg)
事件捕获：当某个元素触发某个事件（如onclick），顶层对象document就会发出一个事件流，随着DOM树的节点向目标元素节点流去，直到到达事件真正发生的目标元素。在这个过程中，事件相应的监听函数是不会被触发的。

事件目标：当到达目标元素之后，执行目标元素该事件相应的处理函数。如果没有绑定监听函数，那就不执行。

事件起泡：从目标元素开始，往顶层元素传播。途中如果有节点绑定了相应的事件处理函数，这些函数都会被一次触发。如果想阻止事件起泡，可以使用e.stopPropagation()（Firefox）或者e.cancelBubble=true（IE）来组织事件的冒泡传播。

### 4. jQuery中delegate函数

    $("#link-list").delegate("a", "click", function(){
      // "$(this)" is the node that was clicked
      console.log("you clicked a link!",$(this));
    });

jQuery的delegate的方法需要三个参数，一个选择器，一个事件名称，和事件处理函数。

### 5. 优点
通过上面的介绍，大家应该能够体会到使用事件委托对于web应用程序带来的几个优点：

1. 管理的函数变少了。不需要为每个元素都添加监听函数。对于同一个父节点下面类似的子元素，可以通过委托给父元素的监听函数来处理事件。
2. 可以方便地动态添加和修改元素，不需要因为元素的改动而修改事件绑定。
3. JavaScript和DOM节点之间的关联变少了，这样也就减少了因循环引用而带来的内存泄漏发生的概率。
