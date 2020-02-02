---
title: 前端-Vue中的过渡与动画知识
date: 2020-02-02 16:54:20
categories: 前端
---

Vue中的过渡、动画技术，只是对CSS的过渡、动画技术的补充。原本通过CSS的过渡、动画，已经基本能完成所有的动画需求了。而，引入Vue 过渡、动画技术，是为了更好的在Vue中使用CSS的过渡、动画技术。

## 过渡

1. **v-enter**：定义进入过渡的开始状态。
2. **v-enter-active**：定义进入过渡生效时的状态。在整个进入过渡的阶段中应用，在元素被插入之前生效，在过渡完成之后移除。这个类可以被用来定义进入过渡的过程时间，延迟和曲线函数。
3. **v-enter-to**: 定义进入过渡的结束状态。
4. **v-leave**: 定义离开过渡的开始状态。
5. **v-leave-active**：定义离开过渡生效时的状态。在整个离开过渡的阶段中应用，在离开过渡被触发时立刻生效，在过渡完成之后移除。这个类可以被用来定义离开过渡的过程时间，延迟和曲线函数。
6. **v-leave-to**: 定义离开过渡的结束状态。

![5990c1dff7dc7a8fb3b34b4462bd0105](/image/92CC791D-63A4-4434-87EE-AE6E71BAEAD0.png)

#### 举例说明

![d19917d50499beae982fd014a80b22c5](/image/2020-02-01 20-48-22.2020-02-01 20_49_27.gif)

```html
<template>
  <div>
    <button @click="show = !show">过渡效果</button>
    <transition name="slide-fade">
      <p v-if="show">hello</p>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'Transitions',
  data: function() {
    return {
      show: true
    }
  }
}
</script>

<style scoped>
.slide-fade-enter-active {
  transition-property: all;
  transition-duration: 0.3s;
  transition-timing-function: ease;
}
.slide-fade-leave-active {
  transition-property: all;
  transition-duration: 0.8s;
  transition-timing-function: cubic-bezier(1, 0.5, 0.8, 1);
}
.slide-fade-enter,
.slide-fade-leave-to {
  transform: translateX(10px);
  opacity: 0;
}
</style>
```

## 动画

CSS 动画用法同 CSS 过渡。

#### 举例说明

![b8f44bbd331f0916f260feb788114640](/image/2020-02-01 21-09-21.2020-02-01 21_10_43.gif)

```html
<template>
  <div>
    <button @click="show = !show">动画效果</button>
    <transition name="bounce">
      <p v-if="show">Vue是一套用于构建用户界面的渐进式框架。</p>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'Transitions',
  data: function() {
    return {
      show: true
    }
  }
}
</script>

<style scoped>
.bounce-enter-active {
  animation-name: bounce-in;
  animation-duration: 0.5s;
}
.bounce-leave-active {
  animation-name: bounce-out;
  animation-duration: 0.5s;
}
@keyframes bounce-in {
  0% {
    transform: scale(0);
  }
  50% {
    transform: scale(1.5);
  }
  100% {
    transform: scale(1);
  }
}
@keyframes bounce-out {
  0% {
    transform: scale(1);
  }
  100% {
    transform: scale(0);
  }
}
</style>
```

## 自定义过渡/动画的类名

通过以下属性，进行自定义过渡类名，对照【过度的类名】

- enter-class: 对应 v-enter
- enter-active-class: 对应 v-enter-active
- enter-to-class: 对应 v-enter-to
- leave-class: 对应 v-leave
- leave-active-class: 对应 v-leave-active
- leave-to-class: 对应 v-leave-to

#### 举例说明

![d0d9a5ffed45f2bc9007e92d3b988dc0](/image/2020-02-01 21-25-18.2020-02-01 21_26_07.gif)

```html
// 本例依赖Animate.css动画库，请在HTML中另外引入
<link href="https://cdn.jsdelivr.net/npm/animate.css@3.5.1" rel="stylesheet" type="text/css">
```

```html
<template>
  <div>
    <button @click="show = !show">动画效果</button>
    <transition
      name="bounce"
      enter-active-class="animated tada"
      leave-active-class="animated bounceOutRight"
    >
      <span v-if="show"></span>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'Transitions',
  data: function() {
    return {
      show: true
    }
  }
}
</script>

<style scoped>
span {
  display: block;
  height: 20px;
  width: 20px;
  background-color: red;
  margin-left: auto;
  margin-right: auto;
  margin-top: 20px;
}
</style>
```

## 过渡/动画 的 JavaScript 钩子

通过暴露出来的钩子，我们可以监听 过渡/动画 触发的时机，也可以直接通过JavaScript来完成动画效果。

- before-enter：function(el) {} - 元素显示之前调用。
- enter：function(el, done) {} - 元素显示中调用，在这里通过JavaScript完成动画效果。
- after-enter：function(el) {} - 元素显示后调用。
- enter-cancelled：function(el) {} - 元素显示操作取消调用。
- before-leave：function(el) {} - 元素消失之前调用。
- leave：function(el, done) {} - 元素消失中调用，在这里通过JavaScript完成动画效果。
- after-leave：function(el) {} - 元素消失后调用。
- leave-cancelled：function(el) {} - 元素消失操作取消调用。

**参数说明**

- el：执行动画的元素
- done：动画执行完毕时的回调。当用 JavaScript 过渡的时候，在 enter 和 leave 中必须使用 done 进行回调。否则，它们将被同步调用，过渡会立即完成。

#### 举例说明

![cabc5ae31ed792231e130080cb0e91f1](/image/2020-02-01 22-27-05.2020-02-01 22_28_22.gif)

```html
// 本例依赖Velocity.js动画库
npm install velocity-animate
```

```html
<template>
  <div>
    <button @click="show = !show">动画效果</button>
    <transition
      v-on:before-enter="beforeEnter"
      v-on:enter="enter"
      v-on:leave="leave"
      v-bind:css="false"
    >
      <div v-if="show">vue</div>
    </transition>
  </div>
</template>

<script>
import Velocity from 'velocity-animate'

export default {
  name: 'Transitions',
  data: function() {
    return {
      show: true
    }
  },
  methods: {
    beforeEnter: function(el) {
      el.style.opacity = 0
    },
    enter: function(el, done) {
      Velocity(el, { opacity: 1, fontSize: '1em' }, { duration: 800 })
      Velocity(el, {}, { complete: done })
    },
    leave: function(el, done) {
      Velocity(el, { translateX: '15px', rotateZ: '50deg' }, { duration: 600 })
      Velocity(el, { rotateZ: '100deg' }, { loop: 2 })
      Velocity(el, { opacity: 0 }, { complete: done })
    }
  }
}
</script>

<style scoped>
</style>
```

## 列表过渡

使用 <transition-group> 组件，同时渲染整个列表。拥有一下几个特点:

- 以一个真实元素呈现：默认为一个 <span>。你也可以通过 tag 属性 更换为其他元素。
- 内部元素 总是需要 提供唯一的 key 属性值。
- 过渡操作将会应用在内部的元素中，而不是这个组/容器本身。

> 自定义属性类名，JavaScript 操作元素实现动画效果用法同之前一样，不特殊介绍。

#### 举例说明

![34acd7418a825b78e05feb22f5980118](/image/2020-02-02 16-12-57.2020-02-02 16_14_11.gif)

```html
<template>
  <div>
    <button v-on:click="add">Add</button>
    <button v-on:click="remove">Remove</button>
    <transition-group name="list" tag="p">
      <span v-for="item in items" v-bind:key="item" class="list-item">{{ item }}</span>
    </transition-group>
  </div>
</template>

<script>
export default {
  name: 'Transitions',
  data: function() {
    return {
      items: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      nextNum: 10
    }
  },
  methods: {
    randomIndex: function() {
      return Math.floor(Math.random() * this.items.length)
    },
    add: function() {
      this.items.splice(this.randomIndex(), 0, this.nextNum++)
    },
    remove: function() {
      this.items.splice(this.randomIndex(), 1)
    }
  }
}
</script>

<style scoped>
.list-item {
  display: inline-block;
  margin-right: 10px;
}
.list-enter-active,
.list-leave-active {
  transition: all 1s;
}
.list-enter, .list-leave-to
/* .list-leave-active for below version 2.1.8 */ {
  opacity: 0;
  transform: translateY(30px);
}
</style>
```

## 灵活使用过渡效果

Vue的核心思想是数据驱动。过渡自然也是数据驱动的。不断切换数据
将过渡与数据驱动相结合，通过不断切换数据来出发你预先设置好的过渡。能够以灵活的方式来实现任何动画。

#### 举例说明

![35221b38a2c55bcad5ae0d44c8e5a7a5](/image/2020-02-02 16-33-04.2020-02-02 16_33_58.gif)

```html
<template>
  <div>
    <transition name="blink" v-on:after-enter="afterEnter" v-on:after-leave="afterLeave">
      <p v-if="show">闪烁吧</p>
    </transition>
    <button v-if="stop" v-on:click="stop = false; show = false">启动动画</button>
    <button v-else v-on:click="stop = true">停止动画</button>
  </div>
</template>

<script>
export default {
  name: 'Transitions',
  data: function() {
    return {
      show: true,
      stop: true
    }
  },
  methods: {
    afterEnter() {
      if (!this.stop) {
        this.show = false
      }
    },
    afterLeave() {
      this.show = true
    }
  }
}
</script>

<style scoped>
.blink-enter-active,
.blink-leave-active {
  transition: opacity 0.6s ease;
}
.blink-enter,
.blink-leave-to {
  opacity: 0;
}
</style>
```

## 参考

https://cn.vuejs.org/v2/guide/transitions.html【以上内容为官方文档的要点摘录】
http://blog.daiyibo.cn/2020/01/31/前端-动画、过渡用法介绍/
