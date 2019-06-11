---
title: Android-Maven依赖规则
date: 2019-06-11 08:18:53
tags: 客户端
---

## dependencies 字段说明

- groupId：所需 Jar 包的项目名
- artifactId：所需 Jar 包的模块名
- version：所需 Jar 包的版本号
- type：依赖类型，默认类型是 Jar
- exclusions：主动排除子项目传递过来的依赖
- scope：设置依赖的传递范围
  1. compile
     编译范围，默认 scope，在工程环境的 classpath（编译环境）和打包（如果是 WAR 包，会包含在 WAR 包中）时候都有效。
  2. provided
     容器或 JDK 已提供范围，表示该依赖包已经由目标容器（如 tomcat）和 JDK 提供，只在编译的 classpath 中加载和使用，打包的时候不会包含在目标包中。最常见的是 j2ee 规范相关的 servlet-api 和 jsp-api 等 jar 包，一般由 servlet 容器提供，无需在打包到 war 包中，如果不配置为 provided，把这些包打包到工程 war 包中，在 tomcat6 以上版本会出现冲突无法正常运行程序（版本不符的情况）。
  3. runtime
     一般是运行和测试环境使用，编译时候不用加入 classpath，打包时候会打包到目标包中。一般是通过动态加载或接口反射加载的情况比较多。也就是说程序只使用了接口，具体的时候可能有多个，运行时通过配置文件或 jar 包扫描动态加载的情况。典型的包括：JDBC 驱动等。
  4. test
     测试范围，一般是单元测试场景使用，在编译环境加入 classpath，但打包时不会加入，如 junit 等。
  5. system
     系统范围，与 provided 类似，只是标记为该 scope 的依赖包需要明确指定基于文件系统的 jar 包路径。因为需要通过 systemPath 指定本地 jar 文件路径，所以该 scope 是不推荐的。如果是基于组织的，一般会建立本地镜像，会把本地的或组织的基础组件加入本地镜像管理，避过使用该 scope 的情况。

## 参考

https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html
https://www.cnblogs.com/wangyonghao/p/5976055.html
