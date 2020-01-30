---
title: 前端-CSS样式表声明
date: 2020-01-30 16:09:52
categories: 前端
---

<img src="/image/css_shenmin.gif">

- 选择器：用于标识需改变样式的 HTML 元素
- 样式属性：key和value用冒号分开，总体标识一个样式属性。分号用来隔离多个样式属性。

#### 特殊情况说明

```css
<-- 如果值为若干单词，则要给值加引号 -->
p {font-family: "sans serif";}

<-- 多个样式属性之间，用 分号 隔离 -->
p {
  text-align: center;
  color: black;
  font-family: arial;
}

<-- 逗号表示同个属性的多个可能取值；它是顺序取值，前一个不存在就选择后一个，描述同一属性。 -->
p {
  font-family:Arial,Verdana,Geneva,sans-serif;
}
```

## 样式表声明

#### 外部样式表

当样式需要应用于很多页面时，外部样式表将是理想的选择。

```html
// html
// 在头部引用外部样式表的引用
<head>
<link rel="stylesheet" type="text/css" href="mystyle.css" />
</head>
// css
// mystyle.css 文件内容如下
hr {color: sienna;}
p {margin-left: 20px;}
body {background-image: url("images/back40.gif");}
```

#### 内部样式表

当单个文档需要特殊的样式时，需要使用内部样式表。

```html
<head>
<style type="text/css">
  hr {color: sienna;}
  p {margin-left: 20px;}
  body {background-image: url("images/back40.gif");}
</style>
</head>
```

#### 内联样式表

当样式仅需要在一个元素上应用一次时，需要使用内联样式表。

```html
<p style="color: red; margin-left: 20px">
This is a paragraph
</p>
```