---
title: 前端-JS中Promise的理解
date: 2018-11-25 11:26:43
categories: 前端
---

# Promise简介

Promise对象代表一个异步操作，里面保存着某个未来才会结束的事件的结果。对象的状态不受外界影响。

- Promise对象有三种状态：pending（进行中）、resolve（已成功）和rejected（已失败）。只有异步操作的结果，可以决定当前是哪一种状态，任何其他操作都无法改变这个状态。一旦状态改变，就不会再变，任何时候都可以得到这个结果。
- Promise对象的状态改变，只有两种可能：从pending变为resolve和从pending变为rejected。只要这两种情况发生，状态就凝固了，不会再变了，会一直保持这个结果。
- Promise对象的回调，可以暂存状态。即，如果改变已经发生了，你再对Promise对象添加回调函数，也会立即得到这个结果。

# Promise基本使用

### 基础语法介绍

```javascript
// 声明操作
const promise = new Promise(function(resolve, reject) {

  // 进行异步操作，例如setTimeout方法
  // 但当前位置代码还是在主线程上操作的
  console.log('do something');

  if (Date.now() % 2 === 0){
    // 成功回调
    resolve('success value');
  } else {
    // 失败回调
    reject('failed value');
  }
});

// 使用操作
promise.then(function(value) {
  // 成功回调
}, function(error) {
  // 失败回调，是可选的
});
```

### Promise代码执行顺序
```javascript
let promise = new Promise(function(resolved) {

  // new Promise() 本质上是调用构造函数的操作
  // 因此，下面代码会在函数执行时，就被调用
  console.log('Promise');

  // 调用resolved函数，将Promise中的resolved
  // 状态保存起来，待then时出发resolved状态
  resolved();
});

promise.then(function() {
  // 在下一个事件循环中被调用
  // 当前脚本所有同步任务执行完才会执行
  console.log('resolved.');
});

// 当前脚本的同步执行任务
console.log('Hi!');

// 打印内容
// Promise
// Hi!
// resolved
```

### Promise返回一个Promise结果
p1和p2都是 Promise 的实例，但是p2的resolve方法将p1作为参数，即一个异步操作的结果是返回另一个异步操作。

这时p1的状态就会传递给p2，也就是说，p1的状态决定了p2的状态。如果p1的状态是pending，那么p2的回调函数就会等待p1的状态改变；如果p1的状态已经是resolved或者rejected，那么p2的回调函数将会立刻执行。

```javascript

// 构造p1时，开始3s计时操作
const p1 = new Promise(function (resolve, reject) {
  setTimeout(() => reject(new Error('fail')), 3000)
});

// 构造p1时，开始1s计时操作
const p2 = new Promise(function (resolve, reject) {

  // 1s后，将p1结果保存下来
  // 由于p1是Promise对象，因此p1当前的状态确定了p2的状态，当前为pending状态
  // 2s后，p1返回reject状态，于是p2也返回了reject状态
  setTimeout(() => resolve(p1), 1000)
});

p2.then(result => console.log(result))
  .catch(error => console.log(error));

// 打印内容
// Error: fail

```

# Promise特性介绍

### Promise.prototype.then()介绍
then返回的作用是为 Promise 实例添加状态改变时的回调函数。

- then方法的第一个参数是resolved状态的回调函数，第二个参数（可选）是rejected状态的回调函数。
- then方法返回的是一个新的Promise实例（注意，不是原来那个Promise实例）。

```javascript
// then函数，将返回一个新的Promise实例
new Promise(function(resolved, reject) {
  // 构造Promise对象
  resolved('first');
}).then(() =>{
  // 返回一个Promise对象
  return Promise.reject('second');
}).then(() =>{
  // 相当于 Promise.reject('third');
  throw 'third'
}).then(null, () => {
  // 相当于 Promise.resolved('fourth');
  return 'fourth'
});
```

### Promise.prototype.catch()介绍
- Promise.prototype.catch方法是Promise.prototype.then(null, rejection)的别名，用于指定发生错误时的回调函数。
- Promise 对象的错误具有“冒泡”性质，会一直向后传递，直到被捕获为止。也就是说，错误总是会被下一个catch语句捕获。

一般在使用promise时，最好在后面添加catch操作。用catch来替代then(resolved, reject)的处理范式

```javascript
// 不推荐
promise
  .then(function(data) {
    // success
  }, function(err) {
    // error
  });

// 推荐，在promise最后统一处理error情况
promise
  .then(function(data) { //cb
    // success
  })
  .catch(function(err) {
    // error
  });
```

### Promise.prototype.finally()介绍
- finally方法用于指定不管 Promise 对象最后状态如何，都会执行的操作。
- finally方法的回调函数不接受任何参数，因此没有办法知道前面 Promise 状态到底是resolved还是rejected。

finally方法的本质如下：

```javascript
promise
.finally(() => {
  // 语句
});

// 等同于
promise
.then(
  result => {
    // 语句
    return result;
  },
  error => {
    // 语句
    throw error;
  }
);
```

# 常用静态方法

### Promise.all()
Promise.all方法用于将多个 Promise 实例，包装成一个新的 Promise 实例。

```javascript
const p = Promise.all([p1, p2, p3]);
```

上面代码中，Promise.all方法接受一个数组作为参数，p1、p2、p3都是 Promise 实例，如果不是，就会先调用下面讲到的Promise.resolve方法，将参数转为 Promise 实例，再进一步处理。

p的状态由p1、p2、p3决定，分成两种情况。

- 只有p1、p2、p3的状态都变成fulfilled，p的状态才会变成fulfilled，此时p1、p2、p3的返回值组成一个数组，传递给p的回调函数。
- 只要p1、p2、p3之中有一个被rejected，p的状态就变成rejected，此时第一个被reject的实例的返回值，会传递给p的回调函数。


### Promise.race()
Promise.race方法同样是将多个 Promise 实例，包装成一个新的 Promise 实例。

```javascript
const p = Promise.race([p1, p2, p3]);
```
上面代码中，Promise.all方法接受一个数组作为参数，p1、p2、p3都是 Promise 实例，如果不是，就会先调用下面讲到的Promise.resolve方法，将参数转为 Promise 实例，再进一步处理。

p的状态由以下条件决定。

- 只要p1、p2、p3之中有一个实例率先改变状态，p的状态就跟着改变。那个率先改变的 Promise 实例的返回值，就传递给p的回调函数。

### Promise.resolve() & Promise.reject()

Promise.resolve()的本质

```javascript
Promise.resolve(p);

// 等同于
Promise.resolve = function(p) {

	if (/** p 为 Promise实例 **/) {
		// 直接返回Promise实例
		return p;
	} else if (/** p 中存在有thenable属性 **/) {
		return new Promise(function(resolved, reject) {
			resolved(p.thenable());
		});
	} else if (/** p 存在 **/) {
		return new Promise(function(resolved, reject) {
			resolved(p);
		});
	} else { /** p 不存在 **/
		return new Promise(function(resolved, reject) {
			resolved();
		});
	}
}
```

Promise.reject()的本质

```javascript
const p = Promise.reject('出错了');

// 等同于
const p = new Promise((resolve, reject) => reject('出错了'))
```

# 参考
http://es6.ruanyifeng.com/#docs/promise#Promise-prototype-then

