---
title: Android-WebView 硬件加速原理.md
date: 2020-09-20 23:37:42
categories: 客户端
---

## Android中的硬件加速
在Android中，大多数应用的界面都是利用常规的View来构建的（除了游戏、视频、图像等应用可能直接使用OpenGL ES）。下面根据Android 6.0原生系统的Java层代码，对View的软件和硬件加速渲染做一些分析和对比。

#### DisplayList
DisplayList是一个基本绘制元素，包含元素原始属性（位置、尺寸、角度、透明度等），对应Canvas的drawXxx()方法（如下图）。

信息传递流程：Canvas(Java API) —> OpenGL(C/C++ Lib) —> 驱动程序 —> GPU。

在Android 4.1及以上版本，DisplayList支持属性，如果View的一些属性发生变化（比如Scale、Alpha、Translate），只需把属性更新给GPU，不需要生成新的DisplayList。

#### Android 6.0 绘制流程

![4ff2187c6e65058068a5f831d3e5de68](/image/4E126BCD-9A43-43FC-AEB3-01F37302F6D7.png)

#### Display List的渲染过程

应用程序窗口的Display List的渲染过程就分析完成了。整个过程比较复杂，但是总结来说，核心逻辑就是：

1. 将Main Thread维护的Display List同步到Render Thread维护的Display List去。这个同步过程由Render Thread执行，但是Main Thread会被阻塞住。

2. 如果能够完全地将Main Thread维护的Display List同步到Render Thread维护的Display List去，那么Main Thread就会被唤醒，此后Main Thread和Render Thread就互不干扰，各自操作各自内部维护的Display List；否则的话，Main Thread就会继续阻塞，直到Render Thread完成应用程序窗口当前帧的渲染为止。

3. Render Thread在渲染应用程序窗口的Root Render Node的Display List之前，首先将那些设置了Layer的子Render Node的Display List渲染在各自的一个FBO上，接下来再一起将这些FBO以及那些没有设置Layer的子Render Node的Display List一起渲染在Frame Buffer之上，也就是渲染在从Surface Flinger请求回来的一个图形缓冲区上。这个图形缓冲区最终会被提交给Surface Flinger合并以及显示在屏幕上。

第2步能够完全将Main Thread维护的Display List同步到Render Thread维护的Display List去很关键，它使得Main Thread和Render Thread可以并行执行，这意味着Render Thread在渲染应用程序窗口当前帧的Display List的同时，Main Thread可以去准备应用程序窗口下一帧的Display List，这样就使得应用程序窗口的UI更流畅。

## Bugfix：透明WebView怎么使用硬件加速

![e017767f66855da4f12f7b57348f2e6e](/image/1EFD0CFB-2FB9-48C5-91DE-7C27966D84C3.png)

参考：

- https://stackoverflow.com/questions/9282333
- https://issuetracker.google.com/issues/36925660

问题分析：
- 如果是因为在低版本系统中，用了硬件加速，OpenGL 忽略了透明背景色的话，可以通过 设置透明度或者设置背景图片来解决这个问题。
- 如果是因为硬件加速处理透明度的优化算法出现了问题，可以通过自研内核解决此问题。从 Android 4.4 开发，Android 已经通过 Chromium 来实现 Webview 功能了。出现这种情况的概率应该不大。

监测透明WebView的硬件加速问题：
目前来看，此问题反馈者主要集中在 Android 3.2 和 Android 4.1 的机型设备上。目前集团App最低支持版本为 5.1 版本。下周重点关注下机型兼容问题。Apollo线上全量开硬件加速。

## 参考

https://tech.meituan.com/2017/01/19/hardware-accelerate.html
https://blog.csdn.net/Luoshengyang/article/details/45601143
https://blog.csdn.net/luoshengyang/article/details/45769759
https://blog.csdn.net/luoshengyang/article/details/45943255
https://blog.csdn.net/luoshengyang/article/details/46281499
https://blog.csdn.net/luoshengyang/article/details/46449677
https://blog.csdn.net/luoshengyang/article/details/45831269
https://blog.csdn.net/Luoshengyang/article/details/53366272

