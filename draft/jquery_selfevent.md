# jQuery自定义事件
一直以为jQuery的bind只能绑定jQuery中的事件，今天从一本书上看到jQuery的bind也能绑定自定义事件。

事实上我们可以通过bind绑定一个自定义事件，然后再通过trigger来触发这个事件。例如给element绑定一个hello事件，再通过trigger来触发这个事件：

    //给element绑定hello事件
    element.bind("hello",function(){
        alert("hello world!");
    });

    //触发hello事件
    element.trigger("hello");

这段代码这样写似乎感觉不出它的好处，看了下面的例子也许你会明白使用自定义事件的好处了：

我们已一个选项卡的插件为例：我们让ul列表来响应点击事件，当用户点击一个列表项时，给这个列表项添加一个名为active的类，同时将其他列表项中的active类移除，以此同时让刚刚点击的列表对应的内容区域也添加active类。

HTML：

    <ul id="tabs">
        <li data-tab="users">Users</li>
        <li data-tab="groups">Groups</li>
    </ul>
    <div id="tabsContent">
        <div data-tab="users">part1</div>
        <div data-tab="groups">part2</div>
    </div>


jQuery:

    $.fn.tabs=function(control){
        var element=$(this);
        control=$(control);
        element.delegate("li","click",function(){
            var tabName=$(this).attr("data-tab");
             //点击li的时候触发change.tabs自定义事件  
            element.trigger("change.tabs",tabName);
        });

        //给element绑定一个change.tabs自定义事件
        element.bind("change.tabs",function(e,tabName){
            element.find("li").removeClass("active");
            element.find(">[data-tab='"+ tabName +"']").addClass("active");
        });     
        element.bind("change.tabs",function(e,tabName){
            control.find(">[data-tab]").removeClass("active");
            control.find(">[data-tab='"+ tabName +"']").addClass("active");
        });
        //激活第一个选项卡  
        var firstName=element.find("li:first").attr("data-tab");
        element.trigger("change.tabs",firstName);

        return this;
    };

由于插件位于jQuery的prototype里面，因此我们可以基于jQuery实例来调用：

    $("ul#tabs").tabs("#tabsContent");

从上面的例子我们可以看到使用自定义事件回调使得选项卡状态切换回调彼此分离，让代码变得整洁易读。
