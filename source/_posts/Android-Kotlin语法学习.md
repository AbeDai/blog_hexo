---
title: Android-Kotlin语法学习
date: 2019-10-29 16:29:12
categories: 客户端
---

## 构造函数
> [文档](https://www.kotlincn.net/docs/reference/classes.html)

#### 概念讲解
类可以有一个主构造函数以及一个或多个次构造函数。每个次构造函数需要委托给主构造函数， 可以直接委托或者通过别的次构造函数间接委托
- 主构造函数、次构造函数
- 初始化块
- 初始化顺序

#### 示例
```
// 声明类时，支持声明主构造函数
class Person constructor(value1: String) {

    private var first = "调用：1".also(::println)

    // 初始化块
    init {
        println("调用：2")
    }

    private var third = "调用：3".also(::println)

    // 次构造函数，需要间接实现主构造函数
    constructor(value1: String, value2: String): this(value1) {
        println("调用：4")
    }
}
```

## 继承
> [文档](https://www.kotlincn.net/docs/reference/classes.html)

#### 概念讲解
- 声明父类
- 实现构造方法
- 覆盖方法、属性：open、override
- 继承类的初始化顺序
- 调用父类方法

#### 示例
```
// Animal
open class Animal(open val age: Int) {
    init {
        println("初始化调用：1")
    }
}

// Person继承Animal，并实现主构造函数
open class Person(open val name: String, override val age: Int) : Animal(age) {
    init {
        println("初始化调用：2")
    }

    open fun run() {
        println("人会跑步")
    }
}

// Programmer
interface Programmer {
    fun codding()
}

// DaiYibo 继承Person，实现Programmer
class DaiYibo : Person, Programmer {

    private lateinit var _skill: String;
    init {
        println("初始化调用：3")
    }

    // 次构造函数，需主动实现父类构造函数
    constructor(skill: String) : super("daiyibo", 18) {
        println("初始化调用：4")
        this._skill = skill;
    }

    // 覆盖Person方法
    override fun run() {
        // 调用父类方法
        super.run()
        println("daiyibo 跑的非常快")
    }

    // 实现Programmer接口方法
    override fun codding() {

        println("daiyibo 会敲代码【$_skill】")
    }
}
```

## 接口
> [文档](https://www.kotlincn.net/docs/reference/interfaces.html)

#### 概念讲解
- 声明接口
- 实现接口
- 声明接口属性
- 接口方法调用

#### 示例
```
interface A {

    // 抽象属性
    val prop: Int

    // 提供访问器的实现
    val propertyWithImplementation: String
        get() = "foo"

    // 提供方法foo的默认实现
    fun foo() {
        print("A")
    }

    // 声明bar抽象方法
    fun bar()
}

interface B {

    // 提供方法foo的默认实现
    fun foo() {
        print("B")
    }

    // 提供方法bar的默认实现
    fun bar() {
        print("bar")
    }
}

// 构造方法中声明变量
class C(override val prop: Int) : A {
    override fun bar() {
        print("bar")
    }
}

class D : A, B {

    // 初始化A接口中的抽象属性
    override val prop: Int = 0

    override fun foo() {
        // 指明调用A接口中的方法
        super<A>.foo()
        // 指明调用B接口中的方法
        super<B>.foo()
    }

    override fun bar() {
        // 只有B接口实现此方法，因此不需要指明
        super.bar()
    }
}
```

## 可见性修饰符
> [文档](https://www.kotlincn.net/docs/reference/properties.html)

#### 概念讲解
- private：意味着只在这个类内部（包含其所有成员）可见；
- protected：和 private一样 + 在子类中可见。
- internal：能见到类声明的 本模块内 的任何客户端都可见其 internal 成员；
- public：能见到类声明的任何客户端都可见其 public 成员。

> 模块
> 可见性修饰符 internal 意味着该成员只在相同模块内可见。更具体地说， 一个模块是编译在一起的一套 Kotlin 文件：
> 一个 IntelliJ IDEA 模块；
> 一个 Maven 项目；

#### 示例
```
public class Test {
    private fun printPrivate() {
        print("private")
    }

    public fun printPublic() {
        print("public")
    }

    internal fun printInternal() {
        print("internal")
    }
}
```

## 属性与字段
> [文档](https://www.kotlincn.net/docs/reference/properties.html)

#### 完整语法
```kotlin
var|val [lateinit] <propertyName>[: <PropertyType>] [= <property_initializer>]
    [<getter>]
    [<setter>]
```

#### 字段意义
- val：声明只读关键字
- var：声明可变关键字
- lateinit：延迟初始化，不能作用于基本类型
- set：声明设值器
- get：声明获值器
- field：幕后字段，只在getter、setter方法中使用，表示当前属性

#### 示例
```kotlin
class Person {
        var name: String = "daiyibo"
            set(value) {
                field = "$value..."
            }
            get() {
                return "...$field"
            }
        val age: Int = 18
        lateinit var next: Person
    }
```

## 空安全
> [文档](https://www.kotlincn.net/docs/reference/properties.html)

#### 字段意义
- 可空类型与非空类型
- 在条件中检测 null
- 安全的调用
- Elvis 操作符
- !! 操作符
- 安全的类型转换
