---
title: 前端-CSS布局那些事
date: 2020-01-01 08:47:44
categories: 前端
---

## 文档流
文档流是文档中可显示对象在排列时所占用的位置。将窗体自上而下分成一行行显示，并在每行中按从左到右的顺序排放元素的效果，就是文档流直观的表现。

## 元素类型

- 块级元素（block elements）：支持width、height、padding、border与margin，排列方式是垂直排列
- 行内元素（inline elements）：不width、height、padding、border与margin，排列方式是水平排列
- 行内块元素（inline-block elements）：内部表现类似block元素，支持block元素的width、height、padding、border与margin；而外部排列类似行内元素，即水平排列

## display介绍

#### 举例说明

```html
// html布局
<span class="block">内容为block的展示方式</span>
// css类型
.block {
    display: block;
}
```

#### 常用类型说明

- none：此元素不会被显示。
- block：此元素将显示为块级元素，此元素前后会带有换行符。
- Inline：默认。此元素会被显示为内联元素，元素前后没有换行符。
- inline-block：行内块元素。（CSS2.1 新增的值）
- Inherit：规定应该从父元素继承 display 属性的值

https://www.w3school.com.cn/cssref/pr_class_display.asp

## position介绍

#### 举例说明

```html
// html布局
<span class="block">位置为relative的排列方式</span>
// css类型
.relative {
    position: relative;
}
```

#### 常用类型说明

- absolute：生成绝对定位的元素，相对于第一个父元素进行定位。
- relative：生成相对定位的元素，相对于其正常位置进行定位。
- fixed：生成绝对定位的元素，相对于浏览器窗口进行定位。ps，此元素不在不被排列在文档流中。

https://www.w3school.com.cn/cssref/pr_class_position.asp
https://www.cnblogs.com/paulwhw/p/9199682.html

## z-index介绍

#### 举例说明

```html
// html布局
<span class="zindex">z坐标很高哦</span>
// css类型
.zindex {
    z-index: 5;
}
```

#### 常用类型说明

- z-index：设置一个定位元素沿z轴的位置，数字越大，则离用户更近。支持负数。

https://www.w3school.com.cn/cssref/pr_pos_z-index.asp

## Flex介绍

Flex布局由flex容器（flex container）以及在容器中的flex元素（flex item）组成。整个Flex布局结构如下：
<img width="600" src="/image/flex_概览.png">
容器默认存在两根轴：水平的主轴（main axis）和垂直的交叉轴（cross axis）。项目默认沿主轴排列。

#### 举例说明

```html
// html布局
<div class="flex">
    <span class="flex-item">
        flex-item
    </span>
</div>
// css类型
.flex {
    display: flex;
    flex-direction: row;
    flex-wrap: nowrap;
    justify-content: flex-start;
    align-items: center;
    align-content: center;
}

.flex-item {
    order: 1;
    flex-grow: 1;
    flex-shrink: 1;
    flex-basis: 40px;
    align-self: center;
}
```

#### flex容器属性介绍

- flex-direction：主轴方向，决定元素的排列方向。
    - row（默认值）：主轴为水平方向，起点在左端。
    - row-reverse：主轴为水平方向，起点在右端。
    - column：主轴为垂直方向，起点在上沿。
    - column-reverse：主轴为垂直方向，起点在下沿。
- flex-wrap：如果一条轴线排不下，如何换行。
    - nowrap（默认）：不换行。
    - wrap：换行，第一行在上方。
    - wrap-reverse：换行，第一行在下方。
- justify-content：定义了项目在主轴上的对齐方式。
    - flex-start（默认值）：左对齐。
    - flex-end：右对齐。
    - center： 居中。
    - space-between：两端对齐，项目之间的间隔都相等。
    - space-around：每个项目两侧的间隔相等。所以，项目之间的间隔比项目与边框的间隔大一倍。
- align-items：定义项目在交叉轴上如何对齐。
    - flex-start：交叉轴的起点对齐。
    - flex-end：交叉轴的终点对齐。
    - center：交叉轴的中点对齐。
    - baseline: 项目的第一行文字的基线对齐。
    - stretch（默认值）：如果项目未设置高度或设为auto，将占满整个容器的高度。
- align-content：定义了多根轴线的对齐方式。如果项目只有一根轴线，该属性不起作用。
    - flex-start：与交叉轴的起点对齐。
    - flex-end：与交叉轴的终点对齐。
    - center：与交叉轴的中点对齐。
    - space-between：与交叉轴两端对齐，轴线之间的间隔平均分布。
    - space-around：每根轴线两侧的间隔都相等。所以，轴线之间的间隔比轴线与边框的间隔大一倍。
    - stretch（默认值）：轴线占满整个交叉轴。

#### flex元素属性介绍

- order：定义项目的排列顺序。数值越小，排列越靠前，默认为0。
- flex-grow：定义项目的放大比例，默认为0，即如果存在剩余空间，也不放大。
- flex-shrink：定义了项目的缩小比例，默认为1，即如果空间不足，该项目将缩小。
- flex-basis：定义了在分配多余空间之前，项目占据的主轴空间（main size）。默认值为auto，即项目的本来大小。
- align-self：允许单个元素有的对齐方式，覆盖align-items属性。默认继承父元素的align-items属性。

https://www.ruanyifeng.com/blog/2015/07/flex-grammar.html
