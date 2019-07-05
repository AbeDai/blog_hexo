---
title: Android-Kotlin赶潮流学习
date: 2019-05-20 19:45:54
categories: 客户端
---

## Kotlin 语法糖理解

Kotlin 和 Java 都是运行在 JVM 上，最终都会转化成 bytecode。因而将同一份 bytecode 反编译成 Java 和 Kotlin 文件是等价的。
将 Kotlin 编译后的 bytecode 反编译成 Java，再进行语法对比，从而了解语法糖到底干了些什么。

以 object 单例为例，比对结果如下：
![](/image/android_kotlin_compare_1.png)

## Kotlin 编写 SDK 对 App 的影响

Kotlin 语法糖在编译后，最终会调用 kotlin-stdlib 方法。因此，在 SDK 中使用 Kotlin，会为使用此 SDK 的 App 引入 kotlin-stdlib 包。在未混淆的情况下，会给 App 增加 600KB 的源码体积。

引入 Kotlin 之后，会增加以下依赖库：

- org.jetbrains.kotlin:kotlin-stdlib-jdk8: 是 Kotlin JVM 运行环境标准库的 Java 8 扩展版
- org.jetbrains.kotlin:kotlin-stdlib-jdk7: 是 Kotlin JVM 运行环境标准库的 Java 7 扩展版
- org.jetbrains.kotlin:kotlin-stdlib: 是 Kotlin JVM 运行环境的标准库
- org.jetbrains.kotlin:kotlin-stdlib-common: 是 Kotlin 运行环境的标准库的公共实现。`kotlin-stdlib-js`与`kotlin-stdlib`都依赖此库，作为标准库的通用逻辑实现库
- org.jetbrains:annotations: 老东家的注解包，辅助`kotlin-stdlib`实现注解元信息的作用

依赖关系如下：

```shell
\--- org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.3.31
     +--- org.jetbrains.kotlin:kotlin-stdlib:1.3.31
     |    +--- org.jetbrains.kotlin:kotlin-stdlib-common:1.3.31
     |    \--- org.jetbrains:annotations:13.0
     \--- org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.3.31
          \--- org.jetbrains.kotlin:kotlin-stdlib:1.3.31 (*)
```

SDK 中使用 Kotlin 的推荐配置如下：

```groovy
apply plugin: 'com.android.library'

apply plugin: 'kotlin-android'

android {
    ...
}

dependencies {
    // kotlin 标准库
    implementation "org.jetbrains.kotlin:kotlin-stdlib:$kotlin_version"
//    // 要使用java 7特性时，使用kotlin-stdlib-jdk7依赖库，不推荐
//    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
//    // 要使用java 8特性时，使用kotlin-stdlib-jdk8依赖库，不推荐
//    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk8:$kotlin_version"
}
```

## 插件 kotlin-android-extensions 介绍

Kotlin Android Extensions 是 Kotlin 官方推出的简化 Android 开发的 Gradle 插件。目前主要针对如下几种场景：

- View Binding：即 UI 绑定，不需要再依赖其它 library(如 butterknife)，即可实现 UI 绑定
- View Caching：UI 缓存，内置已实现了 UI 的缓存策略
- Parcelable：使用注解即可实现 Android 的 Parcelable 序列化

**注: 个人感觉这个插件意义不大**

## Kotlin 在编译时对比

通过编译任务对比，发现`kotlin-android`为编译任务多添加了一个`compileXXXXKotlin`任务。该任务的目标是将 kotlin 代码编译成 jvm 字节码
![](/image/android_kotlin_compare_1.png)

源码版本为 `kotlin-gradle-plugin:1.3.31`

插件 `kotlin-android` 定义

```
// kotlin-android.properties
implementation-class=org.jetbrains.kotlin.gradle.plugin.KotlinAndroidPluginWrapper
```

Kotlin 编译 `compileXXXXKotlin` 任务
实现类为 org.jetbrains.kotlin.gradle.tasks.Tasks.kt 内部类 KotlinCompile

## 参考

https://droidyue.com/blog/2017/05/08/how-to-study-kotlin/
https://www.kotlincn.net/docs/reference/basic-syntax.html
https://blog.csdn.net/tscyds/article/details/79668536
