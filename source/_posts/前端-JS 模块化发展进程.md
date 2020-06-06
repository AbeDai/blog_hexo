---
title: JS-模块化的发展进程
date: 2020-06-06 14:45:50
categories: 前端
---

## CommonJS 介绍

CommonJS规范加载模块是同步的，也就是说，只有加载完成，才能执行后面的操作。Node.js是社区CommonJS最热门的实现。

示例如下：

```js
// 声明 math.js 函数
exports.area = function (r) {
  return Math.PI * r * r;
};
exports.circumference = function (r) {
  return 2 * Math.PI * r;
};

// commonjs 使用 math.js 中的函数
const math = require('math');
math.area(3);
```

## AMD 介绍

AMD规范则是非同步加载模块，允许指定回调函数。由于浏览器环境，模块需要从服务器端加载，这时就必须采用非同步模式，因此浏览器端一般采用AMD规范。

目前，主要有两个Javascript库来实现AMD规范：[require.js](https://requirejs.org/) 和 [curl.js](https://github.com/cujojs/curl) 。

示例如下：

```js
// 声明 math.js 函数
define(function (){
　　var add = function (x,y){
　　　　return x+y;
　　};
　　return {
　　　　add: add
　　};
});

// require.js 使用 math.js 中的函数
require(['math'], function (math){
　　alert(math.add(1,1));
});
```

## ES Module 介绍

Node.js 长期使用 CommonJS 标准，浏览器长期使用 AMD 标准。 ES Modules 是用于处理模块的 ECMAScript 标准。 算是 CommonJS 与 AMD 的大一统处理方式。也是目前来讲最推荐的模块使用方法。

```js
// 声明 uppercase.js 函数
export default str => str.toUpperCase();

// ES Module 使用 uppercase 函数
import uppercase from 'uppercase';
uppercase("AaBbCc");
```

## 参考

http://www.ruanyifeng.com/blog/2012/10/javascript_module.html
http://www.ruanyifeng.com/blog/2012/10/asynchronous_module_definition.html
http://www.ruanyifeng.com/blog/2012/11/require_js.html
