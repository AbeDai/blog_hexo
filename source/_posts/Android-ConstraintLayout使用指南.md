---
title: Android-ConstraintLayout使用指南
date: 2022-06-04 15:10:57
categories: 客户端
---

### 属性介绍

#### 位置

| 属性 | 详情 |
| --- | --- |
| layout_constraintLeft_toLeftOf | 与目标组件左对齐 |
| layout_constraintLeft_toRightOf | 在目标组件的右边 |
| layout_constraintRight_toRightOf | 与目标组件右对齐 |
| layout_constraintRight_toLeftOf | 在目标组件的左边 |
| layout_constraintTop_toTopOf | 与目标组件上对齐 |
| layout_constraintTop_toBottomOf | 在目标组件底部 |
| layout_constraintBottom_toBottomOf | 与目标组件下对齐 |
| layout_constraintBottom_toTopOf | 在目标组件的上部 |
| layout_constraintBaseline_toBaselineOf | 与目标组件基线对齐 |

#### 偏移量

| 属性 | 详情 |
| --- | --- |
| layout_constraintHorizontal_bias | 水平方向的偏移量（小数） |
| layout_constraintVertical_bias | 竖直方向的偏移量（小数） |

#### Percent dimension（百分比布局）

宽高设置百分比长度

| 属性 | 详情 |
| --- | --- |
| layout_constraintWidth_default | 宽度类型设置，可以设置percent、spread和wrap |
| layout_constraintHeight_default | 高度类型设置，同上 |
| layout_constraintWidth_percent | 如果layout_constraintWidth_percent设置的百分比，这里设置小数，为占父布局宽度的多少 |
| layout_constraintHeight_percent | 设置高度的大小，同上 |

#### Ratio（比例）

控件的宽和高设置一定比例

| 属性 | 详情 |
| --- | --- |
| layout_constraintDimensionRatio | 宽高比 |

#### Circular positioning（圆形定位）

以一个控件为圆心设置角度和半径定位

| 属性 | 详情 |
| --- | --- |
| layout_constraintCircle | 关联另一个控件，将另一个控件放置在自己圆的半径上，会和下面两个属性一起使用 |
| layout_constraintCircleRadius | 圆的半径 |
| layout_constraintCircleAngle | 圆的角度 |

#### Chain Style（约束链类型）

设置约束链类型，约束链类型包括：spread，spread_inside和packed

| 属性 | 详情 |
| --- | --- |
| layout_constraintHorizontal_chainStyle | 横向约束链 |
| layout_constraintVertical_chainStyle | 纵向约束链 |	

### 示例
