---
title: Android-Gradle大杂烩
date: 2019-05-04 13:21:27
categories: 客户端
---

## Gradle 常用操作

- **doFirst**：任务最先执行的 action
- **doLast**：任务最后执行的 action
- **dependsOn**：任务之间存在依赖关系
- **finalizedBy**：任务执行完之后，要执行的任务
- **mustRunAfter**：当两个任务同时存在时，任务之间存在优先级关系

```groovy
task stand {

    group='behavior'
    description='stand -> walk -> run'

    doFirst {
        println 'doFirst: stand'
    }

    doLast {
        println 'doLast: stand'
    }
}

task jump {

    group='behavior'
    description='jump -> run'

    doFirst {
        println 'doFirst: jump'
    }

    doLast {
        println 'doLast: jump'
    }
}

task walk {

    group='behavior'
    description='walk -> run'

    doFirst {
        println 'doFirst: walk'
    }

    doLast {
        println 'doLast: walk'
    }
}

task run {

    group='behavior'
    description='run, run, run ~'

    doFirst {
        println 'doFirst: run'
    }

    doLast {
        println 'doLast: run'
    }
}

task rest {

    group='behavior'
    description='take a rest'

    doFirst {
        println 'doFirst: rest'
    }

    doLast {
        println 'doLast: rest'
    }
}


walk.dependsOn stand
jump.dependsOn stand
run.dependsOn walk
run.dependsOn jump
jump.mustRunAfter walk
run.finalizedBy rest

// 输出结果如下：
MacBook-Pro:temp daiyibo$ ./gradlew -q run
doFirst: stand
doLast: stand
doFirst: walk
doLast: walk
doFirst: jump
doLast: jump
doFirst: run
doLast: run
doFirst: rest
doLast: rest

```

参考：https://blog.csdn.net/lzyzsd/article/details/46935405

## Gradle Wrapper 的作用

Gradle Wrapper，它是一个脚本，能够指定 Gradle 的版本。使用 Gradle Wrapper 启动 Gradle 时，如果指定版本的 Gradle 没有被下载关联，会先从 Gradle 官方仓库下载该版本 Gradle 到用户本地，并使用下载的 Gradle 执行任务。这样就标准化了项目，提高了开发效率。

以 Linux 为例，在调用 gradlew 执行任务时，实际上是通过 shell 在执行 gradlew 脚本任务。这个脚本任务，间接通过 jre 调起工作目录下的 gradle/wrapper/gradle-wrapper.jar。由 gradle-wrapper.jar 来负责处理 gradle 的版本控制和任务执行。

参考文章：http://liuwangshu.cn/application/gradle/4-wrapper.html

## Gradle 插件类型

在 Gradle 中一般有两种类型的插件，分别叫做脚本插件和对象插件。脚本插件是额外的构建脚本，它会进一步配置构建，可以把它理解为一个普通的 build.gradle。对象插件又叫做二进制插件，是实现了 Plugin 接口的类。

- 脚本插件，相当于写了一个 xxx.gradle 脚本，在 build.gradle 中引入了这个脚本。例如：[gradle-mvn-push](https://github.com/chrisbanes/gradle-mvn-push)
- 对象插件，就是实现了 org.gradle.api.plugins<Project>接口的插件，例如常见的字节码插桩的编译时插件

参考：http://liuwangshu.cn/application/gradle/5-plugins.html

## Gradle 生命周期

Gradle 生命周期有三个阶段，分别是：实例化阶段->配置阶段->执行阶段

- **初始化阶段**：通过 settings.gradle 判断有哪些项目需要初始化,加载所有需要初始化的项目的 build.gradle 文件并为每个项目创建 project 对象
- **配置阶段**：执行各项目下的 build.gradle 脚本，完成 project 的配置，并且构造 Task 任务依赖关系图以便在执行阶段按照依赖关系执行 Task.执行 task 中的配置代码
- **执行阶段**： 通过配置阶段的 Task 图,按顺序执行需要执行的 任务中的动作代码,就是执行任务中写在 doFirst 或 doLast 中的代码

<img width="600" src="/image/gradle_lifecycle.jpg">

参考：https://docs.gradle.org/current/userguide/build_lifecycle.html
参考：https://www.heqiangfly.com/2016/03/18/development-tool-gradle-lifecycle/

## 理解 groovy 的闭包

闭包（Closure）是很多编程语言中很重要的概念，那么 Groovy 中闭包是什么，官方定义是“Groovy 中的闭包是一个开放，匿名的代码块，可以接受参数，返回值并分配给变量”，简而言之，他说一个匿名的代码块，可以接受参数，有返回值

#### 声明和使用

```
/** 闭包结构 **/
{ [closureParameters -> ] statements }

/** 举例 **/
//执行一句话
{ printf 'Hello World' }

//闭包有默认参数it，且不用申明
{ println it }

//闭包有默认参数it，申明了也无所谓
{ it -> println it }

// name是自定义的参数名
{ name -> println name }

 //多个参数的闭包
{ String x, int y ->
    println "hey ${x} the value is ${y}"
}
```

#### 闭包内的对象：this，owner，delegate

- **this**：对应于定义闭包的那个类，如果在内部类中定义，指向的是内部类
- **owenr**：对应于定义闭包的那个类或者闭包，如果在闭包中定义，对应闭包，否则同 this 一致
- **delegate**：默认是和 owner 一致，或者自定义 delegate 指向

#### 闭包内的 delegate 策略

- **Closure.OWNER_FIRST**：是默认策略。优先在 owner 寻找，owner 没有再 delegate
- **Closure.DELEGATE_FIRST**：优先在 delegate 寻找，delegate 没有再 owner
- **Closure.OWNER_ONLY**：只在 owner 中寻找
- **Closure.DELEGATE_ONLY**：只在 delegate 中寻找
- **Closure.TO_SELF**：自定义策略，未指定属性位置时，都通过自定义策略来获取属性值

参考：https://www.jianshu.com/p/6dc2074480b8
参考：http://www.groovy-lang.org/closures.html
参考：http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html
参考：https://www.jianshu.com/p/ae10f75b37cf

# gradle 执行 Android app 运行任务的原理

参考：https://mp.weixin.qq.com/s/aqo6ueTUxEOdGx5tyzQrPQ
参考：https://mp.weixin.qq.com/s/DzuLtqx_CBFm9tJos9j2Ag

## 参考

Gradle 核心思想：http://liuwangshu.cn/tags/Gradle%E6%A0%B8%E5%BF%83%E6%80%9D%E6%83%B3/
搞定 Groovy 闭包这一篇就够了：https://www.jianshu.com/p/6dc2074480b8
Groovy-Closures 官方文档：http://www.groovy-lang.org/closures.html
Groovy-DSL 官方文档：http://docs.groovy-lang.org/latest/html/documentation/core-domain-specific-languages.html
Groovy-Closures 官方文档-翻译节选：https://www.jianshu.com/p/ae10f75b37cf
Gradle-构建生命周期：https://docs.gradle.org/current/userguide/build_lifecycle.html
Gradle tip #3-指定 Task 顺序：https://blog.csdn.net/lzyzsd/article/details/46935405
Gradle 使用指南-Gradle 生命周期：https://www.heqiangfly.com/2016/03/18/development-tool-gradle-lifecycle/
实战 Gradle*中文完整版.pdf：[点击打开](/image/实战 Gradle*中文完整版@www.jqhtml.com.pdf)
