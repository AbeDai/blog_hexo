---
title: Android - V8 Debug 分析
date: 2020-11-26 22:06:37
categories: 客户端
---

## V8 Debug 用法

**声明ScriptSourceProvider提供器**

```kotlin
// 源码提供器
class SimpleScriptProvider: ScriptSourceProvider {

    // 单例
    companion object {
        val provider: SimpleScriptProvider = SimpleScriptProvider()
    }

    // 模拟源码内容发生变化
    private var dateString: String = updateTimeToNow()
    fun updateTimeToNow(): String {
        dateString = DateFormat.getTimeInstance().format(Date())
        return dateString
    }

    // JS源码文件列表，在Chrome中能看到源码文件列表
    override val allScriptIds = listOf("hello-world0", "hello-world1")

    // 根据JS源码文件，获取源码内容
    override fun getSource(scriptId: String): String {
        val jsScript = ("""
            |var globalHi = "hi from $scriptId"
            |
            |function main(payloadObject) {
            |  var hello = 'hello, ';
            |  var world = 'world';
            |
            |  var testReload = '$dateString';
            |
            |  return globalHi + ' and ' + hello + world + ' at ' + testReload + ' with ' + payloadObject.load + ' !';
            |}
            |
            |main({
            |    load: 'object based payload',
            |    redundantLoad: 'this is ignored',
            |    callBack: function testCallBack() { print('Call back!') }
            |})
        """).trimMargin()
        return jsScript
    }
}
```

**初始化Debug能力**

```kotlin
// j2v8-debugger 内部是由 stetho 来实现的。 App 启动时，进行初始化
StethoHelper.initializeDebugger(this, SimpleScriptProvider.provider)
```

**V8引擎初始化**

```kotlin
// V8 Debugger 一定要在子线程中创建
var v8Executor: ExecutorService = Executors.newSingleThreadExecutor()
// V8 Debugger 创建
var v8Future: Future<V8> = V8Debugger.createDebuggableV8Runtime(v8Executor, "demo", true)
private val v8: V8 by lazy {
  v8Future.get()
}
```

**V8引擎执行脚本**

```kotlin
// 执行V8的线程必须与创建线程相同
v8Executor.submit {
  val result = v8.executeScript(jsScript, scriptToDebug, 0)
  println("[v8 execution result: ] $result")
}
```

**JS源码更新，通知Chrome调试工具**

```kotlin
// 更新Chrome调试工具前缀
StethoHelper.scriptsPathPrefix = "user${Random().nextInt(10)}"
// 更新ScriptProvider提供器的源码内容
SimpleScriptProvider.provider.updateTimeToNow()
// 通知Chrome源码已更新
StethoHelper.notifyScriptsChanged()
```

## V8 Debug 原理介绍

![c0f482875508baab51347373ab1da4ca](/image/0418C016-F84A-4CF0-BCE6-495F9CAD6323.png)

**Debug协议说明**

V8引擎提供了一些调试指令，用于实现基础的Debug能力。例如，设置断点、获取参数、断点进入下一步等。

https://chromedevtools.github.io/devtools-protocol/tot/Debugger/
https://chromedevtools.github.io/devtools-protocol/tot/Runtime/

![8401c41a872e835e6cdbdafa8e58903e](/image/9F8A71D1-D48E-4993-8C18-06CD06E45C42.png)

J2V8-Debugger库的职责：

- V8引擎创建时，建立 V8 与 V8-Debugger， Chrome DevTool 与 V8-Debugger 之间的长连接。
- 当 DevTool 进行断点，获取变量数据等操作时，解析 DevTool 发过来的消息，然后透传给 V8 引擎来执行，并最终将结果传递给DevTool。

#### V8 Debug 建立调试器连接

在App启动时，调用 Stetho 的初始化方法，将 Runtime 和 Debugger 实例注入到 Stetho 中，并启动 LocalServer 与 Chrome DevTools 建立链接。

![158a3b5bd66eb85e99ef50f89ffc8464](/image/08CCA2DC-327F-407E-BD5E-77E1DE01DF41.png)

#### V8 Debug 源码文件列表获取

获取 Debug 源码，基本就是根据 App 启动时的调试通道来做一些消息转发。

![ee705cd03a8411e747e006cf143dca34](/image/54C63323-FC30-49FA-AAA7-7D75EFF28BE6.png)

#### V8 Debug 断点功能分析

设置断点和移除断点都是操作 Chrome DevTools 然后通过 Stetho 来调用 Debugger 和 Runtime 的方法来实现的。关键在于协议的解析和透传给V8引擎。

断点触发操作，是先对 V8 引擎设置断点。等代码运行到对应位置时，V8Messager 来触发 Debugger.breakpointResolved 消息，然后在通过 JsonRocPeer 来通知 Chrome DevTools 断点被触发。

![879129861e4835d41ee9242b35fe4c16](/image/315EB3AC-A7BA-4E56-A8E0-85F310661311.png)

## 参考

https://engineering.salesforce.com/debugging-embedded-javascript-in-an-android-app-using-chrome-devtools-8553864ee09c
https://blog.csdn.net/weixin_26739079/article/details/108884604
