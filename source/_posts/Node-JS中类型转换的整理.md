---
title: Node-JS中类型转换的整理
date: 2019-01-18 14:51:04
categories: 全栈
---

## 类型转换
JS中取值类型非常灵活，在进行算数运算符或比较运算符操作时，常常会进行类型转换操作。最近对类型转换做了系统的梳理。原始值之间的转换规则如下：
![原始值类型转换](/image/js_type.png)

### 对象转换操作
对象转换，相比于原始值相互转换要稍微复杂点。在讲解对象转换前，先说两个对象内置的方法：

```javascript
/**
 * 默认情况下，toString() -> "[object Object]"
 * 许多类都继承了toString()方法，例如数组：
 * [1].toString() -> "1"
 * ['1'].toString() -> "1"
 * [1, 2].toString() -> "1, 2"
 * @return 返回一个反映这个对象的字符串
 **/
toString() {}

/**
 * 默认情况下， valueOf() -> 对象本身。因为对象是复合值，而且大多数对象无法真正的表示一个原始值
 * 许多类都继承了valueOf()方法，例如日期类：
 * (new Date()).valueOf() -> 1548296513124
 * @return 如果存在任意原始值，它就默认将对象转换为表示它的原始值。
 **/
valueOf() {}
```

#### 对象到字符串的转换流程
- 如果对象具有toString()方法，则调用这个方法。如果他返回一个原始值，JS将这个值转换为字符串（如果本身不是字符串的话），并返回这个字符串结果。
- 如果对象没有toString()方法，或者这个方法并不返回这个原始值，那么JS会调用valueOf()方法。如果存在这个方法，则JS调用他。如果返回值是原始值，JS将这个值转换为字符串（如果本身不是字符串的话），并返回这个字符串结果。
- 否则，JS无法从toString()或者valueOf()获取一个原始值，因此这时他将抛出一个类型错误异常。

```javascript
/**
 * 对象转字符串伪代码
 **/
function obj2String(obj){
  let temp = null;
  if (!!obj.toString) {
    temp = obj.toString();
    if (typeof temp === 原始值) {
      return 原始值转化规则(temp);
    }
  }
  if (!!obj.valueOf) {
    temp = obj.valueOf();
    if (typeof temp === 原始值) {
      return 原始值转化规则(temp);
    }
  }
  throw TypeError('转化失败');
}
```

#### 对象到数值的转换流程
- 如果对象具有valueOf()方法，或者返回一个原始值，则JS将这个原始值转换为数字，并返回这个数字。
- 否则，如果对象具有toString()方法，后者返回一个原始值，则JS将其转换并返回
- 否则，JS抛出一个类型错误异常

```javascript
/**
 * 对象转数值伪代码
 **/
function obj2Number(obj){
  let temp = null;
  if (!!obj.valueOf) {
    temp = obj.valueOf();
    if (typeof temp === 原始值) {
      return 原始值转化规则(temp);
    }
  }
  if (!!obj.toString) {
    temp = obj.toString();
    if (typeof temp === 原始值) {
      return 原始值转化规则(temp);
    }
  }
  throw TypeError('转化失败');
}
```

#### 对象到原始值的转换流程

在使用“+”，“==”，“!=”和关系运算符是唯一执行这种特殊的字符串到原始值的转换方式的运算符。因为这些运算符不太清楚要将对象转成String还是Number。将对象转成原始值时，会首先尝试调用valueOf()，然后调用toString()。唯一例外的是Date类型，Date类型会首先尝试调用toString()，然后调用valueOf()。

```javascript
/**
 * 对象转原始值伪代码
 **/
function obj2OriginalValue(obj){
  if (typeof obj == Date) {
    if (!!obj.toString) {
      return obj.toString();
    }
    if (!!obj.valueOf) {
      return obj.valueOf();
    }
  }else {
    if (!!obj.valueOf) {
      return obj.valueOf();
    }
    if (!!obj.toString) {
      return obj.toString();
    }
  }
}
```

## 举例说明

### “+” 操作符功能简介
操作符的运算优先级为：string > 其他类型
  - 存在string类型时，其他类型都会转换成string类型，然后进行字符串连接
  - 不存在string类型时，会尝试将其他类型转换成数字，然后进行数字相加操作

```javascript
// 存在string类型
console.log('str+' + undefined);  //str+undefined
console.log('str+' + null);  //str+null
console.log('str+' + false);  //str+false
console.log('str+' + true);  //str+true
console.log('str+' + 123);  //str+123
// 不存在string类型
console.log(undefined + 123);  //NaN
console.log(undefined + null);  //NaN
console.log(undefined + false);  //NaN
console.log(undefined + true);  //NaN
console.log(123 + null);  //123
console.log(123 + false);  //123
console.log(123 + true);  //124
console.log(null + true);  //1
console.log(null + false);  //1
console.log(true + false);  //1
```

### “-” 操作符功能简介
基本类型进行“—”操作符运算时，将基本类型转换为数字，然后进行数字相减操作。“*”操作符和“/”操作符类似。

```javascript
console.log(123 - null);  //123
console.log(123 - undefined);  //NaN
console.log(123 - false); 123
console.log(123 - true);  //122
console.log(123 - '1');  //122
```