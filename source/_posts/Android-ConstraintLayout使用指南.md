---
title: Android-ConstraintLayout使用指南
date: 2022-06-04 15:10:57
categories: 客户端
---

### 简介

**考试：就是用 constraint 来实现 scrollview 的屏幕均匀分布**

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

#### 布局位置控制

<img width="250" src="/image/485FD9EE-7E0D-4A2F-B6DF-36FF339D081F.png">

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".FirstFragment">

    <ImageView
        android:id="@+id/iv_beauty"
        android:layout_width="150dp"
        android:layout_height="200dp"
        android:scaleType="centerCrop"
        android:src="@mipmap/lyf"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <ImageView
        android:id="@+id/iv_girl"
        android:layout_width="100dp"
        android:layout_height="0dp"
        android:scaleType="centerCrop"
        android:src="@mipmap/lyf2"
        app:layout_constraintBottom_toBottomOf="@+id/iv_beauty"
        app:layout_constraintLeft_toRightOf="@+id/iv_beauty"
        app:layout_constraintTop_toTopOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

#### 居中处理控制

<img width="250" src="/image/0ACD8299-E934-4014-83C7-192AFEC7DF40.png">

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".FirstFragment">

    <ImageView
        android:id="@+id/iv_beauty"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toRightOf="parent"
        android:src="@mipmap/lyf"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

#### bias 偏移控制

> 设置偏移，必须先将控件设置父布局居中。
> 偏移的长度，如横向的偏移，是父布局宽度减去ImageView宽度的剩下的10%

<img width="250" src="/image/86822959-8581-4F0E-896C-8E0AB24C79C3.png">

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".FirstFragment">

    <ImageView
        android:id="@+id/iv_beauty1"
        app:layout_constraintHorizontal_bias="0.5"
        app:layout_constraintVertical_bias="0.1"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintRight_toRightOf="parent"
        android:src="@mipmap/lyf"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

#### Percent dimension 子布局相对于父布局比例控制

> 先将layout_constraintWidth_default属性设置为percent，接着将layout_constraintWidth_percent设置为0.7，即可生效
> 同理，对layout_constraintHeight_default 和 layout_constraintHeight_percent进行高度的设置
> 注意，需要先进行位置固定，此才能生效。如下代码，我们先添加了app:layout_constraintTop_toTopOf="parent"和app:layout_constraintLeft_toLeftOf="parent"，将ImageView设置在左上角，如果没有先进行控件的约束，会发现我们的设置的百分比这个属性没有起作用。

<img width="250" src="/image/7A8DC48F-74C7-4DFC-BD38-8978D6E690BB.png">

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".FirstFragment">

    <ImageView
        android:id="@+id/iv_beauty1"
        android:src="@mipmap/lyf"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toRightOf="parent"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintWidth_default="percent"
        app:layout_constraintWidth_percent="0.5"
        app:layout_constraintHeight_default="percent"
        app:layout_constraintHeight_percent="0.3"
        android:scaleType="centerCrop"
        android:layout_width="0dp"
        android:layout_height="0dp" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

#### Ratio 宽高比设置

> 需先将layout_width或者layout_height一方设置为0dp，另一个设置为正常比例，接着给layout_constraintDimensionRatio设置比例
> 例如app:layout_constraintDimensionRatio="2:1"

<img width="250" src="/image/40296723-5C82-4975-B461-A0511DB1AFF9.png">

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".FirstFragment">

    <ImageView
        android:id="@+id/iv_beauty"
        android:layout_width="200dp"
        android:layout_height="0dp"
        android:scaleType="centerCrop"
        app:layout_constraintDimensionRatio="1:2"
        android:src="@mipmap/lyf2"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintRight_toRightOf="parent"/>

</androidx.constraintlayout.widget.ConstraintLayout>
```

#### 约束链

> 第一步：形成约束链（形成约束链的条件就两个View以对方为约束）
> 第二步：在第一个控件添加约束链类型，layout_constraintVertical_chainStyle 或者 layout_constraintHorizontal_chainStyle 添加约束链类型

<img width="250" src="/image/E70A35DD-0131-4E4B-963D-BC8178BBDE29.png">

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".FirstFragment">

    <ImageView
        android:id="@+id/iv_beauty"
        android:layout_width="200dp"
        android:layout_height="100dp"
        android:scaleType="centerCrop"
        android:src="@mipmap/lyf2"
        app:layout_constraintBottom_toTopOf="@+id/iv_girl"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toRightOf="parent"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintVertical_chainStyle="spread" />

    <ImageView
        android:id="@+id/iv_girl"
        android:layout_width="200dp"
        android:layout_height="100dp"
        android:scaleType="centerCrop"
        android:src="@mipmap/lyf"
        app:layout_constraintBottom_toTopOf="@+id/iv_biu"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toRightOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/iv_beauty" />

    <ImageView
        android:id="@+id/iv_biu"
        android:layout_width="200dp"
        android:layout_height="100dp"
        android:scaleType="centerCrop"
        android:src="@mipmap/lyf2"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toRightOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/iv_girl" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

#### GuideLine 辅助线

GuideLine只能用在ConstraintLayout布局中，用来辅助布局，不会被显示，通常有横向和纵向之分。

<img width="250" src="/image/D1C6A2E8-E74C-481C-A5DD-F287E438FDCA.png">

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".FirstFragment">

    <ImageView
        android:id="@+id/iv_beauty"
        android:layout_width="200dp"
        android:layout_height="100dp"
        android:layout_marginEnd="8dp"
        android:scaleType="centerCrop"
        android:src="@mipmap/lyf"
        app:layout_constraintBottom_toTopOf="@+id/iv_girl"
        app:layout_constraintEnd_toStartOf="@+id/guideline"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintVertical_chainStyle="spread_inside" />

    <ImageView
        android:id="@+id/iv_girl"
        android:layout_width="200dp"
        android:layout_height="100dp"
        android:layout_marginStart="8dp"
        android:scaleType="centerCrop"
        android:src="@mipmap/lyf2"
        app:layout_constraintBottom_toTopOf="@+id/iv_biu"
        app:layout_constraintRight_toRightOf="parent"
        app:layout_constraintStart_toStartOf="@+id/guideline"
        app:layout_constraintTop_toBottomOf="@+id/iv_beauty" />

    <ImageView
        android:id="@+id/iv_biu"
        android:layout_width="200dp"
        android:layout_height="100dp"
        android:layout_marginEnd="8dp"
        android:scaleType="centerCrop"
        android:src="@mipmap/lyf"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toStartOf="@+id/guideline"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/iv_girl" />

    <!-- Guideline可以设置具体的宽度，也可以设置百分比 -->
    <androidx.constraintlayout.widget.Guideline
        android:id="@+id/guideline"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        app:layout_constraintGuide_percent="0.5" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

#### Barrier 障碍控制

> Barrier同Guideline一样，不会被显示，你可以理解为Barrier为我们组成了一个虚拟的视图组，不过它没有视图层级的概念。

<img width="250" src="/image/A931BA82-C0AA-4DCD-BF6A-9381580050D0.png">

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="100dp"
    tools:context=".FirstFragment">

    <ImageView
        android:id="@+id/iv_biu"
        android:layout_width="80dp"
        android:layout_height="80dp"
        android:scaleType="centerCrop"
        android:src="@mipmap/lyf"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintLeft_toRightOf="@+id/barrier"
        android:layout_marginStart="10dp" />

    <androidx.constraintlayout.widget.Barrier
        android:id="@+id/barrier"
        android:layout_width="wrap_content"
        android:layout_height="match_parent"
        app:barrierDirection="right"
        app:constraint_referenced_ids="tv_name,tv_content" />

    <TextView
        android:id="@+id/tv_name"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        app:layout_constraintTop_toTopOf="parent"
        android:layout_marginTop="20dp"
        android:layout_marginStart="20dp"
        app:layout_constraintLeft_toLeftOf="parent"
        android:text="Li Lei"
        android:textSize="20sp" />

    <TextView
        android:id="@+id/tv_content"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginBottom="20dp"
        android:layout_marginStart="20dp"
        app:layout_constraintLeft_toLeftOf="parent"
        android:text="look for bigger world,looking for you"
        android:textSize="16sp"
        app:layout_constraintBottom_toBottomOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

#### Circular positioning 圆形定位控制

<img width="600" src="/image/27668335-CC16-468B-955F-C98C4CC26556.png">

<img width="250" src="/image/5D12057D-3FB0-49FA-99AA-DA3FD4643CA2.png">

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    tools:ignore="MissingConstraints"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".FirstFragment">

    <ImageView
        android:id="@+id/iv_biu"
        android:layout_width="64dp"
        android:layout_height="64dp"
        android:scaleType="centerCrop"
        android:src="@mipmap/lyf"
        app:layout_constraintRight_toRightOf="parent"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <ImageView
        android:id="@+id/iv_girl"
        android:layout_width="64dp"
        android:layout_height="64dp"
        app:layout_constraintCircle="@+id/iv_biu"
        app:layout_constraintCircleRadius="120dp"
        app:layout_constraintCircleAngle="45"
        android:src="@mipmap/lyf2" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

### 参考

https://www.jianshu.com/p/958887ed4f5f
https://developer.android.google.cn/training/constraint-layout
https://blog.csdn.net/guolin_blog/article/details/53122387
