---
title: Android-Debug调试原理
date: 2019-03-22 11:01:46
categories: 客户端
---

## Java-Debug原理
JPDA 定义了一个完整独立的体系，它由三个相对独立的层次共同组成，而且规定了它们三者之间的交互方式，或者说定义了它们通信的接口。
这三个层次由低到高分别是 Java 虚拟机工具接口（JVMTI），Java 调试线协议（JDWP）以及 Java 调试接口（JDI）。这三个模块把调试过程分解成几个很自然的概念：调试者（debugger）和被调试者（debuggee），以及他们中间的通信器。被调试者运行于我们想调试的 Java 虚拟机之上，它可以通过 JVMTI 这个标准接口，监控当前虚拟机的信息；调试者定义了用户可使用的调试接口，通过这些接口，用户可以对被调试虚拟机发送调试命令，同时调试者接受并显示调试结果。在调试者和被调试着之间，调试命令和调试结果，都是通过 JDWP 的通讯协议传输的。所有的命令被封装成 JDWP 命令包，通过传输层发送给被调试者，被调试者接收到 JDWP 命令包后，解析这个命令并转化为 JVMTI 的调用，在被调试者上运行。类似的，JVMTI 的运行结果，被格式化成 JDWP 数据包，发送给调试者并返回给 JDI 调用。而调试器开发人员就是通过 JDI 得到数据，发出指令。

```
             Components                         Debugger Interfaces

                /    |--------------|
               /     |     VM       |
 debuggee ----(      |--------------|  <------- JVM TI - Java VM Tool Interface
               \     |   back-end   |
                \    |--------------|
                /           |
 comm channel -(            |  <--------------- JDWP - Java Debug Wire Protocol
                \           |
                     |--------------|
                     | front-end    |
                     |--------------|  <------- JDI - Java Debug Interface
                     |      UI      |
                     |--------------|
```

## Android相关
Android调试原理
Android调试模型可以看作JPDA框架的具体实现。其中变化比较大的一个是JVM TI适配了Android设备特有的Dalvik虚拟机/ART虚拟机，另一个是JDWP的实现支持ADB和Socket两种通信方式（ADB全称为Android Debug Bridge，是Android系统的一个很重要的调试工具）。整体的调试模型如下：

```
             ____________________________________
            |                                    |
            |          ADB Server (host)         |
            |                                    |
 Debugger <---> LocalSocket <----> RemoteSocket  |
            |                           ||       |
            |___________________________||_______|
                                        ||
                              Transport ||
    (TCP for emulator - USB for device) ||
                                        ||
             ___________________________||_______
            |                           ||       |
            |          ADBD  (device)   ||       |
            |                           ||       |
Android-VM  |                           ||       |
JDWP-thread <====> LocalSocket <-> RemoteSocket  |
            |                                    |
            |____________________________________|
```
运行在PC上的ADB Server和运行在Android设备上的ADBD守护进程之间通过USB或者无线网络建立连接，分别负责Debugger和Android设备的虚拟机进行通信。一旦连接建立起来，Debugger和Android VM通过“桥梁”进行数据的交换，ADB Server和ADBD对它们来说是透明的。

## 参考
https://www.mtyun.com/library/android-remote-debug
https://www.freebuf.com/articles/terminal/114869.html
https://www.ibm.com/developerworks/cn/java/j-lo-jpda1/index.html?ca=drs-
https://www.ibm.com/developerworks/cn/java/j-lo-jpda2/index.html?ca=drs-
https://www.ibm.com/developerworks/cn/java/j-lo-jpda3/index.html
https://www.ibm.com/developerworks/cn/java/j-lo-jpda4/index.html?ca=drs-
