---
title: 前端-Vue组件生命周期
date: 2020-01-01 08:48:17
categories: 前端
---

## Vue生命周期

<img width="900" src="/image/vue_lifecycle.png">

## 组件实例化期

**组件创建前后**
- beforeCreate：在实例初始化之后，数据观测 (data observer) 和 event/watcher 事件配置之前被调用。
- create：在实例创建完成后被立即调用。在这一步，实例已完成以下的配置：数据观测 (data observer)，属性和方法的运算，watch/event 事件回调。然而，挂载阶段还没开始，$el 属性目前不可见。

**组件挂载前后**
- beforeMount：在挂载开始之前被调用：相关的 render 函数首次被调用。$el 属性已经可见，但还是原来的 DOM，并非是新创建的。
- mounted：el 被新创建的 vm.$el 替换，并挂载到实例上去之后调用该钩子。如果 root 实例挂载了一个文档内元素，当 mounted 被调用时 vm.$el 也在文档内。

## 组件存在期

**组件数据更新前后**
- beforeUpdate：数据更新时，虚拟 DOM 变化之前调用，这里适合在更新之前访问现有的 DOM，比如手动移除已添加的事件监听器。
- updated：数据更新和虚拟 DOM 变化之后调用。

## 销毁期

**组件销毁前后**
- beforeDestroy：实例销毁之前调用，在这一步，实例仍然完全可用。一般在这里移除事件监听器、定时器等，避免内存泄漏。
- destroyed：Vue 实例销毁后调用。调用后，Vue 实例指示的所有东西都会解绑定，所有的事件监听器会被移除，所有的子实例也会被销毁。


## 参考
https://juejin.im/post/5cde19cee51d453a572aa307
https://cn.vuejs.org/v2/guide/instance.html#%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E5%9B%BE%E7%A4%BA
