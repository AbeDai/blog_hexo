---
title: 网络-对于《Socket心跳包》的思考
date: 2018-11-04 15:16:52
categories: 网络
---

## 为什么需要Socket心跳包

实现方式上，TCP keepalive 和Socket心跳包机制类似。TCP keepalive 机制通过，在进行TCP连接时，发送keepalive数据包，来判断当前TCP连接是否仍然有效。问题来了，既然已经有了TCP keepalive，为什么还需要Socket心跳机制呢？

个人认为，需要Socket心跳机制的原因如下：

1. 真实网路环境中，TCP keepalive消息，可能会被中继设备和路由设备终结。
2. 自己实现Socket心跳机制，处理断线重连的灵活性更高。
3. TCP keepalive本身是OSI模型中的传输层处理逻辑，由操作系统负责探查，即便服务进程死锁或阻塞，操作系统也会如常处理TCP keepalive消息，因此TCP keepalive的目标是保证传输层的网路通畅。而Socket心跳机制，是OSI模型中的应用层处理逻辑，由服务程序负责探查，不但能保证应用程序存活，网络通畅，更重要的是能够保证应用程序仍在正常工作。

## 通讯方式
- 单工：只允许甲方向乙方传送信息，而乙方不能向甲方传送，例如汽车的单行道。
- 全双工：允许数据在两个方向上同时进行传送操作，例如汽车的双行道。
- 半双工：允许数据在两个方向上进行传送操作，但是两端不能同时传送。例如一条窄窄的马路，同时只能有一辆车通过，当目前有两辆车对开，这种情况下就只能一辆先过，等到头儿后另一辆再开。

## WebSocket是什么？
中文翻译

- https://www.jianshu.com/p/867274a5e054
- https://www.jianshu.com/p/fc09b0899141

英文原文

- https://tools.ietf.org/html/rfc6455

## OkHttp3中WebSocket心跳设计

OkHttp3在3.5版本之后，对WebSocket进行了支持。

OkHttp3:3.5~3.10

- 没有做心跳失效操作，手机端只负责发送ping操作，不管pong是否有收到。

OkHttp3:3.11.0~之后

- 做了简单的心跳失效操作，当发送第二次ping时，第一次ping的服务端pong还没有得到回应，则说明心跳失效。
