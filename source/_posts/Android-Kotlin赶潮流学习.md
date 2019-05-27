---
title: Android-Kotlin赶潮流学习
date: 2019-05-20 19:45:54
tags: 客户端
---

## Kotlin语法糖理解
Kotlin和Java都是运行在JVM上，最终都会转化成bytecode。因而将同一份bytecode反编译成Java和Kotlin文件是等价的。
将Kotlin编译后的bytecode反编译成Java，再进行语法对比，从而了解语法糖到底干了些什么。

以object单例为例，比对结果如下：
![](/image/android_kotlin_compare_1.png)

## Kotlin编写SDK对App的影响
Kotlin语法糖在编译后，最终会调用kotlin-stdlib方法。因此，在SDK中使用Kotlin，会为使用此SDK的App引入kotlin-stdlib包。在未混淆的情况下，会给App增加600KB的源码体积。

引入Kotlin之后，会增加以下依赖库：
- org.jetbrains.kotlin:kotlin-stdlib-jdk8: 是Kotlin JVM运行环境标准库的Java 8扩展版
- org.jetbrains.kotlin:kotlin-stdlib-jdk7: 是Kotlin JVM运行环境标准库的Java 7扩展版
- org.jetbrains.kotlin:kotlin-stdlib: 是Kotlin JVM运行环境的标准库
- org.jetbrains.kotlin:kotlin-stdlib-common: 是Kotlin运行环境的标准库的公共实现。`kotlin-stdlib-js`与`kotlin-stdlib`都依赖此库，作为标准库的通用逻辑实现库
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

SDK中使用Kotlin的推荐配置如下：
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
Kotlin Android Extensions是Kotlin官方推出的简化Android开发的Gradle插件。目前主要针对如下几种场景：
- View Binding：即UI绑定，不需要再依赖其它library(如butterknife)，即可实现UI绑定
- View Caching：UI缓存，内置已实现了UI的缓存策略
- Parcelable：使用注解即可实现Android的Parcelable序列化

**注: 个人感觉这个插件意义不大**

## Kotlin在编译时对比

通过编译任务对比，发现`kotlin-android`为编译任务多添加了一个`compileXXXXKotlin`任务。该任务的目标是将kotlin代码编译成jvm字节码
![](/image/android_kotlin_compare_1.png)

源码版本为 `kotlin-gradle-plugin:1.3.31`

插件 `kotlin-android` 定义
```
// kotlin-android.properties
implementation-class=org.jetbrains.kotlin.gradle.plugin.KotlinAndroidPluginWrapper
```

Kotlin编译 `compileXXXXKotlin` 任务
实现类为 org.jetbrains.kotlin.gradle.tasks.Tasks.kt 内部类 KotlinCompile

## 参考
https://droidyue.com/blog/2017/05/08/how-to-study-kotlin/
https://www.kotlincn.net/docs/reference/basic-syntax.html
https://blog.csdn.net/tscyds/article/details/79668536