---
title: Android-Kotlin When 语句分析
date: 2021-10-10 12:49:50
categories: 客户端
---

### Kotlin When 语法介绍

Kotlin `when` 表达式是一个返回值的条件表达式。 Kotlin `when` 表达式用于替换`switch`语句。Kotlin中 `when` 表达式能够干你想用 `switch` 干的每件事，甚至更多。

### 特性：`when` 作为表达式

- `when` 每个 `case` 的最后一个参数，就是 `when` 表达式的返回值
- 当 `when` 表达式有入参的时候，`case` 就是一个 相等 或 包含 的关系

```kotlin
val number = (System.currentTimeMillis() % 6).toInt()
val numberProvided = when (number) {
    1 -> "One"
    2 -> "Two"
    3 -> "Three"
    4 -> "Four"
    5 -> "Five"
    else -> "invalid number"
}
println("You provide $numberProvided")
```

### 特性：没有表达的 `when` 语句

- 与其他语言相同

```kotlin
var number = 4  
when(number) {  
    1 -> println("One")  
    2 -> println("Two")  
    3 -> println("Three")  
    4 -> println("Four")  
    5 -> println("Five")  
    else -> println("invalid number")  
}
```

### 特性：`when` 使用括号的多重声明

- 括号内声明的变量作用域为此括号

```kotlin
var number = 1  
when(number) {  
    1 -> {  
        println("Monday")  
        println("First day of the week")  
    }  
    7 -> println("Sunday")  
    else -> println("Other days")  
}
```

### 特性：`when` 使用范围和区间

- 相当于调用 `contain` 函数，如果 `when` 入参包含在其中，则执行此case

```kotlin
var number = 1  
when(number) {  
    3, 4, 5, 6 -> {  
        println("x,x,x,x")  
        println("other message")
    }  
    in 6..10 -> println("6..10")
    in setOf(11, 12) -> println("setOf(11, 12)")
    else -> println("other case")  
}
```

### 特性：`when` 取代 `if-else` `if` 链

- 不提供参数时，所有的分支条件都是简单的布尔表达式，而当一个分支的条件为真时则执行该分支

```kotlin
when {
    x == 0 -> println("x == 0")
    y == "day" -> println("y == \"day\"")
    else -> println("when else")
}
```

### 反解编译产物

```kotlin
fun main() {
    // 参数赋值
    val x = (System.currentTimeMillis() % 10).toInt()
    val y = if (System.currentTimeMillis() % 2 == 0L) "year" else "mouth"

    // 一个复杂的when函数
    val result = when (x) {
        0, 1 -> {
            val a = 100
            println("when 表达式：0, 1 -> {$a}")
            "1"
        }
        2 -> {
            val a = 200
            println("when 表达式：2 -> {$a}")
            "2"
        }
        in 3..10 -> {
            println("when 表达式：in 3..10 -> {}")
            "3"
        }
        in setOf(11, 12) -> {
            println("when 表达式：in setOf(11, 12) -> {}")
            "4"
        }
        is Int -> {
            println("when 表达式：is Int -> {}")
            "5"
        }
        else -> {
            println("when 表达式：else -> {}")
            "6"
        }
    }
    println("when 表达式结果：${result}")

    // when 取代 if-else if 链
    // 不提供参数时，所有的分支条件都是简单的布尔表达式，而当一个分支的条件为真时则执行该分支
    when {
        x == 0 -> println("x == 0")
        y == "day" -> println("y == \"day\"")
        else -> println("when else")
    }
}
```

**反解后代码**

```java
public final void main() {
  int x = (int)(System.currentTimeMillis() % (long)10);
  String y = System.currentTimeMillis() % (long)2 == 0L ? "year" : "mouth";
  String var10000;
  String var6;
  boolean var7;
  if (x != 0 && x != 1) {
     if (x == 2) {
        int a = 200;
        var6 = "when 表达式：2 -> {" + a + '}';
        var7 = false;
        System.out.println(var6);
        var10000 = "2";
     } else {
        label34: {
           String var9;
           boolean var11;
           if (3 <= x) {
              if (10 >= x) {
                 var9 = "when 表达式：in 3..10 -> {}";
                 var11 = false;
                 System.out.println(var9);
                 var10000 = "3";
                 break label34;
              }
           }

           if (SetsKt.setOf(new Integer[]{11, 12}).contains(x)) {
              var9 = "when 表达式：in setOf(11, 12) -> {}";
              var11 = false;
              System.out.println(var9);
              var10000 = "4";
           } else {
              var9 = "when 表达式：is Int -> {}";
              var11 = false;
              System.out.println(var9);
              var10000 = "5";
           }
        }
     }
  } else {
     int a = 100;
     var6 = "when 表达式：0, 1 -> {" + a + '}';
     var7 = false;
     System.out.println(var6);
     var10000 = "1";
  }

  String result = var10000;
  String var4 = "when 表达式结果：" + result;
  boolean var10 = false;
  System.out.println(var4);
  if (x == 0) {
     var4 = "x == 0";
     var10 = false;
     System.out.println(var4);
  } else if (Intrinsics.areEqual(y, "day")) {
     var4 = "y == \"day\"";
     var10 = false;
     System.out.println(var4);
  } else {
     var4 = "when else";
     var10 = false;
     System.out.println(var4);
  }

}
```

