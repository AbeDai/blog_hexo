---
title: 网络-对于《Socket心跳包》的思考
date: 2018-11-04 15:16:52
categories: 基础
---

## 为什么需要 Socket 心跳包

实现方式上，TCP keepalive 和 Socket 心跳包机制类似。TCP keepalive 机制通过，在进行 TCP 连接时，发送 keepalive 数据包，来判断当前 TCP 连接是否仍然有效。问题来了，既然已经有了 TCP keepalive，为什么还需要 Socket 心跳机制呢？

个人认为，需要 Socket 心跳机制的原因如下：

1. 真实网路环境中，TCP keepalive 消息，可能会被中继设备和路由设备终结。
2. 自己实现 Socket 心跳机制，处理断线重连的灵活性更高。
3. TCP keepalive 本身是 OSI 模型中的传输层处理逻辑，由操作系统负责探查，即便服务进程死锁或阻塞，操作系统也会如常处理 TCP keepalive 消息，因此 TCP keepalive 的目标是保证传输层的网路通畅。而 Socket 心跳机制，是 OSI 模型中的应用层处理逻辑，由服务程序负责探查，不但能保证应用程序存活，网络通畅，更重要的是能够保证应用程序仍在正常工作。

## 通讯方式

- 单工：只允许甲方向乙方传送信息，而乙方不能向甲方传送，例如汽车的单行道。
- 全双工：允许数据在两个方向上同时进行传送操作，例如汽车的双行道。
- 半双工：允许数据在两个方向上进行传送操作，但是两端不能同时传送。例如一条窄窄的马路，同时只能有一辆车通过，当目前有两辆车对开，这种情况下就只能一辆先过，等到头儿后另一辆再开。

## WebSocket 是什么？

中文翻译

- https://www.jianshu.com/p/867274a5e054
- https://www.jianshu.com/p/fc09b0899141

英文原文

- https://tools.ietf.org/html/rfc6455

## OkHttp3 中 WebSocket 心跳设计

OkHttp3 在 3.5 版本之后，对 WebSocket 进行了支持。

OkHttp3:3.5~3.10

- 没有做心跳失效操作，手机端只负责发送 ping 操作，不管 pong 是否有收到。

OkHttp3:3.11.0~之后

- 做了简单的心跳失效操作，当发送第二次 ping 时，第一次 ping 的服务端 pong 还没有得到回应，则说明心跳失效。
