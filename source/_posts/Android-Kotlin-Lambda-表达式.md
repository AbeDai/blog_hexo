---
title: Android - Kotlin Lambda 表达式
date: 2021-10-07 20:12:03
categories: 客户端
---

### Lambda 语法介绍

我在这里先总结出Lambda表达式的一些特征。在下面讲解到Lambda语法与实践时大家就明白了。即：

- Lambda表达式总是被大括号括着
- 其参数(如果存在)在 -> 之前声明(参数类型可以省略)
- 函数体(如果存在)在 -> 后面。

#### 举例说明

```kotlin
1. 无参数的情况
val/var 变量名 = { 操作的代码 }

2. 有参数的情况
val/var 变量名 : (参数的类型，参数类型，...) -> 返回值类型 = {参数1，参数2，... -> 操作参数的代码 }

可等价于
// 此种写法：即表达式的返回值类型会根据操作的代码自推导出来。
val/var 变量名 = { 参数1 ： 类型，参数2 : 类型, ... -> 操作参数的代码 }

3. lambda表达式作为函数中的参数的时候，这里举一个例子：
fun test(a : Int, 参数名 : (参数1 ： 类型，参数2 : 类型, ... ) -> 表达式返回类型){
    ...
}
```

### Lambda 实例

#### 无参数的情况

```kotlin
// 源代码
fun test(){ println("无参数") }

// lambda代码
val test = { println("无参数") }

// 调用
test()  => 结果为：无参数
```

#### 有参数的情况

```kotlin
// 源代码
fun test(a : Int , b : Int) : Int{
    return a + b
}

// lambda
val test : (Int , Int) -> Int = {a , b -> a + b}
// 或者
val test = {a : Int , b : Int -> a + b}

// 调用
test(3,5) => 结果为：8
```

#### Lambda表达式 作为 函数参数的情况

```kotlin
// 源代码
fun test(a : Int , b : Int) : Int{
    return a + b
}

fun sum(num1 : Int , num2 : Int) : Int{
    return num1 + num2
}

// 调用
test(10,sum(3,5)) // 结果为：18

// lambda
fun test(a : Int , b : (num1 : Int , num2 : Int) -> Int) : Int{
    return a + b.invoke(3,5)
}

// 调用
test(10,{ num1: Int, num2: Int ->  num1 + num2 })  // 结果为：18
```

### Lambda 进阶

#### it关键字

- `it`并不是`Kotlin`中的一个关键字(保留字)。
- `it`是在当一个高阶函数中`Lambda`表达式的参数只有一个的时候可以使用`it`来使用此参数。`it`可表示为单个参数的隐式名称，是`Kotlin`语言约定的。

```kotlin
 fun test(num1 : Int, bool : (Int) -> Boolean) : Int{
   return if (bool(num1)){ num1 } else 0
}

println(test(10,{it > 5}))
println(test(4,{it > 5}))
```

#### `_`关键字

- 在使用Lambda表达式的时候，可以用下划线 `_` 表示未使用的参数，表示不处理这个参数。

```kotlin
val map = mapOf("key1" to "value1","key2" to "value2","key3" to "value3")

map.forEach{
     key , value -> println("$key \t $value")
}

// 不需要key的时候
map.forEach{
    _ , value -> println("$value")
}
```

#### 匿名函数

- 匿名函数的特点是可以明确指定其返回值类型。
- 它和常规函数的定义几乎相似。他们的区别在于，匿名函数没有函数名。

```kotlin
val test1 = fun(x : Int , y : Int) = x + y  // 当返回值可以自动推断出来的时候，可以省略，和函数一样
val test2 = fun(x : Int , y : Int) : Int = x + y
val test3 = fun(x : Int , y : Int) : Int{
    return x + y
}

println(test1(3,5))
println(test2(4,6))
println(test3(5,7))
```

#### 带接收者的函数字面值

- `Lambda`表达式作为接收者类型

```kotlin
class HTML {
    fun body() { …… }
}

fun html(init: HTML.() -> Unit): HTML {
    val html = HTML()  // 创建接收者对象
    html.init()        // 将该接收者对象传给该 lambda
    return html
}


html {       // 带接收者的 lambda 由此开始
    body()   // 调用该接收者对象的一个方法
}
```

### 参考

https://www.cnblogs.com/Jetictors/p/8647888.html