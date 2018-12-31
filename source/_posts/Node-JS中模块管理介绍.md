---
title: Node-JS中模块管理介绍
date: 2018-12-16 13:21:10
categories: 后台
---

## exports、module.exports、require的使用介绍

exports和module.exports都是用来指定js文件需要导出的属性值。本质上，exports只是module.exports的引用，辅助后者添加内容用的。
```javascript
// 下方等价，因为exports相当于module.exports的引用
exports.func1 = function(){ ... }
module.exports.func1 = function(){ ... }

// 下方代码不等价，因为对exports进行直接复制，相当于将exports的内存指向改变了。所以不再是module.exports的引用
exports = {
	func1 : function(){ ... }
}
module.exports = {
	func1 : function(){ ... }	
}
```

require方法按照下面顺序，查找模块并导出模块对象。

>**缓存模块：**如果X存在于内存缓存中，则直接从内存缓存中读取文件
**核心模块：**如果 X 是内置模块（比如 require('http'）) 
　　1. 返回该模块
　　2. 不再继续执行
**文件模块：**如果 X 以 "./" 或者 "/" 或者 "../" 开头 
　　1. 根据 X 所在的父模块，确定 X 的绝对路径
　　2. 将 X 当成文件，依次查找 X ， X.js ， X.json， X.node ，只要其中有一个存在，就返回该文件，不再继续执行
　　3. 将 X 当成目录，依次查找 X/package.json（main字段）， X/index.js， X/index.json， X/index.node， 只要其中有一个存在，就返回该文件，不再继续执行
**自定义模块：**. 如果 X 不带路径，根据 X 所在的父模块，确定 X 可能的安装目录。 依次在每个目录中，将 X 当成文件名或目录名加载
**未找到模块：** 抛出 "not found"

## js中的默认变量
- exports：声明导出对象属性
- require：导入模块方法
- module：模块对象
- __filename：js文件名
- __dirname：js目录名

这些默认属性是在js编译时，通过对js文件内容进行了头尾包装设置进去的。如下：
```javascript
// 头尾包装伪代码
(function (exports, require, module, __filename, __dirname) {\n 文件内容 \n});

// js文件内容
var math = require('math');
exports.area = function (radius) {
	return Math.PI * radius * radius; 
};

// 编译时的头尾包装
(function (exports, require, module, __filename, __dirname) { 
	var math = require('math');
	exports.area = function (radius) {
		return Math.PI * radius * radius; 
	};
});
```

## js中的包结构
- package.json：包描述文件
- bin：存放可执行二进制文件的目录
- lib：存放js代码的目录
- doc：存放文档的目录
- test：存放单元测试用例代码的目录

包描述信息介绍
package.json位于包的根目录，是对于包的描述信息的配置文件。字段规范如下：

| key | 描述 |
| ----- | ----- |
| name | 名 |
| description | 简介 |
| version | 版本号 |
| keywords | 关键词数组 |
| maintainers | 维护者列表 |
| contributors | 贡献者列表 |
| bugs | 可以反馈bug的网页或邮箱地址 |
| licenses | 许可证列表 |
| respositories | 托管源码的位置列表 |
| dependencies | 依赖项列表 |
| homepage | 网站地址 |
| os | 操作系统支持列表 |
| cpu | CPU架构支持列表 |
| engine | 支持的JS引擎列表 |
| builten | 是否内建在底层系统的标准组件 |
| directories | 目录说明 |
| implements | 实现规范的列表 |
| scripts | 脚本说明对象 |
| authoer | 作者 |
| bin | 配置为命令行工具 |
| main | 入口文件 |
| devDependencies | 开发依赖项列表 |

## npm命令
| 命令 |	含义 |
| ----- | ----- |
| $ npm	| 查看NPM帮助说明
| $ npm -v	| 查看当前NPM版本
| $ npm init	| 初始化包(配置package.json)
| $ npm <command>	| 查看具体命令帮助说明
| $ npm install <package>	| 安装第三方包
| $ npm uninstall <package>	| 卸载包
| $ npm install <package> --save-dev | 安装包并将安装信息写入package.json(devDependencies)
| $ npm install <package> --dev	| 安装第包并将安装信息写入package.json(dependencies)
| $ npm install <package> -g | 全局安装第三方包
| $ npm install <file-url>	| 安装本地包
| $ npm adduser	| 注册npm账号
| $ npm publish <folder> | 上传包
| $ npm owner ls <package-name>	| 查看包拥有者
| $ npm owner add <user> <package-name>	| 添加包拥有者
| $ npm owner rm <user> <package-name> | 删除包拥有者
| $ npm ls | 分析包


## 参考
http://www.ruanyifeng.com/blog/2015/05/require.html
https://blog.csdn.net/q1056843325/article/details/54948719


