# jQuery Deferred和Promise创建响应式应用程序详细介绍
### 概论
JavaScript 中的 Deferred 和 Promise ，它们是 JavaScript 工具包（如Dojo和MochiKit）中非常重要的一个功能，最近也首次亮相于 `流行的 JavaScript 库 jQuery`（已经是1.5版本的事情了）。

Deferred 提供了一个抽象的非阻塞的解决方案（如 Ajax 请求的响应），它创建一个 “promise” 对象，其目的是在未来某个时间点返回一个响应。如果您之前没有接触过 “promise”，我们将会在下面做详细介绍。

抽象来说，deferreds 可以理解为表示需要长时间才能完成的耗时操作的一种方式，相比于阻塞式函数它们是异步的，而不是阻塞应用程序等待其完成然后返回结果。

deferred对象会立即返回，然后你可以把回调函数绑定到deferred对象上，它们会在异步处理完成后被调用。

### Promise
你可能已经阅读过一些关于promise和deferreds实现细节的资料。在本章节中，我们大致介绍下promise如何工作，这些在几乎所有的支持deferreds的javascript框架中都是适用的。

一般情况下，promise作为一个模型，提供了一个在软件工程中描述延时（或将来）概念的解决方案。它背后的思想我们已经介绍过：不是执行一个方法然后阻塞应用程序等待结果返回，而是返回一个promise对象来满足未来值。

举一个例子会有助于理解，假设你正在建设一个web应用程序， 它很大程度上依赖第三方api的数据。那么就会面临一个共同的问题：我们无法获悉一个API响应的延迟时间，应用程序的其他部分可能会被阻塞，直到它返回 结果。Deferreds 对这个问题提供了一个更好的解决方案，它是非阻塞的，并且与代码完全解耦 。

Promise/A提议'定义了一个'then‘方法来注册回调，当处理函数返回结果时回调会执行。它返回一个promise的伪代码看起来是这样的：

    promise = callToAPI( arg1, arg2, ...);
    promise.then(function( futureValue ) {
    /* handle futureValue */
    });
    promise.then(function( futureValue ) {
    /* do something else */
    });

此外，promise回调会在处于以下两种不同的状态下执行：

+ resolved：在这种情况下，数据是可用
+ rejected：在这种情况下，出现了错误，没有可用的值

幸运的是，'then'方法接受两个参数：一个用于promise得到了解决（resolved），另一个用于promise拒绝（rejected）。让我们回到伪代码：

    promise.then( function( futureValue ) {
    /* we got a value */
    } , function() {
    /* something went wrong */
    } );

在某些情况下，我们需要获得多个返回结果后，再继续执行应用程序（例如，在用户可以选择他们感兴趣的选项前，显示一组动态的选项）。这种情况下，'when'方法可以用来解决所有的promise都满足后才能继续执行的场景。

    when(
    promise1,
    promise2,
    ...
    ).then(function( futureValue1, futureValue2, ... ) {
    /* all promises have completed and are resolved */
    });

一个很好的例子是这样一个场景，你可能同时有多个正在运行的动画。 如果不跟踪每个动画执行完成后的回调，很难做到在动画完成后执行下一步任务。然而使用promise和‘when'方式却可以很直截了当的表示：

 一旦动画执行完成，就可以执行下一步任务。最终的结果是我们可以可以简单的用一个回调来解决多个动画执行结果的等待问题。 例如：

     when( function(){
    /* animation 1 */
    /* return promise 1 */
    }, function(){
    /* animation 2 */
    /* return promise 2 */
    } ).then(function(){
    /* once both animations have completed we can then run our additional logic */
    });

 这意味着，基本上可以用非阻塞的逻辑方式编写代码并异步执行。 而不是直接将回调传递给函数，这可能会导致紧耦合的接口，通过promise模式可以很容易区分同步和异步的概念。

　　在下一节中，我们将着眼于jQuery实现的deferreds，你可能会发现它明显比现在所看到的promise模式要简单。

### jQuery的Deferreds
jQuery在1.5版本中首次引入了deferreds。它所实现的方法与我们之前描述的抽象的概念没有大的差别。

原则上，你获得了在未来某个时候得到‘延时'返回值的能力。在此之前是无法单独使用的。

Deferreds 作为对ajax模块较大重写的一部分添加进来，它遵循了CommonJS的promise/ A设计。

新版本的jQuery提供了一些增强的方式来管理 回调，提供更加灵活的方式建立回调，而不用关心原始的回调是否已经触发。 同时值得注意的是，jQuery的递延对象支持多个回调绑定多个任务，任务本身可以既可以是同步也可以是异步的。

您可以浏览下表中的递延功能，有助于了解哪些功能是你需要的：


| 方法 | 介绍 |
| ----------------- |  |
| jQuery.Deferred（）|	创建一个新的Deferred对象的构造函数，可以带一个可选的函数参数，它会在构造完成后被调用。|
| jQuery.when（）    |	通过该方式来执行基于一个或多个表示异步任务的对象上的回调函数 |
| jQuery.ajax（）    |	执行异步Ajax请求，返回实现了promise接口的jqXHR对象 |
| deferred.then（resolveCallback，rejectCallback）|	添加处理程序被调用时，递延对象得到解决或者拒绝的回调。|
| deferred.done（）  | 当延迟成功时调用一个函数或者数组函数.|
| deferred.fail（）	| 当延迟失败时调用一个函数或者数组函数.。|
| deferred.resolve（ARG1，ARG2，...） |	调用Deferred对象注册的‘done'回调函数并传递参数 |
| deferred.resolveWith（context，args）| 调用Deferred对象注册的‘done'回调函数并传递参数和设置回调上下文 |
| deferred.isResolved	| 确定一个Deferred对象是否已经解决。|
| deferred.reject（arg1，arg2，...）|	调用Deferred对象注册的‘fail'回调函数并传递参数 |
| deferred.rejectWith（context，args）|	调用Deferred对象注册的‘fail'回调函数并传递参数和设置回调上下文 |
| deferred.promise（）|	返回promise对象，这是一个伪造的deferred对象：它基于deferred并且不能改变状态所以可以被安全的传递 |

jQuery延时实现的核心是jQuery.Deferred：一个可以链式调用的构造函数。......

需要注意的是任何deferred对象的默认状态是unresolved， 回调会通过 .then() 或 .fail()方法添加到队列，并在稍后的过程中被执行。

下面这个$.when() 接受多个参数的例子

    function successFunc(){ console.log( “success!” ); }
    function failureFunc(){ console.log( “failure!” ); }

    $.when(
    $.ajax( "/main.php" ),
    $.ajax( "/modules.php" ),
    $.ajax( “/lists.php” )
    ).then( successFunc, failureFunc );

在$.when() 的实现中有趣的是，它并非仅能解析deferred对象，还可以传递不是deferred对象的参数，在处理的时候会把它们当做deferred对象并立 即执行回调（doneCallbacks）。

这也是jQuery的Deferred实现中值得一提的地方，此外，deferred.then（）还为deferred.done和 deferred.fail（）方法在deferred的队列中增加回调提供支持。

利用前面介绍的表中提到的deferred功能，我们来看一个代码示例。 在这里，我们创建一个非常基本的应用程序：通过$.get方法（返回一个promise）获取一条外部新闻源（1）并且（2）获取最新的一条回复。 同时程序还通过函数（prepareInterface（））实现新闻和回复内容显示容器的动画。

为了确保在执行其他相关行为前，上面的这三个步骤确保完成，我们使用$.when()。根据您的需要 .then()和.fail() 处理函数可以被用来执行其他程序逻辑。

    function getLatestNews() {
    return $.get( “latestNews.php”, function(data){
    console.log( “news data received” );
    $( “.news” ).html(data);
    } );
    }
    function getLatestReactions() {
    return $.get( “latestReactions.php”, function(data){
    console.log( “reactions data received” );
    $( “.reactions” ).html(data);
    } );
    }

    function prepareInterface() {
    return $.Deferred(function( dfd ) {
    var latest = $( “.news, .reactions” );
    latest.slideDown( 500, dfd.resolve );
    latest.addClass( “active” );
    }).promise();
    }

    $.when(
    getLatestNews(), getLatestReactions(), prepareInterface()
    ).then(function(){
    console.log( “fire after requests succeed” );
    }).fail(function(){
    console.log( “something went wrong!” );
    });

deferreds在ajax的幕后操作中使用并不意味着它们无法在别处使用。

在本节中，我们将看到在一些解决方案中，使用deferreds将有助于抽象掉异步的行为，并解耦我们的代码。

### 异步缓存
当涉及到异步任务，缓存可以是一个有点苛刻的，因为你必须确保对于同一个key任务仅执行一次。因此，代码需要以某种方式跟踪入站任务。 例如下面的代码片段：

    $.cachedGetScript( url, callback1 );
    $.cachedGetScript( url, callback2 );

缓存机制需要确保 脚本不管是否已经存在于缓存，只能被请求一次。 因此，为了缓存系统可以正确地处理请求,我们最终需要写出一些逻辑来跟踪绑定到给定url上的回调。

值得庆幸的是，这恰好是deferred所实现的那种逻辑，因此我们可以这样来做：

    var cachedScriptPromises = {};
    $.cachedGetScript = function( url, callback ) {
    if ( !cachedScriptPromises[ url ] ) {
    cachedScriptPromises[ url ] = $.Deferred(function( defer ) {
    $.getScript( url ).then( defer.resolve, defer.reject );
    }).promise();
    }
    return cachedScriptPromises[ url ].done( callback );
    };

代码相当简单：我们为每一个url缓存一个promise对象。 如果给定的url没有promise，我们创建一个deferred，并发出请求。 如果它已经存在我们只需要为它绑定回调。

该解决方案的一大优势是，它会透明地处理新的和缓存过的请求。 另一个优点是一个基于deferred的缓存 会优雅地处理失败情况。

当promise以‘rejected'状态结束的话，我们可以提供一个错误回调来测试：

    $.cachedGetScript( url ).then( successCallback, errorCallback );

请记住：无论请求是否缓存过，上面的代码段都会正常运作！

### 通用异步缓存
为了使代码尽可能的通用，我们建立一个缓存工厂并抽象出实际需要执行的任务​​：

    $.createCache = function( requestFunction ) {
    var cache = {};
    return function( key, callback ) {
    if ( !cache[ key ] ) {
    cache[ key ] = $.Deferred(function( defer ) {
    requestFunction( defer, key );
    }).promise();
    }
    return cache[ key ].done( callback );
    };
    }

现在具体的请求逻辑已经抽象出来，我们可以重新写cachedGetScript：

    $.cachedGetScript = $.createCache(function( defer, url ) {
    $.getScript( url ).then( defer.resolve, defer.reject );
    });

每次调用createCache将创建一个新的缓存库，并返回一个新的高速缓存检索函数。

现在，我们拥有了一个通用的缓存工厂，它很容易实现涉及从缓存中取值的逻辑场景。

### 图片加载
另一个候选场景是图像加载：确保我们不加载同一个图像两次，我们可能需要加载图像。 使用createCache很容易实现

    $.loadImage = $.createCache(function( defer, url ) {
    var image = new Image();
    function cleanUp() {
    image.onload = image.onerror = null;
    }
    defer.then( cleanUp, cleanUp );
    image.onload = function() {
    defer.resolve( url );
    };
    image.onerror = defer.reject;
    image.src = url;
    });

接下来的代码片段如下：

    $.loadImage( "my-image.png" ).done( callback1 );
    $.loadImage( "my-image.png" ).done( callback2 );

无论image.png是否已经被加载，或者正在加载过程中，缓存都会正常工作。

### 缓存数据的API响应
哪些你的页面的生命周期过程中被认为是不可变的API请求，也是缓存完美的候选场景。 比如，执行以下操作：

    $.searchTwitter = $.createCache(function( defer, query ) {
      $.ajax({
        url: "http://search.twitter.com/search.json",
        data: { q: query },
        dataType: "jsonp",
        success: defer.resolve,
        error: defer.reject
      });
    });

程序允许你在Twitter上进行搜索，同时缓存它们：

    $.searchTwitter( "jQuery Deferred", callback1 );
    $.searchTwitter( "jQuery Deferred", callback2 );

### 定时
基于deferred的缓存并不限定于网络请求;它也可以被用于定时目的。

例如，您可能需要在网页上给定一段时间后执行一个动作，来吸引用户对某个不容易引起注意的特定功能的关注或处理一个延时问题。 虽然setTimeout适合大多数用例，但在计时器出发后甚至理论上过期后就无法提供解决办法。

我们可以使用以下的缓存系统来处理：

    var readyTime;
    $(function() { readyTime = jQuery.now(); });
    $.afterDOMReady = $.createCache(function( defer, delay ) {
      delay = delay || 0;
      $(function() {
        var delta = $.now() - readyTime;
        if ( delta >= delay ) { defer.resolve(); }
        else {
          setTimeout( defer.resolve, delay - delta );
      }
      });
    });

新的afterDOMReady辅助方法用最少的计数器提供了domReady后的适当时机。 如果延迟已经过期，回调会被马上执行。

### 同步多个动画
动画是另一个常见的异步任务范例。 然而在几个不相关的动画完成后执行代码仍然有点挑战性。

尽管在jQuery1.6中才提供了在动画元素上取得promise对象的功能，但它是很容易的手动实现：

    $.fn.animatePromise = function( prop, speed, easing, callback ) {
      var elements = this;
      return $.Deferred(function( defer ) {
        elements.animate( prop, speed, easing, function() {
          defer.resolve();
          if ( callback ) {
            callback.apply( this, arguments );
          }
        });
      }).promise();
    };

然后，我们可以使用$.when()同步化不同的动画：

    var fadeDiv1Out = $( "#div1" ).animatePromise({ opacity: 0 }),
    fadeDiv2In = $( "#div1" ).animatePromise({ opacity: 1 }, "fast" );

    $.when( fadeDiv1Out, fadeDiv2In ).done(function() {
    /* both animations ended */
    });

我们也可以使用同样的技巧，建立了一些辅助方法：

    $.each([ "slideDown", "slideUp", "slideToggle", "fadeIn", "fadeOut", "fadeToggle" ],
    function( _, name ) {
    $.fn[ name + "Promise" ] = function( speed, easing, callback ) {
      var elements = this;
      return $.Deferred(function( defer ) {
        elements[ name ]( speed, easing, function() {
          defer.resolve();
          if ( callback ) {
            callback.apply( this, arguments );
          }
        });
        }).promise();
      };
    });

然后想下面这样使用新的助手代码来同步动画：

    $.when(
    $( "#div1" ).fadeOutPromise(),
    $( "#div2" ).fadeInPromise( "fast" )
    ).done(function() {
    /* both animations are done */
    });


### 一次性事件
虽然jQuery提供你可能需要的所有的时间绑定方法，但当事件仅需要处理一次时，情况可能会变得有点棘手。（ 与$.one() 不同 )

例如，您可能希望有一个按钮，当它第一次被点击时打开一个面板，面板打开之后，执行特定的初始化逻辑。 在处理这种情况时，人们通常会这样写代码：

    var buttonClicked = false;
    $( "#myButton" ).click(function() {
    if ( !buttonClicked ) {
    buttonClicked = true;
    initializeData();
    showPanel();
    }
    });

不久后，你可能会在面板打开之后点击按钮时添加一些操作，如下：

    if ( buttonClicked ) { /* perform specific action */ }

这是一个非常耦合的解决办法。 如果你想添加一些其他的操作，你必须编辑绑定代码或拷贝一份。 如果你不这样做，你唯一的选择是测试buttonClicked。由于buttonClicked可能是false，新的代码可能永远不会被执行，因此你 可能会失去这个新的动作。

使用deferreds我们可以做的更好 （为简化起见，下面的代码将只适用于一个单一的元素和一个单一的事件类型，但它可以很容易地扩展为多个事件类型的集合）：

    $.fn.bindOnce = function( event, callback ) {
    var element = $( this[ 0 ] ),
    defer = element.data( "bind_once_defer_" + event );
    if ( !defer ) {
    defer = $.Deferred();
    function deferCallback() {
    element.unbind( event, deferCallback );
    defer.resolveWith( this, arguments );
    }
    element.bind( event, deferCallback )
    element.data( "bind_once_defer_" + event , defer );
    }
    return defer.done( callback ).promise();
    };

该代码的工作原理如下：

+ 检查该元素是否已经绑定了一个给定事件的deferred对象
+ 如果没有，创建它，使它在触发该事件的第一时间解决
+ 然后在deferred上绑定给定的回调并返回promise

代码虽然很冗长，但它会简化相关问题的处理。 让我们先定义一个辅助方法：

    $.fn.firstClick = function( callback ) {
    return this.bindOnce( "click", callback );
    };

然后，之前的逻辑可以重构如下

    var openPanel = $( "#myButton" ).firstClick();
    openPanel.done( initializeData );
    openPanel.done( showPanel );

如果我们需要执行一些动作，只有当面板打开以后，所有我们需要的是这样的：

    openPanel.done(function() { /* perform specific action */ });

如果面板没有打开，行动将得到延迟到单击该按钮时。

### 在第一次点击时加载面板内容并打开面板
假如，我们有一个按钮，可以打开一个面板，请求其内容然后淡入内容。使用我们前面定义的助手方法，我们可以这样做：

    var panel = $( "#myPanel" );
    panel.firstClick(function() {
    $.when(
    $.get( "panel.html" ),
    panel.slideDownPromise()
    ).done(function( ajaxResponse ) {
      panel.html( ajaxResponse[ 0 ] ).fadeIn();
    });
    });


### 在第一次点击时载入图像并打开面板
假如，我们已经的面板有内容，但我们只希望当第一次单击按钮时加载图像并且当所有图像加载成功后淡入图像。HTML代码如下：

    <div id="myPanel">
    <img data-src="image1.png" />
    <img data-src="image2.png" />
    <img data-src="image3.png" />
    <img data-src="image4.png" />
    </div>

我们使用data-src属性描述图片的真实路径。 那么使用promise助手来解决该用例的代码如下：

    $( "#myButton" ).firstClick(function() {
    var panel = $( "#myPanel" ),
    promises = [];
    $( "img", panel ).each(function() {
    var image = $( this ), src = element.attr( "data-src" );
    if ( src ) {
    promises.push(
    $.loadImage( src ).then( function() {
    image.attr( "src", src );
    }, function() {
    image.attr( "src", "error.png" );
    } )
    );
    }
    });

    promises.push( panel.slideDownPromise() );

    $.when.apply( null, promises ).done(function() { panel.fadeIn(); });
    });

这里的窍门是跟踪所有的LoadImage 的promise，接下来加入面板slideDown动画。

因此首次点击按钮时，面板将slideDown并且图像将开始加载。 一旦完成向下滑动面板和已加载的所有图像，面板才会淡入。

### 在特定延时后加载页面上的图像
假如，我们要在整个页面实现递延图像显示。 要做到这一点，我们需要的HTML的格式如下：

    <img data-src="image1.png" data-after="1000" src="placeholder.png" />
    <img data-src="image2.png" data-after="1000" src="placeholder.png" />
    <img data-src="image1.png" src="placeholder.png" />
    <img data-src="image2.png" data-after="2000" src="placeholder.png" />

意思非常简单：

+ image1.png，第三个图像立即显示，一秒后第一个图像显示
+ image2.png 一秒钟后显示第二个图像，两秒钟后显示第四个图像

　　我们将如何实现呢？

    $( "img" ).each(function() {
    var element = $( this ),
    src = element.attr( "data-src" ),
    after = element.attr( "data-after" );
    if ( src ) {
    $.when(
    $.loadImage( src ),
    $.afterDOMReady( after )
    ).then(function() {
    element.attr( "src", src );
    }, function() {
    element.attr( "src", "error.png" );
    } ).done(function() {
    element.fadeIn();
    });
    }
    });

如果我们想延迟加载的图像本身，代码会有所不同：

    $( "img" ).each(function() {
    var element = $( this ),
    src = element.attr( "data-src" ),
    after = element.attr( "data-after" );
    if ( src ) {
      $.afterDOMReady( after, function() {
        $.loadImage( src ).then(function() {
          element.attr( "src", src );
        }, function() {
          element.attr( "src", "error.png" );
        }).done(function() {
          element.fadeIn();
        });
      });
    }
    });

这里，我们首先在尝试加载图片之前等待延迟条件满足。当你想在页面加载时限制网络请求的数量会非常有意义。

### 结论
正如你看到的，即使在没有Ajax请求的情况下，promise也非常有用的。通过使用jQuery 1.5中的deferred实现 ，会非常容易的从你的代码中分离出异步任务。 这样的话，你可以很容易的从你的应用程序中分离逻辑。
