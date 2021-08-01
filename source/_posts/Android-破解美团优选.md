---
title: Android-破解美团优选
date: 2021-08-01 22:02:38
categories: 客户端
---

### 美团优选Hook方式

#### 反解美团优选源码

通过 jadx-gui 打开美团优选APK，实现对美团优选混淆后源码的阅读。

![581825bd62d99d971e030424e64bcac9](/image/2958839F-428C-4D06-B6F9-883876D5427F.png)

反解后的代码导出到本地，方便后续阅读。

### 美团优选进行Debug调试

#### VirtualXposed 安装

由于美团优选是32位App，所以需要用 VirtualXposed 0.18.2 来进行 Hook 操作。

由于美团优选在某个版本之后，进行网络请求时，遇到Root手机，直接返回无法操作的Case。最终在 华为P40 非 Root 手机 + VirtualXposed 的组合下，能实现美团优选首页的成功渲染操作。

美团优选 /lib/libmtguard.so 是为防止 Xposed Hook 的安全工具，删除即可进行 Xposed Hook。

<div class="half" style="display: flex;justify-content: flex-start;">
    <img width="300" src="/image/3D6B4A6C-7FA6-4C62-887A-CD9024E0E56C.png"/>
    <img width="300" src="/image/483181D1-A4D2-4B04-8AFC-AA2B82A02F0A.png"/>
    <img width="300" src="/image/C8D9DB4E-8DE3-43A1-BD7E-8535FCDBCC75.png"/>
</div>

导入美团优选

<div class="half" style="display: flex;justify-content: flex-start;">
    <img width="300" src="/image/35743D3B-6F1F-4323-956F-92CEEC36219B.png"/>
    <img width="300" src="/image/ACA829EA-736F-44FE-8E9C-C7C207AC3A77.png"/>
</div>

编写美团优选Hook插件后，直接将插件安装到 VirtualXposed 即可

<div class="half" style="display: flex;justify-content: flex-start;">
    <img width="300" src="/image/35743D3B-6F1F-4323-956F-92CEEC36219B.png"/>
    <img width="300" src="/image/921482C9-BAD8-4B87-8974-1155FF850D65.png"/>
</div>

#### 启动美团优选小程序Debug工具

阅读源码发现美团优选的调试工具，能通过 Intent 拉起，尝试有效。

```java
Intent intent = new Intent("com.meituan.mmp.action.MMPDebugAction");
intent.setPackage("com.sankuai.youxuan");
if (!(context instanceof Activity)) {
intent.addFlags(268435456);
}
context.startActivity(intent);
```

美团优选调试工具如下：

<img width="300" src="/image/09F18F77-1417-442E-BDA8-58867BDEE419.png"/>

可以直接开启 WebView Debug 开关，实现在release包中，对**美团优选视图层进行 Chrome Devtool 进行 Debug 操作**。

#### 美团优选通讯协议分析

美团优选协议如下：

- invoke：表示 视图层/逻辑层 与 客户端 之间进行分发的协议
- publish: 表示 视图层与逻辑层 之间进行分发的协议

协议内容如下：

```
publishHandler: custom_event_serviceReady {} [100000]
publishHandler: custom_event_DOMContentLoaded {"data":{},"options":{}} []
publishHandler: custom_event_appDataChange {"type":"update_view","data":{"timestamp":1622796045111,"dataPatches":[{"id":1,"data":{"roleConfirmed":true}}],"sendStartTime":1622796045184,"latestRenderId":209,"latestComponent":{"id":209,"is":"mt-view"}}} [103308779]
```

美团优选协议线程切换逻辑：

当消息发送到Native时，会先判断 method 是同步还是异步，如果为异步函数则直接进行线程切换。**星河消息分发也打算优化成他这样子的实现方式**。

源码如下：

```java
// Native Bridge 分发逻辑
public final String a(final Event event, com.meituan.mmp.lib.interfaces.a aVar) {
        if ("custom_invoke_UI".equals(event.a)) {
            JSONObject a2 = event.a();
            try {
                event = new Event(a2.getString("name"), a2.getString("params"), event.c);
            } catch (JSONException e2) {
                e2.printStackTrace();
            }
        }
        final l a3 = a(event.a);
        if (a3 == null || !a3.b(event.a)) {
            final j jVar = new j(event, aVar);
            if (a3 != null && !a(event, a3, (IApiCallback) jVar)) {
                return null;
            }
            if (!com.meituan.mmp.lib.api.auth.e.a(this.r, com.meituan.mmp.lib.api.auth.e.a(event.a))) {
                StringBuilder sb = new StringBuilder();
                sb.append(event.a);
                sb.append(" api call failed, auth denied, need to configure the necessary fields in app.json!");
                jVar.onFail(AbsApi.codeJson(-1, sb.toString()));
                return null;
            }
            if (a3 == null || this.r.b()) {
                b(event, a3, jVar);
            } else if (this.s == null) {
                StringBuilder sb2 = new StringBuilder();
                sb2.append(event.a);
                sb2.append(" api call failed, activity is null");
                jVar.onFail(AbsApi.codeJson(-1, sb2.toString()));
            } else {
                com.meituan.mmp.lib.api.auth.e.a(this.s, this.r, event, (com.meituan.mmp.lib.api.auth.e.a) new com.meituan.mmp.lib.api.auth.e.a() {
                    public final void a(int i) {
                        switch (i) {
                            case -1:
                                IApiCallback iApiCallback = jVar;
                                StringBuilder sb = new StringBuilder();
                                sb.append(event.a);
                                sb.append(" api call failed, auth denied");
                                iApiCallback.onFail(AbsApi.codeJson(-401001, sb.toString()));
                                return;
                            case 0:
                                jVar.onCancel();
                                break;
                            case 1:
                                g.this.b(event, a3, jVar);
                                return;
                        }
                    }
                });
            }
            return null;
        }
        k kVar = new k(event);
        if (a(event, a3, (IApiCallback) kVar)) {
            StringBuilder sb3 = new StringBuilder("invoke sync: ");
            sb3.append(event.a);
            aa.a(sb3.toString(), DebugHelper.n);
            a(event, (AbsApi) a3, (IApiCallback) kVar);
            aa.a(DebugHelper.n);
        }
        return kVar.a;
    }

// 异步分发方法
private void c(final Event event, final l lVar, final IApiCallback iApiCallback) {
        if (lVar != null) {
            AnonymousClass2 r0 = new Runnable() {
                public final void run() {
                    StringBuilder sb = new StringBuilder("invoke async: ");
                    sb.append(event.a);
                    aa.a(sb.toString(), DebugHelper.n);
                    g.this.a(event, (AbsApi) lVar, iApiCallback);
                    aa.a(DebugHelper.n);
                }
            };
            if (lVar.c()) {
                C0075a.a(r0);
            } else {
                this.e.post(r0);
            }
        } else {
            iApiCallback.onFail(AbsApi.codeJson(-1, "api not found"));
        }
    }
```

#### 美团优选启动耗时分析

找到美团优选的核心打点类，通过 Xposed Hook 方式将核心打点类打开。对 美团优选  启动流程进行分析。Hook 方法如下：

```java
// 核心打点日志
XposedHelpers.setStaticBooleanField(
        loadPackageParam.classLoader.loadClass("com.meituan.mmp.lib.DebugHelper"),
        "a",
        true);
// JSBridge日志
XposedHelpers.setStaticBooleanField(
        loadPackageParam.classLoader.loadClass("com.meituan.mmp.lib.DebugHelper"),
        "n",
        true);
XposedBridge.log("dm_hook 开启美团核心链路日志");
```

美团优选启动流程核心打点如下：

```
- 22:55:36.116 Native基础库加载（353ms）(非首次包管理 + WebView预创建)
- 22:55:36.193 new Activity
- 22:55:36.215 new WebView
- 22:55:36.332 执行JS基础库：service.js （4388）
- 22:55:36.360 执行JS基础库：jsc.polyfill.js （99350）
- 22:55:36.380 WebView 创建完毕
- 22:55:36.439 执行JS基础库：runtime.js （418201）
- 22:55:36.448 Activity launchHomePage
- 22:55:36.471 底导构建完毕
- 22:55:36.472 new Page 完毕 /pages/index/index
- 22:55:36.541 Service执行组件注入 view.service.js、text.service.js、image.service.js
- 22:55:36.571 执行业务JS: app-service.js （1928150）
- 22:55:36.631 消息分发(Service <-> WebView): custom_event_runtimeLaunch {"timestamp":1627484136631} [] 启动
- 22:55:36.645 获取快照 initialRenderData from renderCache: send first data to page
- 22:55:36.745 执行JS启动数据注入: javascript:ServiceJSBridge.subscribeHandler('onAppRoute', ...) 
- 22:55:36.773 WebView 开始渲染: custom_event_H5_FIRST_SCRIPT
- 22:55:36.792 懒加载注入各种组件 Service 和 WebView 执行： pageframe.js、view.js、text.service.js、scroll-view.service.js、page-bootstrap.js、style.css、button.js、swiper.js、swiper-item.js、rich-text.js、form.service.js、input.js
- 22:55:37.079 dom挂载完毕 onPageReady->onDomLoaded
- 22:55:37.084 WebView 执行快照：javascript:HeraJSBridge.subscribeHandler('custom_event_initialData', ...);
- 22:55:37.268 首次渲染完毕：custom_event_H5_FIRST_RENDER
```

美团优选小程序 启动主要分为以下几部分，总共耗时：1160ms

1. 基础框架初始化：360ms
2. 执行业务 App.launch() ：320ms
3. 执行页面渲染：300ms
4. 数据快照渲染：180ms

    
#### 美团优选逻辑层引擎切换为WebView

将美团优选逻辑层引擎切换成 WebView，以便开始逻辑层 Chrome DevTool 功能。

```java
XposedHelpers.findAndHookMethod("com.meituan.mmp.main.MMPEnvHelper",
        loadPackageParam.classLoader,
        "getCustomServiceEngineClazz",
        new XC_MethodHook() {
            @Override
            protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                super.beforeHookedMethod(param);
                if (param.args != null && param.args.length > 0) {
                    param.args[0] = null;
                }
            }
        }
);
XposedBridge.log("dm_hook 使用引擎: WebView");
```

找到美团优选小程序启动流程卡点，延迟 10 秒，保证有充足的时间能打开 Chrome DevTool 进行 Debug 操作

```java
XposedHelpers.findAndHookMethod("com.meituan.mmp.lib.trace.b",
        loadPackageParam.classLoader,
        "b",
        String.class,
        String.class,
        new XC_MethodHook() {
            @Override
            protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                super.beforeHookedMethod(param);
                String arg = (String) param.args[1];
                if ("onAllPackagePrepared".equals(arg)) {
                    // 拦截JS引擎 启动执行
                    Thread.sleep(10000);
                }
            }
        }
);
```
 
最终Debug效果如下：

![e9b7a9147a050ab71b617dc004cb8d7d](/image/4C7AC830-05A2-4282-9C65-05AB77C96A4E.png)


#### 结论

- 美团优选的消息通道是在消息抵达Native侧时，就进行线程切换的，尽量避免了 JS 线程的阻塞。
- 美团优选底部Tab为原生实现，并且与小程序生命周期没有强绑定关系，做到了原生的体验效果。
- 美团优选利用数据快照减少了页面渲染的等待时间。
- 美团优选大量的网络请求都用WebSocket进行传输。
- 美团优选组件、页面等都是按需加载减少了启动阶段的过度损耗。
