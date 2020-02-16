---
title: 前端-Weex框架通读
date: 2020-02-17 00:47:13
categories: 前端
---

## 前言

不知不觉，在技术的道路上已经走了6年了。初次接触跨平台开发概念，还是Facebook推出的ReactNative框架。现在回想一下，已经是5年前的事情了。毋庸置疑，跨端已成了主流模式。我也从Android开发工程师，慢慢变成了一名大前端开发工程师，技术边界从Android拓展到了前端。先后学习了ReactNative、Flutter、Weex。已经谙熟跨端框架的框架套路。已经在框架学习中，渐渐总结出了自己的学习方法论。
本文用于记录，我在学习Weex框架中的一些心得体会。

## 我对跨平台框架的理解

抛开具体实现，如果我们要在公司从0到1规划实现一个跨平台框架。应该有哪些部分组成呢？

<img width="800" src="/image/weex_lijie.svg">

## Weex开发体验

#### Vue在Web中与在Weex中的平台差异

- 执行环境差异：Weex页面对应为真实的Activity，而Web中的页面切换只是SPA（单页面应用）技术模拟出来的效果。Vue全局配置，页面间不共享。
- DOM操作差异：Web中存在DOM树操作，而Weex中不存在此概念。
- CSS样式差异：Weex只支持了部分够用的CSS样式。
- Vue生命周期及API：Weex中Vue为Web中Vue的子集，只支持大部分通用功能。

#### Android端集成

虽然基本集成方式上与ReactNative雷同，但Weex的API设计更富有中国味道。这点还蛮让人喜欢的。页面渲染本质上就是解析JS包，渲染VNode节点，并转化为真实Native的View。

#### 开发环境说明

- Weex环境变量API接口：主要提供当前Weex页面的开发上下文，包括：设备信息、App信息、屏幕尺寸等。
- 跨页面通讯API接口：提供页面间通讯能力，类似于EventBus的全双工通讯架构。

#### 能力扩展性

Weex提供以下能力，和ReactNative类似，满足所有客户端业务扩展需求。
- Module 支持扩展 非 UI 的特定功能。例如 sendHttp、openURL 等。
- Component 扩展 实现特别功能的 Native 控件。
- Adapter 扩展 Weex 对一些基础功能实现了统一的接口，可实现这些接口来定制自己的业务。例如：图片下载等。

#### 内置组件

Weex实现一套自定义组件标签，不同于html标签。例如，文本标签为<text>，而不是<span>标签。不过用法和html标签大相径庭，无学习成本。
- `<a>` 组件用于实现页面间的跳转。
- `<div>` 是通用容器。
- `<text>` 是 Weex 内置的组件，用来将文本按照指定的样式渲染出来.
- `<image>` 用于在界面中显示单个图片。
- `<list>` 组件是提供垂直列表功能的核心组件，拥有平滑的滚动和高效的内存管理，非常适合用于长列表的展示。
- `<waterfall>` 组件是提供瀑布流布局的核心组件。
- `<cell>` 必须以一级子组件的形式存在于 listrecyclerwaterfall 中。
- `<loading>` 为容器提供上拉加载功能。
- `<refresh>` 为容器提供下拉刷新功能。
- `<recycle-list>` 是一个新的支持竖向或横向的列表容器，具有回收和复用的能力，可以大幅优化内存占用和渲染性能。
- `<scroller>` 是一个容纳子组件进行横向或竖向滚动的容器组件。
- `<slider>` 组件用于在一个页面中展示多个图片，在前端这种效果被称为轮播图。默认的轮播间隔为3秒。
- `<input>` 组件用来创建接收用户输入字符的输入组件。
- `<textarea>` 支持多行文本输入。
- `<web>` 用于在 WEEX 页面中显示由 src 属性指定的网页内容。

#### 内置模块

Weex内置了常用模块，功能也还算健全。
- animation 模块：可以用来在组件上执行动画。
- clipboard 模块：提供的接口可以用于获取、设置剪切板内容，目前只支持字符串类型。
- dom 模块：用于对 weex 页面里的组件节点进行一部分特定操作。
- globalEvent 模块：用于监听持久性事件，例如定位信息，陀螺仪等的变化。
- meta 模块：可用于声明单个页面的元信息，通常是一些页面级别的配置，如容器的显示宽度 (viewport) 等。
- modal 模块：提供了以下展示消息框的 API：toast、alert、confirm 和 prompt。
- navigator 模块就是用来实现类似的效果的。
- picker 模块：用于提供数据选择，日期选择，时间选择。
- storage 模块：可以对本地数据进行存储、修改、删除，并且该数据是永久保存的。
- stream 模块：提供了基本的网络请求能力，例如 GET 请求、POST 请求等，用于在组件的生命周期内与服务端进行交互。
- webview 模块：提供了一系列的 <web> 组件操作接口，例如 goBack、goForward 和 reload，一般与 <web> 组件一起使用，在 Weex 页面内渲染 web 页面。
- webSockets 模块：是一种创建持久性的连接，并进行双向数据传输的 HTTP 通信协议。
- deviceInfo 模块：可用来获取设备的基本信息并进行设置，如fullScreenHeight（全面屏高度）。适配全面屏时建议使用该模块。
- console-log 模块：日志输出工具。

#### Weex样式说明

Weex样式是Css样式的阉割版。抛弃Web样式冗余部分，不求繁杂，只求够用。
- Weex 盒模型基于 CSS 盒模型，每个 Weex 元素都可视作一个盒子。
- Weex 布局模型基于 CSS Flexbox布局。
- Weex 支持 position 定位，用法与 CSS position 类似。
- Weex 支持 transition 属性来提升您应用的交互性与视觉感受。
- Weex 支持四种伪类：active, focus, disabled, enabled。
- Weex 支持 box-shadow 属性用于设置元素阴影。
- Weex 支持线性渐变背景。
- Weex 支持字体样式：color、font-size、font-style、font-weight、text-decoration、text-align、font-family等。

#### Weex通用事件

Weex封装了常用的点击事件。除此之外，还有冒泡拦截、手势事件机制，为交互提供了高扩展性。
- 通用事件：点击（click）、长按（longpress）、控件可见（appear）、控件消失（disappear）、页面可见（viewappear）、页面消失（viewdisappear）。
- 冒泡机制：Weex提供了事件冒泡机制，为事件传递提供了很好的拦截方式。
- 手势事件：提供触摸点和触摸状态，为自定义手势提供扩展空间。触摸开始（touchstart）、触摸中（touchmove）、触摸结束（touchend）、手势拦截（stopPropagation）。
