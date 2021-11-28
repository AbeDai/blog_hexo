---
title: 前端 - Vue组合式API（Composition API）
date: 2021-11-28 23:16:10
categories: 前端
---

### 组合式API（Composition API）

通过创建 Vue 组件，我们可以将界面中重复的部分连同其功能一起提取为可重用的代码段。仅此一项就可以使我们的应用在可维护性和灵活性方面走得相当远。然而，我们的经验已经证明，光靠这一点可能并不够，尤其是当你的应用变得非常大的时候——想想几百个组件。处理这样的大型应用时，共享和重用代码变得尤为重要。

<img width="200" src="/image/F250188F-FF99-46F8-B042-B8FB65F31ABF.png">

这是一个大型组件的示例，其中**逻辑关注点**按颜色进行分组。

这种碎片化使得理解和维护复杂组件变得困难。选项的分离掩盖了潜在的逻辑问题。此外，在处理单个逻辑关注点时，我们必须不断地“跳转”相关代码的选项块。

如果能够将同一个逻辑关注点相关代码收集在一起会更好。而这正是组合式 API 使我们能够做到的。

参考：https://v3.cn.vuejs.org/guide/composition-api-introduction.html

### **setUp** 语法介绍

在 setUp 函数中，Vue3 为我们提供了丰富的 API，能覆盖 Vue2 中的所有语法场景。

#### 调用时机

setUp 作为组合是API的入口，其调用时机为：创建组件实例，然后初始化 props ，紧接着就调用setup 函数。从生命周期钩子的视角来看，它会在 beforeCreate 钩子之前被调用。

#### 参数

使用 setup 函数时，它将接收两个参数：

- props
- context

##### Props

setup 函数中的第一个参数是 props。正如在一个标准组件中所期望的那样，setup 函数中的 props 是响应式的，当传入新的 prop 时，它将被更新。

##### Context

传递给 setup 函数的第二个参数是 context。context 是一个普通 JavaScript 对象，暴露了其它可能在 setup 中有用的值：

```javascript
// Attribute (非响应式对象，等同于 $attrs)
console.log(context.attrs)

// 插槽 (非响应式对象，等同于 $slots)
console.log(context.slots)

// 触发事件 (方法，等同于 $emit)
console.log(context.emit)

// 暴露公共 property (函数)
console.log(context.expose)
```

### setUp 用法分析

常见业务开发需求如下

- 生命周期Hook
- 父子组件函数调用
- 父组件属性传递
- 内置属性使用
- 函数申明
- ref组件引用

在接下来的示例中，我们将从这几个方面介绍其使用方法。

### setUp 使用示例

<img width="400" src="/image/83DFD698-BFF8-4625-8157-2344155E4AC0.png">

#### setUp 函数版

```html
// 父组件
<template>
  <div>
    <button @click="tiggerSetUpComponentVisiable">移除/展示 set-up-component 组件</button>
    <h4>set-up-component 组件调用 父组件变化: {{ callParentFromSetUpComponentCount }}</h4>
    <button @click="callSetUpComponentMethod2">调用 set-up-component 组件 method2</button>
    <h4>------------------------------ ↑父 ↓子 组件分割线 ------------------------------</h4>
    <set-up-component
      v-if="isShowSetUpComponent"
      ref="refSetUpComponent"
      prop1="111111111111111"
      prop2="222222222222222"
      prop3="333333333333333"
      @callParent="callParentFromSetUpComponent"
    >
      <template #testSolt>
        <h4>测试 Slot 插槽</h4>
      </template>
    </set-up-component>
  </div>
</template>

<script lang="ts">
import SetUpComponent, { SetUpComponentExpose } from './components/JSSetUpComponent.vue';
import { defineComponent } from '@vue/runtime-core';

export default defineComponent({
  name: 'App',
  components: {
    SetUpComponent,
  },
  data() {
    return {
      isShowSetUpComponent: true,
      mSetUpComponent: undefined,
      callParentFromSetUpComponentCount: 0,
    };
  },
  mounted() {
    const setUpComponentExpose = (this.$refs.refSetUpComponent as SetUpComponentExpose);
    console.log(`this.$refs.refSetUpComponent expose: prop1 - ${setUpComponentExpose.prop1}, prop2 - ${setUpComponentExpose.prop2}`);
  },
  methods: {
    tiggerSetUpComponentVisiable() {
      this.isShowSetUpComponent = !this.isShowSetUpComponent;
    },
    callSetUpComponentMethod2() {
      const setUpComponentExpose = (this.$refs.refSetUpComponent as SetUpComponentExpose);
      if (setUpComponentExpose) {
        setUpComponentExpose.method2();
      }
    },
    callParentFromSetUpComponent() {
      this.callParentFromSetUpComponentCount++;
    },
  },
});
</script>

// 子组件
<template>
  <div>
    <h4>{{ `暴露属性: prop1: ${prop1}` }}</h4>
    <h4>{{ `暴露属性: prop2: ${prop2}` }}</h4>
    <h4>{{ `暴露属性: prop3: ${prop3}` }}</h4>
    <h4>{{ `内置属性: innerProp1: ${innerProp1}` }}</h4>
    <h4>函数调用: method1 result: {{ method1.call(this) }}</h4>
    <button @click="method2">函数调用: 自增 innerProp1</button>
    <h4 ref="refH1">引用获取: setup refH1</h4>
    <button @click="method3">函数调用: call parent component</button>
    <slot name="testSolt"></slot>
  </div>
</template>

<script lang="ts">
import {
  onMounted,
  defineComponent,
  onBeforeMount,
  onUnmounted,
  onBeforeUpdate,
  onUpdated,
  onBeforeUnmount,
  toRefs,
  Ref,
  ref,
} from '@vue/runtime-core';

export interface SetUpComponentExpose {
  prop1: Ref<string>
  prop2: Ref<string>
  method2: () => void
}

export default defineComponent({
  name: 'SetUpComponent',
  props: {
    prop1: {
      type: String,
      default: '',
    },
    prop2: {
      type: String,
      default: '',
    },
    prop3: {
      type: String,
      default: '',
    },
  },
  setup(props, context) {
    // 属性使用
    const { prop1, prop2 } = toRefs(props);

    // 插槽使用
    if (context.slots.testSolt) {
      console.log(context.slots.testSolt);
    }

    // 生命周期测试
    console.log('component: setup - beforeCreate & created');
    onMounted(() => {
      console.log('component: setup - onMounted');
    });
    onBeforeMount(() => {
      console.log('component: setup - onBeforeMount');
    });
    onBeforeUpdate(() => {
      console.log('component: setup - onBeforeUpdate');
    });
    onUpdated(() => {
      console.log('component: setup - onUpdated');
    });
    onBeforeUnmount(() => {
      console.log('component: setup - onBeforeUnmount');
    });
    onUnmounted(() => {
      console.log('component: setup - onUnmounted');
    });

    // 内部属性声明
    const innerProp1: Ref<number> = ref(0);

    // 函数声明
    const method1 = () => {
      return `${innerProp1.value}`;
    };
    const method2 = () => {
      innerProp1.value++;
    };

    // 属性、方法声明
    context.expose(
      {
        prop1,
        prop2,
        method2,
      } as SetUpComponentExpose,
    );

    // 获取元素引用
    const refH1 = ref<HTMLElement | undefined>(undefined);
    setTimeout(() => {
      if (refH1 && refH1.value) {
        refH1.value.append('a1');
      }
    }, 3000);

    // 调用 父组件函数
    const method3 = () => {
      context.emit('callParent');
    };

    return {
      method1,
      method2,
      method3,
      innerProp1,
      refH1,
    };
  },
});
</script>
```

#### script setup 标签版

```html
// 父组件
<template>
  <div>
    <button @click="tiggerSetUpComponentVisiable">移除/展示 set-up-component 组件</button>
    <h4>set-up-component 组件调用 父组件变化: {{ callParentFromSetUpComponentCount }}</h4>
    <button @click="callSetUpComponentMethod2">调用 set-up-component 组件 method2</button>
    <h4>------------------------------ ↑父 ↓子 组件分割线 ------------------------------</h4>
    <set-up-component
      v-if="isShowSetUpComponent"
      ref="refSetUpComponent"
      prop1="111111111111111"
      prop2="222222222222222"
      prop3="333333333333333"
      @callParent="callParentFromSetUpComponent"
    >
      <template #testSolt>
        <h4>测试 Slot 插槽</h4>
      </template>
    </set-up-component>
  </div>
</template>

<script lang="ts">
import SetUpComponent, { SetUpComponentExpose } from './components/TSSetUpComponent.vue';
import { defineComponent } from '@vue/runtime-core';

export default defineComponent({
  name: 'App',
  components: {
    SetUpComponent,
  },
  data() {
    return {
      isShowSetUpComponent: true,
      mSetUpComponent: undefined,
      callParentFromSetUpComponentCount: 0,
    };
  },
  mounted() {
    const setUpComponentExpose = (this.$refs.refSetUpComponent as SetUpComponentExpose);
    console.log(`this.$refs.refSetUpComponent expose: prop1 - ${setUpComponentExpose.prop1}, prop2 - ${setUpComponentExpose.prop2}`);
  },
  methods: {
    // 控制子组件是否展示
    tiggerSetUpComponentVisiable() {
      this.isShowSetUpComponent = !this.isShowSetUpComponent;
    },
    // 调用 set-up-component 组件 method2（父组件 调用 子组件）
    callSetUpComponentMethod2() {
      const setUpComponentExpose = (this.$refs.refSetUpComponent as SetUpComponentExpose);
      if (setUpComponentExpose) {
        setUpComponentExpose.method2();
      }
    },
    // set-up-component 组件调用 App 组件的函数（子组件 调用 父组件）
    callParentFromSetUpComponent() {
      this.callParentFromSetUpComponentCount++;
    },
  },
});
</script>

// 子组件
<template>
  <div>
    <h4>{{ `暴露属性: prop1: ${prop1}` }}</h4>
    <h4>{{ `暴露属性: prop2: ${prop2}` }}</h4>
    <h4>{{ `暴露属性: prop3: ${prop3}` }}</h4>
    <h4>{{ `内置属性: innerProp1: ${innerProp1}` }}</h4>
    <h4>函数调用: method1 result: {{ method1.call(this) }}</h4>
    <button @click="method2">函数调用: 自增 innerProp1</button>
    <h4 ref="refH1">引用获取: setup refH1</h4>
    <button @click="method3">函数调用: call parent component</button>
    <slot name="testSolt"></slot>
  </div>
</template>

<script setup lang="ts">
import { defineProps, useSlots, defineExpose, defineEmits } from 'vue';
import {
  onMounted,
  onBeforeMount,
  onUnmounted,
  onBeforeUpdate,
  onUpdated,
  onBeforeUnmount,
  toRefs,
  Ref,
  ref,
} from '@vue/runtime-core';

export interface SetUpComponentExpose {
  prop1: Ref<string>
  prop2: Ref<string>
  method2: () => void
}

// 属性声明
const props = defineProps({
  prop1: {
    type: String,
    default: '',
  },
  prop2: {
    type: String,
    default: '',
  },
  prop3: {
    type: String,
    default: '',
  },
});

// 属性使用
const { prop1, prop2 } = toRefs(props);

// 插槽使用
const slot = useSlots();
if (slot.testSolt) {
  console.log(slot.testSolt);
}

// 生命周期测试
console.log('component: setup - beforeCreate & created');
onMounted(() => {
  console.log('component: setup - onMounted');
});
onBeforeMount(() => {
  console.log('component: setup - onBeforeMount');
});
onBeforeUpdate(() => {
  console.log('component: setup - onBeforeUpdate');
});
onUpdated(() => {
  console.log('component: setup - onUpdated');
});
onBeforeUnmount(() => {
  console.log('component: setup - onBeforeUnmount');
});
onUnmounted(() => {
  console.log('component: setup - onUnmounted');
});

// 内部属性声明
const innerProp1: Ref<number> = ref(0);

// 函数声明
const method1 = () => {
  return `${innerProp1.value}`;
};
const method2 = () => {
  innerProp1.value++;
};

// 暴露属性、方法声明
defineExpose(
  {
    prop1,
    prop2,
    method2,
  } as SetUpComponentExpose,
);

// 获取元素引用
const refH1 = ref<HTMLElement | undefined>(undefined);
setTimeout(() => {
  if (refH1 && refH1.value) {
    refH1.value.append('a1');
  }
}, 3000);

// 调用 父组件函数
const emit = defineEmits(['callParent']);
const method3 = () => {
  emit('callParent');
};

</script>
```

### Vue3 是否应该全面使用 setup 的讨论

composition API：组合式API，Vue3 中的API使用方式，即上面说的 setUp。
options API：选择式API，Vue2 中的API使用方式。

结论：如果是想认认真真写很多代码，那就用 composition API 好好组织设计，如果只是单纯糊几个业务，options API 也能 handle 住。

参考：https://www.zhihu.com/question/461860114

### 参考

https://v3.cn.vuejs.org/guide/composition-api-introduction.html
https://v3.cn.vuejs.org/guide/composition-api-setup.html
https://www.jianshu.com/p/f47556e726de
https://juejin.cn/post/6987254959918039048
https://www.zhihu.com/question/461860114

