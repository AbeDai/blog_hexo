---
title: Android-DexClassLoader和Smali语法介绍
date: 2019-04-07 14:33:37
tags: 客户端
---

## 可以考虑单独剥离一篇文章，进行学习介绍
https://blog.csdn.net/luoshengyang/article/details/6768304

## LocalSocket补漏
入门介绍，讲清楚了这些概念：http://www.cnblogs.com/bastard/archive/2012/10/09/2717052.html
实践项目：https://blog.csdn.net/azhengye/article/details/73863404#localsocket%E9%80%9A%E4%BF%A1%E5%AE%9E%E4%BE%8B
原理了解：linux内核源代码情景分析-第七章
为什么Zynote要通过Socket进行IPC通讯，而不是通过Binder来实现呢？
需要再去巩固下这块的知识，然后产出功能实现了
https://www.zhihu.com/question/312480380/answer/603452687

## 杂记
Dalvik虚拟机与Java虚拟机的最显著区别是它们分别具有不同的类文件格式以及指令集。

## Android Dalvik虚拟机
Java虚拟机是基于JIT实现的。而Dalvik虚拟机是基于AOT实现的。直接反编译看看Java指令代码，来体会下吧~

## 简单介绍了下虚拟机垃圾回收机制
[入门简介](https://blog.csdn.net/luoshengyang/article/details/41338251)

## 参考
[Dalvik虚拟机简要介绍](https://blog.csdn.net/luoshengyang/article/details/8852432)
- 打开看完，但是没有怎么做总结

[Android初始化语言(init.rc语法)](https://blog.csdn.net/xusiwei1236/article/details/41577231)
[init.rc文件解析](https://blog.csdn.net/u010223349/article/details/8829613)

[Android系统进程Zygote启动过程](https://blog.csdn.net/luoshengyang/article/details/6768304)
- 看到了ZygoteInit.java文件开始被执行


[Dalvik虚拟机的启动过程分析](https://blog.csdn.net/luoshengyang/article/details/8885792)

虽然看的不是很懂，但是从原理层面上了解了虚拟机的运行过程，有点打开眼界的样子。之后，看看源码，加深下印象。加油吧~
[Dalvik虚拟机的运行过程分析](https://blog.csdn.net/luoshengyang/article/details/8914953)

参考书纲：
https://www.kancloud.cn/alex_wsc/androids/473616