---
title: 前端-Webpack概念介绍
date: 2020-05-17 22:21:34
categories: 前端
---

## 核心概念

**入口(entry)**
- 指示 webpack 应该使用哪个模块，来作为构建其内部依赖图的开始。

**输出(output)**
- 告诉 webpack 在哪里输出它所创建的 bundles ，以及如何命名这些文件。

**加载器(loader)**
- 让 webpack 能够去处理那些非 JavaScript 文件，webpack 自身只理解 JavaScript 。

**插件(plugins)**
- 可以用于执行范围更广的任务。插件的范围包括，从打包优化和压缩，一直到重新定义环境中的变量。

**模式(mode)**
- 通过选择 development 或 production 之中的一个，来设置 mode 参数，你可以启用相应模式下的 webpack 内置的优化。

**模块(module)**
- JS 本身就支持模块化编程。由于Loader支持 CoffeeScript 、 TypeScript 、Babel 、Sass 、Less 等语言。所以，JS + Loader ，扩展了模块化的能力。
- 模块路径解析规则：目前支持绝对依赖、相对依赖、模块依赖。

**依赖图(dependency graph)**
- 一个文件依赖于另一个文件，webpack 就把此视为文件之间有 依赖关系 。 从这些 入口起点 开始，webpack 递归地构建一个 依赖图 ，这个依赖图包含着应用程序所需的每个模块，然后将所有这些模块打包为少量的 bundle 。

## 最简的Webpack应用

目录结构如下

![93576F50-945F-406F-8163-B52F9332C21C](/image/93576F50-945F-406F-8163-B52F9332C21C.png)

具体实现和打包流程如下

![61F9B423-13F7-4F0C-B36F-124F0F962CC2](/image/61F9B423-13F7-4F0C-B36F-124F0F962CC2.png)

项目源码

[webpack_demo.zip](/image/webpack_demo.zip)

## Vue-cli 如何使用 Webpack 打包技术

Vue-cli 在执行时，会读取vue.config.js中的配置文件，然后调用 Vue-Cli 中的 Service.js 间接的生成 webpack.json.js文件来应用webpack工具。

#### webpack.config.js常用写法

```js
"use strict";

// 文件处理工具类
const path = require("path”);
// html插件
var htmlWebpackPlugin = require("html-webpack-plugin");

module.exports = {
  // 入口文件
  entry: {
    index: "./src/index.js",
    search: "./src/search.js"
  },
  // 出口文件
  output: {
    path: path.join(__dirname, "dist"),
    filename: "[name].js"
  },
  // 插件声明
  plugins: [
    // 插件以数组方式声明
    new htmlWebpackPlugin()
  ],
  module: {
    // 加载器声明
    rules: [
      // test：正则表达式，正则匹配的文件将被loader处理
      // use：用于处理匹配文件的加载器
      {
        test: /\.js$/,
        use: "babel-loader"
      },
      // use：加载器为数组形式时，处理顺序为从右到左。
      // 即：less---【less-loader】---css---【css-loader】---style---【style-loader】---作用于<header>中
      {
        test: /\.less$/,
        use: ["style-loader", "css-loader", "less-loader"]
      },
      {
        test: /\.jpeg$/,
        use: ["file-loader"]
      }
    ]
  },
  mode: "production"
};
```

## 参考
* https://www.webpackjs.com/
