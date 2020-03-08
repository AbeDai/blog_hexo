---
title: 前端-关于Vue组件的所有知识点
date: 2020-03-08 20:16:05
categories: 前端
---
## 组件注册

#### 组件命名建议

组件文件命名：建议采用大驼峰写法。例如：MyComponent.vue。
组件名：建议采用大驼峰写法。例如：MyComponent。
使用组件：建议采用全小写加连字符。Vue自动完成加MyComponent转成my-component。例如：my-component。

#### 全局注册

全局注册之后的组件可以在任何新创建的 Vue 根实例中使用。

```js
// 全局注册
import ComponentA from './ComponentA.vue'
Vue.component('ComponentA', ComponentA)

// template
<component-a></component-a>
```

#### 局部注册

局部注册之后的组件，只在当前单文件中可用，其他页面需要重新注册。

```js
// 局部注册
import ComponentA from './ComponentA.vue'
export default {
  components: {
    'ComponentA': ComponentA
  }
}

// template
<component-a></component-a>
```

#### 组件this上下文说明

组件的method、data、props中的属性，可以直接在this中使用。Vue框架，主动将这些属性提取到this对象下，来方便开发者使用。

![67a9c2b6e0c6b18bbd608add883bfb12](/image/3C9F785A-1C77-4F11-87C2-728ECE78481C.png)

## 组件交互

#### 组件属性-Prop
通常你希望每个 prop 都有指定的值类型。这时，你可以以对象形式列出 prop，这些属性的名称和值分别是 prop 各自的名称和类型：
- **声明写法**：通过驼峰写法进行属性声明，通过短横线分隔写法来进行属性使用。因为在html中标签为大小写不敏感。
- **属性声明**：Vue支持使用Array、Object两种方式声明属性。通常推荐使用 Object 方式列出属性，这些属性的名称和值分别是 prop 各自的名称和类型，为属性声明提供了自校验功能。
- **属性使用**：传递静态值时，值为String类型，例如 <my-comp prop1="string"/>。传递动态值时，内容为可执行的JS代码，this指向组件本身，例如 <my-comp v-bind:prop1="Number(100)" />。
- **单向数据流**：父级 prop 的更新只能会向下流动到子组件中。这样能防止从子组件意外改变父级组件的状态，从而导致你的应用的数据流向难以理解。不应该在子组件内部改变 prop，如果你这样做了，Vue 会在浏览器的控制台中发出警告。
- **非 Prop 的 Attribute**：一个非 prop 的 attribute 是指传向一个组件，但是该组件并没有相应 prop 定义的 attribute。此时，非 prop 属性会透传给组件的根元素。[解释](https://segmentfault.com/a/1190000010699647)

##### 示例

![193fd73fcc7c50312ac79513562a6d20](/image/BE72FB2D-1CB9-4977-94C8-C6AABB59DD86_1.png)

```html
// 外部组件
<template>
  <div>
    <!-- 静态赋值：默认 传入字符串 -->
    <!-- 动态赋值：通过 `v-bind` 来告诉 Vue 这是一个 JavaScript 表达式而不是一个字符串。this指向当前组件实例 -->
    <!-- 非 Prop 的 Attribute「这里指`class="no-prop-attr-class"`」，会透传给my-comp的根元素，达到设置class的效果。 -->
    <my-comp
      class="no-prop-attr-class"
      v-bind:pBoolean="Boolean()"
      v-bind:pFunction="showConsole"
      pNumberOrString="数字 | 字符串"
      v-bind:pString="dString"
      v-bind:pObject="{ title: '标题', object1 : '对象元素1' , object2 : '对象元素2' }"
    />
  </div>
</template>

<script>
import MyComp from './MyComp.vue'

export default {
  components: {
    MyComp
  },
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data: function() {
    return {
      dString: '字符串'
    }
  },
  methods: {
    showConsole: function(e) {
      console.log('click: ' + e)
    }
  }
}
</script>

// 自定义组件
<template>
  <div>
    <table border="1">
      <tr>
        <th>属性</th>
        <th>内容</th>
      </tr>
      <tr>
        <td>data.title</td>
        <td>{{title}}</td>
      </tr>
      <tr>
        <td>props.pBoolean</td>
        <td>{{pBoolean}}</td>
      </tr>
      <tr>
        <td>props.pNumberOrString</td>
        <td>{{pNumberOrString}}</td>
      </tr>
      <tr>
        <td>props.pString</td>
        <td>{{pString}}</td>
      </tr>
      <tr>
        <td>props.pArray</td>
        <td>
          <div style="display:flex; align-items: center; flex-direction: column;">
            <div style="display:flex; align-items:start; flex-direction: column;">
              <span v-for="(p, index) in pArray" v-bind:key="index">- {{ p }}</span>
            </div>
          </div>
        </td>
      </tr>
      <tr>
        <td>props.pObject</td>
        <td>
          <div>
            <div style="display:flex; align-items:start; margin-left:16px; margin-right:16px;">
              <span
                v-for="(key, index) in Object.keys(pObject)"
                v-bind:key="index"
              >- {{ key }} : {{ pObject[key] }}</span>
            </div>
          </div>
        </td>
      </tr>
      <tr>
        <td>pFunction</td>
        <td>
          <span v-on:click="click">点击触发外部方法</span>
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  name: 'MyComp',
  // 属性声明
  props: {
    // 基础的类型检查
    pBoolean: Boolean,
    pFunction: Function,
    // 多种可能的类型
    pNumberOrString: [String, Number],
    // 必填的字符串
    pString: {
      type: String,
      required: true
    },
    // 带有默认值的数字
    pArray: {
      type: Array,
      default: function() {
        return ['array1', 'array2']
      }
    },
    // 带有校验功能的对象
    pObject: {
      type: Object,
      validator: function(value) {
        if (!!value && !!value['title']) {
          return true
        }
        return false
      }
    }
  },
  data: function() {
    return {
      title: this.pObject.title
    }
  },
  methods: {
    click: function() {
      // 触发外部方法
      this.pFunction(new Date().toString())
    }
  }
}
</script>

<style scoped>
tr th table {
  color: black;
  font-size: 22px;
  margin-top: 20px;
  padding: 8px;
  padding-left: 16px;
  padding-right: 16px;
  background-color: oldlace;
}
</style>
```

#### 组件自定义事件

- **事件名写法**：事件名不存在任何自动化的大小写转换。触发的事件名需要完全匹配事件所用的名称。为了避免html自动将驼峰写法转成全小写。事件名建议始终使用短横线分隔写法。

##### 示例

![9b725e429e53a6eea8beb8a919b60a8f](/image/WX20200301-213836@2x.png)

```html
// 外部组件
<template>
  <div>
    <!-- show-alert：事件推荐短横线分隔写法 -->
    <!-- update:string这：专门用于变更外部数据 -->
    <my-comp
      v-bind:pString="dString"
      v-on:update:string="dString = $event"
      v-on:show-alert="showAlert"
    />
  </div>
</template>

<script>
import MyComp from './MyComp.vue'

export default {
  components: {
    MyComp
  },
  name: 'HelloWorld',
  props: {
    msg: String
  },
  data: function() {
    return {
      dString: Date().toString()
    }
  },
  methods: {
    showAlert: function(e) {
      alert(e)
    }
  }
}
</script>

// 自定义组件
<template>
  <div>
    <table border="1">
      数据：{{pString}}
      <tr>
        <td>调用外部弹框写法模板</td>
        <td v-on:click="click1">触发弹框</td>
      </tr>
      <tr>
        <td>数据更新写法模板</td>
        <td v-on:click="click2">触发更新</td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  name: 'MyComp',
  props: {
    pString: String
  },
  methods: {
    click1: function() {
      this.$emit('show-alert', Date().toString())
    },
    click2: function() {
      this.$emit('update:string', Date().toString())
    }
  }
}
</script>

<style scoped>
tr th table {
  color: black;
  font-size: 22px;
  margin-top: 20px;
  padding: 8px;
  padding-left: 16px;
  padding-right: 16px;
  background-color: oldlace;
}
</style>
```

#### 组件插槽

插槽，`<slot>`元素作为承载内容分发的出口。通过`<slot>`元素，可以实现在组件外部添加自定义布局至自定义组件指定位置。

> 插槽，类似于对Android中往ViewGroup中添加View的一个抽象。从技术角度上，将addView的使用场景抽象成了Slot。极大地为视图开发工作提效。

- **插槽作用域**：该插槽跟模板的其它地方一样可以访问相同的实例属性，而不能访问组件的作用域。
- **后备内容**：在没有提供Slot内容的时候，渲染后备内容。
- **具名插槽**：在自定义组件需要使用多个插槽时，可以利用具名插槽渲染多个插槽。默认插槽的名字为default。声明：`<slot name="solt:name" />`。具名插槽的使用需要和templete结合使用：`<template v-slot:solt:name />`。
- **插槽Prop**：扩展插槽作用域，建立插槽与自定义组件之间的数据通道，让插槽内容能够访问子组件中才有的数据。声明：`<slot v-bind:user="user">`。使用：`<template v-slot:default="slotProps">`。

##### 示例

![5351eea7ff55b458ce1ef41bb909e37d](/image/WX20200302-225541@2x.png)

```html
// 插槽外部使用
<template>
  <div>
    <!-- show-alert：事件推荐短横线分隔写法 -->
    <!-- update:string这：专门用于变更外部数据 -->
    <my-comp>
      <template v-slot:default>
        <span>此为插槽默认用法</span>
      </template>
      <template v-slot:name>
        <span>此为具名插槽</span>
      </template>
      <template v-slot:scope>
        <span>{{soltString}}</span>
      </template>
      <template v-slot:[soltOrder]>
        <span>此为动态插槽名举例</span>
      </template>
      <!-- 插槽属性 -->
      <template v-slot:prop="slotProps">
        <div class="flex-center">
          <span
            v-bind:key="index"
            v-for="(key, index) in Object.keys(slotProps)"
          >属性: {{ slotProps[key] }}</span>
        </div>
      </template>
    </my-comp>
  </div>
</template>

<script>
import MyComp from "./MyComp.vue";

export default {
  components: {
    MyComp
  },
  name: "App",
  data: function() {
    return {
      soltString: "插槽作用域为实例属性",
      soltOrder: "order"
    };
  }
};
</script>

<style scoped>
.flex-center {
  display: flex;
  flex-direction: column;
}
</style>

// 自定义组件声明插槽
<template>
  <div>
    <table border="1">
      <tr>
        <td>默认插槽</td>
        <td>
          <!-- default表示默认插槽，可不写 -->
          <slot name="default"></slot>
        </td>
      </tr>
      <tr>
        <td>内容插槽</td>
        <td>
          <!-- 后备内容示范 -->
          <slot name="backup">
            <span>此为后备内容</span>
          </slot>
        </td>
      </tr>
      <tr>
        <td>插槽作用域</td>
        <td>
          <!-- 插槽作用域 -->
          <slot name="scope"></slot>
        </td>
      </tr>
      <tr>
        <td>具名插槽</td>
        <td>
          <slot name="name"></slot>
        </td>
      </tr>
      <tr>
        <td>插槽属性</td>
        <td>
          <slot name="prop" v-bind:slot-data1="soltData1" v-bind:slot-data2="soltData2"></slot>
        </td>
      </tr>
      <tr>
        <td>动态插槽名</td>
        <td>
          <slot name="order"></slot>
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  name: "MyComp",
  data: function() {
    return {
      soltData1: "solt-data-1",
      soltData2: "solt-data-2"
    };
  }
};
</script>

<style scoped>
tr th table {
  color: black;
  font-size: 22px;
  margin-top: 20px;
  padding: 8px;
  background-color: oldlace;
}

span {
  margin-left: 16px;
  margin-right: 16px;
}
</style>
```

#### 动态组件与组件缓存

- 动态组件：通过属性值来确定渲染组件的类型。用法：`<component v-bind:is="comp"></component>`
- 组件缓存：缓存组件示例。切换组件时，可利用缓存，不需要重新创建。用法：`<keep-alive>`

```html
// 组件使用
<template>
  <div>
    <table border="1">
      <tr>
        <td>
          <button v-on:click="changeComp">切换</button>
        </td>
        <td>
          <keep-alive>
            <!-- 动态组件，组件类型由comp属性值来决定 -->
            <component v-bind:is="comp"></component>
          </keep-alive>
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
import MyCompA from "./MyCompA.vue";
import MyCompB from "./MyCompB.vue";

export default {
  components: {
    MyCompA,
    MyCompB
  },
  name: "App",
  data: function() {
    return {
      showSwitch: false
    };
  },
  methods: {
    changeComp: function() {
      this.showSwitch = !this.showSwitch;
    }
  },
  computed: {
    comp: function() {
      return this.showSwitch ? MyCompA : MyCompB;
    }
  }
};
</script>

<style scoped>
tr th table {
  color: black;
  font-size: 22px;
  margin-top: 20px;
  padding: 8px;
  background-color: oldlace;
}
</style>

// 自定义组件A
<template>
  <div style="display: flex; flex-direction: column; align-items: center;">
    组件A
    <div style="display: flex; flex-direction: row; margin: 10px 10px">
      <button v-on:click="count++">+</button>
      <span style="margin-left: 16px; margin-right: 16px;">{{count}}</span>
      <button v-on:click="count--">-</button>
    </div>
  </div>
</template>

<script>
export default {
  name: "MyCompA",
  data: function() {
    return {
      count: 0
    };
  }
};
</script>

// 自定义组件B
<template>
  <div style="display: flex; flex-direction: column; align-items: center;">
    组件B
    <div style="display: flex; flex-direction: row; margin: 10px 10px">
      <button v-on:click="count++">+</button>
      <span style="margin-left: 16px; margin-right: 16px;">{{count}}</span>
      <button v-on:click="count--">-</button>
    </div>
  </div>
</template>

<script>
export default {
  name: "MyCompB",
  data: function() {
    return {
      count: 0
    };
  }
};
</script>
```

#### 异步组件

Vue 允许你以一个工厂函数的方式定义你的组件，这个工厂函数会异步解析你的组件定义。Vue 只有在这个组件需要被渲染的时候才会触发该工厂函数，且会把结果缓存起来供未来重渲染。

```js
Vue.component('async-example', function (resolve, reject) {
  setTimeout(function () {
    // 向 `resolve` 回调传递组件定义
    resolve({
      template: '<div>I am async!</div>'
    })
  }, 1000)
})
```

#### 组件的隐藏用法

骚操作，不太符合设计规范哦~

- $root：用来访问根实例。
- $parent：用来从一个子组件访问父组件的实例。
- $ref：通过 ref 这个 attribute 为子组件赋予一个 ID 引用。
- $on(eventName, eventHandler)：侦听一个事件。
- $once(eventName, eventHandler)：一次性侦听一个事件。
- $off(eventName, eventHandler)：停止侦听一个事件。

## 参考

https://cn.vuejs.org/v2/guide/components.html