---
title: Git-文件大小写补漏
date: 2019-04-15 23:00:15
categories: 基础
---

## 怎么解决Git文件大小？

### 使用Git MV ★★★

```shell
git mv xxx.file XXX.file
```

### 手动修改 ★★ 

```shell
// 删除原文件
git rm xxx.file
// 修改文件名，大小写进行区分
mv xxx.file XXX.file
// 提交新文件
git add XXX.file
```

### 配置Git仓库 ★ 

```shell
// 关闭忽略大小写配置
git config core.ignorecase false
// 打开忽略大小写配置
git config core.ignorecase true
```

## git为什么默认不区分文件大小写？

macOS 默认是『 Mac OS 扩展（日志式）』格式的磁盘，这个是不区分大小写的，而 Linux 是区分大小写的，所以其实还是要注意这个方面把。

另外你可以把磁盘抹成『 Mac OS 扩展（区分大小写，日志式）』，但是有些软件可能就挂了，所以还是别瞎折腾了。

可以通过 git mv 操作来避免 git 未识别：

```shell
git mv myfolder tmp
git mv tmp MyFolder
```

你也可以修改 git config 来达到区分大小写：

```shell
git config core.ignorecase false
```

## 参考
https://www.cnblogs.com/haojiahong/p/5594257.html
https://www.zhihu.com/question/57779034
