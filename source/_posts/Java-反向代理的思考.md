---
title: Java-反向代理的思考
date: 2018-12-18 11:29:15
categories: 客户端
---

## 动态代理使用介绍

动态代理，利用Java的反射技术，在运行时创建一个实现某些给定接口的新类及其实例。代理的是接口，不是类，更不是抽象类。演示代码如下：

```java
public class Main {

    public static void main(String[] args) {
        // 实现动态代理
        IHello iHello = (IHello) Proxy.newProxyInstance(IHello.class.getClassLoader(), new Class[]{IHello.class}, new InvocationHandler() {

            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                System.out.println("before");
                Object rs = method.invoke(new Hello(), args);
                System.out.println("after");
                return rs;
            }
        });
        iHello.sayHello();
    }

    public interface IHello {
        void sayHello();
    }

    static class Hello implements IHello {
        @Override
        public void sayHello() {
            System.out.println("Hello World");
        }
    }
}

// print:
// Hello World
```

## 方法介绍

```java
/**
 * 动态创建一个代理对象
 *
 * @param loader 定义了由哪个ClassLoader对象来对生成的代理对象进行加载
 * @param interfaces 表示的是我将要给我需要代理的对象提供一组什么接口
 * @param h 表示的是当我这个动态代理对象在调用方法的时候，会关联到哪一个InvocationHandler对象上
 * @return 代理对象的实例
 */
public static Object newProxyInstance(ClassLoader loader, Class<?>[] interfaces,  InvocationHandler h)  throws IllegalArgumentException

/**
 * 调用代理方法
 */
public interface InvocationHandler {

    /**
     * 调用代理方法
     *
     * @param proxy 指代我们所代理的那个真实对象
     * @param method 指代的是我们所要调用真实对象的方法的Method对象
     * @param args 指代的是调用真实对象某个方法时接受的参数
     * @return 返回的Object是指真实对象方法的返回类型
     */
    public Object invoke(Object proxy, Method method, Object[] args)
            throws Throwable;
}
```

## AOP的场景思考
java中的注解用于描述代码辅助信息。注解的好处是在不影响代码逻辑，插入代码描述信息。
如何让代码更好的解耦，应该是很重要的问题。尤其是现在组件化开发模式盛行，如何让组件之间减少依赖关系，变得越来越重要了。下面讲解下，我所认为的组件间通讯的方式：

```java
// 业务逻辑中使用登录功能
Login l = AOPHelper.get("login");
l.login();

// 登录模块接口描述
public interface Login {

    @Interface("login")
    public void login();
}

// 登录模块实现类，注意这个实现可能是在登录组件中的，所以最好不要将业务逻辑和LoginImpl实现直接耦合在一起
public class LoginImpl {

    @Impl("login")
    public void login(){
        Log.e("test", "登录成功");
    }
}

// 通过AOPHelper类，将实现和接口之间通过注解的方式连接起来。
// 通过这种方式，既做到了组件和业务的解耦，也做到了具体实现的调用连接。
public class AOPHelper {
    // 收集注解信息，然后将接口和实现关联起来
}
```



## 参考
https://www.cnblogs.com/techyc/p/3455950.html
https://zhuanlan.zhihu.com/p/29188162