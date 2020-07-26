---
title: 前端-JS中的宏任务和微任务
date: 2020-07-26 13:49:21
categories: 前端
---

## 运行机制

![e6dd78c74cb671dd9408c2273308a265](/image/D7234422-64CA-4BB7-9F5D-FBF60E112408.jpg)

- 执行一个宏任务（栈中没有就从事件队列中获取）
- 执行过程中如果遇到微任务，就将它添加到微任务的任务队列中
宏任务执行完毕后，立即执行当前微任务队列中的所有微任务（依次执行）
- 当前宏任务执行完毕，开始检查渲染，然后GUI线程接管渲染
- 渲染完毕后，JS线程继续接管，开始下一个宏任务（从事件队列中获取）

![d437562d6ea5874b3205701819bc1f27](/image/0F348294-16C0-4A58-A55F-AA462BAFF9B1.jpg)

#### 宏任务

```
script(整体代码)
setTimeout
setInterval
I/O
UI交互事件
postMessage
MessageChannel
setImmediate(Node.js 环境)
```

#### 微任务

```
Promise.then
Object.observe
MutaionObserver
process.nextTick(Node.js 环境)
```

#### 实例

```javascript
console.log("script do start")
setTimeout(()=>{
  console.log('setTimeout')
},0)
p = new Promise((resolve,reject)=>{
  console.log('Promise.do()')
  resolve()
})
p.then(()=>{
  console.log('Promise.then()')
})
console.log("script do end")

// 日志
script do start
Promise.do()
script do end
Promise.then()
setTimeout
```

#### await做了什么

从字面意思上看await就是等待，await 等待的是一个表达式，这个表达式的返回值可以是一个promise对象也可以是其他值。

很多人以为await会一直等待之后的表达式执行完之后才会继续执行后面的代码，实际上await是一个让出线程的标志。await后面的表达式会先执行一遍，将await后面的代码加入到microtask中，然后就会跳出整个async函数来执行后面的代码。

由于因为async await 本身就是promise+generator的语法糖。所以await后面的代码是microtask。

```javascript
async function async1() {
	console.log('async1 start');
	await async2();
	console.log('async1 end');
}
```

等价于

```javascript
async function async1() {
	console.log('async1 start');
	Promise.resolve(async2()).then(() => {
                console.log('async1 end');
        })
}
```

## 参考
https://zhuanlan.zhihu.com/p/78113300
https://juejin.im/post/5b498d245188251b193d4059
