---
title: 前端-Vue响应式原理
date: 2020-06-07 16:39:15
categories: 前端
---

## 核心概念

#### 数据代理

当你把一个普通的 JavaScript 对象传入 Vue 实例作为 data 选项，Vue 将遍历此对象所有的 property，并使用 [Object.defineProperty](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty) 把这些 property 全部转为 [getter/setter](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Guide/Working_with_Objects#%E5%AE%9A%E4%B9%89_getters_%E4%B8%8E_setters)。

#### 观察者模式

Vue 的响应式，核心机制是 **观察者模式**。

数据是被观察的一方，发生改变时，通知所有的观察者，这样观察者可以做出响应，比如，重新渲染然后更新视图。

#### 数据跟踪变化（MVVM模型）
Vue 中 data 的这些 getter/setter 对用户来说是不可见的，但是在内部它们让 Vue 能够追踪依赖，在 property 被访问和修改时通知变更。

![5de7af21d4c2de951720c006f84b98fc.png](/image/2AF4194F-6DA4-44A4-8746-09D237BEFDFF.png)

## 源码理解

简易版Vue源码：https://github.com/AbeDai/simply-vue

基本是从 Vue 代码中精简、改造得到的，主要保留了 Vue 中与双向数据绑定有关的部分

#### 监听数据变更

通过 Object.defineProperty() 替换配置对象属性的 set、get 方法，实现“拦截”

```js
// Vue 实例化过程
var vm = new Vue(/* ... */)

// 跟将传入的 data 进行响应式初始化相关的代码，在 "vue/src/core/instance/state.js" 文件中
observe(data) // 目的 是让传入的整个对象成为响应式

// 新建一个 dep 对象，与当前数据对应 
// 通过 Object.defineProperty() 重新定义对象属性，配置属性的 set、get，从而数据被获取、设置时可以执行 Vue 的代码
defineReactive(obj, key, value)
```

#### 建立依赖关系

watcher 在执行 getter 函数时触发数据的 get 方法，从而建立依赖关系

```js
// 构建Watcher对象
new Watcher(vm, userInfo, onUserInfoChange, {/* 略 */})

// 在 watcher 对象创建过程中，除了记录 vm、getter、cb 以及初始化各种属性外，最重要的就是调用了传入的 getter 函数
value = this.getter.call(vm, vm)

// 在 getter 函数的执行过程中，获取读取需要的数据，于是触发了前面通过 defineReactive() 配置的 get 方法。在 get 方法中触发 dep.depend() 来实现 watcher 与 dep 之间的关系建立
dep.depend()
```

最终关系如下：

![7163115ccff76f36150e48a9d1ff9c3a](/image/5E7E0A7B-DFD5-47D6-AE09-99E55D9F8EF3.png)

#### 数据更新分发至观察者

写入数据时触发 set 方法，从而借助 dep 发布通知，进而 watcher 进行更新

```js
// 更新数据会触发通过 defineReactive() 配置的 set 方法，如果数据改变
vm.name = 'tang'

// 通过 dep 对象来通知所有的依赖方法，于是 dep 遍历内部的 subs 执行
dep.notify()

// 这样 watcher 就被通知到了，知道了数据改变，从而继续后续的处理。
watcher.update()
```

## 参考

https://www.jianshu.com/p/4dff7c2cdaaa
https://www.jianshu.com/p/d3a15a1f94a0
https://github.com/luobotang/simply-vue
https://cn.vuejs.org/v2/guide/reactivity.html