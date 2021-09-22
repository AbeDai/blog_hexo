---
title: Android - 小程序容器框架设计
date: 2021-09-22 12:13:40
categories: 客户端
---

# 小程序容器核心概念

小程序 与 H5 的最大区别就在于双引擎设计。设计双引擎，我理解以下优势：

- 管控性和安全性：小程序业务代码的执行环境为 JSEngine，无法调用到小程序基础能力以外的更多宿主能力。
- 类App的运行环境：在进行页面时，小程序业务代码的执行环境始终处于一个 JSEngine 实例，JS对象不会随页面而销毁。

小程序的核心在于双引擎设计，双引擎设计 其实就是 JSEngine、WebVIew、Native 三者之间的通讯。

![7107fedb61d781637b52b13ac1c7f388](/image/4970F055-0EF4-4133-8A22-3A981803A9F2.png)

图中的消息流转过程，为 点击刷新按钮 -> 请求网络数据 -> 展示请求结果 的典型前端逻辑。

- [1] [2] 表示 `WebView -> JSEngien`，用户点击行为从视图层传递到逻辑层，触发小程序业务代码。
- [3] [4] 表达 `JSEngine -> Native`，网络请求行为从逻辑层传递到 Native 层，让 Native 去触发网络请求操作。
- [5] [6] 表达 `Native -> JSEngine`，网络请求结果从 Native 层传递到逻辑层，触发到小程序业务代码，执行接下来的逻辑。
- [7] [8] 表达 `JSEngine -> WebView`，视图变更结果从逻辑层传递到视图层，业务代码根据请求结果，触发视图变更。

# 通讯设计

小程序通讯协议设计上，消息存在6条通道，分别来维护 WebView、JSEngine、Native 三者之间的通讯。

#### WebView -> JSEngine

从 `WebView层` 发消息给 `JSEngine层`，分为两步。

`WebView层` 调用 `DiminaWebViewBridge.publish` 发消息给 `Native层`，`Native层` 调用 `DiminaServiceBridge.subscribeHandler` 将消息转发到 `JSEngine层`。

```
// Native层 声明、WebView层 调用
// payload: 传递数据
DiminaWebViewBridge.publish(payload)

// JSEngine层 声明、Native层 调用
// payload: 从 webview 层传递过来的数据
DiminaServiceBridge.subscribeHandler(payload)
```

#### WebView -> Naitve

从 `WebView层` 发消息给 `Naitve层`，分为两步。

`WebView层` 调用 `DiminaWebViewBridge.invoke` 发消息给 `Native层`，`Native层` 处理完时间后，调用`DiminaWebViewBridge.invokeCallbackHandler` 将回调结果发送到 `WebView层`。

```
// Native层 声明、WebView层 调用
// methodName: 函数名
// payload: 入参数据
// methodName: 回调id
// moduleName: 模块名
DiminaWebViewBridge.invoke(methodName, payload, invokeId, moduleName)

// WebView层 声明、 Native层调用
// payload: 回调数据
// invokeId: 回调id
DiminaWebViewBridge.invokeCallbackHandler({payload:{}, invokeId:""})
```

#### JSEngine -> WebView

从 `JSEngine层` 发消息给 `WebView层`，分为两步。

`JSEngine层` 调用 `DiminaServiceBridge.publish` 发消息给 `Native层`，`Native层` 调用 `DiminaWebViewBridge.subscribeHandler` 将消息转发到 `JSEngine层`。

注意这里的 WebViewId 是用来指定往哪个 WebView 发送消息的。

```
// Native层 声明、JSEngine层 调用
// payload: 传递数据
// webviewId: 传递给视图层id
DiminaServiceBridge.publish(payload, webviewId)

// WebView层 声明、Native层 调用
// payload: 从 jsengine 层传递过来的数据
DiminaWebViewBridge.subscribeHandler({payload})
```

#### JSEngine -> Native

从 `JSEngine层` 发消息给 `Native层`，分为两步。

`JSEngine层` 调用 `DiminaServiceBridge.invoke` 发消息给 `Native层`，`Native层` 处理完时间后，调用`DiminaServiceBridge.invokeCallbackHandler` 将回调结果发送到 `JSEngine层`。

注意这里的 `invokeId` 是用来进行回调绑定的。

```
// Native层 声明、JSEngine层 调用
// methodName: 函数名
// payload: Bridge入参
// methodName: 回调id
// moduleName: 模块名
DiminaServiceBridge.invoke(methodName, payload, invokeId, moduleName)

// JSEngine层 声明、Native层 调用
// payload: 回调数据
// invokeId: 回调id
DiminaServiceBridge.invokeCallbackHandler({payload, invokeId})
```

#### Native -> WebView

从 `Native层` 发消息给 `WebView层`。用于触发客户端的生命周期给前端。
`Native层` 调用 `DiminaWebViewBridge.invokeCallbackHandler` 发消息给 `WebView层`。

```
// WebView层 声明、Native层 调用
// payload: Bridge入参
// event: 事件名
DiminaWebViewBridge.invokeCallbackHandler({payload, event})
```

#### Native -> JSEngine

从 `Native层` 发消息给 `WebView层`。用于触发客户端的生命周期给前端。
`Native层` 调用 `DiminaServiceBridge.invokeCallbackHandler` 发消息给 `JSEngine层`。

```
// JSEngine层 声明、Native层 调用
// payload: Bridge入参
// event: 事件名
DiminaServiceBridge.invokeCallbackHandler({payload, event})
```
