---
title: Node-JS中原型的理解
date: 2018-11-10 23:43:24
categories: 后台
---

# prototype与\_\_proto\_\_的区别

### 概念介绍

1. 所有对象都具有\_\_proto\_\_属性。在JS中，一切皆对象。方法（Function）是对象，方法的原型(Function.prototype)也是对象，因此它们都有\_\_proto\_\_属性。
2. 方法(Function)是一个特殊的对象，它除了有\_\_proto\_\_属性之外，还有自己特有的prototype属性。prototype属性指向一个所有实例共享的原型对象。原型对象中有一个constructor属性，指回到原函数。
3. 对象的\_\_proto\_\_属性指向该对象的构造函数的prototype属性，这保证了对象能够访问构造函数的prototype属性中定义的属性和方法。

### 举例分析

![原型链图](/image/js_prototype.jpg)

1. 构造函数（Foo()）
	- 构造函数的Foo.prototype属性指向了原型对象，在原型对象里有共有方法，所有构造函数声明的实例（f1，f2）都可以共享这些共用方法。
	- 构造函数也是对象，也有\_\_proto\_\_属性。指向谁呢？指向它的构造函数的原型对象呗。函数的构造函数不就是Function嘛，因此这里的\_\_proto\_\_指向了Function.prototype。
2. 原型对象（Foo.prototype）
	- 原型对象Foo.prototype保存着实例共享的方法，还有属性constructor指回构造函数。
3. 实例（f1，f2）
	- f1，f2是Foo的两个实例，这两个对象有属性\_\_proto\_\_，指向构造函数的原型对象，这样就可以访问原型对象的所有方法啦。

**总结**

1. 对象有属性\_\_proto\_\_，指向该对象的构造函数的原型对象。
2. 方法除了有属性\_\_proto\_\_,还有属性prototype，prototype指向该方法的原型对象。



# new操作到底做了什么？

```javascript
 
let obj = new Base();

// 本质上等价于
// 我们创建了一个空对象obj
let obj  = {}; 
// 我们将这个空对象的__proto__成员指向了Base函数对象prototype成员对象
obj.__proto__ = Base.prototype;
// 我们将Base函数对象的this指针替换成obj，并调用Base方法对obj进行初始化
Base.call(obj);
 
```

# 为啥constructor指向会错乱?

```javascript
function F(){};
var p1 = new F();
F.prototype = {};
var p2 = new F()
console.log(p1.constructor)//F
console.log(p2.constructor)//Object
```
 
首先你要明白，F.prototype 是对一个实例对象的引用，这个实例对象在你创建函数 F( ) 的时候同时被生成，如果我们给这个对象起个名字叫做 A，那么我们可以简单的理解为：A 是一个被存储在内存中的一个实例对象，而 F.prototype 是指向 A 的一个指针。

同时，A 对象内也有一个指针 constructor ，它指向了函数 F()。

那么当你第一次使用 new F( ) 时，生成了一个新对象 a ，p1 是对象 a 的一个引用（即p是指向a的一个指针），而 a 的 \_\_proto\_\_ 属性在此时也已经被指向为 A。

即目前，指向对象实例 A 的指针有两个，分别是 a.\_\_proto\_\_ 和 F.prototype。

之后你对 F.prototype 进行赋值时，实际上改变了 F.prototype 的指向，试他指向了另一个个实例对象{}，我们管这个实例对象叫 B 好了，对于这个实例对象 B，它的 constructor 的属性指向了 Object。

请注意，此时 a 的 \_\_proto\_\_ 的指向并没有改变，仍是指向了实例对象A。

那么当你第二次调用 new F( ) 的时候，实际上生成了另一个新的实例对象 b, b 的 \_\_proto\_\_ 属性指向的是B。

所以在 p1.constructor 的背后其实是相当于:
p1 -> a, a.\_\_proto\_\_ -> A, A.constructor -> F( )

而在 p2.constructor 的背后则为：
p2 -> b, b.\_\_proto\_\_ -> B, B.constructor -> Object( )

![Construct指向图](/image/js_construct.png)

# 参考
- https://segmentfault.com/q/1010000006918070
- https://www.zhihu.com/question/34183746
