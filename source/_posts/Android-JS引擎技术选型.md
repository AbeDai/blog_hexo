---
title: Android - JS引擎技术选型
date: 2020-11-08 15:03:42
categories: 客户端
---

## 技术选型
### 双引擎方案

**JSC方案**
滴滴出行已集成JSC（2.6M）。Hummer之前是基于此方案实现，会存在一些无法解决的Crash，最终替换为quickjs。

**V8方案**
涂鸦智能已集成V8（4.1M）。此方案肯定是最终双引擎的实现方案。与自定义WebView如出一辙，都是基于Chromium。需要和集团沟通V8包接入。

**WebView方案**
直接利用不展示的WebView作为JS引擎。此方案可作为降级方案，或临时调试方案。

### 双引擎JSDebug调试

**V8方案**
Debug时，切换V8引擎，可以直接支持JS调试。

**WebView方案**
Debug时，切换到WebView作为JS引擎。支持调试。

### 衡量指标

* 执行效率
* 后期维护成本
* Debug模式
* ES6 支持程度：参考小程序：https://opendocs.alipay.com/mini/framework/implementation-detail
* 性能分析：https://neyoufan.github.io/2016/12/23/android/Android%20Js%E5%BC%95%E6%93%8E/%E5%9C%A8Android%E4%B8%8A%E4%BD%BF%E7%94%A8JS%E5%BC%95%E6%93%8E%E6%98%AF%E4%B8%80%E7%A7%8D%E4%BB%80%E4%B9%88%E6%A0%B7%E7%9A%84%E4%BD%93%E9%AA%8C%EF%BC%9F/

## 框架设计

### Hummer Engine 架构分析

Hummer 双引擎主要是基于 JSCore（Weex裁剪版） 和 QuickJS 来展开的。着重分析JSCore相关模块，QuickJS设计思路类似。

![c65d46a1944b7ddd29255fe78aec3164](/image/18073238-7B80-47E7-AA39-4A9BDA39DF98.png)

- 底层直接应用 JSCore 的动态库。
- Hummer Engine 基于 JSCore 的对外能力来进行封装 JNI 能力，用 Hummer 的 java 层使用。
- Hummer Engine java 层来间接执行 js 方法。包括属性的赋值，方法调用，jsscript的执行等。

Hummer 引擎能力分析：

![49e282c32a66294c49e2bd80f72a1fae](/image/8DB5732B-917F-49CD-BD4D-0E80A7D6D0A3.png)


### J2V8 架构分析

源码地址：https://github.com/eclipsesource/J2V8

看了 J2V8 的 Java 层 API 封装。从设计上比 Hummer 要优秀不少。决定分析一波 J2V8 的 Java 层 API。在做 双引擎 设计时，尽量想 J2V8靠齐。

![ae8b90853664e94e268a15a19f4ba593](/image/5D1692FC-D443-41B3-9456-C13CB2438B1C.png)

用法简介：https://blog.csdn.net/baidu_32237719/article/details/96888266

### 双引擎工作分解

- 引擎 JS 和 WebView 的 JS 之间的交互操作
    - WebView 发消息给 引擎 JS：点击事件
    - 引擎 JS 来发消息给 WebView：操作dom
- 引擎 JS 和 Native Bridge 之间的交互操作
    - JS 来触发 Native 方法：JSBridge被触发
    - Native 方法来触发 JS callback 回调：JSBridge回调
    - Native 方法触发 全局 JS 方法：发布订阅机制

基于以上场景，来抽象双引擎需要用到那些 JS 操作能力。再参考 J2V8 Java层封装来实现 Didi JSCore 的 Java 抽象层。


##### 双引擎API能力实现如下（打小红旗部分）

![8ae9df98721dc06002e349b7afdfcbce](/image/30CDB86A-31B2-44CA-8DCC-E2607173ECCE.png)

##### 调试能力

国外有人已经做了基于Facebook的Stetho的J2V8调试工具了。直接借鉴即可。

https://github.com/AlexTrotsenko/j2v8-debugger

