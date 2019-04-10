---
title: Android-搭建Jenkins服务流程
date: 2019-03-22 11:24:29
categories: 客户端
---

## 持续集成简介

持续集成指的是，频繁地（一天多次）将代码集成到主干。

它的好处主要有两个。

1. 快速发现错误。每完成一点更新，就集成到主干，可以快速发现错误，定位错误也比较容易。
2. 防止分支大幅偏离主干。如果不是经常集成，主干又在不断更新，会导致以后集成的难度变大，甚至难以集成。

持续集成的目的，就是让产品可以快速迭代，同时还能保持高质量。它的核心措施是，代码集成到主干之前，必须通过自动化测试。只要有一个测试用例失败，就不能集成。

> [持续集成是什么？](http://www.ruanyifeng.com/blog/2015/09/continuous-integration.html)<br>
> [如何理解持续集成、持续交付、持续部署？](https://www.zhihu.com/question/23444990)


## Jenkins安装篇

- 安装Java运行环境：Jenkins的运行依赖Java环境，所以在安装Jenkins之前必须要安装JDK或JRE
- 安装Jenkins工具：在mac上安装Jenkins服务极其简单，只需要下载[Jenkins安装包](https://jenkins.io/download/)，双击安装即可

- 启动和停止Jenkins服务
  ```  
  // 启动Jenkins
  sudo launchctl load /Library/LaunchDaemons/org.jenkins-ci.plist
  // 终止Jenkins
  sudo launchctl unload /Library/LaunchDaemons/org.jenkins-ci.plist
  ```

## Jenkins配置Android项目

- 全局配置android环境，gradle环境，java环境
- 配置Git仓库地址
- 编写构建Android项目脚本
- 编译后文件存档

> [Jenkins配置Android项目](https://blog.csdn.net/it_talk/article/details/50261229)

## Jenkins搭建分布式构建

- 配置ssh秘钥
- 通过ssh建立master与slave之间的关联
- 启动节点
- 将构建任务分配给slave节点执行

> [Jenkins创建slave节点-Linux平台](https://blog.csdn.net/jiang1986829/article/details/51141731)

## Jenkins自动化测试（Sonarqueb）
- 安装Sonarqube工具
- 配置mysql数据库
- 加入扫描插件
- 配置jenkins构建工程，加入sonarqueb步骤
- 构建，产生报表

> [Jenkins+Sonarqueb进行自动化测试和代码质量检测](https://yq.aliyun.com/articles/541761)

## 参考

[Jenkins权威指南](http://daiyibo.oss-cn-hongkong.aliyuncs.com/blog_file/Jenkins%E6%9D%83%E5%A8%81%E6%8C%87%E5%8D%97%40www.jqhtml.com.pdf)