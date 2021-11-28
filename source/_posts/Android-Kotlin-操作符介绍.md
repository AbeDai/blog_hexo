---
title: Android - Kotlin 操作符介绍
date: 2021-11-28 16:17:44
categories: 客户端
---

### 速查表

| 函数名	 | 定义 |
| --- | --- |
| repeat | fun repeat(times: Int, action: (Int) -> Unit)	 |  
| with | fun <T, R> with(receiver: T, f: T.() -> R): R = receiver.f()	 |  
| run | <R> run(block: () -> R): R	 |  
| let | fun <T, R> T.let(f: (T) -> R): R	 |  
| apply | fun <T> T.apply(f: T.() -> Unit): T	 |  
| run | fun <T, R> T.run(f: T.() -> R): R	 |  
| also | fun <T> T.also(block: (T) -> Unit): T	 |  
| takeIf | fun <T> T.takeIf(predicate: (T) -> Boolean): T?	 |  
| takeUnless | fun <T> T.takeUnless(predicate: (T) -> Boolean): T?	 | 

### repeat

作用：是循环执行多少次block中内容。

**源码**

```kotlin
/**
 * Executes the given function [action] specified number of [times].
 *
 * A zero-based index of current iteration is passed as a parameter to [action].
 */
@kotlin.internal.InlineOnly
public inline fun repeat(times: Int, action: (Int) -> Unit) {
    contract { callsInPlace(action) }

    for (index in 0..times - 1) {
        action(index)
    }
}
```

**实例**

```kotlin
fun repeatDemo() {
    repeat(3) {
        println("Hello world")
    }
}

// 反编译后代码
public final void repeatDemo() {
  byte var1 = 3;
  boolean var2 = false;
  boolean var3 = false;
  int var9 = 0;

  for(byte var4 = var1; var9 < var4; ++var9) {
     int var6 = false;
     String var7 = "Hello world";
     boolean var8 = false;
     System.out.println(var7);
  }

}
```

### with

作用：with函数也是一个单独的函数，并不是Kotlin中的extension，指定的T作为闭包的receiver，使用参数中闭包的返回结果

**源码**

```kotlin
@kotlin.internal.InlineOnly
public inline fun <T, R> with(receiver: T, block: T.() -> R): R {
    contract {
        callsInPlace(block, InvocationKind.EXACTLY_ONCE)
    }
    return receiver.block()
}
```

**关于 `T.() -> R` 语法介绍**

> T.()->Unit 等同于为T定义了一个无参数的扩展函数，所以在函数体内可以直接通过this或省略来访问T代表的对象

**实例**

```kotlin
fun withDemo() {
    val result = with(ArrayList<String>()) {
        add("testWith")
        add("testWith")
        add("testWith")
        return@with 1
    }
    println(result)
}
    
// 反编译后代码
public final void withDemo() {
  ArrayList var2 = new ArrayList();
  boolean var3 = false;
  boolean var4 = false;
  int var6 = false;
  var2.add("testWith");
  var2.add("testWith");
  var2.add("testWith");
  int result = 1;
  boolean var7 = false;
  System.out.println(result);
}
```

### let

作用：默认当前这个对象作为闭包的it参数，返回值是函数里面最后一行，或者指定return。

**源码**

```kotlin
@kotlin.internal.InlineOnly
public inline fun <T, R> T.let(block: (T) -> R): R {
    contract {
        callsInPlace(block, InvocationKind.EXACTLY_ONCE)
    }
    return block(this)
}
```

**实例**

```kotlin
fun letDemo() {
    val result: Int = "testLet".let {
        if (Random().nextBoolean()) {
            println(it)
            return@let 1
        } else {
            println(it)
            return@let 2
        }
    }
    println(result)
}
    
// 反编译后代码
public final void letDemo() {
  String var2 = "testLet";
  boolean var3 = false;
  boolean var4 = false;
  int var6 = false;
  byte var10000;
  boolean var7;
  if ((new Random()).nextBoolean()) {
     var7 = false;
     System.out.println(var2);
     var10000 = 1;
  } else {
     var7 = false;
     System.out.println(var2);
     var10000 = 2;
  }

  int result = var10000;
  boolean var8 = false;
  System.out.println(result);
}
```

### apply

作用：调用某对象的apply函数，在函数范围内，可以任意调用该对象的任意方法，并返回该对象。

**源码**

```kotlin
@kotlin.internal.InlineOnly
public inline fun <T> T.apply(block: T.() -> Unit): T {
    contract {
        callsInPlace(block, InvocationKind.EXACTLY_ONCE)
    }
    block()
    return this
}
```

**实例**

```kotlin
fun applyDemo() {
    val result = ArrayList<String>().apply {
        add("testApply")
        add("testApply")
        add("testApply")
    }
    println(result)
}

// 反编译后代码
public final void applyDemo() {
  ArrayList var2 = new ArrayList();
  boolean var3 = false;
  boolean var4 = false;
  int var6 = false;
  var2.add("testApply");
  var2.add("testApply");
  var2.add("testApply");
  ArrayList result = var2;
  boolean var7 = false;
  System.out.println(result);
}
```

### run

作用：run函数和apply函数很像，只不过run函数是使用最后一行的返回，apply返回当前自己的对象。

**源码**

```kotlin
@kotlin.internal.InlineOnly
public inline fun <T, R> T.run(block: T.() -> R): R {
    contract {
        callsInPlace(block, InvocationKind.EXACTLY_ONCE)
    }
    return block()
}
```

**实例**

```kotlin
fun runDemo() {
    val result = "testRun".run {
        println("this = $this")
        1
    }
    println(result)
}

// 反编译后代码
public final void runDemo() {
  String var2 = "testRun";
  boolean var3 = false;
  boolean var4 = false;
  int var6 = false;
  String var7 = "this = " + var2;
  boolean var8 = false;
  System.out.println(var7);
  int result = 1;
  boolean var9 = false;
  System.out.println(result);
}
```

### 另一个Run

作用：不是extension，它的定义如下，执行block，返回block的返回。

**源码**

```kotlin
public inline fun <R> run(block: () -> R): R {
    contract {
        callsInPlace(block, InvocationKind.EXACTLY_ONCE)
    }
    return block()
}
```

**实例**

```kotlin
fun run2Demo() {
    val date = run {
        Date()
    }
    println("date = $date")
}

// 反编译后代码
public final void run2Demo() {
  boolean var3 = false;
  boolean var4 = false;
  Solution1128 $this$run = (Solution1128)this;
  int var6 = false;
  Date date = new Date();
  String var2 = "date = " + date;
  var3 = false;
  System.out.println(var2);
}
```

### also

作用：执行block，返回this。

**源码**

```kotlin
@kotlin.internal.InlineOnly
@SinceKotlin("1.1")
public inline fun <T> T.also(block: (T) -> Unit): T {
    contract {
        callsInPlace(block, InvocationKind.EXACTLY_ONCE)
    }
    block(this)
    return this
}
```

**实例**

```kotlin
fun alsoDemo() {
    val date = Date().also {
        println("in also time = " + it.time)
    }
    println("also = $date")
}

// 反编译后代码
public final void alsoDemo() {
  Date var2 = new Date();
  boolean var3 = false;
  boolean var4 = false;
  int var6 = false;
  String var7 = "in also time = " + var2.getTime();
  boolean var8 = false;
  System.out.println(var7);
  String var9 = "also = " + var2;
  var3 = false;
  System.out.println(var9);
}
```

### takeIf

作用：满足block中条件，则返回当前值，否则返回null，block的返回值Boolean类型。

**源码**

```kotlin
@kotlin.internal.InlineOnly
@SinceKotlin("1.1")
public inline fun <T> T.takeIf(predicate: (T) -> Boolean): T? {
    contract {
        callsInPlace(predicate, InvocationKind.EXACTLY_ONCE)
    }
    return if (predicate(this)) this else null
}
```

**实例**

```kotlin
fun takeIfDemo () {
    val date = Date().takeIf {
        // 是否在2018年元旦后
        it.after(Date(2018 - 1900, 0, 1))
    }
    println("date = $date")
}

// 反编译后代码
public final void takeIfDemo() {
  Date var2 = new Date();
  boolean var3 = false;
  boolean var4 = false;
  int var6 = false;
  Date date = var2.after(new Date(118, 0, 1)) ? var2 : null;
  String var7 = "date = " + date;
  var3 = false;
  System.out.println(var7);
}
```

### takeUnless

作用：和takeIf相反，如不满足block中的条件，则返回当前对象，否则为null。

**源码**

```kotlin
@kotlin.internal.InlineOnly
@SinceKotlin("1.1")
public inline fun <T> T.takeUnless(predicate: (T) -> Boolean): T? {
    contract {
        callsInPlace(predicate, InvocationKind.EXACTLY_ONCE)
    }
    return if (!predicate(this)) this else null
}
```

**实例**

```kotlin
 fun takeUnlessDemo() {
        val date = Date().takeUnless {
            // 是否在2018年元旦后
            it.after(Date(2018 - 1900, 0, 1))
        }
        println("date = $date")
    }

// 反编译后代码
public final void takeUnlessDemo() {
      Date var2 = new Date();
      boolean var3 = false;
      boolean var4 = false;
      int var6 = false;
      Date date = !var2.after(new Date(118, 0, 1)) ? var2 : null;
      String var7 = "date = " + date;
      var3 = false;
      System.out.println(var7);
   }
```

### 参考

https://www.jianshu.com/p/5c4a954d2b2c#let
https://www.jianshu.com/p/f3ca07b582e5
