---
title: 前端-CSS选择器全解
date: 2020-01-30 16:08:44
categories: 前端
---

选择器是CSS中很重要的概念。用于描述当前CSS样式作用于哪些HTML标签。

#### 元素选择器

元素选择器可以为特定的HTML元素指定特定的样式。

```html
// css
html {color:red;}
h1 {color:blue;}

// html
<p>这个段落是红色的</p>
<h1>这个标题是蓝色的</h1>
```

#### 类选择器

> 参考：https://www.w3school.com.cn/css/css_selector_class.asp

类选择器可以为标有特定 class 的 HTML 元素制定特有的样式。

```css
// css
.green { color: green; }
.green strong { color: blue; } // 与派生选择器结合使用

// html
<p class="green">这个段落是红色。</p>
<p class="green">这个段落是绿色。<strong>strong标签内容为蓝色。</strong></p>
```

类选择器可以结合元素选择器来使用。

```css
// css
* { color:red }
h1.green { color:green }

// html
<p>这个段落是红色的</p>
<h1>这个段落是绿色的，为类选择器和元素选择器结合使用的结果</h1>
```

多类选择器表示多个类选择器和多个HTML元素之间的关系：
    - HTML元素通过空格来隔离多个类名：`<p class="important warning">`
    - 类选择器通过点号来表示类名全部符合的要求：`.important.warning {background:silver;}`
    
```css
// css
.warning {color:green;}
.important {color:yellow;}
.important.warning {color:red;}

// html
<p class="important">这个段落是黄色的</p>
<p class="warning">这个段落是绿色的</p>
<p class="important warning">这个段落是红色的</p>
```

#### id选择器

id 选择器可以为标有特定 id 的 HTML 元素指定特定的样式。

```html
// css
#red { color: red; }
#green { color: green; }
#green strong { color: blue; } // 与派生选择器结合使用
  
// html
<p id="red">这个段落是红色。</p>
<p id="green">这个段落是绿色。<strong>strong标签内容为蓝色。</strong></p>
```

#### 属性选择器

> 参考：https://www.w3school.com.cn/css/css_selector_attribute.asp

属性选择器可以对带有指定属性的 HTML 元素设置样式。而不仅限于 class 和 id 属性。

| 选择器 | 描述 |
| --- | --- |
| [attribute] | 用于选取带有指定属性的元素。 |
| [attribute=value] | 用于选取带有指定属性和值的元素。 |
| [attribute~=value] | 用于选取属性值中包含指定词汇的元素。 |
| [attribute\|=value] | 用于选取带有以指定值开头的属性值的元素，该值必须是整个单词。 |
| [attribute^=value] | 匹配属性值以指定值开头的每个元素。 |
| [attribute$=value] | 匹配属性值以指定值结尾的每个元素。 |
| [attribute*=value] | 匹配属性值中包含指定值的每个元素。 |

```css
// css
[title]
{
color:red;
}

// html
<p title="test">这个段落是红色，因为符合属性选择器的作用条件。</p>
<p >这个段落为默认颜色。</p>
```

属性选择器可以结合元素选择器来使用。
```css
// 对只有 href 属性的锚（a 元素）应用样式
a[href] {color:red;}
```

多个属性进行选择，只需将属性选择器链接在一起即可。
```css
// 将同时有 href 和 title 属性的 HTML 超链接的文本设置为红色
a[href][title] {color:red;}
```

#### 派生选择器

派生选择器允许你根据文档的上下文关系来确定某个标签的样式。

```css
// css
strong {
  color: red;
  }

h2 {
  color: red;
  }

h2 strong {
  color: blue;
  }
  
// html
<p>P标签中的Strong标签下的文字是<strong>红色</strong></p>
<h2>H2标签下的文字是红色</h2>
<h2>H2标签中的Strong标签下的文字是<strong>蓝色</strong></h2>
```

#### 伪类选择器

> 参考：https://www.w3school.com.cn/css/css_pseudo_classes.asp

伪类为不存在的类，用于向某些选择器添加特殊的效果，是一种动态表现形式。

![](/image/css_weilei.png)

| 伪类 | 描述 |
| --- | --- |
| :active | 向被激活的元素添加样式。 |
| :focus | 向拥有键盘输入焦点的元素添加样式。 |
| :hover | 当鼠标悬浮在元素上方时，向元素添加样式。 |
| :link | 向未被访问的链接添加样式。 |
| :visited | 向已被访问的链接添加样式。 |
| :first-child | 向元素的第一个子元素添加样式。 |
| :lang | 向带有指定 lang 属性的元素添加样式。 |

```css
// css
a:link {color: #FF0000}
a:visited {color: #00FF00}
a:hover {color: #FF00FF}
a:active {color: #0000FF}

// html
<a href="/index.html" target="_blank">这是一个链接。</a>
```

#### 伪元素选择器

> 参考：https://www.w3school.com.cn/css/css_pseudo_elements.asp

伪元素为不存在的元素，用于向某些选择器设置特殊效果，是一种灵活的表现形式。

![](/image/css_weiyuansu.png)

| 伪元素 | 描述 |
| --- | --- |
| :first-letter | 向文本的第一个字母添加特殊样式。 |
| :first-line | 向文本的首行添加特殊样式。 |
| :before | 在元素之前添加内容。 |
| :after | 在元素之后添加内容。 |

```css
// css
p:first-letter {
  color: #FF0000;
  }

// html
<p>This is a paragraph in an article。</p>
```

#### 通配符选择器

通配符选择器用 * 来适配所有元素，将CSS样式应用于所有HTML元素。

```css
* {color:red;}
```

## 选择器的组合方式

#### 后代选择器

> 参考：https://www.w3school.com.cn/css/css_selector_descendant.asp

后代选择器可以定位某元素后代的元素。后代选择器有一个易被忽视的方面，即两个元素之间的层次间隔可以是无限的。

```css
* {color:black;}
h1 em {color:red;}
.parent em {color:blue;}

// html
<p>这个段落为黑色</p>
<h1>这个表示为黑色，<em>我是红色</em></h1>
<p class="parent">这个表示为黑色，<em>我是蓝色</em></h1>
```

#### 子元素选择器

> 参考：https://www.w3school.com.cn/css/css_selector_child.asp

子元素选择器可以定位某元素的子元素。与后代选择器不同的是，层次间隔不是无限的，不作用于子元素，不作用于孙元素。

```css
// css
h1 > strong {color:red;}

// html
<h1>黑色<strong>红色</strong><strong>红色</strong>黑色</h1>
<h1>黑色<em>黑色<strong>黑色</strong></em>黑色</h1>
```

#### 相邻兄弟选择器

> 参考：https://www.w3school.com.cn/css/css_selector_adjacent_sibling.asp

相邻兄弟选择器可选择紧接在另一元素后的元素，且二者有相同父元素。

```css
// 选择紧接在 h1 元素后出现的段落，h1 和 p 元素拥有共同的父元素
h1 + p {margin-top:50px;}
```

## 选择器特性

#### 选择器分组

对选择器进行分组，这样，被分组的选择器就可以分享相同的声明。用逗号将需要分组的选择器分开。

```css
<-- 所有标题元素都设置为绿色 -->
h1,h2,h3,h4,h5,h6 {
  color: green;
  }
```

> 选择器分组语法，作用于所有类型的选择器：元素选择器、id选择器、类选择器、属性选择器。

#### 选择器继承

子元素从父元素继承属性。

```css
<-- body元素将使用Verdana字体。通过CSS继承，子元素将继承最高级元素所拥有的属性 -->
<-- 子元素诸如p、td、ul、ol、ul、li、dl、dt、dd，不需要另外的规则，都应该显示Verdana字体 -->
body {
  font-family: Verdana, sans-serif;
  }
```

## 选择器优先级

- CSS 优先规则1： 最近的祖先样式比其他祖先样式优先级高。
- CSS 优先规则2："直接样式"比"祖先样式"优先级高。
- CSS 优先规则3：优先级关系：内联样式 > ID 选择器 > 类选择器 = 属性选择器 = 伪类选择器 > 标签选择器 = 伪元素选择器
    - ID 选择器， 如 `#id{}`
    - 类选择器， 如 `.class{}`
    - 属性选择器， 如 `a[href="segmentfault.com"]{}`
    - 伪类选择器， 如 `:hover{}`
    - 伪元素选择器， 如 `::before{}`
    - 标签选择器， 如 `span{}`
    - 通配选择器， 如 `*{}`
- CSS 优先规则4：当一个标签同时被多个选择符选中，我们便需要确定这些选择符的优先级。我们用如下规则进行确定。计算选择符中 ID 选择器的个数（a），计算选择符中类选择器、属性选择器以及伪类选择器的个数之和（b），计算选择符中标签选择器和伪元素选择器的个数之和（c）。按 a、b、c 的顺序依次比较大小，大的则优先级高，相等则比较下一个。若最后两个的选择符中 a、b、c 都相等，则按照"就近原则"来判断。
- CSS 优先规则5：属性后插有 !important 的属性拥有最高优先级。如：`p {background: red !important;}`