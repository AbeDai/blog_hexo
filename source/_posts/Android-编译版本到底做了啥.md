---
title: Android-编译版本到底做了啥?
date: 2019-05-10 16:15:54
categories: 客户端
---

## compileSdkVersion
应用编译时使用的sdk版本(仅编译时生效，与运行时无关)

```
1. 我们日常开发中编译、打包apk时使用的android sdk版本就是由compileSdkVersion指定的
2. 代码中可用的api也与该版本对应，高于声明版本的api则无法找到、使用
3. 顺带一提，buildtools的版本要与compileSdkVersion保持一致
4. 推荐总是使用最新的 SDK 进行编译。在现有代码上使用新的编译检查可以获得很多好处，避免新弃用的 API ，并且为使用新的 API 做好准备
```

## buildToolsVersion
buildToolsVersion 是 Android SDK 构建工具，是构建 Android 应用程序所需的 Android SDK 的一个组件。它安装在 <sdk>/build-tools/ 目录中，它只是构建工具

## minSdkVersion
一个用于指定应用运行所需最低 API 级别的整数。 如果系统的 API 级别低于该属性中指定的值，Android 系统将阻止用户安装应用

## maxSdkVersion
一个指定作为应用设计运行目标的最高 API 级别的整数，新版本平台完全向前兼容，所以默认支持到最高版本

## targetSdkVersion（重要） 
应用运行时使用的sdk版本，指定的android sdk的功能特性，将在运行时生效。

```
举个例子，比如android6.0(api 23)系统的动态权限检查功能
1、targetSdkVersion<23时：
该应用安装在android6.0的手机上后，
不会执行android6.0系统以上特有的动态权限检查逻辑，
而是仍继续执行以前的权限检查逻辑。

2、当targetSdkVersion变为23后：
android6.0系统的动态权限检查特性将生效。

3、当targetSdkVersion为25(代表android7.0)>23：
安装在android6.0的设备上时，
仍只能执行6.0及其以下的功能特性，无法执行7.0的新特性。

通常targetSdkVersion 小于等于 compileSdkVersion，
一般都是在compileSdkVersion指定的版本编译并测试过相关特性没有问题后，
才将targetSdkVersion改为compileSdkVersion的版本
```