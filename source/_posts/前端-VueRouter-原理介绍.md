---
title: 前端- VueRouter 原理介绍
date: 2020-10-05 15:46:37
categories: 前端
---
### VueRouter在H5中的集中模式

![ba1131a9dfb2cca3811cc0a9c029bea7](/image/25ECCB6E-C7FC-4478-940C-7FCF2B852AD8.png)

VueRouter在网页中，主要有两种模式，分别是 `Hash模式` 和 `History模式`。

- **Hash模式**：即浏览器url中#后面的内容，包含#。hash是URL中的锚点，代表的是网页中的一个位置，单单改变#后的部分，浏览器只会加载相应位置的内容，不会重新加载页面。
- **History模式**：HTML5 History API提供了一种功能，能让开发人员在不刷新整个页面的情况下修改站点的URL，就是利用 history.pushState API 来完成 URL 跳转而无须重新加载页面。

### VueRouter 函数执行流程

![67b5b575ba1ef603edd7825788c65501](/image/AC4A1CE8-D263-45C1-A4E7-4F51C09B8420.jpg)

#### HashHistory push 流程分析

在`VueRouter`中是通过mode这一参数控制路由的实现模式的：

```javascript
const router = new VueRouter({
  mode: 'hash',
  routes: [...]
})
```

创建`VueRouter`的实例对象时，`mode`以构造函数参数的形式传入。带着问题阅读源码，我们就可以从`VueRouter`类的定义入手。一般插件对外暴露的类都是定义在源码`src`根目录下的`index.js`文件中，打开该文件，可以看到`VueRouter`类的定义，摘录与`mode`参数有关的部分如下：

```javascript
export default class VueRouter {
  
  mode: string; // 传入的字符串参数，指示history类别
  history: HashHistory | HTML5History | AbstractHistory; // 实际起作用的对象属性，必须是以上三个类的枚举
  fallback: boolean; // 如浏览器不支持，'history'模式需回滚为'hash'模式
  
  constructor (options: RouterOptions = {}) {
    
    let mode = options.mode || 'hash' // 默认为'hash'模式
    this.fallback = mode === 'history' && !supportsPushState // 通过supportsPushState判断浏览器是否支持'history'模式
    if (this.fallback) {
      mode = 'hash'
    }
    if (!inBrowser) {
      mode = 'abstract' // 不在浏览器环境下运行需强制为'abstract'模式
    }
    this.mode = mode

    // 根据mode确定history实际的类并实例化
    switch (mode) {
      case 'history':
        this.history = new HTML5History(this, options.base)
        break
      case 'hash':
        this.history = new HashHistory(this, options.base, this.fallback)
        break
      case 'abstract':
        this.history = new AbstractHistory(this, options.base)
        break
      default:
        if (process.env.NODE_ENV !== 'production') {
          assert(false, `invalid mode: ${mode}`)
        }
    }
  }

  init (app: any /* Vue component instance */) {
    
    const history = this.history

    // 根据history的类别执行相应的初始化操作和监听
    if (history instanceof HTML5History) {
      history.transitionTo(history.getCurrentLocation())
    } else if (history instanceof HashHistory) {
      const setupHashListener = () => {
        history.setupListeners()
      }
      history.transitionTo(
        history.getCurrentLocation(),
        setupHashListener,
        setupHashListener
      )
    }

    history.listen(route => {
      this.apps.forEach((app) => {
        app._route = route
      })
    })
  }

  // VueRouter类暴露的以下方法实际是调用具体history对象的方法
  push (location: RawLocation, onComplete?: Function, onAbort?: Function) {
    this.history.push(location, onComplete, onAbort)
  }

  replace (location: RawLocation, onComplete?: Function, onAbort?: Function) {
    this.history.replace(location, onComplete, onAbort)
  }
}
```

可以看出：

1. 作为参数传入的字符串属性`mode`只是一个标记，用来指示实际起作用的对象属性`history`的实现类，两者对应关系如下：

    > - history: HTML5History
    > - hash: HashHistory
    > - abstract: AbstractHistory

2. 在初始化对应的`history`之前，会对`mode`做一些校验：若浏览器不支持`HTML5History`方式（通过`supportsPushState`变量判断），则`mode`强制设为`'hash'`；若不是在浏览器环境下运行，则mode强制设为`'abstract'`

3. `VueRouter`类中的`onReady()`, `push()`等方法只是一个代理，实际是调用的具体`history`对象的对应方法，在`init()`方法中初始化时，也是根据`history`对象具体的类别执行不同操作

在浏览器环境下的两种方式，分别就是在`HTML5History`，`HashHistory`两个类中实现的。他们都定义在`src/history`文件夹下，继承自同目录下`base.js`文件中定义的`History`类。`History`中定义的是公用和基础的方法，直接看会一头雾水，我们先从`HashHistory`类中看着亲切的`push()`, `replace()`方法的说起。

##### HashHistory.push()

我们来看`HashHistory`中的`push()`方法：

```javascript
push (location: RawLocation, onComplete?: Function, onAbort?: Function) {
  this.transitionTo(location, route => {
    pushHash(route.fullPath)
    onComplete && onComplete(route)
  }, onAbort)
}

function pushHash (path) {
  window.location.hash = path
}
```

`transitionTo()`方法是父类中定义的是用来处理路由变化中的基础逻辑的，`push()`方法最主要的是对`window`的`hash`进行了直接赋值：

```javascript
window.location.hash = route.fullPath
```

`hash`的改变会自动添加到浏览器的访问历史记录中。

那么视图的更新是怎么实现的呢，我们来看父类`History`中`transitionTo()`方法的这么一段：

```javascript
transitionTo (location: RawLocation, onComplete?: Function, onAbort?: Function) {
  const route = this.router.match(location, this.current)
  this.confirmTransition(route, () => {
    this.updateRoute(route)
    ...
  })
}

updateRoute (route: Route) {
  this.cb && this.cb(route)
}

listen (cb: Function) {
  this.cb = cb
}
```

可以看到，当路由变化时，调用了`History`中的`this.cb`方法，而`this.cb`方法是通过`History.listen(cb)`进行设置的。回到`VueRouter`类定义中，找到了在`init()`方法中对其进行了设置：

```javascript
init (app: any /* Vue component instance */) {
  this.apps.push(app)
  history.listen(route => {
    this.apps.forEach((app) => {
      app._route = route
    })
  })
}
```

根据注释，`app`为`Vue`组件实例，但我们知道`Vue`作为渐进式的前端框架，本身的组件定义中应该是没有有关路由内置属性`_route`，如果组件中要有这个属性，应该是在插件加载的地方，即`VueRouter`的`install()`方法中混合入`Vue`对象的，查看`install.js`源码，有如下一段：

```javascript
export function install (Vue) {
  
  Vue.mixin({
    beforeCreate () {
      if (isDef(this.$options.router)) {
        this._router = this.$options.router
        this._router.init(this)
        Vue.util.defineReactive(this, '_route', this._router.history.current)
      }
      registerInstance(this, this)
    },
  })
}
```

通过`Vue.mixin()`方法，全局注册一个混合，影响注册之后所有创建的每个 `Vue` 实例，该混合在`beforeCreate`钩子中通过`Vue.util.defineReactive()`定义了响应式的`_route`属性。所谓响应式属性，即当`_route`值改变时，会自动调用Vue实例的`render()`方法，更新视图。

总结一下，从设置路由改变到视图更新的流程如下：

```javascript
$router.push() --> HashHistory.push() --> History.transitionTo() --> History.updateRoute() --> {app._route = route} --> vm.render()
```

#### HashHistory 监听地址栏变化

除此之外在浏览器中，用户还可以直接在浏览器地址栏中输入改变路由，因此`VueRouter`还需要能监听浏览器地址栏中路由的变化，并具有与通过代码调用相同的响应行为。在`HashHistory`中这一功能通过`setupListeners`实现：

```javascript
setupListeners () {
  window.addEventListener('hashchange', () => {
    if (!ensureSlash()) {
      return
    }
    this.transitionTo(getHash(), route => {
      replaceHash(route.fullPath)
    })
  })
}
```

该方法设置监听了浏览器事件`hashchange`，调用的函数为`replaceHash`，即在浏览器地址栏中直接输入路由相当于代码调用了`replace()`方法。

### 参考

https://zhuanlan.zhihu.com/p/27588422
