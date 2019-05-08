---
title: Git-git config使用介绍
date: 2019-05-08 08:09:31
categories: 基础
---

## 简介
Git 提供了一个叫做 git config 的工具。主要用来配置或者读取相应的环境变量。而这些环境变量，决定了 Git 在各个环节的具体工作方式和行为。

## 配置文件的位置
git config 文件的存放位置主要有三个处：

- **./etc/gitconfig 文件**：包含了适用于系统所有用户和所有Git仓库的值。可以通过传递 `--system` 使 Git 读或写这个特定的文件。
- **~/.gitconfig 文件**：具体到当前用户和当前用户Git仓库的值。可以通过传递 `--global` 使 Git 读或写这个特定的文件。
- **gitDir/.git/config 文件**：特定指向工作区的单一的Git仓库。每个级别重写前一个级别的值。

覆盖规则如下：

- gitDir/.git/config -> ~/.gitconfig -> ./etc/gitconfig


## 查看当前Git仓库配置
如果你想查看当前Git仓库的配置，你可以使用 `git config --list` 命令来列出Git在该处找到的所有的设置:

```shell
daiyibodeMacBook-Pro:maven-upload-tool daiyibo$ git config --list
user.name=daiyibo
user.email=daiyibo@souche.com
core.autocrlf=input
core.excludesfile=/Users/daiyibo/.gitignore_global
difftool.sourcetree.cmd=opendiff "$LOCAL" "$REMOTE"
difftool.sourcetree.path=
mergetool.sourcetree.cmd=/Applications/Sourcetree.app/Contents/Resources/opendiff-w.sh "$LOCAL" "$REMOTE" -ancestor "$BASE" -merge "$MERGED"
mergetool.sourcetree.trustexitcode=true
color.ui=auto
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
core.ignorecase=true
core.precomposeunicode=true
remote.origin.url=git@git.souche-inc.com:souche-wireless-architecture/Pakun/maven-upload-tool.git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
branch.master.remote=origin
branch.master.merge=refs/heads/master
```

## 调整.git/config文件
调整git仓库是否支持大小写，其实是在`gitDir/.git/config`下修改了配置项

```shell
daiyibodeMacBook-Pro:maven-upload-tool daiyibo$ cat .git/config | grep "ignorecase"
	ignorecase = true
daiyibodeMacBook-Pro:maven-upload-tool daiyibo$ git config core.ignorecase false
daiyibodeMacBook-Pro:maven-upload-tool daiyibo$ cat .git/config | grep "ignorecase"
	ignorecase = false
```

## 参考
https://blog.csdn.net/gdutxiaoxu/article/details/79253737