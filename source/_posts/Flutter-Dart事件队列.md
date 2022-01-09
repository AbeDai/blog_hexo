---
title: Flutter-Dart事件队列
date: 2022-01-09 15:04:37
categories: 客户端
---

### Dart 消息队列 

Event Loop（事件循环）、Event Queue（事件队列）和 Microtask Queue微任务队列。

dart是单线程模型，默认情况下dart代码在主Isolate执行（相当于Android的UI线程），由Event Loop驱动。并且包含了一个Event Queue和一个Microtask Queue 
dart代码执行的过程如下图所示

![fa9ebdace421fb812e5202708da9fc60](/image/861F4520-9DB5-4774-96F3-563179549ABD.png)

可以看到，当 main() 执行完成后，Event Loop 开始工作。首先，它以FIFO（先进先出）顺序执行微任务队列中的所有的微任务，直到微任务队列为空，然后将事件队列中的第一项出队并处理，并且重复该循环：执行所有微任务，然后处理事件队列中的下一项。

### API介绍

##### 事件队列

| 函数 | 作用 |
| --- | --- |
| new Future(FutureOr<T> computation()) | 添加一个任务到事件队列的队尾 |
| Future.delayed(Duration duration, [FutureOr<T> computation()]) | 将任务延时添加到事件队列的队尾 |
 
##### 微任务队列

| 函数 | 作用 |
| --- | --- |
| scheduleMicrotask(void callback()) | 将任务添加到微任务队列的队尾 |
| Future.microtask(FutureOr<T> computation()) | 将任务添加到微任务队列的队尾 |
| Future.sync(FutureOr<T> computation()) | 同步执行（立即执行）其构造参数的函数(除非该构造参数的函数返回Future),并且构造的Future在微任务队列调度完成。 |
| Future.value([FutureOr<T> value]) | 构造的Future在微任务队列里调度完成，如果传入的value是Future,那么该任务会等待到传入的Future结束后执行 |

> 注：首先Future的then()并没有将任务添加到任何队列中，它仅仅只是注入了一个回调，在Future任务执行完成之后会执行该回调方法，并且会将Future的结果传递过去。在如果在调用一个Future的then()之前该Future已经执行完成了，那么该任务会被添加到微任务队列。

### 示例分析

```dart
import 'dart:async';

void main() {
  Future future1 = Future(() => print('future1'));
  Future future2 = Future(() => print('future2'));
  Future future3 = Future(() => print('future3'));
  Future future4 = Future(() => print('future4'));

  print('main 1');

  Future future5 = Future.value("future5").then((onValue) {
    print(onValue);
    print('future5.then');
  }).whenComplete(() {
    print('future5 complete');
  });

  Future future6 = Future.value(future1).then((_) {
    print('future6.then');
  }).whenComplete(() {
    print('future6 complete');
  });

  future4.then((_) {
    print('future4.then');
  });

  Future future7 = Future.sync(() {
    print('future7');
  }).then((_) {
    print('future7.then');
  }).whenComplete(() {
    print('future7 complete');
  });

  future3.then((_) {
    print('future3.then1');
    future2.then((_) {
      print('future2.then');
    });
    scheduleMicrotask((){print('scheduleMicrotask on future3.then1');});
  }).then((_) => print('future3.then2'));

  print('main 2');

  future1.then((_) {
    print('future1.then');
  });

  future5.then((_) {
    print('future5.then2');
  });
}
```

**main() 函数执行图例**

![7acd98d605f0ce8dfb443a8f2400669f](/image/082EC062-7F67-4179-B7F3-46914857B6D7.png)

**main() 函数执行描述**

按照任务调度图中的流程，直接执行的放在main区域。

1. 执行`Future future1 = Future(() => print('future1'));`,将任务`() => print('future1')`添加到事件队列

1. 执行`Future future2 = Future(() => print('future2'));`, 将任务`() => print('future2')`添加到事件队列

1. 执行`Future future3 = Future(() => print('future3'));`, 将任务`() => print('future3')`添加到事件队列

1. 执行`Future future4 = Future(() => print('future4'));`, 将任务`() => print('future4')`添加到事件队列

1. 执行`print('main 1');`,放入mian区域

1. 执行`Future future5 = Future.value("future5").then((onValue) { print(onValue); print('future5.then'); }).whenComplete(() { print('future5 complete'); });,`
    a. 执行`Future future5 = Future.value("future5")`,首先传入的不是Future，不需要等待，并且该Future会在微任务队列完成，所以添加到微任务队列，future5任务实际上就是设置了value
    b. 执行`then((onValue) {print(onValue); print('future5.then'); })`,注入then回调监听`((onValue) {print(onValue); print('future5.then'); })`到future5上，等待future5任务执行后回调，
    c. 执行`whenComplete(() {print('future5 complete');});`,注入一个回调监听`(() {print('future5 complete');})`到future5 回调监听后，与then()有点相似，区别是即使Future执行出错了，还是会调用whenComplete回调，而不会调用then()，并且then()可以接收值，`whenComplete()不接收。同样是等待future5整个执行完成后回调，有点类似于"finally" block`

1. 执行`Future future6 = Future.value(future1).then((_) {print('future6.then'); }).whenComplete(() { print('future6 complete');});`
    a. 执行`Future future6 = Future.value(future1)`，首先传入的future1是Future，所以，将future6假装是一个listener，插入到future1后，如果future1已经有listener，则找到最后一个并插到最后
    b.执行`then((_) {print('future6.then'); })`,注入listener到future6后，实际就是future1后
    c.执行`whenComplete(() {print('future6 complete');});`,同样注入回调监听`(() {print('future6 complete');})`

1. 执行`future4.then((_) {print('future4.then');});`,注入回调监听`（(_) {print('future4.then');}）`到future4后。

1. 执行`Future future7 = Future.sync(() { print('future7');}).then((_) { print('future7.then'); }).whenComplete(() {print('future7 complete'); });`
    a. 执行`Future future7 = Future.sync(() { print('future7');})`，首先构造参数函数`（() { print('future7');}）`会立即执行,放入main区域，并且future7 会在微任务队列调度完成，添加到微任务队列
    b.执行`then((_) { print('future7.then'); }) `,注册回调监听`((_) { print('future7.then'); })`到future7后
    c. 执行`whenComplete(() {print('future7 complete'); });`,注册回调监听`（() {print('future7 complete'); }）`

1. 执行`future3.then((_) {print('future3.then1'); future2.then((_) { print('future2.then');}); scheduleMicrotask((){print('scheduleMicrotask on future3.then1');}); }).then((_) => print('future3.then2'));`
    a. 执行`then((_) {print('future3.then1'); future2.then((_) { print('future2.then');}); scheduleMicrotask((){print('scheduleMicrotask on future3.then1');}); })`,注册回调监听`((_) {print('future3.then1'); future2.then((_) { print('future2.then');}); scheduleMicrotask((){print('scheduleMicrotask on future3.then1');}); })`到future3后
    b. 执行`then((_) => print('future3.then2'));`,注册回调监听`（(_) => print('future3.then2')）`到future3的回调最后

1. 执行`print('main 2');`,放入main区域

1. 执行`future1.then((_) {print('future1.then'); });`,注册回调监听`((_) {print('future1.then'); })`到future1的回调最后

1. 执行`future5.then((_) { print('future5.then2');});`,注册回调监听`((_) { print('future5.then2');})`到future5当前的listener最后

### 参考

https://www.jianshu.com/p/1ce1605a2097
