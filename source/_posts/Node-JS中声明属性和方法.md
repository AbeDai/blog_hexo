---
title: 前端-JS中声明属性和方法
date: 2018-12-09 14:01:02
categories: 后台
---

# 声明类

es6中的class关键字，其实只是一个语法糖，本质上是对原型链的一个封装。

# 声明属性

截止es6，声明属性的最佳实践如下:

```
// 声明类
class Clazz {
  constructor(){
    // 建议将静态属性和对象属性的声明的初始化都放在构造函数中进行
    // 声明对象属性
    this.field = "对象属性";
    // 声明静态属性
    Test.sField = "静态属性";
  }
}
```

### 本质说明

- 静态属性的本质就是在类上挂在对象，而类本质上就是构造函数function，所以静态属性就是直接在构造函数上挂在对象。
- 对象属性的本质就是在对象上挂在对象。

```
// 实现对象属性的效果
let clazz = new Clazz();
clazz.field =  "对象属性“;

// 实现静态属性的效果
Clazz.sField = "静态属性";

```

## 声明方法

截止es6，声明方法的最佳实践如下：

```
// 声明类
class Clazz {
  
  func(){
    console.log("声明对象方法");
  }
  
  static sFunc(){
    console.log("声明静态方法");
  }
}

// 调用对象方法
let clazz = new Clazz();
clazz.func();
// 调用静态方法
Clazz.sFunc();
```

### 本质说明

- 静态方法本质和静态属性类似，就是在构造函数上挂在方法。
- 对象方法本质是在构造函数的原型链上挂在对象。

```

// 声明类
class Clazz {
  
  func(){
    console.log("声明对象方法");
  }
  
  static sFunc(){
    console.log("声明静态方法");
  }
}

// 等价于
function Clazz(){}

Clazz.prototype.func = {
  console.log("声明对象方法");
}

Clazz.sFunc = {
  console.log("声明静态方法");
}

```

