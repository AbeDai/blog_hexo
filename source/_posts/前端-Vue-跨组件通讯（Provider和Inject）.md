---
title: 前端 - Vue 跨组件通讯（Provider和Inject）
date: 2020-07-26 22:36:46
categories: 前端
---

### 用法介绍

这对选项需要一起使用，以允许一个祖先组件向其所有子孙后代注入一个依赖，不论组件层次有多深，并在起上下游关系成立的时间里始终生效。

**provide 介绍**

选项应该是一个对象或返回一个对象的函数。该对象包含可注入其子孙的 property。

**inject 介绍**

- 一个字符串数组，或
- 一个对象，对象的 key 是本地的绑定名，value 是：
    - 在可用的注入内容中搜索用的 key (字符串或 Symbol)，或
    - 一个对象，该对象的：
        - from property 是在可用的注入内容中搜索用的 key (字符串或 Symbol)
        - default property 是降级情况下使用的 value

```javascript
// 父级组件提供 'foo'
var Provider = {
  provide: {
    oldFoo: 'bar'
  },
  // ...
}

// 子组件注入 'foo'
var Child = {
  inject: foo: { from: 'oldFoo', default: 'foo' },
  created () {
    console.log(this.foo) // => "bar"
  }
  // ...
}
```

### 原理分析

#### provide 浅析

创建组件时，调用 Vue 初始化方法（Vue.\_init）。

```javascript
// Vue 组件混入模式
function initMixin (Vue) {
  // Vue 组件初始化方法
  Vue.prototype._init = function (options) {
    var vm = this;
    ...
    // expose real self
    vm._self = vm;
    initInjections(vm); // resolve injections before data/props (处理注入数据逻辑)
    initState(vm);
    initProvide(vm); // resolve provide after data/props (处理提供数据逻辑)
    ...
  };
}

// 通过此方法将 provide 需要提供的数据挂载到 VM 的 _provided 属性上。
function initProvide (vm) {
  var provide = vm.$options.provide;
  if (provide) {
    vm._provided = typeof provide === 'function'
      ? provide.call(vm)
      : provide;
  }
}
```

#### inject 浅析

创建组件时，调用 Vue 初始化方法（Vue.\_init）。

```javascript
// Vue 组件混入模式
function initMixin (Vue) {
  // Vue 组件初始化方法
  Vue.prototype._init = function (options) {
    var vm = this;
    ...
    // expose real self
    vm._self = vm;
    initInjections(vm); // resolve injections before data/props (处理注入数据逻辑)
    initState(vm);
    initProvide(vm); // resolve provide after data/props (处理提供数据逻辑)
    ...
  };
}

// 寻找祖先组件中 provide 的对象，并将 数据挂载到 当前组件上。
function initInjections (vm) {
  // 从祖先组件中寻找inject所需的数据。
  var result = resolveInject(vm.$options.inject, vm);
  if (result) {
    toggleObserving(false);
    Object.keys(result).forEach(function (key) {
      /* istanbul ignore else */
      if (process.env.NODE_ENV !== 'production') {
        // 将数据挂载到 当前组件上
        defineReactive$$1(vm, key, result[key], function () {
          warn(
            "Avoid mutating an injected value directly since the changes will be " +
            "overwritten whenever the provided component re-renders. " +
            "injection being mutated: \"" + key + "\"",
            vm
          );
        });
      } else {
        // 将数据挂载到 当前组件上
        defineReactive$$1(vm, key, result[key]);
      }
    });
    toggleObserving(true);
  }
}

// 根据 $parent 递归寻找祖先组件中的元素，
function resolveInject (inject, vm) {
  if (inject) {
    var result = Object.create(null);
    var keys = hasSymbol
      ? Reflect.ownKeys(inject)
      : Object.keys(inject);

    for (var i = 0; i < keys.length; i++) {
      var key = keys[i];
      var provideKey = inject[key].from;// 处理 inject 的 from 属性逻辑
      var source = vm;
      while (source) {
        if (source._provided && hasOwn(source._provided, provideKey)) {
          result[key] = source._provided[provideKey];
          break
        }
        source = source.$parent;
      }
      if (!source) {
        // 处理 inject 的 default 函数逻辑
        if ('default' in inject[key]) {
          var provideDefault = inject[key].default;
          result[key] = typeof provideDefault === 'function'
            ? provideDefault.call(vm)
            : provideDefault;
        }
      }
    }
    return result
  }
}
```

### 参考

https://cn.vuejs.org/v2/api/#provide-inject
