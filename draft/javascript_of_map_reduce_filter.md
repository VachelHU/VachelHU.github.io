# JavaScript实现Map、Reduce和Filter

      // 函数式编程：
      //描述我们要做什么，而不是我们如何去做。这意味着我们工作在一个更高的抽象层次。函数式编程将导致更精巧、清晰和令人愉快的代码。
   	// 最基础的forEach
      function forEach(array, action) {
          for (var i = 0; i < array.length; i++) {
              action(array[i]);
          }
      }
      // 测试forEach
      forEach(["Pear", "Apple"], function(name) {
          console.log(name);
      });
      // ------------------------------------------------ //
      // 实现reduce
      function reduce(combine, base, array) {
          forEach(array, function(element) {
              base = combine(base, element);
          });
          return base;
      }
      // 使用reduce实例1：计算数组中的0的个数
      function countZeros(array) {
          function counter(total, elem) {
              return total + (elem == 0 ? 1 : 0);
          }
          return reduce(counter, 0, array);
      }
      alert("countZeros by reduce: " + countZeros([1, 3, 0, 4, 7, 0]));
      // 使用reduce实例2：求和
      function sum(array) {
          function add(a, b) {
              return a + b;
          }
          return reduce(add, 0, array);
      }
      alert("sum by reduce: " + sum([1, 2, 3, 5]));
      // ------------------------------------------------ //
     // 实现map
      function map(func, array) {
          var result = [];
          forEach(array, function(elem) {
              result.push(func(elem));
              // 对于map，func函数一般只有一个参数，所以用func(elem)
          });
          return result;
      }
      // 利用map实现数组的每个数字翻倍
      var array = [1, 2, 3, 4, 5];
      var mappedArray = map(function(elem) {
          return elem * 2;
      }, array);
      console.log(mappedArray);
      // 利用map实现数组向下取整
      var array2 = [1.3, 4.5, 6.7, 8, 9.2];
      var mappedArray2 = map(Math.floor, array2);
      console.log(mappedArray2);
     // ------------------------------------------------ //
     // 实现filter：我自己根据上面两个补充实现的
      function filter(func, array) {
          var result = [];
          forEach(array, function(elem) {
              if(func(elem))
                  result.push(elem);
          });
          return result;
      }
      // 使用filter过滤出偶数
      function isEven(elem) {
          return elem % 2 == 0;
      }
      var array3 = [1, 2, 3, 4, 5, 6, 7, 8, 9];
      var filterArray = filter(isEven, array3);
      console.log(filterArray);
