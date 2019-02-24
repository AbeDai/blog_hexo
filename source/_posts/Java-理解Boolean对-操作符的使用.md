---
title: Java-理解Boolean对|=操作符的使用
date: 2019-02-20 08:53:53
categories: 客户端
---

## 简介
关于这个操作符的首次理解如下：

```java
boolean aBool = true;
aBool |= false;
// 等价于
boolean aBool = true;
aBool = aBool | false;
```

这里延伸出来两个问题：
    - boolean可以用来做位操作，boolean在内存中的存储方式是怎么样的呢？
    - 为啥不用 || 来替代 | 进行boolean操作呢？这样做有啥好处呢？

## boolean的内存占用规则
参考《Java虚拟机规范》得出结论，声明boolean变量时占了4字节，声明数组时单个boolean元素占了1字节。

通过代码验证以上说法：

```java
/** java代码 **/
boolean a;
// 1: 常量赋值 true
a = true;
// 2: 常量赋值 false
a = false;
// 3: 创建boolean数组
boolean[] b = new boolean[1];
// 4: 数组中boolean元素赋值 true
b[0] = true;
// 5: 数组中boolean元素赋值 flase
b[0] = false;

/** JVM指令助记符 **/
// 1: 常量赋值 true
0: iconst_1
1: istore_1
// 2: 常量赋值 false
2: iconst_0
3: istore_1
// 3: 创建boolean数组
4: iconst_1
5: newarray       boolean
7: astore_2
// 4: 数组中boolean元素赋值 true
8: aload_2
9: iconst_0
10: iconst_1
11: bastore
// 5: 数组中boolean元素赋值 flase
12: aload_2
13: iconst_0
14: iconst_0
15: bastore
16: return
```

> 注：boolean变量在虚拟机中，其实是用int操作来代替的；而boolean数组中变量，其实是用byte来代替的。

## boolean中对||和|进行对比操作

其实说破很简单，||（逻辑或），从操作码中可以看出，只要一个条件为true，就会省略后面的逻辑判断操作，从而做到了逻辑上的简化。而|（按位或），从操作码中可以看出，需要将所有boolean结果分别进行按位操作。所以得出结论，| 的性能，应该要比 || 慢。 以后编码的时候，还是少用为好。

```java
/** java代码 **/
// 1: 声明变量 b1，b2，b3，b4，b5，b6
boolean b1 = true;
boolean b2 = false;
boolean b3 = true;
boolean b4 = false;
boolean b5 = true;
boolean b6 = false;
// 2: 逻辑或操作
boolean return1 = b1 || b2 || b3 || b4 || b5 || b6;
// 3: 按位或操作
boolean return2 = b1 | b2 | b3 | b4 | b5 | b6;

/** JVM指令助记符 **/
// 1: 声明变量 b1，b2，b3，b4，b5，b6
0: iconst_1
1: istore_1
2: iconst_0
3: istore_2
4: iconst_1
5: istore_3
6: iconst_0
7: istore        4
9: iconst_1
10: istore        5
12: iconst_0
13: istore        6
// 2: 逻辑或操作
15: iload_1
16: ifne          42
19: iload_2
20: ifne          42
23: iload_3
24: ifne          42
27: iload         4
29: ifne          42
32: iload         5
34: ifne          42
37: iload         6
39: ifeq          46
42: iconst_1
43: goto          47
46: iconst_0
47: istore        7
// 3: 按位或操作
49: iload_1
50: iload_2
51: ior
52: iload_3
53: ior
54: iload         4
56: ior
57: iload         5
59: ior
60: iload         6
62: ior
63: istore        8
65: return
```

## 参考
https://blog.csdn.net/dreamsky1989/article/details/7458259
https://www.jianshu.com/p/2f663dc820d0