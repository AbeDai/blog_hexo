---
title: Android - 小程序容器框架设计
date: 2021-09-22 12:13:40
categories: 客户端
---

# 容器分层设计

![f69d65bef279012d727937e8c8f2601c](/image/0DBC8993-174F-448A-A2D8-C69577C6DFF7.png)

小程序容器基本分成三层：

1. 基础引擎层
2. 容器框架层
3. 扩展能力层

#### 基础引擎层

我们对逻辑层引擎进行了接口层抽象，方便其进行底层替换。基于接口，我们实现了 `V8引擎`、`SystemView引擎`、`X5引擎`、`JSCore引擎`。经过实际项目稳定性与性能验证之后，我们觉得用 `V8引擎` 作为我们的逻辑层引擎，当 `V8引擎` 出现线上问题时，我们会执行降级策略，降级使用 `SystemWebView引擎`。

视图层还未进行接口层抽象。

#### 容器框架层

我们将与小程序容器息息相关的能力，沉淀到 `容器框架层`。其实 `扩展能力层` 与 `容器框架层` 之间，也没有特别清楚的划分。目前，我们将以下模块沉淀到了`容器框架层` 中：

1. 路由跳转：包括 navigateTo，redirectTo，navigateBack，relaunch，switchTab，exitMiniProgram。
2. 生命周期管理：包括 前后台切换，页面跳转，内存不足通知。
3. 包管理：包括 静默更新，强制更新，本地安装。
4. 监控：包括 稳定性，性能，使用量 的监控。
5. 样式：包括 标题栏，下拉刷新，跳转动画，加载中动画，分包下载动画。
6. 调试：包括 IDE预览功能，V8 Debug功能，vConsole功能。
7. 文件：包括 Storage存储，文件下载，文件保存。、

#### 扩展能力层

小程序容器与前端交互最多的就属于这个 `扩展能力` （说人话就是 JSBridge）。查看[微信开发者文档](https://developers.weixin.qq.com/miniprogram/dev/framework/)，就能看到这里面巨大的工作量。

目前，已经实现了 `183` 个 JSBridge。基本覆盖了 滴滴出行小程序 大部分的业务场景。

[详见文档](https://docx.intra.xiaojukeji.com/docs/dimina#/README)

#### 扩展机制

对于 Custom View，我们提供了 `Dimina.registerCustomComponent` 方法，支持 组件的自定义扩展。每个组件需实现 `onMounted`,`onPropertiesUpdate`,`onDestroyed` 三个方法，来完成与 前端 的交互。

```
// 组件被挂载
public abstract View onMounted(Context context, JSONObject attributes);

// 组件更新
public void onPropertiesUpdate(JSONObject attributes)

// 组件销毁
public abstract void onDestroyed();
```

对于 Custom Bridge，我们提供了4种不同级别的扩展方式。

```
// 全局 的 注册 JS Module 给 前端 使用
Dimina.registerJSModule(Class<? extends BaseServiceModule> moduleClass);

// 全局 的 重写或者新增星河默认的DMServiceJSModule下的方法Bridge
Dimina.registerDMServiceSubJSModule(Class<? extends BaseServiceModule> moduleClass);

// 小程序级别 的 注册 JS Module 给 前端 使用
new DMMina().registerJSModule(Class<? extends BaseServiceModule> moduleClass);

// 小程序级别 的 重写或者新增星河默认的DMServiceJSModule下的方法Bridge
new DMMina().registerJSModule(Class<? extends BaseServiceModule> moduleClass);
```

#### 插件化机制

由于每个App的架构不同，我们将 小程序容器 中比较重的 JSBridge 模块抽象成了插件。只有当业务需要时才进行接入，进一步提高了容器的灵活性。
Bridge 插件化，既能减少小程序容器的引入带来的包体积问题，还能减少无用权限的声明。

目前，小程序容器支持的插件有：

- 地图
- 分享
- 登录
- 支付
- 视频
- 蓝牙

业务可以选择性的依赖。
